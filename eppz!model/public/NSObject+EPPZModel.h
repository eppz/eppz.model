//
//  NSObject+EPPZModel.h
//  eppz!model
//
//  Created by Borbás Geri on 01/05/14.
//  Copyright (c) 2010-2014 eppz! development, LLC.
//
//  donate! by following http://www.twitter.com/_eppz
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import <Foundation/Foundation.h>
#import "EPPZMapper.h"


/*!
 
 Protocol to mark a given class to enjoy @c EPPZModel features. No methods to implement,
 it only tells @c EPPZModel internals that the class is a subject to represent / reconstruct.
 
 */
@protocol EPPZModel <NSObject>
@end


/*!
 
 Extend @c NSObject with `EPPZModel` features.
 
 */
@interface NSObject (EPPZModel)


/*!
 
 A unique identifier that identifes object during a mapping process. Having this,
 mapping can represent / reconstruct cross referenced relations between models.
 Default value holds @c -hash of the object.
 
 */
@property (nonatomic, strong) NSString *modelId;


#pragma mark - Mappers

/*!
 
 A mapper that specifies how the model is represented, reconstructed. Typically you
 implement this method, and return an @c EPPZMapper instance that contains all the
 customizaion you need for the given class.
 
 */
+(EPPZMapper*)defaultMapper;

/*!
 
 Currently selected mapper that specifies how the model is represented,
 reconstructed. If not set, falls back to @c +defaultMapper.
 
 */
+(EPPZMapper*)mapper;
+(void)setMapper:(EPPZMapper*) mapper;


#pragma mark - Representation (runtime to dictionary)

/*!
 
 Returns a dictionary representation (using selected mapper), but only if object
 explicitly conforms to `<EPPZModel>` protocol. Simply returns the object otherwise.s
 
 */
-(NSDictionary*)dictionaryRepresentation;

/*!
 
 Returns a dictionary representation only with the given fields (properties)
 using selected mapper, but only if object explicitly conforms to `<EPPZModel>`
 protocol. Simply returns the object otherwise.
 
 @param fields
 Either an @c NSArray of fields to be represented, or may pass in an @c NSDictionary with fields,
 and can also passing sub-fields within collections down the line. In the latter case only
 the keys gonna be parsed, the actual values will be dismissed (unless it is a sub-field
 @c NSDictionary).
 
 */
-(NSDictionary*)dictionaryRepresentationOfFields:(id) fields;


#pragma mark - Reconstruction (dictionary to runtime)

/*!
 
 Creates an instance with the given dictionary representation (using @c defaultMapper).
 Uses @c +instance to create a new instance.
 
 */
+(instancetype)instanceWithDictionary:(NSDictionary*) dictionary;

/*!
 
 Initializes an instance with the given dictionary representation (using selected mapper).
 Sets every property that is represented, also create objects down the object graph is not
 existed already.
 
 */
-(void)initializeWithDictionary:(NSDictionary*) dictionary;

/*!
 
 Configures an instance with the given dictionary representation (using selected mapper).
 Sets every property that is represented, but only on objects that are already living in
 the runtime object graph.
 
 */
-(void)configureWithDictionary:(NSDictionary*) dictionary;


@end

//
//  NSObject+EPPZModel_inspecting.m
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

#import "NSObject+EPPZModel.h"
#import "NSObject+EPPZModel_inspecting.h"


@interface NSObject (EPPZModel_inspecting_private)
@property (nonatomic, strong) NSArray *propertyNames_;
@end


@implementation NSObject (EPPZModel_inspecting_private)
@dynamic propertyNames_;
@end


@implementation NSObject (EPPZModel_inspecting)


#pragma mark - Synthesize dynamic properties

+(void)load
{
    [EPPZSwizzler synthesizePropertyNamed:@"propertyNames_"
                                   ofKind:[NSArray class]
                                 forClass:[NSObject class]
                               withPolicy:retain];
}


#pragma mark - Class inspection

+(NSString*)className
{ return NSStringFromClass(self); }

-(NSString*)className
{ return NSStringFromClass(self.class); }

-(NSArray*)propertyNames
{
    // Lazy initialize `propertyNames_`.
    if (self.propertyNames_ == nil)
    { self.propertyNames_ = [self.class propertyNamesIncludingSuperclassProperties]; }
    return self.propertyNames_;
}

-(void)updatePropertyNames
{ self.propertyNames_ = [self.class propertyNamesIncludingSuperclassProperties]; }

+(NSArray*)propertyNamesIncludingSuperclassProperties
{
    // Only collects `<EPPZModel>` properties.
    if ([self conformsToProtocol:@protocol(EPPZModel)] == NO)
    { return @[]; }
    
    // Collection.
    NSMutableArray *propertyNames = [NSMutableArray new];
    
    // Iterative up the inheritance chain.
    NSArray *superClassPropertyNames = [[self superclass] propertyNamesIncludingSuperclassProperties];

    // Collect only properties that have not collected so far.
    [superClassPropertyNames enumerateObjectsUsingBlock:^(NSString *eachPropertyName, NSUInteger index, BOOL *stop)
    {
        if ([propertyNames containsObject:eachPropertyName] == NO)
        { [propertyNames addObject:eachPropertyName]; }
    }];
    
    // Collect properties from this class.
    [propertyNames addObjectsFromArray:[self propertyNamesForClassOnly]];
    
    // Return immutable copy.
    return [NSArray arrayWithArray:propertyNames];
}

+(NSArray*)propertyNamesForClassOnly
{
    // Collection.
    NSMutableArray *propertyNames = [NSMutableArray new];
    
    // Collect for this class.
    NSUInteger propertyCount;
    objc_property_t *properties = class_copyPropertyList(self, &propertyCount);
    for (int index = 0; index < propertyCount; index++)
    {
        NSString *eachPropertyName = [NSString stringWithUTF8String:property_getName(properties[index])];
        [propertyNames addObject:eachPropertyName];
    }
    
    free(properties); // As it is a copy
    
    // Return immutable.
    return [NSArray arrayWithArray:propertyNames];
}


#pragma mark - Property inspection

-(NSString*)typeOfPropertyNamed:(NSString*) propertyName
{
    NSString *propertyType = nil;
    NSString *propertyAttributes;
    
    // Get Class of property.
    Class class = object_getClass(self);
    objc_property_t property = class_getProperty(class, [propertyName UTF8String]);
    
    // Try to get getter method.
    if (property == NULL)
    {
        char typeCString[256];
        Method getter = class_getInstanceMethod(class, NSSelectorFromString(propertyName));
        method_getReturnType(getter, typeCString, 256);
        propertyAttributes = [NSString stringWithCString:typeCString encoding:NSUTF8StringEncoding];
        
        // Mimic type encoding for `typeNameForTypeEncoding:`.
        propertyType = [self typeNameForTypeEncoding:[NSString stringWithFormat:@"T%@", propertyAttributes]];
        
        if (getter == NULL)
        { WARNING_AND_NIL(@"No property called `%@` of %@", propertyName, self.className); }
    }
    
    // Or go on with property attribute parsing.
    else
    {
        // Get property attributes.
        const char *propertyAttributesCString;
        propertyAttributesCString = property_getAttributes(property);
        propertyAttributes = [NSString stringWithCString:propertyAttributesCString encoding:NSUTF8StringEncoding];
        
        if (propertyAttributesCString == NULL)
        { WARNING_AND_NIL(@"Could not get attributes for property called `%@` of <%@>", propertyName, self.className); }
        
        // Parse property attributes.
        NSArray *splitPropertyAttributes = [propertyAttributes componentsSeparatedByString:@","];
        if (splitPropertyAttributes.count > 0)
        {
            // From Objective-C Runtime Programming Guide.
            // xcdoc://ios//library/prerelease/ios/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html
            NSString *encodeType = splitPropertyAttributes[0];
            NSArray *splitEncodeType = [encodeType componentsSeparatedByString:@"\""];
            propertyType = (splitEncodeType.count > 1) ? splitEncodeType[1] : [self typeNameForTypeEncoding:encodeType];
        }
        else
        { WARNING_AND_NIL(@"Could not parse attributes for property called `%@` of <%@>å", propertyName, self.className); }
    }
    
    return propertyType;
}

-(NSString*)typeNameForTypeEncoding:(NSString*) typeEncoding
{
    // From Objective-C Runtime Programming Guide.
    // xcdoc://ios//library/prerelease/ios/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
    NSDictionary *typeNamesForTypeEncodings = @{
                                                
                                                @"Tc" : @"char",
                                                @"Ti" : @"int",
                                                @"Ts" : @"short",
                                                @"Tl" : @"long",
                                                @"Tq" : @"long long",
                                                @"TC" : @"unsigned char",
                                                @"TI" : @"unsigned int",
                                                @"TS" : @"unsigned short",
                                                @"TL" : @"unsigned long",
                                                @"TQ" : @"unsigned long long",
                                                @"Tf" : @"float",
                                                @"Td" : @"double",
                                                @"Tv" : @"void",
                                                @"T^v" : @"void*",
                                                @"T*" : @"char*",
                                                @"T@" : @"id",
                                                @"T#" : @"Class",
                                                @"T:" : @"SEL",
                                                
                                                @"T^c" : @"char*",
                                                @"T^i" : @"int*",
                                                @"T^s" : @"short*",
                                                @"T^l" : @"long*",
                                                @"T^q" : @"long long*",
                                                @"T^C" : @"unsigned char*",
                                                @"T^I" : @"unsigned int*",
                                                @"T^S" : @"unsigned short*",
                                                @"T^L" : @"unsigned long*",
                                                @"T^Q" : @"unsigned long long*",
                                                @"T^f" : @"float*",
                                                @"T^d" : @"double*",
                                                @"T^v" : @"void*",
                                                @"T^*" : @"char**",
                                                
                                                @"T@" : @"id",
                                                @"T#" : @"Class",
                                                @"T:" : @"SEL"
                                                
                                                };
    
    // Recognized format.
    if ([[typeNamesForTypeEncodings allKeys] containsObject:typeEncoding])
    { return [typeNamesForTypeEncodings objectForKey:typeEncoding]; }
    
    // Struct property.
    if ([typeEncoding hasPrefix:@"T{"])
    {
        // Try to get struct name.
        NSCharacterSet *delimiters = [NSCharacterSet characterSetWithCharactersInString:@"{="];
        NSArray *components = [typeEncoding componentsSeparatedByCharactersInSet:delimiters];
        NSString *structName;
        if (components.count > 1)
        { structName = components[1]; }
        
        // Falls back to `struct` when unknown name encountered.
        if ([structName isEqualToString:@"?"]) structName = @"struct";
        
        return structName;
    }
    
    // Falls back to raw encoding if none of the above.
    return typeEncoding;
}

-(Class)classOfPropertyNamed:(NSString*) propertyName
{
    // Attempt to get class of property.
    Class class = nil;
    NSString *className = [self typeOfPropertyNamed:propertyName];
    class = NSClassFromString(className);
    
    // Warning.
    if (class == nil)
    { WARNING_AND_NIL(@"No class called `%@` in runtime", className); }
    
    return class;
}


@end

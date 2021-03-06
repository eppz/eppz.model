//
//  EPPZLog.h
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


#define FORMAT(...) [NSString stringWithFormat:__VA_ARGS__]
#define LOG(...) __log(FORMAT(__VA_ARGS__))
#define WARNING(...) __logWarning(FORMAT(__VA_ARGS__))
#define WARNING_AND_VOID(...) __logWarning(FORMAT(__VA_ARGS__)); return
#define WARNING_AND_NIL(...) __logWarning(FORMAT(__VA_ARGS__)); return nil


static NSString *const __warningFormat = @"WARNING: %@";


void __log(NSString *message);
void __logWarning(NSString *message);
void __logWarning(NSString *message);

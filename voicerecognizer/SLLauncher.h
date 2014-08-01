//
//  SLLauncher.h
//  MIJSLauncher
//
//  Created by Koji Ohki on 2014/08/01.
//  Copyright (c) 2014 MIJS All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLLauncher : NSObject
{
    NSMutableArray *_appList;
}
- (id)init;
- (BOOL)execute: (NSString *)phrase;
- (NSArray *)appList;
- (BOOL)executeApp: (NSString *)appName
           withArg: (NSString *)arg;
- (BOOL)addApp: (NSString *)appName
        withScheme: (NSString *)urlScheme
        byPhrase: (NSString *)phrase
        distinguishedIn: (NSString *)keyword;
@end

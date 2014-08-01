//
//  SLLauncher.m
//  MIJSLauncher
//
//  Created by Koji Ohki on 2014/08/01.
//  Copyright (c) 2014 MIJS All rights reserved.
//

#import "SLLauncher.h"

@implementation SLLauncher

- (id)init
{
    if (self = [super init])
    {
        _appList = [NSMutableArray array];
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource: @"apps" ofType: @"csv"];
        NSString *text = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        
        // 改行文字で区切って配列に格納する
        NSArray *lines = [text componentsSeparatedByString:@"\n"];
        NSLog(@"lines count: %ld", (unsigned long)lines.count);    // 行数
        
        for (NSString *row in lines) {
            // コンマで区切って配列に格納する
            NSArray *items = [row componentsSeparatedByString:@","];
            NSLog(@"%@", items);

            if (3 <= [items count])
            {
                [_appList addObject: [NSDictionary dictionaryWithObjectsAndKeys:
                                  [items objectAtIndex: 0], @"name",
                                  [items objectAtIndex: 1], @"scheme",
                                  [items objectAtIndex: 2], @"pattern",
                                  nil]];
            }
            
        }
    }
    
    return self;
}

- (void)executeURLScheme: (NSString *)urlScheme
                withArgs: (NSString *)firstArg, ...
{
    NSLog(@"SLLauncher#executeURLScheme");
    NSLog(@"URLScheme: [%@]", urlScheme);
    
    NSMutableArray *argList = [NSMutableArray array];
    va_list args;
    va_start(args, firstArg);
    for (NSString *arg = firstArg; arg != nil; arg = va_arg(args, NSString *))
    {
        [argList addObject: arg];
    }
    va_end(args);
    
    for (NSString *arg in argList)
    {
        NSLog(@"arg: [%@]", arg);
    }

    NSMutableString *str = [NSMutableString stringWithString: urlScheme];
    int i = 0;
    for (NSString *arg in argList)
    {
        NSRange result = [str rangeOfString: [NSMutableString stringWithFormat: @"%%%d", i]];
        if (result.location != NSNotFound)
        {
            [str replaceCharactersInRange: result withString: [arg stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]]];
        }
        ++i;
    }
    NSLog(@"URL: [%@]", str);
    
    NSURL *url = [NSURL URLWithString: str];
    
    [[UIApplication sharedApplication] openURL: url];
}

- (BOOL)execute: (NSString *)phrase
{
    for (NSDictionary *dic in _appList)
    {
        NSString *pattern = [dic objectForKey: @"pattern"];
        if ([pattern hasPrefix: @"%"])
        {
            if ([pattern hasSuffix: @"%"])
            {
                NSString *keyword = [pattern substringWithRange: NSMakeRange(1, [pattern length] - 2)];
                NSRange result = [phrase rangeOfString: keyword];
                if (result.location != NSNotFound)
                {
                    [self executeURLScheme: [dic objectForKey: @"scheme"]
                                  withArgs: [phrase substringToIndex: result.location],
                     [phrase substringFromIndex: result.location + [pattern length]],
                     nil];

                    return YES;
                }
            }
            else
            {
                NSString *keyword = [pattern substringFromIndex: 1];
                if ([phrase hasSuffix: keyword])
                {
                    [self executeURLScheme: [dic objectForKey: @"scheme"]
                                  withArgs: [phrase substringToIndex: [phrase length] - [keyword length]],
                     nil];
                    
                    return YES;
                }
            }
        }
        else if ([pattern hasSuffix: @"%"])
        {
            NSString *keyword = [pattern substringToIndex: [pattern length] - 2];
            if ([phrase hasPrefix: keyword])
            {
                [self executeURLScheme: [dic objectForKey: @"scheme"]
                              withArgs: [phrase substringFromIndex: [keyword length]],
                    nil];
                
                return YES;
            }
        }
        else
        {
            NSString *keyword = pattern;
            if ([phrase isEqualToString: keyword])
            {
                [self executeURLScheme: [dic objectForKey: @"scheme"]
                              withArgs: nil];
                
                return YES;
            }
        }
    }
    
    return NO;
}

- (NSArray *)appList
{
    NSMutableArray *list = [NSMutableArray array];
    for (NSDictionary *dic in _appList)
    {
        [list addObject: [dic objectForKey: @"name"]];
    }

    return list;
}

- (BOOL)executeApp: (NSString *)appName
           withArg: (NSString *)arg
{
    for (NSDictionary *dic in _appList)
    {
        if ([appName isEqualToString: [dic objectForKey: @"name"]])
        {
            [self executeURLScheme: [dic objectForKey: @"scheme"]
                          withArgs: arg, nil];
        }
        return YES;
    }

    return NO;
}

- (BOOL)addApp: (NSString *)appName
    withScheme: (NSString *)urlScheme
      byPhrase: (NSString *)phrase
distinguishedIn: (NSString *)keyword
{
    NSLog(@"SLLauncher#addApp: [%@] withScheme: [%@] byPhrase: [%@] distinguishedIn: [%@]", appName, urlScheme, phrase, keyword);
    
    NSString *pattern;

    if ([phrase isEqualToString: keyword])
    {
        pattern = keyword;
    }
    else if ([phrase hasSuffix: keyword])
    {
        pattern = [@"%" stringByAppendingString: keyword];
    }
    else if ([phrase hasPrefix: keyword])
    {
        pattern = [keyword stringByAppendingString: @"%"];
    }
    else
    {
        NSRange result = [phrase rangeOfString: keyword];
        if (result.location != NSNotFound)
        {
            pattern = [[@"%" stringByAppendingString: keyword] stringByAppendingString: @"%"];
        }
        else
        {
            return NO;
        }
    }
    
    [_appList addObject: [NSDictionary dictionaryWithObjectsAndKeys:
                         appName, @"name",
                         urlScheme, @"scheme",
                         pattern, @"pattern",
                         nil]];
    
    NSLog(@"addObject: name:[%@] scheme:[%@] pattern:[%@]", appName, urlScheme, pattern);
    
    return YES;
}

@end

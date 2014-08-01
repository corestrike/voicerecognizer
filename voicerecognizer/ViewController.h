//
//  ViewController.h
//  voicerecognizer
//
//  Created by corestrike on 2014/08/01.
//  Copyright (c) 2014年 corestrike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VNTextInputView.h"
#import "SLLauncher.h"

@interface ViewController : UIViewController
@property (strong, nonatomic) IBOutlet VNTextInputView *textInputView;
@property (weak, nonatomic) IBOutlet UITextField *queryStringField;
@property (strong, nonatomic) SLLauncher *slLuncher;
@end

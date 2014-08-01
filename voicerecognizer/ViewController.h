//
//  ViewController.h
//  voicerecognizer
//
//  Created by corestrike on 2014/08/01.
//  Copyright (c) 2014年 corestrike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VNTextInputView.h"

@interface ViewController : UIViewController
@property (strong, nonatomic) IBOutlet VNTextInputView *textInputView;
@property (weak, nonatomic) IBOutlet UITextField *queryStringField;
@end

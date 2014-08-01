//
//  ViewController.m
//  voicerecognizer
//
//  Created by corestrike on 2014/08/01.
//  Copyright (c) 2014年 corestrike. All rights reserved.
//

#import "ViewController.h"
#import "ResultViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()
@property (weak, nonatomic) id dictationController;
@property BOOL recordFlg;
@end

@implementation ViewController
@synthesize queryStringField;
@synthesize textInputView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dictationRecordingDidEnd:)
                                                 name:VNDictationRecordingDidEndNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dictationRecognitionSucceeded:)
                                                 name:VNDictationRecognitionSucceededNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dictationRecognitionFailed:)
                                                 name:VNDictationRecognitionFailedNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.recordFlg = false;
    [super viewDidAppear:animated];
}


// 結果ページを表示
- (void)pushResultScene:(NSString*)query
{
    ResultViewController *resultViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"result"];
    resultViewController.queryString = query;
    [self.navigationController pushViewController:resultViewController animated:YES];
}

// Siri画面を呼び出すボタンアクション
- (IBAction)inputQueryAction:(id)sender
{
    if(!self.dictationController)
        self.dictationController = [NSClassFromString(@"UIDictationController") performSelector:@selector(sharedInstance)];

    if (self.dictationController) {
        UIButton* btn = (UIButton*)sender;
        if(!self.recordFlg) {
            if (![textInputView isFirstResponder]) {
                [textInputView becomeFirstResponder];
            }
            [btn setTitle:@"読み取り終了" forState:UIControlStateNormal];
            self.recordFlg = true;
            [self startDictation];
        }else{
            [btn setTitle:@"ここを押して検索" forState:UIControlStateNormal];
            self.recordFlg = false;
            [self stopDictation];
        }
    }
}

- (NSString *)wholeTestWithDictationResult:(NSArray *)dictationResult {
    NSMutableString *text = [NSMutableString string];
    for (UIDictationPhrase *phrase in dictationResult) {
        [text appendString:phrase.text];
    }
    
    return text;
}

// 読み取り開始
- (void)startDictation {
    [self.dictationController performSelector:@selector(startDictation)];

//    displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(onTimer:)];
//    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
//    
//    [self resetProgress];
//    micImageView.hidden = NO;
//    resultLabel.text = nil;
}

// 読み取り終了
- (void)stopDictation {
    [self.dictationController performSelector:@selector(stopDictation)];
    
//    [displayLink invalidate];
//    displayLink = nil;
//    
//    [self showWaitingServerProcessIndicator];
//    micImageView.hidden = YES;
}

// 読み取りキャンセル
// 今回は使わなくっていい
- (void)cancelDictation {
    [self.dictationController performSelector:@selector(cancelDictation)];
    
//    [displayLink invalidate];
//    displayLink = nil;
//    
//    [self resetProgress];
//    micImageView.hidden = NO;
//    resultLabel.text = nil;
}

// 文字列のプロセッシング
- (void)processDictationText:(NSString *)text {
    self.queryStringField.text = text;
    
//    if ([text hasSuffix:[NSString stringWithUTF8String:"を検索"]]) {
//        text = [text substringToIndex:[text length] - 3];
//        
//        searchBar.text = text;
//        
//        NSURL *searchURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.google.com/m?q=%@&ie=UTF-8&oe=UTF-8&client=safari",
//                                                 [text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
//        [webView loadRequest:[NSURLRequest requestWithURL:searchURL]];
//    } else if ([text isEqualToString:[NSString stringWithUTF8String:"戻る"]]) {
////        [webView goBack];
//    } else if ([text isEqualToString:[NSString stringWithUTF8String:"進む"]]) {
////        [webView goForward];
//    }
    
    // 結果ページに遷移
    [self pushResultScene:text];
}

- (void)dictationRecordingDidEnd:(NSNotification *)notification {
    NSLog(@"DidEnd");
}

// 認識に成功した場合
- (void)dictationRecognitionSucceeded:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSArray *dictationResult = [userInfo objectForKey:VNDictationResultKey];
    
    NSString *text = [self wholeTestWithDictationResult:dictationResult];
    [self processDictationText:text];
}

// 認識に失敗した場合
- (void)dictationRecognitionFailed:(NSNotification *)notification {
    self.queryStringField.text = @"-";
}

@end

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
@synthesize slLuncher;

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
    self.slLuncher = [[SLLauncher alloc] init];
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
    resultViewController.slLuncher = self.slLuncher;
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
}

// 読み取り終了
- (void)stopDictation {
    [self.dictationController performSelector:@selector(stopDictation)];
}

// 読み取りキャンセル
// 今回は使わなくっていい
- (void)cancelDictation {
    [self.dictationController performSelector:@selector(cancelDictation)];
}

// 文字列のプロセッシング
- (void)processDictationText:(NSString *)text {
    self.queryStringField.text = text;
    
    if(![self.slLuncher execute:text]){
        // 結果ページに遷移
        [self pushResultScene:text];
    }
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

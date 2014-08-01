//
//  ResultViewController.m
//  voicerecognizer
//
//  Created by corestrike on 2014/08/01.
//  Copyright (c) 2014年 corestrike. All rights reserved.
//

#import "ResultViewController.h"

@interface ResultViewController ()
@end

@implementation ResultViewController
@synthesize queryString;
@synthesize queryStringField;
@synthesize slLuncher;
@synthesize resultTable;
@synthesize appsList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    self.queryStringField.layer.borderColor = [[UIColor colorWithRed:0.10 green:0.84 blue:0.99 alpha:1.0] CGColor];
    self.queryStringField.layer.borderWidth = 0.5f;
    
    // UITableViewの謎の隙間を埋める処理
    // 舐めてるのか
    self.resultTable.contentInset = UIEdgeInsetsMake(-15, 0, -15, 0);
    
    // 結果テーブルの設定
    [self.resultTable setDelegate:self];
    [self.resultTable setDataSource:self];

    // 結果セットをリストに登録
    self.appsList = [[NSMutableArray alloc] init];
    [self.appsList addObject:@"Googleで検索してみる"];
    [self.appsList addObject:@"Yahoo!検索で検索してみる"];
    [self.appsList addObject:@"なんでもいいから地図出せよ"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 文字列の設定
    // queryStringはstrong指定で値渡し用に使っている
    self.queryStringField.text = self.queryString;
}

// アプリを選択したときの動作
- (void)lanchOtherApps:(NSInteger)num
{
    // 検索文字列の取得
    NSString* queryStr = self.queryStringField.text;
    
    // リストからアプリ情報を取得
    NSString* appsInfo = [self.appsList objectAtIndex:num];
    
    // ToDo: URLスキーマの実装
    
}

// 検索画面に戻る
- (IBAction)backToLaunchScene:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/* UITableView必須関数群 */
// セクションあたりのアプリ数＝選択できるアプリの数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.appsList count];
}

// セルの中身を表示
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellIdentifier = @"myCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if ( !cell ) {
        cell = [UITableViewCell new];
    }
    
    // セルの透過処理
    cell.backgroundColor = [UIColor clearColor];
//    tableView.backgroundColor = [UIColor clearColor];
    
    // セルの文字色
    cell.textLabel.textColor = [UIColor whiteColor];
    
    // アプリ名の設定
    cell.textLabel.text = [self.appsList objectAtIndex:indexPath.row];
    
    return cell;
}

// セルをタップした時の動作
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self lanchOtherApps:indexPath.row];
}
@end

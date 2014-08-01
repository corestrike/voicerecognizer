//
//  ResultViewController.h
//  voicerecognizer
//
//  Created by corestrike on 2014/08/01.
//  Copyright (c) 2014年 corestrike. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *resultTable;
@property (weak, nonatomic) IBOutlet UITextField *queryStringField;
@property (strong, nonatomic) NSString *queryString;
@property (strong, nonatomic) NSMutableArray *appsList;
@end

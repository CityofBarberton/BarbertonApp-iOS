//
//  BTNFirstViewController.h
//  barberton
//
//  Created by Christopher Stoll on 1/5/14.
//  Copyright (c) 2014 Christopher Stoll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STTwitterAPI.h"

@interface BTNNewsMasterViewController : UIViewController <UITableViewDataSource>

@property (nonatomic, strong) NSArray *twitterStatuses;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

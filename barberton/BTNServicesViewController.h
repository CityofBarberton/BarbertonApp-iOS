//
//  BTNServiceViewController.h
//  barberton
//
//  Created by Christopher Stoll on 1/7/14.
//  Copyright (c) 2014 Christopher Stoll. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTNServicesViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UILabel *textFieldTopic;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (weak, nonatomic) IBOutlet UITextField *textViewName;
@property (weak, nonatomic) IBOutlet UITextField *textViewAddress;
@property (weak, nonatomic) IBOutlet UITextField *textViewPhone;

@property (strong, nonatomic) NSMutableDictionary *issueDict;
@property (weak, nonatomic) IBOutlet UITextField *textFieldSummary;
@property (weak, nonatomic) IBOutlet UITextField *textFieldLocation;
@property (weak, nonatomic) IBOutlet UILabel *labelDetails;

@end

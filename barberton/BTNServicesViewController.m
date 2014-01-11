//
//  BTNServiceViewController.m
//  barberton
//
//  Created by Christopher Stoll on 1/7/14.
//  Copyright (c) 2014 Christopher Stoll. All rights reserved.
//

#import "BTNServicesViewController.h"
#import "BTNPlist.h"

@interface BTNServicesViewController ()

@end

@implementation BTNServicesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [self readPlist];
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [self writePlist];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Plist

- (void)readPlist {
    BTNPlist *sharedPlist = [BTNPlist sharedPlist];
    
    [_textFieldEmail setText:sharedPlist.email];
    [_textViewName setText:sharedPlist.name];
    [_textViewAddress setText:sharedPlist.address];
    [_textViewPhone setText:sharedPlist.phone];
    
    _issueDict = [[NSMutableDictionary alloc] initWithDictionary:sharedPlist.currentIssue];
    [_textFieldTopic setText:_issueDict[@"topic"]];
    [_textFieldSummary setText:_issueDict[@"summary"]];
    [_textFieldLocation setText:_issueDict[@"location"]];
    [_labelDetails setText:_issueDict[@"details"]];
}

- (void)writePlist {
    BTNPlist *sharedPlist = [BTNPlist sharedPlist];
    
    sharedPlist.email = _textFieldEmail.text;
    sharedPlist.name = _textViewName.text;
    sharedPlist.address = _textViewAddress.text;
    sharedPlist.phone = _textViewPhone.text;
    
    [_issueDict setValue:_textFieldTopic.text forKey:@"topic"];
    [_issueDict setValue:_textFieldSummary.text forKey:@"summary"];
    [_issueDict setValue:_textFieldLocation.text forKey:@"location"];
    [_issueDict setValue:_labelDetails.text forKey:@"details"];
    sharedPlist.currentIssue = (NSDictionary*)_issueDict;
    
    [sharedPlist save];
}

#pragma mark - Resign responder on scroll

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self findAndResignFirstResonder:scrollView];
}

- (BOOL)findAndResignFirstResonder:(UIView *)stView {
    if (stView.isFirstResponder) {
        [stView resignFirstResponder];
        return YES;
    }
    
    for (UIView *subView in stView.subviews) {
        if ([self findAndResignFirstResonder:subView]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [self findAndResignFirstResonder:self.tableView];
}

@end

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
    [_textFieldTopic setText:_issueDict[PLIST_TOPIC]];
    [_textFieldSummary setText:_issueDict[PLIST_SUMMARY]];
    [_textFieldLocation setText:_issueDict[PLIST_LOCATION]];
    [_labelDetails setText:_issueDict[PLIST_DETAILS]];
}

- (void)writePlist {
    BTNPlist *sharedPlist = [BTNPlist sharedPlist];
    
    sharedPlist.email = _textFieldEmail.text;
    sharedPlist.name = _textViewName.text;
    sharedPlist.address = _textViewAddress.text;
    sharedPlist.phone = _textViewPhone.text;
    
    [_issueDict setValue:_textFieldTopic.text forKey:PLIST_TOPIC];
    [_issueDict setValue:_textFieldSummary.text forKey:PLIST_SUMMARY];
    [_issueDict setValue:_textFieldLocation.text forKey:PLIST_LOCATION];
    [_issueDict setValue:_labelDetails.text forKey:PLIST_DETAILS];
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

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"SubmitRequest"]){
        if ([self.textFieldTopic.text isEqualToString:@""] || [self.textFieldEmail.text isEqualToString:@""] || [self.textViewName.text isEqualToString:@""] || [self.textViewAddress.text isEqualToString:@""] || [self.textViewPhone.text isEqualToString:@""] || [self.textFieldSummary.text isEqualToString:@""] || [self.textFieldLocation.text isEqualToString:@""] || [self.labelDetails.text isEqualToString:@""]) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Missing Information" message:@"Please fill in all field so that we can complete your request." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return NO;
        } else {
            return YES;
        }
    } else {
        return YES;
    }
}

@end

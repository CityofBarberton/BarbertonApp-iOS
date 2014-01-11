//
//  BTNSafetyTipsViewController.m
//  barberton
//
//  Created by Christopher Stoll on 1/6/14.
//  Copyright (c) 2014 Christopher Stoll. All rights reserved.
//

#import "BTNSafetyWebViewController.h"

@interface BTNSafetyWebViewController ()

@end

@implementation BTNSafetyWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = self.pageTitle;
    NSURL *url = [NSURL URLWithString:self.pageURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)openInSafari:(id)sender {
    [[UIApplication sharedApplication] openURL:self.webView.request.URL];
}

@end

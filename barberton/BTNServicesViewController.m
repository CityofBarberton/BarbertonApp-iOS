//
//  BTNSecondViewController.m
//  barberton
//
//  Created by Christopher Stoll on 1/5/14.
//  Copyright (c) 2014 Christopher Stoll. All rights reserved.
//

#import "BTNServicesViewController.h"

@interface BTNServicesViewController ()

@end

@implementation BTNServicesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSURL *url = [NSURL URLWithString:@"http://webapps.cityofbarberton.com/osTicket/open.alt.php"];
    //NSString *body = [NSString stringWithFormat:@"name=%@&email=%@", @"chris",@"a@b.com"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //[request setHTTPMethod: @"POST"];
    //[request setHTTPBody: [body dataUsingEncoding:NSUTF8StringEncoding]];
    [self.webView loadRequest:request];
    
    //NSString *html = [yourWebView stringByEvaluatingJavaScriptFromString: @"document.body.innerHTML"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  BTNSafetyTipsViewController.h
//  barberton
//
//  Created by Christopher Stoll on 1/6/14.
//  Copyright (c) 2014 Christopher Stoll. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTNSafetyWebViewController : UIViewController

@property (strong, nonatomic) NSString *pageTitle;
@property (strong, nonatomic) NSString *pageURL;

@property (weak, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)openInSafari:(id)sender;

@end

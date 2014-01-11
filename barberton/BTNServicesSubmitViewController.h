//
//  BTNSecondViewController.h
//  barberton
//
//  Created by Christopher Stoll on 1/5/14.
//  Copyright (c) 2014 Christopher Stoll. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTNServicesSubmitViewController : UIViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

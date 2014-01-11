//
//  BTNNewsDetailViewController.h
//  barberton
//
//  Created by Christopher Stoll on 1/5/14.
//  Copyright (c) 2014 Christopher Stoll. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTNNewsDetailViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong) NSDictionary *twitterStatus;
@property (weak, nonatomic) IBOutlet UIWebView *messageText;

@end

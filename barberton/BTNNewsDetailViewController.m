//
//  BTNNewsDetailViewController.m
//  barberton
//
//  Created by Christopher Stoll on 1/5/14.
//  Copyright (c) 2014 Christopher Stoll. All rights reserved.
//

#import "BTNNewsDetailViewController.h"

@interface BTNNewsDetailViewController ()

@end

@implementation BTNNewsDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self updateViewData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateViewData {
    NSDictionary *status = self.twitterStatus;
    // TODO: this is not the full message on RT, get the full message
    NSMutableString *text = [status valueForKey:@"text"];
    NSString *dateString = [status valueForKey:@"created_at"];
    
    NSDictionary *entities = [status valueForKey:@"entities"];
    NSArray *urls = [entities valueForKey:@"urls"];
    NSArray *user_mentions = [entities valueForKey:@"user_mentions"];
    NSArray *media = [entities valueForKey:@"media"];
    
    // expand "RT @name" to "From: First Last"
    NSDictionary *retweeted_status = [status valueForKey:@"retweeted_status"];
    if (retweeted_status) {
        NSDictionary *user = [retweeted_status valueForKey:@"user"];
        NSString *name = [user valueForKey:@"name"];
        
        NSMutableString *newText = [[NSMutableString alloc] initWithFormat:@"<div style='margin-bottom:.5em;'>From %@:</div>%@", name, [retweeted_status valueForKey:@"text"]];
        text = newText;
    }
    
    // display urls in pretty form
    for (int i = 0; i < urls.count; ++i) {
        NSDictionary *urlDict = urls[i];
        NSString *url = [urlDict valueForKey:@"url"];
        NSString *display_url = [urlDict valueForKey:@"display_url"];
        NSString *expanded_url = [urlDict valueForKey:@"expanded_url"];
        NSString *euFull = [[NSString alloc] initWithFormat:@"<a href='%@'>%@</a>", expanded_url, display_url];
        
        if (url && display_url && expanded_url) {
            [text replaceOccurrencesOfString:url withString:euFull options:NSCaseInsensitiveSearch range:NSMakeRange(0, [text length])];
        }
    }
    
    // expand "@name" to "First Last"
    for (int i = 0; i < user_mentions.count; ++i) {
        NSDictionary *umDict = user_mentions[i];
        NSString *name = [umDict valueForKey:@"name"];
        NSString *screen_name = [umDict valueForKey:@"screen_name"];
        NSString *nameFull = [[NSString alloc] initWithFormat:@"%@", name];
        NSString *snFull = [[NSString alloc] initWithFormat:@"@%@", screen_name];
        
        if (name && screen_name) {
            [text replaceOccurrencesOfString:snFull withString:nameFull options:NSCaseInsensitiveSearch range:NSMakeRange(0, [text length])];
        }
    }
    
    // expand attached images
    for (int i = 0; i < media.count; ++i) {
        NSDictionary *mediaDict = media[i];
        NSString *media_url = [mediaDict valueForKey:@"media_url"];
        NSString *url = [mediaDict valueForKey:@"url"];
        NSString *imgTag = [[NSString alloc] initWithFormat:@"<img src='%@' style='margin:1em 0; width:100%%' />", media_url];
        
        if (url && imgTag) {
            [text replaceOccurrencesOfString:url withString:imgTag options:NSCaseInsensitiveSearch range:NSMakeRange(0, [text length])];
        }
    }
    
    NSDateFormatter *dateFormatterInput = [[NSDateFormatter alloc] init];
    [dateFormatterInput setDateFormat:@"EEE MMM dd HH:mm:ss Z yyyy"];
    NSDate *dateInput = [dateFormatterInput dateFromString:dateString];
    
    NSDateFormatter *dateFormatterOutput = [[NSDateFormatter alloc] init];
    [dateFormatterOutput setDateFormat:@"MMMM d, yyyy h:mm a"];
    NSString *formattedDateString = [dateFormatterOutput stringFromDate:dateInput];
        
    NSString *finalText = [[NSString alloc] initWithFormat:@"<body style='margin:1.5em;font-size:larger;'>%@ <div style='color:#666;float:right;margin:1em;font-size:smaller;'>&ndash; %@</div></body>", text, formattedDateString];
    
    [self.messageText loadHTMLString:finalText baseURL:nil];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if (navigationType != UIWebViewNavigationTypeOther) {
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    return YES;
}

@end

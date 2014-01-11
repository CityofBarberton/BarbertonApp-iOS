//
//  BTNSecondViewController.m
//  barberton
//
//  Created by Christopher Stoll on 1/5/14.
//  Copyright (c) 2014 Christopher Stoll. All rights reserved.
//

#import "BTNServicesSubmitViewController.h"
#import "BTNPlist.h"

#define SITE_URL @"http://webapps.cityofbarberton.com/osTicket/open.alt.php"
#define SITE_CSRF @"__CSRFToken__"
#define SITE_ACTION @"a"
#define SITE_DRAFTID @"draft_id"

#define SITE_TOPIC @"topicId"
#define SITE_DETAILS @"message"

#define REGEX_INPUT @"<input type=\"(hidden|text)\" .*?>"
#define REGEX_NAME @"name=\".*?\""
#define REGEX_VALUE @"value=\".*?\""

#define INPUT_EMAIL 0
#define INPUT_NAME 1
#define INPUT_ADDRESS 2
#define INPUT_PHONE 3
#define INPUT_EXT 4
#define INPUT_SUMMARY 5
#define INPUT_LOCATION 6
#define INPUT_LAT 7
#define INPUT_LON 8

@interface BTNServicesSubmitViewController ()
@property (strong, nonatomic) NSMutableArray *inputNames;
@property (strong, nonatomic) NSString *inputCSRFToken;
@property (strong, nonatomic) NSString *inputAction;
@property (strong, nonatomic) NSString *inputDraftId;
@property BOOL postPage;
@end

@implementation BTNServicesSubmitViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self loadWebPage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - webView

/*
 * Load the open ticket page to establish a session
 */
- (void)loadWebPage {
    self.postPage = NO;
    
    NSURL *url = [NSURL URLWithString:SITE_URL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

/*
 * Post back to the open ticket page to create the ticket
 */
- (void)postWebPage:(NSString *)html {
    self.postPage = YES;
    
    [self scrapeInputNames:html];
    
    BTNPlist *sharedPlist = [BTNPlist sharedPlist];
    NSMutableDictionary *issueDict = [[NSMutableDictionary alloc] initWithDictionary:sharedPlist.currentIssue];
    NSMutableString *postData = [[NSMutableString alloc] initWithFormat:@"%@=%@", SITE_CSRF, self.inputCSRFToken];
    [postData appendFormat:@"&%@=%@", SITE_ACTION, self.inputAction];
    [postData appendFormat:@"&%@=%@", SITE_TOPIC, issueDict[PLIST_TOPIC_ID]];
    
    int i = 0;
    for (NSDictionary *inputName in self.inputNames) {
        if (i == INPUT_EMAIL) {
            [postData appendFormat:@"&%@=%@", inputName, sharedPlist.email];
        } else if (i == INPUT_NAME) {
            [postData appendFormat:@"&%@=%@", inputName, sharedPlist.name];
        } else if (i == INPUT_ADDRESS) {
            [postData appendFormat:@"&%@=%@", inputName, sharedPlist.address];
        } else if (i == INPUT_PHONE) {
            [postData appendFormat:@"&%@=%@", inputName, sharedPlist.phone];
        } else if (i == INPUT_EXT) {
            [postData appendFormat:@"&%@=%@", inputName, @""];
        } else if (i == INPUT_SUMMARY) {
            [postData appendFormat:@"&%@=%@", inputName, issueDict[PLIST_SUMMARY]];
        } else if (i == INPUT_LOCATION) {
            [postData appendFormat:@"&%@=%@", inputName, issueDict[PLIST_LOCATION]];
        } else if (i == INPUT_LAT) {
            [postData appendFormat:@"&%@=%@", inputName, issueDict[PLIST_LAT]];
        } else if (i == INPUT_LON) {
            [postData appendFormat:@"&%@=%@", inputName, issueDict[PLIST_LON]];
        }
        ++i;
    }
    [postData appendFormat:@"&%@=%@", SITE_DETAILS, issueDict[PLIST_DETAILS]];
    
    NSURL *url = [NSURL URLWithString:SITE_URL];
    NSString *body = [NSString stringWithString:postData];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod: @"POST"];
    [request setHTTPBody: [body dataUsingEncoding:NSUTF8StringEncoding]];
    [self.webView loadRequest:request];
}

/*
 * Catch the load so that we can scrape the session ID and field names
 */
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (!self.postPage) {
        NSString *html = [webView stringByEvaluatingJavaScriptFromString: @"document.body.innerHTML"];
        [self postWebPage:html];
    } else {
        [self.activityIndicator setHidden:YES];
        [self.webView setHidden:NO];
        [self writePlist];
    }
}

#pragma mark - Utilities

/*
 * Scrape the HTML field names from the create ticket screen
 * osTicket does not have an API to create tickets from random remote clients,
 * and it obfuscates the field names [to prevent monkey business],
 * hence the need for this
 * 
 * osTicket also has Cross-site request forgery prevention mechanisms,
 * so we need to grab a session ID
 */
- (void)scrapeInputNames:(NSString *)html {
    _inputNames = [[NSMutableArray alloc] init];
    
    NSString *searchedString = [[NSString alloc] initWithString:html];
    NSRange searchedRange = NSMakeRange(0, [searchedString length]);
    NSString *patternInput = REGEX_INPUT;
    NSString *patternName = REGEX_NAME;
    NSString *patternValue = REGEX_VALUE;
    NSError *error = nil;
    
    // find all the <input /> strings
    NSRegularExpression* findInputs = [NSRegularExpression regularExpressionWithPattern:patternInput options:0 error:&error];
    NSArray *matches = [findInputs matchesInString:searchedString options:0 range: searchedRange];
    
    for (NSTextCheckingResult *match in matches) {
        NSString* matchText = [searchedString substringWithRange:[match range]];
        
        // find all the names of the <input /> strings
        NSRange subSearchedRange = NSMakeRange(0, [matchText length]);
        NSRegularExpression *findNames = [NSRegularExpression regularExpressionWithPattern:patternName options:0 error:&error];
        NSArray *subMatches = [findNames matchesInString:matchText options:0 range: subSearchedRange];
        
        for (NSTextCheckingResult* subMatch in subMatches) {
            NSString *subMatchText = [matchText substringWithRange:[subMatch range]];
            NSString *subMatchTextClean = [subMatchText substringWithRange:NSMakeRange(6, (subMatchText.length - 7))];
            
            // grab and store the CSRF token (and other given) value
            if ([subMatchTextClean isEqualToString:SITE_CSRF] || [subMatchTextClean isEqualToString:SITE_ACTION] || [subMatchTextClean isEqualToString:SITE_DRAFTID]) {
                // find the values for these specific <input /> strings
                NSRegularExpression *findValues = [NSRegularExpression regularExpressionWithPattern:patternValue options:0 error:&error];
                NSArray *valueMatches = [findValues matchesInString:matchText options:0 range:subSearchedRange];
                
                for (NSTextCheckingResult *valueMatch in valueMatches) {
                    NSString *valueText = [matchText substringWithRange:[valueMatch range]];
                    NSString *valueTextClean = [valueText substringWithRange:NSMakeRange(7, (valueText.length - 8))];
                    
                    if ([subMatchTextClean isEqualToString:SITE_CSRF]) {
                        _inputCSRFToken = valueTextClean;
                    } else if([subMatchTextClean isEqualToString:SITE_ACTION]) {
                        _inputAction = valueTextClean;
                    } else if ([subMatchTextClean isEqualToString:SITE_DRAFTID]) {
                        _inputDraftId = valueTextClean;
                    }
                }
            
            // store the input names
            } else {
                [_inputNames addObject:subMatchTextClean];
            }
        }
    }
}

- (void)writePlist {
    BTNPlist *sharedPlist = [BTNPlist sharedPlist];
    NSMutableDictionary *issueDict = [[NSMutableDictionary alloc] initWithDictionary:sharedPlist.currentIssue];
    [issueDict setValue:@"" forKey:PLIST_TOPIC_ID];
    [issueDict setValue:@"" forKey:PLIST_TOPIC];
    [issueDict setValue:@"" forKey:PLIST_SUMMARY];
    [issueDict setValue:@"" forKey:PLIST_LOCATION];
    [issueDict setValue:@"" forKey:PLIST_LAT];
    [issueDict setValue:@"" forKey:PLIST_LON];
    [issueDict setValue:@"" forKey:PLIST_DETAILS];
    sharedPlist.currentIssue = (NSDictionary*)issueDict;
    [sharedPlist save];
}

@end

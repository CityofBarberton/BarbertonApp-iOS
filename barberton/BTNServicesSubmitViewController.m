//
//  BTNSecondViewController.m
//  barberton
//
//  Created by Christopher Stoll on 1/5/14.
//  Copyright (c) 2014 Christopher Stoll. All rights reserved.
//

#import "BTNServicesSubmitViewController.h"

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
    NSURL *url = [NSURL URLWithString:@"http://webapps.cityofbarberton.com/osTicket/open.alt.php"];
    //NSString *body = [NSString stringWithFormat:@"name=%@&email=%@", @"chris",@"a@b.com"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //[request setHTTPMethod: @"POST"];
    //[request setHTTPBody: [body dataUsingEncoding:NSUTF8StringEncoding]];
    [self.webView loadRequest:request];
}

/*
 * Catch the load so that we can scrape the session ID and field names
 */
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *html = [webView stringByEvaluatingJavaScriptFromString: @"document.body.innerHTML"];
    [self scrapeInputNames:html];
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
    NSString *patternInput = @"<input type=\"(hidden|text)\" .*?>";
    NSString *patternName = @"name=\".*?\"";
    NSString *patternValue = @"value=\".*?\"";
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
            if ([subMatchTextClean isEqualToString:@"__CSRFToken__"] || [subMatchTextClean isEqualToString:@"a"] || [subMatchTextClean isEqualToString:@"draft_id"]) {
                // find the values for these specific <input /> strings
                NSRegularExpression *findValues = [NSRegularExpression regularExpressionWithPattern:patternValue options:0 error:&error];
                NSArray *valueMatches = [findValues matchesInString:matchText options:0 range:subSearchedRange];
                
                for (NSTextCheckingResult *valueMatch in valueMatches) {
                    NSString *valueText = [matchText substringWithRange:[valueMatch range]];
                    NSString *valueTextClean = [valueText substringWithRange:NSMakeRange(7, (valueText.length - 8))];
                    
                    if ([subMatchTextClean isEqualToString:@"__CSRFToken__"]) {
                        _inputCSRFToken = valueTextClean;
                    } else if([subMatchTextClean isEqualToString:@"a"]) {
                        _inputAction = valueTextClean;
                    } else if ([subMatchTextClean isEqualToString:@"draft_id"]) {
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

@end

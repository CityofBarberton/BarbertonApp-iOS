//
//  BTNFirstViewController.m
//  barberton
//
//  Created by Christopher Stoll on 1/5/14.
//  Copyright (c) 2014 Christopher Stoll. All rights reserved.
//

#import "BTNNewsMasterViewController.h"
#import "BTNTwitter.h"
#import "BTNNewsDetailViewController.h"

@interface BTNNewsMasterViewController ()
@property (nonatomic, strong) STTwitterAPI *twitter;
@end

@implementation BTNNewsMasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self getTwitterStatuses];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Get data

- (void)getTwitterStatuses {
    // TODO: get rid of all the NSLog messages
    STTwitterAPI *twitter = [STTwitterAPI twitterAPIAppOnlyWithConsumerKey:TWITTER_CONSUMER_KEY consumerSecret:TWITTER_CONSUMER_TOKEN];
    
    [twitter verifyCredentialsWithSuccessBlock:^(NSString *bearerToken) {
        //NSLog(@"Access granted with %@", bearerToken);
        
        [twitter getUserTimelineWithScreenName:@"BarbertonCity" successBlock:^(NSArray *statuses) {
            //NSLog(@"-- statuses: %@", statuses);
            self.twitterStatuses = statuses;
            // TODO: store this in core data, maybe (then have to consider deleted tweets)
            [self.tableView reloadData];
        } errorBlock:^(NSError *error) {
            NSLog(@"-- error: %@", error);
        }];
        
    } errorBlock:^(NSError *error) {
        NSLog(@"-- error %@", error);
        //UIAlertView *errorAlert;
        //id *errorAlertView = [errorAlert initWithTitle:@"Error" message:@"Could not retreive news feed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.twitterStatuses count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"STTwitterTVCellIdentifier"];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"STTwitterTVCellIdentifier"];
    }
    
    NSDictionary *status = [self.twitterStatuses objectAtIndex:indexPath.row];
    
    NSString *text = [status valueForKey:@"text"];
    NSString *dateString = [status valueForKey:@"created_at"];
    
    // remove the "RT @name: " part of retweets for the list view
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"RT .*?: " options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *initialText = [regex stringByReplacingMatchesInString:text options:0 range:NSMakeRange(0, [text length]) withTemplate:@""];
    
    // Fix &amp; display
    error = NULL;
    NSRegularExpression *regexB = [NSRegularExpression regularExpressionWithPattern:@"&amp;" options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *intermediateText = [regexB stringByReplacingMatchesInString:initialText options:0 range:NSMakeRange(0, [initialText length]) withTemplate:@"&"];
    
    //
    // TODO: pull this out to another class, it is duplicated from the details screen
    //
    
    // Make other format adjustments
    NSDictionary *entities = [status valueForKey:@"entities"];
    //NSArray *urls = [entities valueForKey:@"urls"];
    NSArray *user_mentions = [entities valueForKey:@"user_mentions"];
    //NSArray *media = [entities valueForKey:@"media"];
    
    // expand ".@name" to "First Last"
    NSMutableString *workingText = [[NSMutableString alloc] initWithString:intermediateText];
    for (int i = 0; i < user_mentions.count; ++i) {
        NSDictionary *umDict = user_mentions[i];
        NSString *name = [umDict valueForKey:@"name"];
        NSString *screen_name = [umDict valueForKey:@"screen_name"];
        NSString *nameFull = [[NSString alloc] initWithFormat:@"%@", name];
        NSString *snFull = [[NSString alloc] initWithFormat:@".@%@", screen_name];
        NSString *nameFullReply = @"...";
        NSString *snFullReply = [[NSString alloc] initWithFormat:@"@%@", screen_name];
        //NSString *snFull = @"";
        
        if (name && screen_name) {
            [workingText replaceOccurrencesOfString:snFull withString:nameFull options:NSCaseInsensitiveSearch range:NSMakeRange(0, [workingText length])];
            [workingText replaceOccurrencesOfString:snFullReply withString:nameFullReply options:NSCaseInsensitiveSearch range:NSMakeRange(0, [workingText length])];
        }
    }
    NSString *finalText = [[NSString alloc] initWithString:workingText];
    
    NSDateFormatter *dateFormatterInput = [[NSDateFormatter alloc] init];
    [dateFormatterInput setDateFormat:@"EEE MMM dd HH:mm:ss Z yyyy"];
    NSDate *dateInput = [dateFormatterInput dateFromString:dateString];
    
    NSDateFormatter *dateFormatterOutput = [[NSDateFormatter alloc] init];
    [dateFormatterOutput setDateFormat:@"MMMM d, yyyy h:mm a"];
    NSString *formattedDateString = [dateFormatterOutput stringFromDate:dateInput];
    
    cell.textLabel.text = finalText;
    cell.detailTextLabel.text = formattedDateString;
    
    return cell;
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    [[segue destinationViewController] setTwitterStatus:[self.twitterStatuses objectAtIndex:indexPath.row]];
}

@end

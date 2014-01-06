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
    STTwitterAPI *twitter = [STTwitterAPI twitterAPIAppOnlyWithConsumerKey:TWITTER_CONSUMER_KEY consumerSecret:TWITTER_CONSUMER_TOKEN];
    
    [twitter verifyCredentialsWithSuccessBlock:^(NSString *bearerToken) {
        //NSLog(@"Access granted with %@", bearerToken);
        
        [twitter getUserTimelineWithScreenName:@"BarbertonCity" successBlock:^(NSArray *statuses) {
            //NSLog(@"-- statuses: %@", statuses);
            self.twitterStatuses = statuses;
            [self.tableView reloadData];
        } errorBlock:^(NSError *error) {
            NSLog(@"-- error: %@", error);
        }];
        
    } errorBlock:^(NSError *error) {
        NSLog(@"-- error %@", error);
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
    
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"RT .*?: " options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *finalText = [regex stringByReplacingMatchesInString:text options:0 range:NSMakeRange(0, [text length]) withTemplate:@""];
    
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

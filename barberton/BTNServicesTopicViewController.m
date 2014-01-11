//
//  BTNServicesTopicViewController.m
//  barberton
//
//  Created by Christopher Stoll on 1/10/14.
//  Copyright (c) 2014 Christopher Stoll. All rights reserved.
//

#import "BTNServicesTopicViewController.h"
#import "BTNPlist.h"

@interface BTNServicesTopicViewController ()
@property (strong, nonatomic) NSArray *topics;
@end

@implementation BTNServicesTopicViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    BTNPlist *sharedPlist = [BTNPlist sharedPlist];
    _topics = [[NSArray alloc] initWithArray:sharedPlist.topics];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.topics count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ServiceDetailCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *tmpDict = [[NSDictionary alloc] initWithDictionary:[self.topics objectAtIndex:indexPath.row]];
    cell.textLabel.text = tmpDict[@"name"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BTNPlist *sharedPlist = [BTNPlist sharedPlist];
    NSMutableDictionary *issueDict = [[NSMutableDictionary alloc] initWithDictionary:sharedPlist.currentIssue];
    
    NSDictionary *topic = [[NSDictionary alloc] initWithDictionary:[_topics objectAtIndex:self.tableView.indexPathForSelectedRow.row]];
    NSString *topicName = topic[@"name"];
    NSNumber *topicValue = topic[@"value"];
    
    [issueDict setValue:topicName forKey:@"topic"];
    [issueDict setValue:topicValue forKey:@"topicid"];
    sharedPlist.currentIssue = issueDict;
    
    [sharedPlist save];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end

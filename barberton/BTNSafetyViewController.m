//
//  BTNSafetyViewController.m
//  barberton
//
//  Created by Christopher Stoll on 1/6/14.
//  Copyright (c) 2014 Christopher Stoll. All rights reserved.
//

#import "BTNSafetyViewController.h"
#import "BTNSafetyWebViewController.h"

@interface BTNSafetyViewController ()

@end

@implementation BTNSafetyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"tips"]){
        [[segue destinationViewController] setPageTitle:@"Police Tips"];
        [[segue destinationViewController] setPageURL:@"https://local.nixle.com/tip/city-of-barberton/"];
    } else if ([[segue identifier] isEqualToString:@"signs"]) {
        [[segue destinationViewController] setPageTitle:@"Signage Request"];
        [[segue destinationViewController] setPageURL:@"https://www.dropbox.com/s/ehnymjdd42f2uvv/Signage%20Request%20Form.pdf"];
    }
}

@end

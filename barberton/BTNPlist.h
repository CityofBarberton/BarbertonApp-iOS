//
//  BTNPlist.h
//  barberton
//
//  Created by Christopher Stoll on 1/7/14.
//  Copyright (c) 2014 Christopher Stoll. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PLIST_PATH @"barberton-settings.plist"
#define PLIST_RESOURCE @"barberton-settings"
#define PLIST_TYPE @"plist"

@interface BTNPlist : NSObject

@property (strong, nonatomic) NSArray *topics;

@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *phone;

@property (strong, nonatomic) NSDictionary *currentIssue;

+ (id)sharedPlist;
- (void)save;

@end

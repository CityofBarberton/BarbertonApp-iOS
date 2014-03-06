//
//  BTNPlist.h
//  barberton
//
//  Created by Christopher Stoll on 1/7/14.
//  Copyright (c) 2014 Christopher Stoll. All rights reserved.
//
//  This was designed for use with the BTNServices* classes
//  They need to share little bits of information, implementing
//  CoreData seemed like overkill, so did setting up listeners
//  and sending messages that way; besides I wan any data in the
//  services tab to persist until a request is submited (some
//  data, such as name and email, will persist forever).
//
//  Perhaps there is a better way to do this?
//

#import <Foundation/Foundation.h>

#define PLIST_PATH @"barberton-settings.plist"
#define PLIST_RESOURCE @"barberton-settings"
#define PLIST_TYPE @"plist"

#define PLIST_TOPICS @"topics"
#define PLIST_TOKEN @"token"
#define PLIST_EMAIL @"email"
#define PLIST_NAME @"name"
#define PLIST_ADDRESS @"address"
#define PLIST_PHONE @"phone"
#define PLIST_ISSUES @"issues"
#define PLIST_TOPIC @"topic"
#define PLIST_SUMMARY @"summary"
#define PLIST_LOCATION @"location"
#define PLIST_LAT @"lat"
#define PLIST_LON @"lon"
#define PLIST_DETAILS @"details"
#define PLIST_TOPIC @"topic"
#define PLIST_TOPIC_ID @"topicid"
#define PLIST_TOPIC_NAME @"name"
#define PLIST_TOPIC_VALUE @"value"

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

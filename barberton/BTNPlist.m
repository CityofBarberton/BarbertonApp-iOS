//
//  BTNPlist.m
//  barberton
//
//  Created by Christopher Stoll on 1/7/14.
//  Copyright (c) 2014 Christopher Stoll. All rights reserved.
//

#import "BTNPlist.h"

@interface BTNPlist () {
    NSMutableDictionary *plistDictionary;
}
@end

@implementation BTNPlist

/*
 * to set up a singleton
 */
+ (id)sharedPlist {
    static BTNPlist *sharedBTNPlist = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedBTNPlist = [[self alloc] init];
    });
    
    return sharedBTNPlist;
}

- (id)init {
    if (self = [super init]) {
        [self readPlist];
    }
    return self;
}

- (void)readPlist {
    NSString *plistPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    plistPath = [plistPath stringByAppendingPathComponent:PLIST_PATH];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:plistPath]) {
        NSString *sourcePath = [[NSBundle mainBundle] pathForResource:PLIST_RESOURCE ofType:PLIST_TYPE];
        [fileManager copyItemAtPath:sourcePath toPath:plistPath error:nil];
    }
    
    plistDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    _topics = [[NSArray alloc] initWithArray:plistDictionary[PLIST_TOPICS]];
    
    _token = plistDictionary[PLIST_TOKEN];
    _email = plistDictionary[PLIST_EMAIL];
    _name = plistDictionary[PLIST_NAME];
    _address = plistDictionary[PLIST_ADDRESS];
    _phone = plistDictionary[PLIST_PHONE];
    
    NSArray *plistIssues = [[NSArray alloc] initWithArray:plistDictionary[PLIST_ISSUES]];
    _currentIssue = [plistIssues firstObject];
}

- (void)savePlist {
    NSString *plistPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    plistPath = [plistPath stringByAppendingPathComponent:PLIST_PATH];
    
    plistDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    [plistDictionary setValue:_topics forKey:PLIST_TOPICS];
    [plistDictionary setValue:_token forKey:PLIST_TOKEN];
    [plistDictionary setValue:_email forKey:PLIST_EMAIL];
    [plistDictionary setValue:_name forKey:PLIST_NAME];
    [plistDictionary setValue:_address forKey:PLIST_ADDRESS];
    [plistDictionary setValue:_phone forKey:PLIST_PHONE];
    
    NSArray *issueList = [[NSArray alloc] initWithObjects:_currentIssue, nil];
    [plistDictionary setValue:issueList forKey:PLIST_ISSUES];
    
    [plistDictionary writeToFile:plistPath atomically:YES];
}

- (void)save {
    [self savePlist];
}

@end

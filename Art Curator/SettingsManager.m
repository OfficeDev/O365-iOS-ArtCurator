/*
 * Copyright (c) Microsoft. All rights reserved. Licensed under the MIT license.
 * See full license at the bottom of this file.
 */

#import "SettingsManager.h"

// Save file location
static NSString * const kArchiveFileName = @"settings.archive";

// Default values
static NSString *const kDefaultLikeResponse = @"Excellent submission. Please email me at your convenience to discuss a sale.";
static NSString *const kDefaultDislikeResponse = @"This submission isn't what I'm looking for. Thank you anyway.";
static NSString *const kDefaultsearchFolder = @"Inbox";

// Notifications
NSString * const SettingsChangedNotification    = @"SettingsChanged";

@interface SettingsManager()
@property (readonly, nonatomic) NSURL *saveURL;
@end

@implementation SettingsManager

#pragma mark - Singleton
+ (SettingsManager*) sharedInstance{
    static SettingsManager *sharedInstance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SettingsManager alloc] init];
        [sharedInstance setSettingsChanged:NO];
    });
    
    return sharedInstance;
}

#pragma mark - Initialization
- (instancetype) init{
    self = [super init];
    if(self){
        [self restoreDefaultSettings];
    }
    return self;
}

#pragma mark - Properties
/**
 *  Returns URL for settings file path
 *
 *  @return NSURL
 */
- (NSURL *)saveURL
{
    NSArray *documentURLs = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                                   inDomains:NSUserDomainMask];
    
    return [documentURLs[0] URLByAppendingPathComponent:kArchiveFileName];
}


/**
 *  Set search folder and post notifications - this is used for flagging a reload
*/
- (void) setSearchFolder:(NSString *)searchFolder{
    _searchFolder = searchFolder;
    [self setForReload:YES];
}

#pragma mark - Misc Public Methods
/**
 *  Send notification for reload
 *
 *  @param reload
 */
- (void) setForReload:(BOOL)reload{
    [[NSNotificationCenter defaultCenter] postNotificationName:SettingsChangedNotification object:nil];    
}

/**
 *  Restore default settings
 */
- (void)restoreDefaultSettings{
    self.likeActionMarkAsRead = YES;
    self.likeActionSendResponse = YES;
    self.likeResponseString = kDefaultLikeResponse;
    
    self.dislikeActionMarkAsRead = YES;
    self.dislikeActionSendResponse = YES;
    self.dislikeResponseString = kDefaultDislikeResponse;
    
    self.searchFolder = kDefaultsearchFolder;

    self.isLoggedIn = NO;
}

/**
 *  Load settings from saved file
 *
 *  @return BOOL success
 */
- (BOOL)reload{
    NSDictionary *settings = [NSKeyedUnarchiver unarchiveObjectWithFile:[self.saveURL path]];
    if(!settings)
        return NO;
    
    self.likeActionMarkAsRead       = [settings[@"likeActionMarkAsRead"] boolValue];
    self.likeActionSendResponse     = [settings[@"likeActionSendResponse"] boolValue];
    self.likeResponseString         = settings[@"likeResponseString"];
    self.dislikeActionMarkAsRead    = [settings[@"dislikeActionMarkAsRead"] boolValue];
    self.dislikeActionSendResponse  = [settings[@"dislikeActionSendResponse"] boolValue];
    self.dislikeResponseString      = settings[@"dislikeResponseString"];
    self.isLoggedIn                 = [settings[@"isLoggedIn"] boolValue];
    self.searchFolder               = settings[@"submissionFolder"];
    
    return YES;
}

/**
 *  Save settings to file
 *
 *  @return BOOL success
 */
- (BOOL)save{
    NSMutableDictionary *settings = [[NSMutableDictionary alloc] init];
    
    settings[@"likeActionMarkAsRead"]       = @(self.likeActionMarkAsRead);
    settings[@"likeActionSendResponse"]     = @(self.likeActionSendResponse);
    settings[@"likeResponseString"]         = self.likeResponseString;
    settings[@"dislikeActionMarkAsRead"]    = @(self.dislikeActionMarkAsRead);
    settings[@"dislikeActionSendResponse"]  = @(self.dislikeActionSendResponse);
    settings[@"dislikeResponseString"]      = self.dislikeResponseString;
    settings[@"isLoggedIn"]                 = @(self.isLoggedIn);
    settings[@"submissionFolder"]           = self.searchFolder;
    
    return [NSKeyedArchiver archiveRootObject:settings
                                       toFile:[self.saveURL path]];
}

/**
 *  Clear all settings
 *
 *  @return BOOL success
 */
- (BOOL) clearAll{
    [self restoreDefaultSettings];
    return [self save];
}
@end

// *********************************************************
//
// O365-iOS-Art Curator, https://TBD
//
// Copyright (c) Microsoft Corporation
// All rights reserved.
//
// MIT License:
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to
// the following conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
// LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
// *********************************************************

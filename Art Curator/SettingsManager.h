/*
 * Copyright (c) Microsoft. All rights reserved. Licensed under the MIT license.
 * See full license at the bottom of this file.
 */

#import <Foundation/Foundation.h>

extern NSString * const SettingsChangedNotification;

/**
 *  Class to handle Application Settings
 */
@interface SettingsManager : NSObject

// Properties
@property (nonatomic, assign) BOOL likeActionMarkAsRead;
@property (nonatomic, assign) BOOL likeActionSendResponse;
@property (nonatomic, strong) NSString *likeResponseString;

@property (nonatomic, assign) BOOL dislikeActionMarkAsRead;
@property (nonatomic, assign) BOOL dislikeActionSendResponse;
@property (nonatomic, strong) NSString *dislikeResponseString;

@property (nonatomic, strong) NSString *searchFolder;

@property (nonatomic, assign) BOOL isLoggedIn;

@property (nonatomic, strong) NSString *userEmail;

@property (nonatomic, assign) BOOL settingsChanged;

// Operations
- (BOOL) save;
- (BOOL) reload;
- (BOOL) clearAll;
- (void) setForReload:(BOOL)reload;

+ (SettingsManager*) sharedInstance;

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

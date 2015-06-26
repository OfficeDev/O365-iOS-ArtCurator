/*
 * Copyright (c) Microsoft. All rights reserved. Licensed under the MIT license.
 * See full license at the bottom of this file.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MSOutlookMessage;
@class MessageContainer;
@class MSOutlookAttachment;

extern NSString * const Office365ClientDidConnectNotification;
extern NSString * const Office365ClientDidDisconnectNotification;


/**
 *  Main class that talks to Office 365 and performs operations in Outlook
 */
@interface Office365Client : NSObject

// Dependencies
@property (strong,   nonatomic) NSNotificationCenter *notificationCenter;

// App specific credentials provided by Azure when registering the app
@property (readonly, nonatomic) NSString     *clientId;
@property (readonly, nonatomic) NSURL        *redirectURL;
@property (readonly, nonatomic) NSURL        *authorityURL;

// Convenience
@property (readonly, nonatomic) BOOL          isConnected;

- (instancetype)initWithClientId:(NSString *)clientId
                     redirectURL:(NSURL *)redirectURL
                    authorityURL:(NSURL *)authorityURL;


// Connect and disconnect from Office 365
- (void)connectWithCompletionHandler:(void (^)(BOOL success, NSString *email, NSError *error))completionHandler;
- (void)disconnectWithCompletionHandler:(void (^)(BOOL success, NSError *error))completionHandler;


// Fetching outlook messages
- (void) fetchMessageContainersFromFolder:(NSString*)targetFolderName
                                   filter:(NSString*)filter
                        completionHandler:(void (^)(NSArray *messages)) completionHandler;
- (void) fetchImageContentBytesFrom:(MessageContainer *)message completionHandler:(void (^)(UIImage *image))completionHandler;

// Updating a message
- (void) markMessage:(MessageContainer*)message
              isRead:(BOOL)isRead
   completionhandler:(void (^)(BOOL success, NSError*error))completionHandler;

// Replying to a message

- (void) replyToMessage:(MessageContainer*)message
           withComments:(NSString*)comments
      completionHandler:(void (^)(BOOL success, NSError *error))completionHandler;

// Send message with attachment
- (void) sendMailWithSubject:(NSString*)subject
                        body:(NSString*)bodyString
                   recipient:(NSString*)emailAddress
             fileContentType:(NSString*)contentType
                contentBytes:(NSData*)contentBytes
                    fileName:(NSString*)fileName
           completionHandler:(void (^)(BOOL success, NSError *error))completionHandler;

- (void) createDraftMessage:(NSString*)subject
      recipientEmailAddress:(NSString*)emailAddress
          completionHandler:(void (^)(MSOutlookMessage *addedMessage, NSError *error))completionHandler;

- (void) addAttachment:(MSOutlookMessage *)message
           fileContent:(NSString*)contentType
          contentBytes:(NSData*)contentBytes
     completionHandler:(void (^)(MSOutlookAttachment *attachment, NSError *error))completionHandler;

- (void) sendDraftMessageId:(NSString*)messageId
          completionHandler:(void (^)(BOOL success, NSError *error))completionHandler;

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

/*
 * Copyright (c) Microsoft. All rights reserved. Licensed under the MIT license.
 * See full license at the bottom of this file.
 */

#import "Office365Client.h"

#import <ADALiOS/ADAL.h>
#import <ADALiOS/ADKeychainTokenCacheStore.h>

#import <office365_odata_base/office365_odata_base.h>
#import <office365_discovery_sdk/office365_discovery_sdk.h>
#import <office365_exchange_sdk/office365_exchange_sdk.h>

#import "MessageContainer.h"

// Notifications
NSString * const Office365ClientDidConnectNotification    = @"Office365ClientDidConnectNotification";
NSString * const Office365ClientDidDisconnectNotification = @"Office365ClientDidDisconnectNotification";

// Discovery URL
static NSString * const kDiscoveryResourceId       = @"https://api.office.com/discovery/";
static NSString * const kDiscoveryEndpoint         = @"https://api.office.com/discovery/v1.0/me/";

static NSString * const kOffice365ServiceDiscovery = @"Discovery";
static NSString * const kOffice365ServiceMail      = @"Mail";

// App information
static NSString * const REDIRECT_URL_STRING = @"https://UseOnlyToRunTheArtCuratorSample";
static NSString * const CLIENT_ID           = @"1feaa784-0130-48d9-adeb-776fc65888c5";
static NSString * const AUTHORITY           = @"https://login.microsoftonline.com/common";

@interface Office365Client()<NSURLSessionTaskDelegate>

@property (strong, nonatomic) NSURLSession *urlSession;

/**
 The authenticationContext keeps track of the tokenCacheStore which is what
 holds on to our authentication tokens.  It also knows how to acquire new tokens
 if necessary.
 */
@property (readonly, nonatomic) ADAuthenticationContext *authenticationContext;

/**
 This lookup cache has NSString keys which are the service names, and
 MSDiscoveryServiceInfo objects as values.  This is used to find the
 endpoints for connecting to services like 'Mail'.
 */
@property (copy, nonatomic) NSDictionary *serviceInfoLookupCache;

@end

@implementation Office365Client

@synthesize authenticationContext = _authenticationContext;

/**
 Initialize with preset application information
 */
- (instancetype)init
{
    return [self initWithClientId:CLIENT_ID
                      redirectURL:[NSURL URLWithString:REDIRECT_URL_STRING]
                     authorityURL:[NSURL URLWithString:AUTHORITY]];
}

/**
 *  Initialize with specific application information
 *
 *  @param clientId     Client ID
 *  @param redirectURL  Redirect URL
 *  @param authorityURL Authority URL
 *
 *  @return Office365Client - instancetype
 */
- (instancetype)initWithClientId:(NSString *)clientId
                     redirectURL:(NSURL *)redirectURL
                    authorityURL:(NSURL *)authorityURL
{
    self = [super init];
    
    if (self) {
        _clientId     = [clientId copy];
        _redirectURL  = redirectURL;
        _authorityURL = authorityURL;
    }
    
    return self;
}


#pragma mark - Properties
/**
 *  Creates and returns ADAuthenticationContext
 *
 *  @return ADAuthenticationContext (Azure AC Authentication)
 */
- (ADAuthenticationContext *)authenticationContext
{
    if (!_authenticationContext) {
        ADAuthenticationError *error;
        
        _authenticationContext = [ADAuthenticationContext authenticationContextWithAuthority:self.authorityURL.absoluteString
                                                                                       error:&error];
        
        if (!_authenticationContext) {
            NSLog(@"ERROR: Unable to create an authentication context. {%@}", [error localizedDescription]);
            NSLog(@"ERROR: Be sure that the authority is correct: '%@'", self.authorityURL);
        }
    }
    
    id tokenCache = _authenticationContext.tokenCacheStore;
    
    if ([tokenCache isKindOfClass:[ADKeychainTokenCacheStore class]]) {
        // If the application needs to share the cached tokens with other applications from the same vendor, the app will need to specify the
        // shared group here and add the necessary entitlements to the application.
        // See Apple's keychain services documentation for details.
        [tokenCache setSharedGroup:nil];
    }
    
    return _authenticationContext;
}

/**
 *  Returns is connected
 *
 *  @return isConnected - simply check against serviceInfoLoopupCache
 */

- (BOOL)isConnected
{
    return self.serviceInfoLookupCache != nil;
}

/**
 *  Returns shared URL session
 *
 *  @return urlSession
 */
- (NSURLSession *)urlSession
{
    if (!_urlSession) {
        _urlSession = [NSURLSession sharedSession];
    }
    
    return _urlSession;
}

/**
 *  Returns default NSNotificationCenter
 *
 *  @return notificationCenter
 */
- (NSNotificationCenter *)notificationCenter
{
    if (!_notificationCenter) {
        _notificationCenter = [NSNotificationCenter defaultCenter];
    }
    return _notificationCenter;
}


#pragma mark - Connect
/**
 *  Connects to Office 365.
 *  First it connects to Azure AD and fetches a token. It then, tries to look up service endpoints for the user using discovery services.
 *
 *  @param completionHandler
 */
- (void)connectWithCompletionHandler:(void (^)(BOOL success, NSString *email, NSError *error))completionHandler
{
    // acquire token
    [self fetchAuthTokenWithCompletionHandler:^(ADAuthenticationResult *result) {
        
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey:             @"Cannot create service client.",
                                   NSLocalizedFailureReasonErrorKey:      @"Service endpoints could not be found.",
                                   NSLocalizedRecoverySuggestionErrorKey: @"Consider reconnecting."};
        
        if(AD_FAILED == result.status){
            completionHandler(NO, nil, [NSError errorWithDomain:@"Office365"
                                                      code:-1
                                                  userInfo:userInfo]);
        }else if(AD_USER_CANCELLED == result.status){
            completionHandler(NO, nil, nil);
        }
        else{
            [self fetchServiceInfosWithCompletionHandler:^(NSDictionary *serviceInfoLookup, NSError *error) {
                BOOL success = (serviceInfoLookup != nil);
                if(success){
                    [self.notificationCenter postNotificationName:Office365ClientDidConnectNotification
                                                           object:self];
                    completionHandler(YES, [[result tokenCacheStoreItem] userInformation].userId, nil);
                }
                else{
                    completionHandler(NO, nil, [NSError errorWithDomain:@"Office365"
                                                              code:-1
                                                          userInfo:userInfo]);
                }
            }];
        }
    }];
}


/**
 *  Disconnect from Office 365.
 *
 *  @param completionHandler
 */
- (void)disconnectWithCompletionHandler:(void (^)(BOOL success, NSError *error))completionHandler
{
    ADAuthenticationError *error;
    [self.authenticationContext.tokenCacheStore removeAllWithError:&error];
    
    if (error) {
        NSLog(@"ERROR: Had trouble disconnecting, but will ignore it. {%@}", [error localizedDescription]);
    }
    // Remove all of the cookies from the session's cookie store.
    NSHTTPCookieStorage *cookieStore = self.urlSession.configuration.HTTPCookieStorage;
    
    for (NSHTTPCookie *cookie in cookieStore.cookies) {
        [cookieStore deleteCookie:cookie];
    }
    
    // Clear our local caches
    self.serviceInfoLookupCache = nil;
    
    if (completionHandler) {
        completionHandler(YES, nil);
    }
    
    [self.notificationCenter postNotificationName:Office365ClientDidDisconnectNotification
                                           object:self];

}

/**
 *  Fetches Azure AD Authentication token
 *
 *  @param completionHandler
 */
- (void)fetchAuthTokenWithCompletionHandler:(void (^)(ADAuthenticationResult *result))completionHandler{
    [self.authenticationContext acquireTokenWithResource:kDiscoveryResourceId
                                                clientId:self.clientId
                                             redirectUri:self.redirectURL
     
                                         completionBlock:^(ADAuthenticationResult *result) {
                                             completionHandler(result);
                                         }];
}

#pragma mark - Discovery
/**
 *  Fetches service endpoints using the AD Authentication context.
 *
 *  @param completionHandler
 */
- (void)fetchServiceInfosWithCompletionHandler:(void (^)(NSDictionary *serviceInfoLookup, NSError *error))completionHandler
{
    if (self.serviceInfoLookupCache) {
        completionHandler(self.serviceInfoLookupCache, nil);
        return;
    }

    ADALDependencyResolver *dependencyResolver = [[ADALDependencyResolver alloc] initWithContext:self.authenticationContext
                                                                                      resourceId:kDiscoveryResourceId
                                                                                        clientId:self.clientId
                                                                                     redirectUri:self.redirectURL];
    
    MSDiscoveryClient *discoveryClient = [[MSDiscoveryClient alloc] initWithUrl:kDiscoveryEndpoint
                                                             dependencyResolver:dependencyResolver];
    MSDiscoveryServiceInfoCollectionFetcher *serviceInfoCollectionFetcher = [discoveryClient getservices];

    /**
     *  Retrieves MSDiscoveryServiceInfoCollectionFetcher by calling readWithCallback
     *
     *  @param serviceInfos service information in an array
     *  @param error
     *
     *  @return
     */
    NSURLSessionTask *servicesTask = [serviceInfoCollectionFetcher readWithCallback:^(NSArray<MSDiscoveryServiceInfo> *serviceInfos, MSODataException *error) {
        if(serviceInfos.count == 0 && error){
            completionHandler(nil, error);
        }
        if (serviceInfos.count == 0) {
            NSLog(@"WARNING: There are no service endpoints for the authenticated user.");
        }
        NSMutableDictionary *serviceInfoLookup = [[NSMutableDictionary alloc] init];
        for (MSDiscoveryServiceInfo *serviceInfo in serviceInfos) {
            serviceInfoLookup[serviceInfo.capability] = serviceInfo;
        }
        self.serviceInfoLookupCache = serviceInfoLookup;
        completionHandler([serviceInfoLookup copy], nil);
    }];
    [servicesTask resume];
    
}


/**
 *  Fetches OutlookClient using ADAuthenticationContext and service endpoints
 *
 *  @param completionHandler
 */
- (void)fetchOutlookClientWithCompletionHandler:(void (^)(MSOutlookClient *outlookClient, NSError *error))completionHandler{
    
    [self.authenticationContext acquireTokenWithResource:[self.serviceInfoLookupCache[kOffice365ServiceMail] serviceResourceId]
                                                clientId:self.clientId
                                             redirectUri:self.redirectURL
                                         completionBlock:^(ADAuthenticationResult *result) {
                                             if (result.status != AD_SUCCEEDED) {
                                                 completionHandler(nil, result.error);
                                                 return;
                                             }
                                             ADALDependencyResolver *dependencyResolver = [[ADALDependencyResolver alloc] initWithContext:self.authenticationContext
                                                                                                                               resourceId:[self.serviceInfoLookupCache[kOffice365ServiceMail] serviceResourceId]
                                                                                                                                 clientId:self.clientId
                                                                                                                              redirectUri:self.redirectURL];
                                             
                                             MSOutlookClient   *serviceClient      = [[MSOutlookClient alloc] initWithUrl:[self.serviceInfoLookupCache[kOffice365ServiceMail] serviceEndpointUri]
                                                                                                        dependencyResolver:dependencyResolver];
                                             
                                             completionHandler(serviceClient, nil);
                                         }];
}


/**
 *  Fetches array of messages from a folder using filters
 *
 *  @param targetFolderName  target folder
 *  @param filter            filter string (use REST filtering feature - 
 *                           https://msdn.microsoft.com/office/office365/APi/complex-types-for-mail-contacts-calendar#RESTAPIResourcesMessage
 *                           e.g./ HasAttachments eq true
 *  @param completionHandler
 */
- (void) fetchMessageContainersFromFolder:(NSString*)targetFolderName
                                   filter:(NSString*)filter
                        completionHandler:(void (^)(NSArray *messages)) completionHandler

{
    [self fetchOutlookClientWithCompletionHandler:^(MSOutlookClient *outlookClient, NSError *error) {
        MSOutlookUserFetcher *userFetcher = [outlookClient getMe];
        MSOutlookFolderCollectionFetcher *folderCollectionFetcher = [userFetcher getFolders];
        
        /**
         *  retrieves folders
         *
         *  @param folders   array of retrieved folders
         *  @param exception error information if they are found, for now ignore any errors
         *
         *  @return
         */
        NSURLSessionTask *task = [folderCollectionFetcher readWithCallback:^(NSArray<MSOutlookFolder> *folders, MSODataException *exception) {
            BOOL folderFound = NO;
            
            for (MSOutlookFolder *folder in folders){
                // folder found
                if([[folder.DisplayName lowercaseString] isEqualToString:[targetFolderName lowercaseString]]){
                    folderFound = YES;

                    MSOutlookMessageCollectionFetcher *messageCollectionFetcher =  [[folderCollectionFetcher getById:folder.Id] getMessages];
                    [messageCollectionFetcher select:@"Id, Subject, Sender, DateTimeReceived, Body"];

                    // Have to include DateTimeReceived -
                    // If filter and orderby are used together, properties in filter
                    [messageCollectionFetcher filter:filter];

                    // To fetch more, we need fetch again until there are no messages - use "skip" property for paging.
                    [messageCollectionFetcher top:50];
                    [messageCollectionFetcher skip:0];
                    
                    NSMutableArray *messageAndAttachmentIds = [NSMutableArray new];
                    
                    [[messageCollectionFetcher readWithCallback:^(NSArray<MSOutlookMessage> *messages, MSODataException *exception) {
                        NSUInteger numberOfMessages = [messages count];
                        
                        if(numberOfMessages == 0){
                            completionHandler(@[]);
                            return;
                        }
                        
                        __block int counter = 0;
                        
                        for(MSOutlookMessage *singleMessage in messages){
                            MSOutlookAttachmentCollectionFetcher *attachmentCollectionFetcher = [[userFetcher getMessagesById:singleMessage.Id] getAttachments];
                            [attachmentCollectionFetcher select:@"ContentType"];
                            NSURLSessionTask *task = [attachmentCollectionFetcher readWithCallback:^(NSArray<MSOutlookAttachment> *attachments, MSODataException *exception) {
                                counter++;
                                for(MSOutlookAttachment *singleAttachment in attachments){
                                    
                                    if([singleAttachment.ContentType isEqualToString:@"image/png"] ||
                                       [singleAttachment.ContentType isEqualToString:@"image/jpeg"]){

                                        MessageContainer *container = [[MessageContainer alloc] initWithMessageId:singleMessage.Id
                                                                                                     attachmentId:singleAttachment.Id
                                                                                                         dateTime:singleMessage.DateTimeReceived
                                                                                                           sender:singleMessage.Sender.EmailAddress.Name
                                                                                                          subject:singleMessage.Subject
                                                                                                             body:singleMessage.Body.Content
                                                                                                       isBodyHTML:singleMessage.Body.ContentType == MSOutlook_BodyType_HTML];
                                        
                                        [messageAndAttachmentIds addObject:container];
                                    }
                                }
                                if(counter == numberOfMessages){
                                    
                                    [messageAndAttachmentIds sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                                        MessageContainer *m1 = (MessageContainer*)obj1;
                                        MessageContainer *m2 = (MessageContainer*)obj2;
                                        
                                        NSDate *m1date = m1.dateTime;
                                        NSDate *m2date = m2.dateTime;
                                        
                                        return [m1date compare:m2date] == NSOrderedAscending;
                                    }];
                                    
                                    completionHandler(messageAndAttachmentIds);
                                    return;
                                }
                            }];
                            [task resume];
                        }
                    }] resume];
                }
            }
            if(!folderFound)
                completionHandler(nil);
        }];
        [task resume];
    }];
}

/**
 *  Fetch contentBytes and return as an image
 *
 *  @param message           MSOutlookMessage information
 *  @param completionHandler
 */
- (void) fetchImageContentBytesFrom:(MessageContainer *)message completionHandler:(void (^)(UIImage *image))completionHandler{
    [self fetchOutlookClientWithCompletionHandler:^(MSOutlookClient *outlookClient, NSError *error) {
        MSOutlookUserFetcher *userFetcher = [outlookClient getMe];
        MSOutlookMessageFetcher *messageFetcher = [userFetcher getMessagesById:message.messageId];
        MSOutlookAttachmentFetcher *attachmentFetcher = [messageFetcher getAttachmentsById:message.attachmentId];
        
        /**
         *  read in file attachment from message
         *
         *  @param fileAttachment
         *  @param exception      error information if they are found, for now ignore any errors
         *
         *  @return <#return value description#>
         */
        [[[attachmentFetcher asFileAttachment] readWithCallback:^(MSOutlookFileAttachment *fileAttachment, MSODataException *exception) {
            
            completionHandler([UIImage imageWithData:fileAttachment.ContentBytes]);
        }] resume];
    }];
        
}

/**
 *  Mark message as read/unread
 *
 *  @param message
 *  @param isRead
 *  @param completionHandler
 */
- (void) markMessage:(MessageContainer*)message
              isRead:(BOOL)isRead
   completionhandler:(void (^)(BOOL success, NSError*error))completionHandler{
    // SDK Bug : The following doesnot work as of 0.9.1. Instead, will use updateRaw function
//    [self fetchOutlookClientWithCompletionHandler:^(MSOutlookClient *outlookClient, NSError *error) {
//        MSOutlookUserFetcher *userFetcher = [outlookClient getMe];
//        MSOutlookMessageFetcher *messageFetcher = [userFetcher getMessagesById:message.messageId];
//        [[messageFetcher readWithCallback:^(MSOutlookMessage *message, MSODataException *exception) {
//            [message setIsRead:YES];
//            [[messageFetcher updateMessage:message callback:^(MSOutlookMessage *message, MSODataException *error) {
//            }] resume];
//            
//        }] resume];
//        
//    }];
    NSError *error;
    NSData  *jsonPayload = [NSJSONSerialization dataWithJSONObject:@{@"IsRead" : @(isRead)}
                                                           options:0
                                                             error:&error];
    NSString *jsonPayloadString = [[NSString alloc] initWithData:jsonPayload encoding:NSUTF8StringEncoding];
    
    [self fetchOutlookClientWithCompletionHandler:^(MSOutlookClient *outlookClient, NSError *error) {
        MSOutlookUserFetcher *userFetcher = [outlookClient getMe];
        MSOutlookMessageFetcher *messageFetcher = [userFetcher getMessagesById:message.messageId];
        
        /**
         *  updates an email message
         *
         *  @param response
         *  @param error
         *
         */
        [[messageFetcher updateRaw:jsonPayloadString callback:^(NSString *response, MSODataException *error) {
            if(!response)
                completionHandler(NO, error);
            else
                completionHandler(YES, nil);
        }] resume];
    }];
}


/**
 *  Reply to a message
 *
 *  @param message
 *  @param comments
 *  @param completionHandler
 */
- (void) replyToMessage:(MessageContainer*)message
           withComments:(NSString*)comments
      completionHandler:(void (^)(BOOL success, NSError *error))completionHandler{
    [self fetchOutlookClientWithCompletionHandler:^(MSOutlookClient *outlookClient, NSError *error) {
        MSOutlookUserFetcher *userFetcher = [outlookClient getMe];
        MSOutlookMessageFetcher *messageFetcher = [userFetcher getMessagesById:message.messageId];
        MSOutlookMessageOperations *messageOperations = [messageFetcher operations];
        
        /**
         *  reply to a message with comments
         *
         *  @param returnValue 0 for success
         *  @param error
         *
         */
        NSURLSessionTask *replyTask = [messageOperations replyWithComment:comments callback:^(int returnValue, MSODataException *error) {
            BOOL success = (returnValue == 0);
            completionHandler(success, error);
        }];
        [replyTask resume];
    }];
}


/**
 *  Send mail to recipient with attachment
 *     note: this implementation will support 1 attachment and 1 repicient. 
 *           if more is needed, simply add to the array of attachment and 
 *           recipients respectively.
 *
 *  @param subject           Email subject
 *  @param emailAddress      Email address
 *  @param contentType       Content type (e.g./ "image/png", "image/jpeg")
 *  @param contentBytes      Content payload
 *  @param fileName          Content name
 *  @param completionHandler
 */
- (void) sendMailWithSubject:(NSString*)subject
                        body:(NSString*)bodyString
                   recipient:(NSString*)emailAddress
             fileContentType:(NSString*)contentType
                contentBytes:(NSData*)contentBytes
                    fileName:(NSString*)fileName
           completionHandler:(void (^)(BOOL success, NSError *error))completionHandler{
    
    [self fetchOutlookClientWithCompletionHandler:^(MSOutlookClient *outlookClient, NSError *error) {
        MSOutlookUserFetcher *userFetcher = [outlookClient getMe];
        MSOutlookMessage *message = [[MSOutlookMessage alloc] init];
        MSOutlookUserOperations *operations = [userFetcher operations];
        
        // set recipient
        MSOutlookRecipient *recipient = [[MSOutlookRecipient alloc] init];
        MSOutlookEmailAddress *email = [[MSOutlookEmailAddress alloc] init];
        [email setAddress:emailAddress];
        [recipient setEmailAddress:email];
        [message setToRecipients:(NSMutableArray<MSOutlookRecipient>*)@[recipient]];
        
        // set subject
        [message setSubject:subject];

        // set body
        MSOutlookItemBody *body = [[MSOutlookItemBody alloc] init];
        body.ContentType = MSOutlook_BodyType_Text;
        body.Content = bodyString;
        [message setBody:body];
        
        // set attachment
        MSOutlookFileAttachment *fileAttachment = [[MSOutlookFileAttachment alloc] init];
        [fileAttachment setContentBytes:contentBytes];
        [fileAttachment setName:fileName];
        [fileAttachment setSize:(int)[contentBytes length]];
        [fileAttachment setContentType:contentType];
        
        NSMutableArray *attachments = [NSMutableArray new];
        [attachments addObject:fileAttachment];
        
        message.Attachments = (NSMutableArray<MSOutlookAttachment>*)attachments;
        
        /**
         *  send mail
         *
         *  @param returnValue 0 for success
         *  @param exception
         *
         */
        [[operations sendMailWithMessage:message
                         saveToSentItems:YES callback:^(int returnValue, MSODataException *exception) {
                             if(returnValue == 0)
                                 completionHandler(YES, nil);
                             else
                                 completionHandler(NO, exception);
                             
                         }] resume];
    }];

}



/**
 *  Creates a message and saves it to draft folder
 *
 *  @param subject
 *  @param emailAddress
 *  @param completionHandler
 */
- (void) createDraftMessage:(NSString*)subject
      recipientEmailAddress:(NSString*)emailAddress
          completionHandler:(void (^)(MSOutlookMessage *addedMessage, NSError *error))completionHandler{
    [self fetchOutlookClientWithCompletionHandler:^(MSOutlookClient *outlookClient, NSError *error) {
        MSOutlookUserFetcher *userFetcher = [outlookClient getMe];
        MSOutlookMessageCollectionFetcher *messageCollectionFetcher = [userFetcher getMessages];
        
        MSOutlookMessage *message = [[MSOutlookMessage alloc] init];
        
        MSOutlookRecipient *recipient = [[MSOutlookRecipient alloc] init];
        MSOutlookEmailAddress *email = [[MSOutlookEmailAddress alloc] init];

        [email setAddress:emailAddress];
        [recipient setEmailAddress:email];
        
        [message setSubject:subject];
        
        [message setToRecipients:(NSMutableArray<MSOutlookRecipient>*)@[recipient]];
        
        /**
         *  create a draft mail that gets stored in draft folder
         *
         *  @param message
         *  @param error       errors
         *
         */
        [[messageCollectionFetcher addMessage:message
                                     callback:^(MSOutlookMessage *message, MSODataException *error) {
                                         if(error){
                                             completionHandler(nil, error);
                                         }
                                         else{
                                             completionHandler(message, error);
                                         }
                                     }] resume];
    }];
}



/**
 *  Adds an attachment to an existing draft message
 *
 *  @param message
 *  @param contentType
 *  @param contentBytes
 *  @param completionHandler
 */
- (void) addAttachment:(MSOutlookMessage *)message
           fileContent:(NSString*)contentType
          contentBytes:(NSData*)contentBytes
     completionHandler:(void (^)(MSOutlookAttachment *attachment, NSError *error))completionHandler{
    [self fetchOutlookClientWithCompletionHandler:^(MSOutlookClient *outlookClient, NSError *error) {
        MSOutlookUserFetcher *userFetcher = [outlookClient getMe];
       
        MSOutlookAttachmentCollectionFetcher *attachmentCollectionFetcher = [[userFetcher getMessagesById:message.Id] getAttachments];
        NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:@"astronaut.png"]);
        
        MSOutlookFileAttachment *fileAttachment = [[MSOutlookFileAttachment alloc] init];
        [fileAttachment setContentBytes:imageData];
        [fileAttachment setName:@"NAME.png"];
        [fileAttachment setSize:(int)[imageData length]];
        [fileAttachment setContentType:@"image/png"];

        /**
         *  Add an attachment to a message (draft)
         *
         *  @param attachment
         *  @param e
         *
         *  @return attachment and an error
         */
        [[attachmentCollectionFetcher addAttachment:fileAttachment callback:^(MSOutlookAttachment *attachment, MSODataException *error) {
            if(error){
                completionHandler(nil, error);
            }
            else{
                completionHandler(attachment, nil);
            }
        }] resume];
    }];
    
}

/**
 *  Sends an existing draft message
 *
 *  @param messageId
 *  @param completionHandler
 */
- (void) sendDraftMessageId:(NSString*)messageId
          completionHandler:(void (^)(BOOL success, NSError *error))completionHandler{
    
    [self fetchOutlookClientWithCompletionHandler:^(MSOutlookClient *outlookClient, NSError *error) {
        MSOutlookUserFetcher *userFetcher = [outlookClient getMe];
        MSOutlookMessageFetcher *fetcher = [userFetcher getMessagesById:messageId];
        [[[fetcher operations] sendWithCallback:^(int returnValue, MSODataException *exception) {
            NSLog(@"Sent %@", exception);
        }] resume];
    }];
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

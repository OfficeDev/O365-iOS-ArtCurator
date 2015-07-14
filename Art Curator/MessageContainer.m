/*
 * Copyright (c) Microsoft. All rights reserved. Licensed under the MIT license.
 * See full license at the bottom of this file.
 */

#import "MessageContainer.h"

@implementation MessageContainer

@synthesize messageId = _messageId;
@synthesize attachmentId = _attachmentId;
@synthesize dateTime = _dateTime;
@synthesize sender = _sender;
@synthesize subject = _subject;
@synthesize description = _description;
@synthesize isBodyHTML = _isBodyHTML;

/**
 *  Initialization
 *
 *  @param messageId
 *  @param attachmentId
 *  @param dateTime
 *  @param sender
 *  @param subject
 *  @param body
 *  @param isBodyHTML
 *
 *  @return MessageContainer
 */
- (instancetype)initWithMessageId:(NSString*)messageId
                     attachmentId:(NSString*)attachmentId
                         dateTime:(NSDate*)dateTime
                           sender:(NSString*)sender
                          subject:(NSString*)subject
                             body:(NSString*)body
                       isBodyHTML:(BOOL)isBodyHTML;{
    
    self = [super init];
    if(self){
        _messageId = messageId;
        _attachmentId = attachmentId;
        _dateTime = dateTime;
        _subject = subject;
        _sender = sender;
        _body = body;
        _isBodyHTML = isBodyHTML;
    }
    return self;
}

@end

// *********************************************************
//
// O365-iOS-ArtCurator, https://github.com/OfficeDev/O365-iOS-ArtCurator
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

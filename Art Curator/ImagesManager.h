/*
 * Copyright (c) Microsoft. All rights reserved. Licensed under the MIT license.
 * See full license at the bottom of this file.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 Class for handling image caching
 It uses SDWebImage - https://github.com/rs/SDWebImage
 */
@interface ImagesManager : NSObject

// Initialization
- (instancetype) initWithNamespace:(NSString*)namespaceString;

// Adding and querying the image cache
- (void)addToImageCache:(UIImage*)image
              messageId:(NSString*)messageId
           attachmentId:(NSString*)attachmentId;

- (void)queryImageCacheWithMessageId:(NSString*)messageId
                         attchmentId:(NSString*)attachmentId
                   completionHandler:(void (^)(UIImage *image))completionHandler;


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

/*
 * Copyright (c) Microsoft. All rights reserved. Licensed under the MIT license.
 * See full license at the bottom of this file.
 */

#import "ImagesManager.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ImagesManager()

@property (nonatomic, strong) SDImageCache *imageCache;

@end


@implementation ImagesManager

/**
 *  Initialization
 *
 *  @param namespaceString namespace to be used in the imageCaching
 *
 *  @return ImageManager
 */
- (instancetype)initWithNamespace:(NSString *)namespaceString{
    self = [super init];
    if(self){
        _imageCache = [[SDImageCache alloc] initWithNamespace:namespaceString];
    }
    return self;
}

/**
 *  Local helper to create a key string for image caching
 *
 *  @param messageId
 *  @param attachmentId
 *
 *  @return Key String for the image caching
 */
- (NSString*)keyWithMessageId:(NSString*)messageId attachmentId:(NSString*)attachmentId{
    return [NSString stringWithFormat:@"%@_%@", messageId, attachmentId];
}


/**
 *  Add to image cache
 *
 *  @param image
 *  @param messageId
 *  @param attachmentId
 */
- (void)addToImageCache:(UIImage*)image
              messageId:(NSString*)messageId
           attachmentId:(NSString*)attachmentId{
    [self.imageCache storeImage:image forKey:[self keyWithMessageId:messageId attachmentId:attachmentId]];
}

/**
 *  Queries for an image
 *
 *  @param messageId
 *  @param attachmentId
 *  @param completionHandler 
 */
- (void)queryImageCacheWithMessageId:(NSString*)messageId
                             attchmentId:(NSString*)attachmentId
                   completionHandler:(void (^)(UIImage *image))completionHandler{
    [self.imageCache queryDiskCacheForKey:[self keyWithMessageId:messageId attachmentId:attachmentId]
                                     done:^(UIImage *image, SDImageCacheType cacheType) {
                                         completionHandler(image);
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

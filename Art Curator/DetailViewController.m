/*
 * Copyright (c) Microsoft. All rights reserved. Licensed under the MIT license.
 * See full license at the bottom of this file.
 */

#import "DetailViewController.h"
#import "MessageContainer.h"
#import "Office365Client.h"
#import "ImagesManager.h"
#import "SettingsManager.h"

static NSString * const kWebViewContentSizeKeyPath = @"scrollView.contentSize";

@interface DetailViewController ()

@end

@implementation DetailViewController

@synthesize activityIndicator = _activityIndicator;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // UI Settings
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.bodyWebView addObserver:self
                       forKeyPath:kWebViewContentSizeKeyPath
                          options:0
                          context:NULL];
    self.bodyWebView.scrollView.scrollEnabled = YES;

    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicator.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    self.activityIndicator.hidden = YES;
    
    [self.view addSubview:self.activityIndicator];
    
    [self loadUI];
}


- (void)dealloc
{
    [self.bodyWebView removeObserver:self
                          forKeyPath:kWebViewContentSizeKeyPath];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setToolbarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setToolbarHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Load UI
/**
 *  Loads the UI
 */
- (void)loadUI{
    // Set title and sender name
    self.titleLabel.text = self.message.subject;
    self.nameLabel.text = self.message.sender;
    
    // Set date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE MM/dd/yyyy hh:mm a"];
    NSLog(@"%@", self.message.dateTime);
    
    self.dateTimeLabel.text = [dateFormatter stringFromDate:self.message.dateTime];
    
    // Get Image
    [self.cacheManager queryImageCacheWithMessageId:self.message.messageId
                                        attchmentId:self.message.attachmentId completionHandler:^(UIImage *image) {
                                            if(image){
                                                self.imageView.image = image;
                                            }
                                            else{
                                                [self.o365Client fetchImageContentBytesFrom:self.message completionHandler:^(UIImage *image) {
                                                    [self.cacheManager addToImageCache:image
                                                                             messageId:self.message.messageId
                                                                          attachmentId:self.message.attachmentId];
                                                    dispatch_sync(dispatch_get_main_queue(), ^{
                                                        self.imageView.image = image;
                                                    });
                                                }];
                                            }
                                        }];
    [self.bodyWebView loadHTMLString:self.message.body baseURL:nil];
}


#pragma mark - Key Value Observing
// This will be called when the contentSize of the webView changes.  Here,
// we will update the height of the webView so that it is as large as it needs
// to be to accommodate all of its content.
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    
    if ([keyPath isEqualToString:kWebViewContentSizeKeyPath]) {
        CGSize newContentSize = self.bodyWebView.scrollView.contentSize;
        self.bodyWebViewHeightLayoutConstraint.constant = newContentSize.height;
    }
}

#pragma mark - Actions 
/**
 *  Action for like tapped
 *
 */
- (IBAction)likeTapped:(id)sender {
    // If mark as read is checked, update read status
    if([[SettingsManager sharedInstance] likeActionMarkAsRead])
        [self.o365Client markMessage:self.message isRead:YES completionhandler:^(BOOL success, NSError *error) {
            ;
        }];

    // If send response is set, send response
    if([[SettingsManager sharedInstance] likeActionSendResponse])
        [self.o365Client replyToMessage:self.message
                           withComments:[[SettingsManager sharedInstance] likeResponseString]
                      completionHandler:^(BOOL success, NSError *error) {
                          if(success){
                              NSLog(@"Reply sent succesfully");
                              [[SettingsManager sharedInstance] setForReload:YES];
                          }
                          else
                              NSLog(@"Reply sent failed - %@", error.localizedDescription);

                          dispatch_async(dispatch_get_main_queue(), ^{
                              [self.navigationController popViewControllerAnimated:YES];
                          });
                      }];
}

/**
 *  Action for dislike tapped
 *
 */
- (IBAction)dislikeTapped:(id)sender {
    // If mark as read is checked, update read status
    if([[SettingsManager sharedInstance] dislikeActionMarkAsRead])
        [self.o365Client markMessage:self.message isRead:YES completionhandler:^(BOOL success, NSError *error) {
            // Not do anything upon completion
        }];

    // If send response is set, send response
    if([[SettingsManager sharedInstance] dislikeActionSendResponse])
        [self.o365Client replyToMessage:self.message
                           withComments:[[SettingsManager sharedInstance] dislikeResponseString]
                      completionHandler:^(BOOL success, NSError *error) {
                          if(success){
                              NSLog(@"Reply sent succesfully");
                              [[SettingsManager sharedInstance] setForReload:YES];
                          }
                          else
                              NSLog(@"Reply sent failed - %@", error.localizedDescription);
                          
                          dispatch_async(dispatch_get_main_queue(), ^{
                              [self.navigationController popViewControllerAnimated:YES];
                          });
                      }];
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

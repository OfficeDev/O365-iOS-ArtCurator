/*
 * Copyright (c) Microsoft. All rights reserved. Licensed under the MIT license.
 * See full license at the bottom of this file.
 */

#import "ImagesCollectionViewController.h"
#import "Office365Client.h"
#import "MessageContainer.h"
#import "ImagesManager.h"
#import "DetailViewController.h"
#import "SettingsManager.h"
#import "SettingsTableViewController.h"
#import "MSOutlookAttachment.h"
#import "MSOutlookMessage.h"

@interface ImagesCollectionViewController ()

// Properties
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) ImagesManager *cacheManager;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) MessageContainer *selectedMessage;

@property (nonatomic, assign) BOOL needToReload;

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UILabel *noSubmissionsMessageLabel;
@property (nonatomic, strong) UILabel *imagesSentMessageLabel;
@property (nonatomic, strong) UIButton *populateButton;
@end

@implementation ImagesCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];

    // Initialize objects
    self.images = [NSMutableArray new];
    self.cacheManager = [[ImagesManager alloc] initWithNamespace:@"MyImageCache"];

    // Set need to reload to be true
    self.needToReload = YES;
  
    // Setup UI
    [self setupUI];
  
    // Add Observer
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(settingsChanged) name:SettingsChangedNotification object:nil];
}


- (void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Setup UI
/**
 *  Setup UI elements
 */
- (void) setupUI{
    // Add refresh control for pull to refresh
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(reloadImages)
             forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    [self.collectionView addSubview:self.refreshControl];
    self.collectionView.alwaysBounceVertical = YES;
    
    // Add background label to display status when there are zero messages
    self.backgroundView = [[UIView alloc] initWithFrame:self.view.frame];

    self.noSubmissionsMessageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.noSubmissionsMessageLabel.textColor = [UIColor blackColor];
    self.noSubmissionsMessageLabel.textAlignment = NSTextAlignmentCenter;
    self.noSubmissionsMessageLabel.text = @"No new submissions in this folder";
    [self.noSubmissionsMessageLabel sizeToFit];
    self.noSubmissionsMessageLabel.center = CGPointMake(self.backgroundView.center.x, self.backgroundView.center.y - 20);
    
    [self.backgroundView addSubview:self.noSubmissionsMessageLabel];
    
    self.populateButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.populateButton.layer.borderWidth = 1.f;
    self.populateButton.layer.borderColor = [self.view.tintColor CGColor];
    [self.populateButton setTitle:@"Send images to your inbox" forState:UIControlStateNormal];
    [self.populateButton addTarget:self action:@selector(populateInbox) forControlEvents:UIControlEventTouchUpInside];
    
    self.populateButton.frame = CGRectMake(self.backgroundView.center.x - 100, self.noSubmissionsMessageLabel.center.y + self.noSubmissionsMessageLabel.frame.size.height, 200, 30);
    [self.backgroundView addSubview:self.populateButton];
    
    self.imagesSentMessageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.imagesSentMessageLabel.font = [UIFont systemFontOfSize:13];
    self.imagesSentMessageLabel.numberOfLines = 0;
    self.imagesSentMessageLabel.textAlignment = NSTextAlignmentCenter;
    self.imagesSentMessageLabel.text = @"3 new art submissions have been sent \nto your inbox.\n\nPull to refresh the page when you receive them\nand move them to your target folder.";
    [self.imagesSentMessageLabel sizeToFit];
    self.imagesSentMessageLabel.center = CGPointMake(self.backgroundView.center.x,
                                                     self.populateButton.frame.origin.y + self.populateButton.frame.size.height +
                                                     self.imagesSentMessageLabel.frame.size.height/2 + 10);
    self.imagesSentMessageLabel.hidden = YES;
    
    [self.backgroundView addSubview:self.imagesSentMessageLabel];
    
    self.collectionView.backgroundView = self.backgroundView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Reloading
/**
 *  Flag to indicate need for reload
 */
- (void) settingsChanged{
    self.needToReload = YES;
}


- (void)viewWillAppear:(BOOL)animated{
    self.navigationItem.hidesBackButton = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    if(self.needToReload){
        self.needToReload = NO;
        [self reloadImages];
    }
}


/**
 *  Reloads attachment images
 */
- (void)reloadImages{
    // Clear current view
    self.backgroundView.hidden = YES;
    [self.images removeAllObjects];
    [self.collectionView reloadData];

    // Start refreshing
    [self.refreshControl beginRefreshing];

    // filter string (use REST filtering feature -
    //                           https://msdn.microsoft.com/office/office365/APi/complex-types-for-mail-contacts-calendar#RESTAPIResourcesMessage
    [self.o365Client fetchMessageContainersFromFolder:[[SettingsManager sharedInstance] searchFolder]
                                               filter:@"HasAttachments eq true and IsRead eq false"
                                    completionHandler:^(NSArray *messages) {
                                        [_images removeAllObjects];
                                        
                                        if(!messages){
                                            NSString *alertTitle = [NSString stringWithFormat:@"Folder not found - %@", [[SettingsManager sharedInstance] searchFolder]];
                                            NSString *alertMessage = @"The specified directory couldn't be found";
                                            
                                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertTitle
                                                                                                           message:alertMessage
                                                                                                    preferredStyle:UIAlertControllerStyleAlert];
                                            [alert addAction:[UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleCancel
                                                                                   handler:^(UIAlertAction *action) {
                                                                                       ;
                                                                                   }]];
                                            [alert addAction:[UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault
                                                                                    handler:^(UIAlertAction *action) {
                                                                                        [self performSegueWithIdentifier:@"showSettings" sender:self];
                                                                                    }]];
                                            [self presentViewController:alert animated:YES completion:^{
                                                    [self.refreshControl endRefreshing];
                                            }];
                                            return;
                                        }
                                        for(MessageContainer *message in messages)
                                            [self.images addObject:message];
                                        
                                        dispatch_sync(dispatch_get_main_queue(), ^{
                                            if([messages count] == 0){
                                                self.noSubmissionsMessageLabel.text = @"No new submissions in this folder";
                                                self.backgroundView.hidden = NO;
                                            }
                                                
                                            else{
                                                self.backgroundView.hidden = YES;
                                            }
                                            
                                            [self.collectionView reloadData];
                                            [self.refreshControl endRefreshing];
                                        });
                                    }];
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_images count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    UIImageView *imageView = (UIImageView*)[cell viewWithTag:100];
    imageView.clipsToBounds = YES;

    MessageContainer *message = [self.images objectAtIndex:indexPath.row];

    // Fetch image from the image cache.
    // If it doesnot exist, download content bytes and add to image cache.
    imageView.image = nil;
    
    [self.cacheManager queryImageCacheWithMessageId:message.messageId
                                        attchmentId:message.attachmentId completionHandler:^(UIImage *image) {
                                            if(image){
                                                imageView.image = image;
                                            }
                                            else{
                                                [self.o365Client fetchImageContentBytesFrom:message completionHandler:^(UIImage *image) {
                                                    dispatch_sync(dispatch_get_main_queue(), ^{
                                                        [self.cacheManager addToImageCache:image messageId:message.messageId attachmentId:message.attachmentId];
                                                        imageView.image = image;
                                                    });
                                                }];
                                            }
                                        }];
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    // Calculate size to fit 4 in smaller of the screen width and height
    CGFloat size = ((self.view.frame.size.width < self.view.frame.size.height)?self.view.frame.size.width:self.view.frame.size.height)/4 - 1;
    return CGSizeMake(size, size);
}


- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedMessage = self.images[indexPath.row];
    [self performSegueWithIdentifier:@"showDetail" sender:self];
    
    return YES;
}

#pragma mark - Populate messages
/**
 *  Send 3 mails with attachments to self
 */
- (void) populateInbox{

    self.noSubmissionsMessageLabel.text = @"Populating";
    self.populateButton.enabled = NO;
    
    [self checkPopulatingCompleteWithTotalNumber:3 start:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.o365Client sendMailWithSubject:@"Cyborg"
                                        body:@"Check out cyborg.png"
                                   recipient:[[SettingsManager sharedInstance] userEmail]
                             fileContentType:@"image/png"
                                contentBytes:UIImagePNGRepresentation([UIImage imageNamed:@"cyborg.png"])
                                    fileName:@"cyborg.png"
                           completionHandler:^(BOOL success, NSError *error) {
                               [self checkPopulatingCompleteWithTotalNumber:0 start:NO];
                               
                           }];
        [self.o365Client sendMailWithSubject:@"Robot art"
                                        body:@"Check out robot.png"
                                   recipient:[[SettingsManager sharedInstance] userEmail]
                             fileContentType:@"image/png"
                                contentBytes:UIImagePNGRepresentation([UIImage imageNamed:@"robot.png"])
                                    fileName:@"robot.png"
                           completionHandler:^(BOOL success, NSError *error) {
                               [self checkPopulatingCompleteWithTotalNumber:0 start:NO];
                           }];
        [self.o365Client sendMailWithSubject:@"Astronaut"
                                        body:@"Check out Astronaut"
                                   recipient:[[SettingsManager sharedInstance] userEmail]
                             fileContentType:@"image/png"
                                contentBytes:UIImagePNGRepresentation([UIImage imageNamed:@"astronaut.png"])
                                    fileName:@"astronaut.png"
                           completionHandler:^(BOOL success, NSError *error) {
                               [self checkPopulatingCompleteWithTotalNumber:0 start:NO];
                           }];
       
        
        
    });
}


/**
 *  Check if all mails are sent.
 *
 *  @param total total number of sent items
 *  @param start indicates start or not, if start, start counting
 */
- (void) checkPopulatingCompleteWithTotalNumber:(int)total start:(BOOL)start{
    static int counter = 0;
    static int totalNum = 0;
    if(start){
        counter = 0;
        totalNum = total;
    }
    
    else{
        counter++;
        if(totalNum == counter){
            dispatch_sync(dispatch_get_main_queue(), ^{
                self.imagesSentMessageLabel.hidden = NO;
                self.noSubmissionsMessageLabel.text = @"";
                self.populateButton.enabled = YES;
            });
        }
    }
}
    
    
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"showDetail"]){
        DetailViewController *vc = segue.destinationViewController;
        vc.message = self.selectedMessage;
        vc.o365Client = self.o365Client;
        vc.cacheManager = self.cacheManager;
    }
    else if([[segue identifier] isEqualToString:@"showSettings"]){
        SettingsTableViewController *vc = segue.destinationViewController;
        vc.o365Client = self.o365Client;
    }
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

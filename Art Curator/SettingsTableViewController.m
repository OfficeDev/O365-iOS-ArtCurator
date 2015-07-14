/*
 * Copyright (c) Microsoft. All rights reserved. Licensed under the MIT license.
 * See full license at the bottom of this file.
 */

#import "SettingsTableViewController.h"
#import "SettingsManager.h"
#import "Office365Client.h"
#import "SettingsResponseTableViewController.h"

@interface SettingsTableViewController ()

@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [self reloadSettings];
}

#pragma mark - UI change
/**
 *  Reload Settings
 */
- (void) reloadSettings{
    self.emailAddressLabel.text = [[SettingsManager sharedInstance] userEmail];
    self.searchFolderCell.textLabel.text = [[SettingsManager sharedInstance] searchFolder];
    
    self.likeMarkAsReadSwitch.on = [[SettingsManager sharedInstance] likeActionMarkAsRead];
    self.likeSendResponseSwitch.on = [[SettingsManager sharedInstance] likeActionSendResponse];
    self.dislikeMarkAsReadSwitch.on = [[SettingsManager sharedInstance] dislikeActionMarkAsRead];
    self.dislikeSendResponseSwitch.on = [[SettingsManager sharedInstance] dislikeActionSendResponse];
 
    [self enableLikeResponseCell:self.likeSendResponseSwitch.on];
    [self enableDisikeResponseCell:self.dislikeSendResponseSwitch.on];
}

#pragma mark - Actions
/**
 *  Sign out tapped
 *
 */
- (IBAction)signoutTapped:(id)sender {
    [self.o365Client disconnectWithCompletionHandler:^(BOOL success, NSError *error) {
        [[SettingsManager sharedInstance] clearAll];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}

/**
 *  Toggle switch on mark as read
 *
 */
- (IBAction)onToggleLikeMarkAsReadSwitch:(UISwitch *)sender {
    [[SettingsManager sharedInstance] setLikeActionMarkAsRead:sender.on];
    [[SettingsManager sharedInstance] save];
}

/**
 *  Toggle switch on send response
 *
 */
- (IBAction)onToggleLikeSendResponseSwitch:(UISwitch *)sender {
    [[SettingsManager sharedInstance] setLikeActionSendResponse:sender.on];
    [[SettingsManager sharedInstance] save];
    [self enableLikeResponseCell:self.likeSendResponseSwitch.on];
}

/**
 *  Toggle switch on mark as read
 *
 */
- (IBAction)onToggleDislikeMarkAsReadSwitch:(UISwitch *)sender {
    [[SettingsManager sharedInstance] setDislikeActionMarkAsRead:sender.on];
    [[SettingsManager sharedInstance] save];
}

/**
 *  Toggle switch on send response
 *
 */
- (IBAction)onToggleDisikeSendResponseSwitch:(UISwitch *)sender {
    [[SettingsManager sharedInstance] setDislikeActionSendResponse:sender.on];
    [[SettingsManager sharedInstance] save];
    [self enableDisikeResponseCell:self.dislikeSendResponseSwitch.on];    
}

#pragma mark - Misc UI Helper functions
/**
 *  Enable/Disable like response cell
 *
 *  @param show
 */
- (void)enableLikeResponseCell:(BOOL)show{
    self.likeResponseCell.textLabel.enabled = show;
    self.likeResponseCell.detailTextLabel.enabled = show;
    self.likeResponseCell.userInteractionEnabled = show;
}

/**
 *  Enable/Disable like response cell
 *
 *  @param show
 */
- (void)enableDisikeResponseCell:(BOOL)show{
    self.dislikeResponseCell.textLabel.enabled = show;
    self.dislikeResponseCell.detailTextLabel.enabled = show;
    self.dislikeResponseCell.userInteractionEnabled = show;
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"editLikeMessage"]){
        SettingsResponseTableViewController *vc = segue.destinationViewController;
        vc.settingsValueType = SettingsLikeResponse;
        
    }else if([segue.identifier isEqualToString:@"editDislikeMessage"]){
        SettingsResponseTableViewController *vc = segue.destinationViewController;
        vc.settingsValueType = SettingsDislikeResponse;
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

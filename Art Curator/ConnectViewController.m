/*
 * Copyright (c) Microsoft. All rights reserved. Licensed under the MIT license.
 * See full license at the bottom of this file.
 */

#import "ConnectViewController.h"
#import "Office365Client.h"

#import <office365_odata_base/office365_odata_base.h>
#import <office365_exchange_sdk/office365_exchange_sdk.h>
#import "MSOutlookMessageCollectionFetcher.h"
#import "MSDiscoveryServiceInfoCollectionFetcher.h"

#import "ImagesCollectionViewController.h"
#import "SettingsManager.h"

@interface ConnectViewController ()

@property (nonatomic, strong) Office365Client *o365Client;

@end

@implementation ConnectViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Hide intro and connect button
    [self showIntroAndButton:NO isLoading:NO];
    
    // Initialize Office365 client
    self.o365Client = [[Office365Client alloc] init];
    
    // If logged in, try connecting here
    if([[SettingsManager sharedInstance] isLoggedIn]){
        [self performConnection];
        [self showIntroAndButton:NO isLoading:YES];
        
    }
    // Else, show connect UI
    else{
        [self showIntroAndButton:YES isLoading:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Connect to Office 365

/**
 *  Initiate connect to Office 365
 *
 *  @param sender button from storyboard/IB
 */
- (IBAction)connectTapped:(id)sender {
    [self performConnection];
}

/**
 *  Connects to Office 365
 */
- (void)performConnection{
    [self showIntroAndButton:NO isLoading:YES];

    // Connect to Office 365 and fetch Outlook client
    [self.o365Client connectWithCompletionHandler:^(BOOL success, NSString *email, NSError *error) {
        if(success){
            // Set settings as accordingly
            [[SettingsManager sharedInstance] setIsLoggedIn:YES];
            [[SettingsManager sharedInstance] setUserEmail:email];
            [[SettingsManager sharedInstance] save];
            
            // Dispatch UI change in a main queue
            dispatch_async(dispatch_get_main_queue(), ^{
                ImagesCollectionViewController *imagesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ImagesCollectionVC"];
                imagesVC.o365Client = self.o365Client;
                [self.navigationController pushViewController:imagesVC animated:NO];
                
                [self showIntroAndButton:YES isLoading:NO];
            });
        }
        else{
            NSLog(@"ERROR here");
            
            if(error){
                // display error
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[error userInfo] valueForKey:NSLocalizedDescriptionKey]
                                                                message:[[error userInfo] valueForKey:NSLocalizedFailureReasonErrorKey]
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                
                [self.introLabel setHidden:NO];
                [self.connectButton setHidden:NO];
                
            }
            [self showIntroAndButton:YES isLoading:NO];
        }
    }];
}

/**
 *  Show and hide intro - Depending on whether the app is in a logged in status or not
 *
 *  @param show      show or hide
 *  @param isLoading show or hide  activityIndicator view
 */
- (void) showIntroAndButton:(BOOL)show isLoading:(BOOL)isLoading{
    if(show){
        [self.introLabel setHidden:NO];
        [self.connectButton setHidden:NO];
        
        [self.activityIndicator stopAnimating];
        [self.activityIndicator setHidden:YES];
    }
    else{
        [self.introLabel setHidden:YES];
        [self.connectButton setHidden:YES];
        
        if(isLoading){
            [self.activityIndicator setHidden:NO];
            [self.activityIndicator startAnimating];
        }
    }
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if([[segue identifier] isEqualToString:@"showImages"]){
        ImagesCollectionViewController *vc = segue.destinationViewController;
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

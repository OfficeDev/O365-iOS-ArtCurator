/*
 * Copyright (c) Microsoft. All rights reserved. Licensed under the MIT license.
 * See full license at the bottom of this file.
 */

#import "SettingsResponseTableViewController.h"
#import "SettingsManager.h"

@interface SettingsResponseTableViewController ()

@end

@implementation SettingsResponseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Setup UI
/**
 *  Setup title and initial textview values depending on edit types
 */
- (void) setupUI{
    switch (self.settingsValueType) {
        case SettingsLikeResponse:
            self.title = @"Like Response";
            self.textView.text = [[SettingsManager sharedInstance] likeResponseString];
            break;
            
        case SettingsDislikeResponse:
            self.title = @"Dislike Response";
            self.textView.text = [[SettingsManager sharedInstance] dislikeResponseString];
            break;
            
        default:
            break;
    }
}


#pragma mark - Actions
/**
 *  Saved tapped - update settings, save them in settings manager and go back
 *
 */
- (IBAction)saveTapped:(id)sender {
    if([self.textView.text length] == 0){
        // display error
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Enter a valid response before saving"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
    if(self.settingsValueType == SettingsLikeResponse){
        [[SettingsManager sharedInstance] setLikeResponseString:self.textView.text];
        [[SettingsManager sharedInstance] save];
    }
    else if(self.settingsValueType == SettingsDislikeResponse){
        [[SettingsManager sharedInstance] setDislikeResponseString:self.textView.text];
        [[SettingsManager sharedInstance] save];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
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

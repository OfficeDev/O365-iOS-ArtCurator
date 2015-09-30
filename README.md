# O365-iOS-Art-Curator
[![Build Status](https://travis-ci.org/OfficeDev/O365-iOS-ArtCurator.svg?branch=master)](https://travis-ci.org/OfficeDev/O365-iOS-ArtCurator)

This sample demonstrates how to use the Outlook Mail API to get emails and attachments from Office 365. It's built for iOS, [Android](https://github.com/OfficeDev/O365-Android-ArtCurator), [Web (Angular web app)](https://github.com/OfficeDev/O365-Angular-ArtCurator), and [Windows Phone](https://github.com/OfficeDev/O365-WinPhone-ArtCurator). Check out our [article on Medium](https://medium.com/@iambmelt/14296d0a25be).
<br />
<br />
<br />
The Art Curator sample provides a different way to view your inbox. Imagine you own a company that sells artistic t-shirts. As the owner of the company, you receive lots of emails from artists with designs they want you to buy. Currently, you use your email client to open each message and attachment. Instead, you can use the Art Curator sample to give you an attachment-first view of your inbox so that you can pick and choose designs you like. 

[![Office 365 iOS Art Curator](/readme-images/artcurator_ios.png)](https://youtu.be/4LOvkweDfhY "Click to see the sample in action")

This sample demonstrates the following operations from the Outlook Services Mail API: 

* [Get folders](https://msdn.microsoft.com/office/office365/APi/mail-rest-operations#GetFolders)
* [Get messages](https://msdn.microsoft.com/office/office365/APi/mail-rest-operations#Getmessages) (including filtering and using select) 
* [Get attachments](https://msdn.microsoft.com/office/office365/APi/mail-rest-operations#GetAttachments)
* [Update messages](https://msdn.microsoft.com/office/office365/APi/mail-rest-operations#Updatemessages)
* [Create and send messages](https://msdn.microsoft.com/office/office365/APi/mail-rest-operations#Sendmessages) (with and without an attachment) 


Prerequisites
==
* [Xcode](https://developer.apple.com/xcode/downloads/) from Apple
* Installation of [CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html)  as a dependency manager.
* An Office 365 account. You can sign up for an [Office 365 Developer subscription](https://msdn.microsoft.com/en-us/library/office/fp179924.aspx) that includes the resources to start building Office 365 apps.


**Note**<br/>
You will also need to ensure your Azure subscription is bound to your Office 365 tenant. Check out the Active Directory team's blog post, [Creating and Managing Multiple Windows Azure Active Directories](http://blogs.technet.com/b/ad/archive/2013/11/08/creating-and-managing-multiple-windows-azure-active-directories.aspx) for instructions. 

In this post, the Adding a new directory section will explain how to do this. You can also read [Set up Azure Active Directory access for your Developer Site](https://msdn.microsoft.com/office/office365/howto/setup-development-environment#bk_CreateAzureSubscription) for more information.

Setting up Xcode project
==
* Clone this repository
* Use CocoaPods to import the ADAL iOS, O365 iOS SDK, and SDWebImage
        
	     pod 'ADALiOS', '~> 1.2.1'
	     pod 'Office365/Outlook', '= 0.9.1'
	     pod 'Office365/Discovery', '= 0.9.1'
	     pod 'SDWebImage', '~>3.7'

 This sample app already contains a podfile that will get the Office 365 and ADAL components(pods) into  the project. Simply navigate to the project From **Terminal** and run 
        
        pod install
        
   For more information, see **Using CocoaPods** in [Additional Resources](#AdditionalResources)
    
First start
==

This app contains pre-registered application information on Azure with **Send mail as a user** and **Read and write user mail** permissions.

App information is defined in ```Office365Client.m```.

    
        // App information
        static NSString * const REDIRECT_URL_STRING = @"https://UseOnlyToRunTheArtCuratorSample";
        static NSString * const CLIENT_ID           = @"1feaa784-0130-48d9-adeb-776fc65888c5";
        static NSString * const AUTHORITY           = @"https://login.microsoftonline.com/common";
        
For your own app,  [Register your native client application on Azure](https://msdn.microsoft.com/library/azure/dn132599.aspx#BKMK_Adding). 

Specify the redirect URI when you register your application. Next, get the client id from the **CONFIGURE** page. 
The application *must* have the **Send mail as a user** and **Read and write user mail** permissions.

For more information, see [iOS-O365-Connect sample]()

Limitations
==
* File support beyond ```.png``` and ```.jpg```
* Handling a single email with multiple attachments
* Paging (getting more than 50 emails)
* Handling folder name uniqueness

Questions and comments
==
* If you have any trouble running this sample, please [log an issue](https://github.com/OfficeDev/O365-iOS-ArtCurator/issues)
* For general questions about the Office 365 APIs, post to [Stack Overflow](http://stackoverflow.com/). Make sure that your questions or comments are tagged with [Office365] and [outlook-restapi]

Troubleshooting
==
With the Xcode 7.0 update, App Transport Security is enabled for simulators and devices running iOS 9. See [App Transport Security Technote](https://developer.apple.com/library/prerelease/ios/technotes/App-Transport-Security-Technote/).

For this sample we have created a temporary exception for the following domain in the plist:

- outlook.office365.com

If these exceptions are not included, all calls into the Office 365 API will fail in this app when deployed to an iOS 9 simulator in Xcode.

Additional resources
==
* [Get started with Office 365 APIs in apps](http://aka.ms/get-started-with-js)
* [Office 365 APIs platform overview](http://msdn.microsoft.com/office/office365/howto/platform-development-overview)
* [Office Dev Center](http://dev.office.com/)
* [Using CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html)
* [Art Curator for Android](https://github.com/OfficeDev/O365-Android-ArtCurator)
* [Art Curator for Windows phone](https://github.com/OfficeDev/O365-WinPhone-ArtCurator)
* [Art Curator for Web (Angular web app)](https://github.com/OfficeDev/O365-Angular-ArtCurator)

Copyright
==
Copyright (c) 2015 Microsoft. All rights reserved.

---
page_type: sample
products:
- office-outlook
- office-365
languages:
- objc
extensions:
  contentType: samples
  createdDate: 6/26/2015 3:03:24 PM
---

# O365 iOS Art Curator

[![生成状态](https://travis-ci.org/OfficeDev/O365-iOS-ArtCurator.svg?branch=master)](https://travis-ci.org/OfficeDev/O365-iOS-ArtCurator)

本示例演示如何使用 Outlook 邮件 API 从 Office 365 获取电子邮件和附件。它针对 iOS、[Android](https://github.com/OfficeDev/O365-Android-ArtCurator)、[Web（Angular Web 应用）](https://github.com/OfficeDev/O365-Angular-ArtCurator) 和 [Windows Phone](https://github.com/OfficeDev/O365-WinPhone-ArtCurator) 构建。查看 [Medium](https://medium.com/@iambmelt/14296d0a25be) 中的文章。
<br />
<br />
<br />
Art Curator 示例提供了一种不同的方式来查看收件箱。想象您拥有一家销售艺术 T 恤的公司。作为公司的所有者，您会收到大量艺术家发送的电子邮件，其中附有他们希望您购买的设计。目前，您可以使用您的电子邮件客户端来打开每封邮件和附件。而使用 Art Curator 示例，您可以先预览收件箱的附件视图，以便选取您喜欢的设计。 

[![Office 365 iOS Art Curator](/readme-images/artcurator_ios.png)![单击可查看实际示例](/readme-images/artcurator_ios.png)

此示例从 Outlook Services 邮件 API 演示以下操作： 

* [获取文件夹](https://msdn.microsoft.com/office/office365/APi/mail-rest-operations#GetFolders)
* [获取邮件](https://msdn.microsoft.com/office/office365/APi/mail-rest-operations#Getmessages)（包括筛选并使用选择） 
* [获取附件](https://msdn.microsoft.com/office/office365/APi/mail-rest-operations#GetAttachments)
* [更新邮件](https://msdn.microsoft.com/office/office365/APi/mail-rest-operations#Updatemessages)
* [创建和发送邮件](https://msdn.microsoft.com/office/office365/APi/mail-rest-operations#Sendmessages) （带附件和不带附件） 


## 先决条件

* Apple [Xcode](https://developer.apple.com/xcode/downloads/)
* 安装 [CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html) 成为依存关系管理器。
* Office 365 帐户。可注册 [Office 365 开发人员订阅](https://msdn.microsoft.com/en-us/library/office/fp179924.aspx)，其中包括用于开始构建 Office 365 应用的资源。


**注意**<br/>
还需要确保你的 Azure 订阅已绑定到 Office 365 租户。请查看 Active Directory 团队的博客文章[创建和管理多个 Windows Azure Active Directory](http://blogs.technet.com/b/ad/archive/2013/11/08/creating-and-managing-multiple-windows-azure-active-directories.aspx) 获取说明。 

在本文章中，“添加新目录”一节将介绍如何执行此操作。有关详细信息，还可参阅“[为开发人员网站设置 Azure Active Directory 访问](https://msdn.microsoft.com/office/office365/howto/setup-development-environment#bk_CreateAzureSubscription)”。

## 设置 Xcode 项目

* 克隆该存储库
* 使用 CocoaPods 导入 ADAL iOS、O365 iOS SDK 和 SDWebImage
        
	     pod 'ADALiOS', '~> 1.2.1'
	     pod 'Office365/Outlook', '= 0.9.1'
	     pod 'Office365/Discovery', '= 0.9.1'
	     pod 'SDWebImage', '~>3.7'

 该示例应用已经包含了可将 Office 365 和 ADAL 组件 (pod) 导入到项目中的 podfile。只需从**终端**中导航到该项目并运行 
        
        pod install
        
   更多详细信息，请参阅[其他资源](#AdditionalResources)中的**使用 CocoaPods**
    
## 首次启动

此应用程序中包含 Azure 上预注册的应用程序信息，具有**以用户身份发送邮件**和**读取和写入用户邮件**权限。

应用程序信息在 ```Office365Client.m``` 中进行定义。

    
        // 应用程序信息
        static NSString * const REDIRECT_URL_STRING = @"https://UseOnlyToRunTheArtCuratorSample";
        static NSString * const CLIENT_ID           = @"1feaa784-0130-48d9-adeb-776fc65888c5";
        static NSString * const AUTHORITY           = @"https://login.microsoftonline.com/common";
        
对于你自己的应用，[在 Azure 上注册本机客户端应用程序](https://msdn.microsoft.com/library/azure/dn132599.aspx#BKMK_Adding)。 

在注册应用程序时，请指定重定向 URI。
接下来，从“**配置**”页面获取客户端 ID。应用程序*必须*拥有**以用户身份发送邮件**权限和**读取和写入用户邮件**权限。

有关详细信息，请参阅 [iOS-O365-Connect 示例]()

## 限制

* 文件支持不再局限于 ```.png``` 和 ```.jpg```
* 处理带有多个附件的单个电子邮件
* 分页（获取超过 50 个电子邮件）
* 处理文件夹名称唯一性

## 问题和意见

* 如果你在运行此示例时遇到任何问题，请[记录问题](https://github.com/OfficeDev/O365-iOS-ArtCurator/issues)
* 对于有关 Office 365 API 的常规问题，请发布到[堆栈溢出](http://stackoverflow.com/)。确保用 [Office365] 和 [outlook-restapi] 标记你的问题或注释

## 疑难解答

通过 Xcode 7.0 更新，运行 iOS 9 的模拟器和设备会启用应用传输安全性。请参阅[应用传输安全技术说明](https://developer.apple.com/library/prerelease/ios/technotes/App-Transport-Security-Technote/)。

在本示例中，我们已经为 plist 中的以下域创建了一个临时异常：

- outlook.office365.com

如果不包括这些异常情况，则在部署到 Xcode 中的 iOS 9 模拟器时，此应用中所有调用 Office 365 API 的操作都将失败。

## 其他资源

* [应用中 Office 365 API 入门](http://aka.ms/get-started-with-js)
* [Office 365 API 平台概述](http://msdn.microsoft.com/office/office365/howto/platform-development-overview)
* [Office 开发人员中心](http://dev.office.com/)
* [使用 CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html)
* [Art Curator for Android](https://github.com/OfficeDev/O365-Android-ArtCurator)
* [Art Curator for Windows Phone](https://github.com/OfficeDev/O365-WinPhone-ArtCurator)
* [Art Curator for Web（Angular web 应用）](https://github.com/OfficeDev/O365-Angular-ArtCurator)

## 版权所有

版权所有 (c) 2015 Microsoft。保留所有权利。


此项目已采用 [Microsoft 开放源代码行为准则](https://opensource.microsoft.com/codeofconduct/)。有关详细信息，请参阅[行为准则 FAQ](https://opensource.microsoft.com/codeofconduct/faq/)。如有其他任何问题或意见，也可联系 [opencode@microsoft.com](mailto:opencode@microsoft.com)。

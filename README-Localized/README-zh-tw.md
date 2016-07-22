# O365 iOS Art Curator
[![組建狀態](https://travis-ci.org/OfficeDev/O365-iOS-ArtCurator.svg?branch=master)](https://travis-ci.org/OfficeDev/O365-iOS-ArtCurator)

這個範例會示範如何使用 Outlook 郵件 API 來取得 Office 365 的電子郵件和附件。它針對 iOS、[Android](https://github.com/OfficeDev/O365-Android-ArtCurator)、[Web (Angular Web 應用程式)](https://github.com/OfficeDev/O365-Angular-ArtCurator) 和 [Windows Phone](https://github.com/OfficeDev/O365-WinPhone-ArtCurator) 建立。簽出我們在[媒體上的文件](https://medium.com/@iambmelt/14296d0a25be)。
<br />
<br />
<br />
Art Curator 範例提供不同的方法來檢視您的收件匣。假設您擁有一家銷售藝術 T 恤的公司。身為公司的擁有人，您會收到大量藝術家的電子郵件，希望您購買他們的設計。目前，您可以使用您的電子郵件用戶端開啟每個訊息及附件。相反地，您可以使用 Art Curator 範例的附件來初步檢視您的收件匣，以挑選您喜歡的設計。

[![Office 365 iOS Art Curator](../readme-images/artcurator_ios.png)](https://youtu.be/4LOvkweDfhY "Click to see the sample in action")

這個範例會示範來自 Outlook 服務郵件 API 的下列作業︰

* [取得資料夾](https://msdn.microsoft.com/office/office365/APi/mail-rest-operations#GetFolders)
* [取得訊息](https://msdn.microsoft.com/office/office365/APi/mail-rest-operations#Getmessages) (包括篩選和使用選取)
* [取得附件](https://msdn.microsoft.com/office/office365/APi/mail-rest-operations#GetAttachments)
* [更新訊息](https://msdn.microsoft.com/office/office365/APi/mail-rest-operations#Updatemessages)
* [建立和傳送訊息](https://msdn.microsoft.com/office/office365/APi/mail-rest-operations#Sendmessages) (包含和不含附件)


必要條件
==
* [Xcode](https://developer.apple.com/xcode/downloads/) (來自 Apple)
* 以相依性管理員身分安裝 [CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html)。
* Office 365 帳戶。您可以註冊[Office 365 開發人員訂閱](https://msdn.microsoft.com/en-us/library/office/fp179924.aspx)，其中包含要開始建置 Office 365 應用程式的資源。


**附註**<br/>
您還需要確定您的 Azure 訂用帳戶已繫結至您的 Office 365 租用戶。參閱 Active Directory 小組的部落格文章[建立和管理多個 Windows Azure Active Directory](http://blogs.technet.com/b/ad/archive/2013/11/08/creating-and-managing-multiple-windows-azure-active-directories.aspx)的指示。

在此貼文中，＜新增目錄＞一節將說明如何執行這項操作。您也可以閱讀[為您的開發人員網站設定 Azure Active Directory 存取](https://msdn.microsoft.com/office/office365/howto/setup-development-environment#bk_CreateAzureSubscription)的詳細資訊。

設定 Xcode 專案
==
* 複製此儲存機制
* 使用 CocoaPods 來匯入 ADAL iOS、O365 iOS SDK 和 SDWebImage
        
	    pod 'ADALiOS', '~> 1.2.1'
	    pod 'Office365/Outlook', '= 0.9.1'
	    pod 'Office365/Discovery', '= 0.9.1'
	    pod 'SDWebImage', '~>3.7'

此範例應用程式已經包含可將 Office 365 和 ADAL 元件 (pods) 放入專案的 podfile。只需從 **Terminal** 瀏覽至專案並執行
        
       pod install
        
  如需詳細資訊，請參閱[其他資源](#AdditionalResources)中的**使用 CocoaPods**
   
第一次啟動
==

這個應用程式包含 Azure 上預先註冊的應用程式資訊，包含**以使用者身分傳送郵件**和**讀取和寫入使用者郵件** 權限。

應用程式資訊定義於 ```Office365Client.m``` 中。

    
       // 應用程式資訊
       static NSString * const REDIRECT_URL_STRING = @"https://UseOnlyToRunTheArtCuratorSample";
       static NSString * const CLIENT_ID           = @"1feaa784-0130-48d9-adeb-776fc65888c5";
       static NSString * const AUTHORITY           = @"https://login.microsoftonline.com/common";
       
對於您自己的應用程式，[在 Azure 上註冊您的原生用戶端應用程式](https://msdn.microsoft.com/library/azure/dn132599.aspx#BKMK_Adding)。

當您註冊應用程式時，請指定重新導向 URI。接下來，從 **[設定]** 頁面中取得用戶端識別碼。
應用程式*必須*有**以使用者身分傳送郵件**和**讀取和寫入使用者郵件** 權限。

如需詳細資訊，請參閱 [iOS-O365-Connect 範例]()

限制
==
* ```.png``` 和 ```.jpg<``` 以外的檔案支援
* 處理有多個附件的單一電子郵件
* 分頁 (取得 50 個以上的電子郵件)
* 處理資料夾名稱的唯一性

問題與意見
==
* 如果您在執行這個範例時有任何問題，請參閱[記錄問題](https://github.com/OfficeDev/O365-iOS-ArtCurator/issues)
* 如需 Office 365 API 的一般問題，請張貼到[堆疊溢位](http://stackoverflow.com/)。請確定使用 [Office365](https://developer.apple.com/library/prerelease/ios/technotes/App-Transport-Security-Technote/") 和 [outlook-restapi] 標記您的問題或註解

疑難排解
==
利用 Xcode 7.0 更新，會針對執行  iOS 9 的模擬器和裝置啟用應用程式傳輸安全性。請參閱 [應用程式傳輸安全性技術說明</a>。

在這個範例中，我們已經為 plist 中的下列網域建立暫存例外狀況：

- outlook.office365.com

如果不包含這些例外狀況，在 Xcode 中部署到 iOS 9 模擬器時，所有 Office 365 API 的呼叫都會在此應用程式中進行。

其他資源
==
* [在應用程式中開始使用 Office 365 API](http://aka.ms/get-started-with-js)
* [Office 365 API 平台概觀](http://msdn.microsoft.com/office/office365/howto/platform-development-overview)
* [Office 開發中心](http://dev.office.com/)
* [使用 CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html)
* [Art Curator for Android](https://github.com/OfficeDev/O365-Android-ArtCurator)
* [Art Curator for Windows phone](https://github.com/OfficeDev/O365-WinPhone-ArtCurator)
* [Art Curator for Web (Angular Web 應用程式)](https://github.com/OfficeDev/O365-Angular-ArtCurator)

著作權
==
Copyright (c) 2015 Microsoft.著作權所有，並保留一切權利。

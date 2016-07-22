# O365 iOS Art Curator
[![ビルドの状態](https://travis-ci.org/OfficeDev/O365-iOS-ArtCurator.svg?branch=master)](https://travis-ci.org/OfficeDev/O365-iOS-ArtCurator)

このサンプルでは、Outlook メール API を使用して Office 365 からメールと添付ファイルを取得する方法を示します。これは、iOS、[Android](https://github.com/OfficeDev/O365-Android-ArtCurator)、[Web (Angular Web アプリ)](https://github.com/OfficeDev/O365-Angular-ArtCurator)、[Windows Phone](https://github.com/OfficeDev/O365-WinPhone-ArtCurator) 用に作成されています。[Medium の記事](https://medium.com/@iambmelt/14296d0a25be)をご確認ください。
<br />
<br />
<br />
Art Curator サンプルを使用すると、受信トレイを別の方法で表示できます。芸術的な T シャツを販売する会社を経営していると想像してみてください。会社のオーナーであるあなたのもとには、買ってほしいと思うデザインを示したたくさんのメールがアーティストから届きます。現在は、各メッセージと添付ファイルを開くためにメール クライアントを使用しています。代わりに Art Curator サンプルを使用すると、受信トレイの添付ファイル優先ビューが表示されて、気に入ったデザインを選べるようになります。

[![Office 365 iOS Art Curator](../readme-images/artcurator_ios.png)](https://youtu.be/4LOvkweDfhY "活用できるサンプルを確認するにはこちらをクリックしてください")

このサンプルでは、Outlook サービス メール API から行う次の操作を示します。

* [フォルダーの取得](https://msdn.microsoft.com/office/office365/APi/mail-rest-operations#GetFolders)
* [メッセージの取得](https://msdn.microsoft.com/office/office365/APi/mail-rest-operations#Getmessages) (フィルター処理、および選択の使用を含む)
* [添付ファイルの取得](https://msdn.microsoft.com/office/office365/APi/mail-rest-operations#GetAttachments)
* [メッセージの更新](https://msdn.microsoft.com/office/office365/APi/mail-rest-operations#Updatemessages)
* [メッセージの作成と送信](https://msdn.microsoft.com/office/office365/APi/mail-rest-operations#Sendmessages) (添付ファイルがある場合とない場合)


前提条件
==
*Apple の [Xcode](https://developer.apple.com/xcode/downloads/)
*依存関係マネージャーとしての [CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html) のインストール。
*Office 365 アカウント。Office 365 アプリのビルドを開始するためのリソースを含む [Office 365 Developer サブスクリプション](https://msdn.microsoft.com/en-us/library/office/fp179924.aspx)にサインアップできます。


**注**<br/>
Azure サブスクリプションが Office 365 テナントにバインドされていることを確認する必要もあります。手順については、Active Directory チームのブログ投稿「[複数の Windows Azure Active Directory を作成して管理する](http://blogs.technet.com/b/ad/archive/2013/11/08/creating-and-managing-multiple-windows-azure-active-directories.aspx)」をご確認ください。

この投稿の「新しいディレクトリを追加する」セクションで、この方法を説明しています。また、詳細については、「[開発者向けサイトに Azure Active Directory へのアクセスをセットアップする](https://msdn.microsoft.com/office/office365/howto/setup-development-environment#bk_CreateAzureSubscription)」もご覧ください。

Xcode プロジェクトのセットアップ
==
*このリポジトリの複製を作成する
*CocoaPods を使用して ADAL iOS、O365 iOS SDK、SDWebImage をインポートする
        
	    pod 'ADALiOS', '~> 1.2.1'
	    pod 'Office365/Outlook', '= 0.9.1'
	    pod 'Office365/Discovery', '= 0.9.1'
	    pod 'SDWebImage', '~>3.7'

このサンプル アプリには、プロジェクトに Office 365 と ADAL コンポーネント (pods) を取り込む podfile がすでに含まれています。**ターミナル**からプロジェクトに移動して次を実行するだけです
        
       pod install
        
  詳細については、「[その他の技術情報](#AdditionalResources)」の「**CocoaPods を使う**」をご覧ください。
   
初めての開始
==

このアプリには、**ユーザーからのメールとして送信**および**ユーザーのメールの読み取りと書き込み**の各アクセス許可により、Azure の事前登録済みのアプリケーション情報が含まれています。

アプリ情報は、```Office365Client.m``` に定義されています。

    
       // App information
       static NSString * const REDIRECT_URL_STRING = @"https://UseOnlyToRunTheArtCuratorSample";
       static NSString * const CLIENT_ID           = @"1feaa784-0130-48d9-adeb-776fc65888c5";
       static NSString * const AUTHORITY           = @"https://login.microsoftonline.com/common";
       
独自のアプリの場合は、[Azure にネイティブ クライアント アプリケーションを登録します](https://msdn.microsoft.com/library/azure/dn132599.aspx#BKMK_Adding)。

アプリケーションの登録時にリダイレクト URI を指定します。次に、**[構成]** ページからクライアント ID を取得します。
アプリケーションには、**ユーザーからのメールとして送信**および**ユーザーのメールの読み取りと書き込み**の各アクセス許可が*必要です*。

詳細については、[iOS-O365-Connect サンプル]()をご覧ください。

制限事項
==
*```.png``` と ```.jpg``` 以外のファイルのサポート
*添付ファイルが複数ある 1 つのメールの処理
*ページング (50 通を超えるメールの受け取り)
*フォルダー名の一意性の処理

質問とコメント
==
*このサンプルの実行について問題がある場合は、[問題をログに記録](https://github.com/OfficeDev/O365-iOS-ArtCurator/issues)してください。
*Office 365 API 全般の質問については、[Stack Overflow](http://stackoverflow.com/) に投稿してください。質問やコメントには、必ず [Office365] と [outlook-restapi] のタグを付けてください。

トラブルシューティング
==
Xcode 7.0 のアップデートにより、iOS 9 を実行するシミュレーターやデバイス用に App Transport Security を使用できるようになりました。「[App Transport Security のテクニカル ノート](https://developer.apple.com/library/prerelease/ios/technotes/App-Transport-Security-Technote/)」をご覧ください。

このサンプルでは、plist 内の次のドメインのために一時的な例外を作成しました:

- outlook.office365.com

これらの例外が含まれていないと、Xcode で iOS 9 シミュレーターにデプロイされたときに、このアプリで Office 365 API へのすべての呼び出しが失敗します。

その他の技術情報
==
* [アプリで Office 365 API の使用を開始する](http://aka.ms/get-started-with-js)
* [Office 365 API プラットフォームの概要](http://msdn.microsoft.com/office/office365/howto/platform-development-overview)
* [Office デベロッパー センター](http://dev.office.com/)
* [CocoaPods を使う](https://guides.cocoapods.org/using/using-cocoapods.html)
* [Android 用 Art Curator](https://github.com/OfficeDev/O365-Android-ArtCurator)
* [Windows Phone 用 Art Curator](https://github.com/OfficeDev/O365-WinPhone-ArtCurator)
* [Web (Angular Web アプリ) 用 Art Curator](https://github.com/OfficeDev/O365-Angular-ArtCurator)

著作権
==
Copyright (c) 2015 Microsoft.All rights reserved.


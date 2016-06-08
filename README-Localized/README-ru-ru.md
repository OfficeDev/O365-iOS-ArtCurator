# O365 Art Curator для iOS
[![Состояние сборки](https://travis-ci.org/OfficeDev/O365-iOS-ArtCurator.svg?branch=master)](https://travis-ci.org/OfficeDev/O365-iOS-ArtCurator)

В этом примере показано, как извлекать сообщения и вложения из Office 365 с помощью API Почты Outlook. Это приложение создано для iOS, [Android](https://github.com/OfficeDev/O365-Android-ArtCurator), [веб-браузеров (веб-приложение на платформе Angular)](https://github.com/OfficeDev/O365-Angular-ArtCurator) и [Windows Phone](https://github.com/OfficeDev/O365-WinPhone-ArtCurator). Просмотрите нашу [статью на сайте Medium](https://medium.com/@iambmelt/14296d0a25be).
<br />
<br />
<br />
Art Curator воплощает новый подход к просмотру папки "Входящие". Представьте, что вы владеете компанией, которая продает дизайнерские футболки. Как владелец компании вы получаете много сообщений с рисунками от художников. Сейчас вы открываете сообщения и вложения с помощью почтового клиента. Вместо того вы можете воспользоваться приложением Art Curator, чтобы в первую очередь просматривать вложения из папки "Входящие" и выбирать рисунки, которые вам нравятся. 

[![Office 365 iOS Art Curator](../readme-images/artcurator_ios.png)](https://youtu.be/4LOvkweDfhY "Щелкните, чтобы просмотреть пример в действии")

В этом примере демонстрируются следующие операции из API Почты Outlook Services: 

* [Извлечение папок](https://msdn.microsoft.com/office/office365/APi/mail-rest-operations#GetFolders)
* [Извлечение сообщений](https://msdn.microsoft.com/office/office365/APi/mail-rest-operations#Getmessages) (в том числе фильтрация и использование выборки) 
* [Извлечение вложений](https://msdn.microsoft.com/office/office365/APi/mail-rest-operations#GetAttachments)
* [Обновление сообщений](https://msdn.microsoft.com/office/office365/APi/mail-rest-operations#Updatemessages)
* [Создание и отправка сообщений](https://msdn.microsoft.com/office/office365/APi/mail-rest-operations#Sendmessages) (с вложением или без него) 


Необходимые компоненты
==
* Среда разработки [Xcode](https://developer.apple.com/xcode/downloads/) от Apple.
* Диспетчер зависимостей [CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html).
* Учетная запись Office 365. Вы можете подписаться на [план Office 365 для разработчиков](https://msdn.microsoft.com/ru-ru/library/office/fp179924.aspx), который включает ресурсы для создания приложений Office 365.


**Примечание**<br/>
Убедитесь, что ваша подписка на Azure привязана к клиенту Office 365. Инструкции см. в записи блога команды Active Directory о [создании нескольких каталогов Windows Azure Active Directory и управлении ими](http://blogs.technet.com/b/ad/archive/2013/11/08/creating-and-managing-multiple-windows-azure-active-directories.aspx) 

в разделе, посвященном добавлению нового каталога. Дополнительные сведения см. в разделе о [настройке доступа к Azure Active Directory для Сайта разработчика](https://msdn.microsoft.com/office/office365/howto/setup-development-environment#bk_CreateAzureSubscription).

Настройка проекта Xcode
==
* Клонируйте этот репозиторий.
* Импортируйте пакеты ADAL iOS, SDK Office 365 для iOS и SDWebImage с помощью диспетчера зависимостей CocoaPods.
        
	     pod 'ADALiOS', '~> 1.2.1'
	     pod 'Office365/Outlook', '= 0.9.1'
	     pod 'Office365/Discovery', '= 0.9.1'
	     pod 'SDWebImage', '~>3.7'

 Это приложение уже содержит компонент podfile, который добавит компоненты Office 365 и ADAL (pod) в проект. Просто перейдите к проекту в приложении **Терминал** и выполните следующую команду: 
        
        pod install
        
   Дополнительные сведения см. в руководстве **Использование CocoaPods** в разделе [Дополнительные ресурсы](#AdditionalResources).
    
Первый запуск
==

Это приложение содержит сведения о предварительной регистрации в Azure с разрешениями на **отправку почты от имени пользователя** и **чтение и создание писем от имени пользователя**.

Сведения о приложении содержаться в папке ```Office365Client.m```.

    
        // App information
        static NSString * const REDIRECT_URL_STRING = @"https://UseOnlyToRunTheArtCuratorSample";
        static NSString * const CLIENT_ID           = @"1feaa784-0130-48d9-adeb-776fc65888c5";
        static NSString * const AUTHORITY           = @"https://login.microsoftonline.com/common";
        
Сведения о регистрации собственного клиентского приложения в Azure см. [здесь](https://msdn.microsoft.com/library/azure/dn132599.aspx#BKMK_Adding). 

При регистрации приложения укажите URI перенаправления. После этого получите идентификатор клиента на странице **НАСТРОЙКА** 
Приложение *должно* иметь разрешения на **отправку почты от имени пользователя** и **чтение и создание писем от имени пользователя**.

Дополнительные сведения см. в [примере iOS-O365-Connect]().

Ограничения
==
* Поддержка типов файлов, отличных от ```PNG``` и ```JPG```
* Обработка одного сообщения с несколькими вложениями
* Подкачка (извлечение более 50 сообщений)
* Обработка уникальности имен папок

Вопросы и комментарии
==
* Если у вас не получается запустить этот пример, [сообщите о проблеме](https://github.com/OfficeDev/O365-iOS-ArtCurator/issues).
* Общие вопросы об API Office 365 задавайте на сайте [Stack Overflow](http://stackoverflow.com/). Обязательно помечайте свои вопросы и комментарии тегами [Office365] и [outlook-restapi]

Устранение неполадок
==
Для симуляторов и устройств под управлением iOS 9 с обновлением Xcode 7.0 поддерживается технология App Transport Security. См. [технический комментарий к App Transport Security](https://developer.apple.com/library/prerelease/ios/technotes/App-Transport-Security-Technote/).

Для этого приложения мы создали временное исключение для следующего домена в plist:

— outlook.office365.com

Если эти исключения не включены, при развертывании на симуляторе с iOS 9 в Xcode вызов API Office 365 в этом приложении будет невозможен.

Дополнительные ресурсы
==
* [Начало работы с API Office 365 в приложениях](http://aka.ms/get-started-with-js)
* [Обзор платформы API Office 365](http://msdn.microsoft.com/office/office365/howto/platform-development-overview)
* [Центр разработки для Office](http://dev.office.com/)
* [Использование CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html)
* [Art Curator для Android](https://github.com/OfficeDev/O365-Android-ArtCurator)
* [Art Curator для Windows Phone](https://github.com/OfficeDev/O365-WinPhone-ArtCurator)
* [Art Curator для веб-браузеров (веб-приложение на платформе Angular)](https://github.com/OfficeDev/O365-Angular-ArtCurator)

Авторские права
==
(c) Корпорация Майкрософт (Microsoft Corporation), 2015. Все права защищены.


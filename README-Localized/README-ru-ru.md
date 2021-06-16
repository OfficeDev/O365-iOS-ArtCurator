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

# O365 Art Curator для iOS

[![Состояние сборки](https://travis-ci.org/OfficeDev/O365-iOS-ArtCurator.svg?branch=master)](https://travis-ci.org/OfficeDev/O365-iOS-ArtCurator)

В этом примере показано, как извлекать сообщения и вложения из Office 365 с помощью API приложения "Почта Outlook". Он построен для [iOS](https://github.com/OfficeDev/O365-Android-ArtCurator), Android, [веб-браузеров (веб-приложение Angular)](https://github.com/OfficeDev/O365-Angular-ArtCurator) и [Windows Phone](https://github.com/OfficeDev/O365-WinPhone-ArtCurator). Ознакомьтесь с нашей [статьей на портале Medium](https://medium.com/@iambmelt/14296d0a25be).
<br />
<br />
<br />
Art Curator воплощает новый подход к просмотру папки "Входящие". Представьте, что вы владеете компанией, которая продает дизайнерские футболки. Как владелец компании вы получаете много сообщений с рисунками от художников. Сейчас вы открываете сообщения и вложения с помощью почтового клиента. Вместо этого вы можете воспользоваться приложением Art Curator, чтобы предварительно просматривать вложения из сообщений в папке "Входящие" и выбирать рисунки, которые вам нравятся. 

[![ Office 365 Art Curator для iOS](/readme-images/artcurator_ios.png)![Щелкните, чтобы посмотреть на примере, как это работает](/readme-images/artcurator_ios.png)

В этом примере показаны следующие операции из API Почты Outlook Services: 

* [Получение папок](https://msdn.microsoft.com/office/office365/APi/mail-rest-operations#GetFolders)
* [Извлечение сообщений](https://msdn.microsoft.com/office/office365/APi/mail-rest-operations#Getmessages) (в том числе фильтрация и использование выборки) 
* [Получение вложений](https://msdn.microsoft.com/office/office365/APi/mail-rest-operations#GetAttachments)
* [Обновление сообщений](https://msdn.microsoft.com/office/office365/APi/mail-rest-operations#Updatemessages)
* [Создание и отправка сообщений](https://msdn.microsoft.com/office/office365/APi/mail-rest-operations#Sendmessages) (с вложениями и без них) 


## Необходимые компоненты

* [Xcode](https://developer.apple.com/xcode/downloads/) от Apple.
* Установка [CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html) в качестве диспетчера зависимостей.
* Учетная запись Office 365. Вы можете подписаться на [план Office 365 для разработчиков](https://msdn.microsoft.com/en-us/library/office/fp179924.aspx), который включает ресурсы, необходимые для создания приложений Office 365. 


**Примечание**<br/>
Необходимо убедиться в том, что ваша подписка на Azure привязана к клиенту Office 365. Соответствующие инструкции содержатся в блоге команды Active Directory [Создание нескольких каталогов Windows Azure Active Directory и управление ими](http://blogs.technet.com/b/ad/archive/2013/11/08/creating-and-managing-multiple-windows-azure-active-directories.aspx) 

в разделе, посвященном добавлению нового каталога. Для получения дополнительных сведений можно ознакомиться со статьей [Настройка доступа к сайту разработчика с помощью Azure Active Directory](https://msdn.microsoft.com/office/office365/howto/setup-development-environment#bk_CreateAzureSubscription).

## Настройка проекта Xcode

* Клонируйте этот репозиторий
* Импортируйте пакеты ADAL iOS, SDK Office 365 для iOS и SDWebImage с помощью диспетчера зависимостей CocoaPods.
        
	     pod 'ADALiOS', '~> 1.2.1'
	     pod 'Office365/Outlook', '= 0.9.1'
	     pod 'Office365/Discovery', '= 0.9.1'
	     pod 'SDWebImage', '~>3.7'

 Этот пример приложения уже содержит компонент podfile, который добавит компоненты Office 365 и ADAL (pod) в проект. Просто перейдите к проекту из раздела **Терминал** и выполните следующую команду: 
        
        pod install
        
   Для получения дополнительных сведений выберите ссылку **Использование CocoaPods** в разделе [Дополнительные ресурсы](#AdditionalResources).
    
## Первый запуск

В этом приложении содержатся сведения о предварительной регистрации в Azure с разрешениями на **отправку почты от имени пользователя** и **чтение и создание писем от имени пользователя**.

Сведения о приложении содержатся в папке ```Office365Client.m```.

    
        // App information
        static NSString * const REDIRECT_URL_STRING = @"https://UseOnlyToRunTheArtCuratorSample";
        static NSString * const CLIENT_ID           = @"1feaa784-0130-48d9-adeb-776fc65888c5";
        static NSString * const AUTHORITY           = @"https://login.microsoftonline.com/common";
        
Свое собственное приложение необходимо [Зарегистрировать собственное клиентское приложение на Azure](https://msdn.microsoft.com/library/azure/dn132599.aspx#BKMK_Adding). 

При регистрации приложения указывается URI перенаправления.
Затем необходимо получить идентификатор клиента на странице **НАСТРОЙКА**. Приложение *должно* иметь разрешения на **отправку почты от имени пользователя** и **чтение и создание писем от имени пользователя**.

Дополнительные сведения см. здесь:[iOS-O365-Connect]()

## Ограничения

* Поддержка файлов, отличных от ```.png``` и ```.jpg```
* Обработка одного сообщения электронной почты с несколькими вложениями
* Разбиение на страницы (получение более 50 сообщений)
* Обработка уникальности имени папки

## Вопросы и комментарии

* Если у вас возникли проблемы с запуском этого примера, [сообщите о неполадке](https://github.com/OfficeDev/O365-iOS-ArtCurator/issues).
* Общие вопросы про API Office 365 публикуйте в[Stack Overflow](http://stackoverflow.com/). Убедитесь в том, что ваши вопросы или комментарии помечены тегами \[Office365] и \[outlook-restapi].

## Устранение неполадок

Для симуляторов и устройств под управлением iOS 9 с обновлением Xcode 7.0 поддерживается технология App Transport Security. См. [технический комментарий к App Transport Security](https://developer.apple.com/library/prerelease/ios/technotes/App-Transport-Security-Technote/).

Для этого примера создано временное исключение для следующего домена в plist:

- outlook.office365.com

Если эти исключения не включены, при развертывании на симуляторе с iOS 9 в Xcode вызов API Office 365 в этом приложении будет невозможен.

## Дополнительные ресурсы

* [Начало работы с API Office 365 в приложениях](http://aka.ms/get-started-with-js)
* [Общие сведения о платформе API Office 365](http://msdn.microsoft.com/office/office365/howto/platform-development-overview)
* [Центр разработчиков Office](http://dev.office.com/)
* [Использование CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html)
* [Art Curator для Android](https://github.com/OfficeDev/O365-Android-ArtCurator)
* [Art Curator для Windows Phone](https://github.com/OfficeDev/O365-WinPhone-ArtCurator)
* [Art Curator для веб-браузеров (веб-приложение Angular)](https://github.com/OfficeDev/O365-Angular-ArtCurator)

## Авторские права

(c) Корпорация Майкрософт (Microsoft Corporation), 2015. Все права защищены.


Этот проект соответствует [Правилам поведения разработчиков открытого кода Майкрософт](https://opensource.microsoft.com/codeofconduct/). Дополнительные сведения см. в разделе [часто задаваемых вопросов о правилах поведения](https://opensource.microsoft.com/codeofconduct/faq/). Если у вас возникли вопросы или замечания, напишите нам по адресу [opencode@microsoft.com](mailto:opencode@microsoft.com).

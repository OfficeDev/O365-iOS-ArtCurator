# Art Curator IOS O365
[![État de création](https://travis-ci.org/OfficeDev/O365-iOS-ArtCurator.svg?branch=master)](https://travis-ci.org/OfficeDev/O365-iOS-ArtCurator)

Cet exemple présente comment utiliser l’API de messagerie Outlook pour obtenir des messages électroniques et des pièces jointes à partir d’Office 365. Il est conçu pour iOS, [Android](https://github.com/OfficeDev/O365-Android-ArtCurator), [Web (application web Angular)](https://github.com/OfficeDev/O365-Angular-ArtCurator) et [Windows Phone](https://github.com/OfficeDev/O365-WinPhone-ArtCurator). Consultez notre [article sur Medium](https://medium.com/@iambmelt/14296d0a25be).
<br />
<br />
<br />
L’exemple Art Curator fournit une autre façon d’afficher votre boîte de réception. Imaginez que vous êtes propriétaire d’une entreprise qui vend des tee-shirts artistiques. En tant que propriétaire de l’entreprise, vous recevez de nombreux messages électroniques de la part d’artistes comportant des conceptions qu’ils tentent de vous vendre. Vous utilisez actuellement votre client de messagerie pour ouvrir chaque message et pièce jointe. Au lieu de cela, vous pouvez utiliser l’exemple Art Curator pour obtenir un premier aperçu des pièces jointes de votre boîte de réception afin que vous puissiez sélectionner et choisir les conceptions qui vous plaisent. 

[![Office 365 iOS Art Curator](../readme-images/artcurator_ios.png)](https://youtu.be/4LOvkweDfhY "Cliquez ici pour voir l’exemple en action")

Cet exemple illustre les opérations suivantes réalisées à partir de l’API de services de messagerie Outlook : 

* [Obtenir des dossiers](https://msdn.microsoft.com/office/office365/APi/mail-rest-operations#GetFolders)
* [Obtenir des messages](https://msdn.microsoft.com/office/office365/APi/mail-rest-operations#Getmessages (y compris le filtrage et la sélection) 
* [Obtenir des pièces jointes](https://msdn.microsoft.com/office/office365/APi/mail-rest-operations#GetAttachments)
* [Mettre à jour des messages](https://msdn.microsoft.com/office/office365/APi/mail-rest-operations#Updatemessages)
* [Créer et envoyer des messages](https://msdn.microsoft.com/office/office365/APi/mail-rest-operations#Sendmessages) (avec et sans pièce jointe) 


Conditions requises
==
* [Xcode](https://developer.apple.com/xcode/downloads/) d’Apple
* Installation de [CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html) en tant que gestionnaire de dépendances.
* Un compte Office 365. Vous pouvez souscrire à un [abonnement Office 365 Developer](https://msdn.microsoft.com/fr-fr/library/office/fp179924.aspx) qui inclut les ressources dont vous avez besoin pour commencer à créer des applications Office 365.


**Remarque**<br/>
Vous devrez également vous assurer que votre abonnement Azure est lié à votre client Office 365. Consultez le billet de blog de l’équipe Active Directory relatif à la [création et à la gestion de plusieurs répertoires Windows Azure Active Directory](http://blogs.technet.com/b/ad/archive/2013/11/08/creating-and-managing-multiple-windows-azure-active-directories.aspx) pour obtenir des instructions. 

Dans ce billet de blog, la section sur l’ajout d’un nouveau répertoire vous explique comment procéder. Vous pouvez également lire l’article relatif à la [configuration d’un accès Azure Active Directory pour votre site du développeur](https://msdn.microsoft.com/office/office365/howto/setup-development-environment#bk_CreateAzureSubscription) pour plus d’informations.

Configuration d’un projet Xcode
==
* Cloner ce référentiel
* Utiliser CocoaPods pour importer la bibliothèque ADAL iOS, le kit de développement logiciel O365 iOS et SDWebImage
        
	     pod ’ADALiOS’, ’~> 1.2.1’
	     pod ’Office365/Outlook’, ’= 0.9.1’
	     pod ’Office365/Discovery’, ’= 0.9.1’
	     pod ’SDWebImage’, ’~>3.7’

 Cet exemple d’application contient déjà un podfile qui recevra les composants ADAL et Office 365 (pods) dans le projet. Accédez simplement au projet à partir de **Terminal** et exécutez 
        
        pod install
        
   Pour plus d’informations, voir **Utilisation de CocoaPods** dans [Ressources supplémentaires](#AdditionalResources).
    
Premier démarrage
==

Cette application contient des informations d’application pré-enregistrées sur Azure avec des autorisations **Envoyer un courrier électronique en tant qu’utilisateur** et **Lire et écrire un courrier électronique d’utilisateur**.

Les informations relatives à l’application sont définies dans ```Office365Client.m```.

    
        // Informations sur l’application
        static NSString * const REDIRECT_URL_STRING = @"https://UseOnlyToRunTheArtCuratorSample";
        static NSString * const CLIENT_ID           = @"1feaa784-0130-48d9-adeb-776fc65888c5";
        static NSString * const AUTHORITY           = @"https://login.microsoftonline.com/common";
        
Pour votre propre application, [inscrivez votre application cliente native auprès d’Azure](https://msdn.microsoft.com/library/azure/dn132599.aspx#BKMK_Adding). 

Indiquez l’URI de redirection lorsque vous inscrivez votre application. Ensuite, obtenez l’ID client à partir de la page **CONFIGURER**. 
L’application *doit* disposer des autorisations **Envoyer un courrier électronique en tant qu’utilisateur** et **Lire et écrire un courrier électronique d’utilisateur**.

Pour plus d’informations, voir l’[exemple iOS-O365-Connect]().

Limitations
==
* Prise en charge de formats de fichiers autres que ```.png``` et ```.jpg```
* Gestion d’un courrier électronique unique avec plusieurs pièces jointes
* Pagination (réception de plus de 50 courriers électroniques)
* Gestion de l’unicité des noms de dossiers

Questions et commentaires
==
* Si vous rencontrez des problèmes lors de l’exécution de cet exemple, veuillez [les consigner](https://github.com/OfficeDev/O365-iOS-ArtCurator/issues).
* Pour des questions générales relatives aux API Office 365, publiez sur [Stack Overflow](http://stackoverflow.com/). Posez vos questions avec les balises [Office365] et [outlook-restapi].

Résolution des problèmes
==
Avec la mise à jour de Xcode 7.0, la sécurité de transport d’application est activée pour les simulateurs et les appareils exécutant iOS 9. Consultez la [note technique relative à la sécurité de transport d’application](https://developer.apple.com/library/prerelease/ios/technotes/App-Transport-Security-Technote).

Pour cet exemple, nous avons créé une exception temporaire pour le domaine suivant dans l’élément plist :

- outlook.office365.com

Si ces exceptions ne sont pas prises en compte, tous les appels de l’API Office 365 échoueront dans cette application lors du déploiement sur un simulateur iOS 9 dans Xcode.

Ressources supplémentaires
==
* [Prise en main des API Office 365 dans les applications](http://aka.ms/get-started-with-js)
* [Présentation de la plateforme des API Office 365](http://msdn.microsoft.com/office/office365/howto/platform-development-overview)
* [Centre de développement Office](http://dev.office.com/)
* [Utilisation de CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html)
* [Art Curator pour Android](https://github.com/OfficeDev/O365-Android-ArtCurator)
* [Art Curator pour Windows phone](https://github.com/OfficeDev/O365-WinPhone-ArtCurator)
* [Art Curator pour Web (application web Angular)](https://github.com/OfficeDev/O365-Angular-ArtCurator)

Copyright
==
Copyright (c) 2015 Microsoft. Tous droits réservés.


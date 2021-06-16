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

# Art Curator de iOS para Office 365

[![Estado de compilación](https://travis-ci.org/OfficeDev/O365-iOS-ArtCurator.svg?branch=master)](https://travis-ci.org/OfficeDev/O365-iOS-ArtCurator)

En este ejemplo, se muestra cómo usar la API de correo de Outlook para obtener correos electrónicos y datos adjuntos de Office 365. Se creó para iOS, [Android](https://github.com/OfficeDev/O365-Android-ArtCurator), la [Web (aplicación web Angular)](https://github.com/OfficeDev/O365-Angular-ArtCurator) y [Windows Phone](https://github.com/OfficeDev/O365-WinPhone-ArtCurator). Consulte nuestro [artículo sobre Medium](https://medium.com/@iambmelt/14296d0a25be).
<br />
<br />
<br />
El ejemplo de Art Curator proporciona una forma diferente de ver la bandeja de entrada. Imagine que posee una empresa que vende camisetas artísticas. Como propietario de la empresa, recibe muchos mensajes de correo electrónico de artistas con diseños que desean que compre. Actualmente, usa el cliente de correo electrónico para abrir cada mensaje y datos adjuntos. En su lugar, puede usar el ejemplo de Art Curator para proporcionarle una primera vista de los datos adjuntos de la bandeja de entrada para que puede elegir y seleccionar los diseños que le gusten. 

[![Ejemplo del Art Curator de iOS para Office 365](/readme-images/artcurator_ios.png)![Haga clic para ver el ejemplo en acción](/readme-images/artcurator_ios.png)

Este ejemplo muestra las siguientes operaciones de la API de correo de los servicios de Outlook: 

* [Obtener carpetas](https://msdn.microsoft.com/office/office365/APi/mail-rest-operations#GetFolders)
* [Obtener mensajes](https://msdn.microsoft.com/office/office365/APi/mail-rest-operations#Getmessages) (incluyendo la selección de filtrado y uso) 
* [Obtener datos adjuntos](https://msdn.microsoft.com/office/office365/APi/mail-rest-operations#GetAttachments)
* [Actualizar mensajes](https://msdn.microsoft.com/office/office365/APi/mail-rest-operations#Updatemessages)
* [Crear y enviar mensajes](https://msdn.microsoft.com/office/office365/APi/mail-rest-operations#Sendmessages) (con y sin datos adjuntos) 


## Requisitos previos

* [Xcode](https://developer.apple.com/xcode/downloads/) de Apple
* Instalación de [CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html) como administrador de dependencias.
* Una cuenta de Office 365. Puede registrarse en una [suscripción a Office 365 Developer](https://msdn.microsoft.com/en-us/library/office/fp179924.aspx) que incluya los recursos para comenzar a crear aplicaciones de Office 365.


**Nota**<br/>
También necesitará asegurarse de que su suscripción a Azure esté enlazada a su inquilino de Office 365. Consulte la publicación del blog del equipo de Active Directory, [Crear y administrar varios directorios de Windows Azure Active](http://blogs.technet.com/b/ad/archive/2013/11/08/creating-and-managing-multiple-windows-azure-active-directories.aspx) para obtener instrucciones. 

En esta publicación, la sección Agregar un nuevo directorio le explicará cómo hacerlo. También puede leer [Configurar el acceso a Azure Active Directory para su sitio para desarrolladores](https://msdn.microsoft.com/office/office365/howto/setup-development-environment#bk_CreateAzureSubscription) para obtener más información.

## Configurar proyecto Xcode

* Clonar este repositorio
* Usar CocoaPods para importar ADAL iOS, O365 iOS SDK y SDWebImage
        
	     pod 'ADALiOS', '~> 1.2.1'
	     pod 'Office365/Outlook', '= 0.9.1'
	     pod 'Office365/Discovery', '= 0.9.1'
	     pod 'SDWebImage', '~>3.7'

 Esta aplicación de ejemplo ya contiene un podfile que recibirá los componentes de ADAL y Office 365 (pods) en el proyecto. Simplemente vaya al proyecto desde **Terminal** y ejecute 
        
        instalación de pod
        
   Para obtener más información, consulte **Usar CocoaPods** en [Recursos adicionales](#AdditionalResources)
    
## Primer inicio

Esta aplicación contiene información de la aplicación registrada previamente en Azure con los permisos **Enviar correo como un usuario** y **Leer y escribir correo de usuario**.

La información de la aplicación está definida en ```Office365Client.m```.

    
        // Información de la aplicación
        static NSString * const REDIRECT_URL_STRING = @"https://UseOnlyToRunTheArtCuratorSample";
        static NSString * const CLIENT_ID           = @"1feaa784-0130-48d9-adeb-776fc65888c5";
        static NSString * const AUTHORITY           = @"https://login.microsoftonline.com/common";
        
Para su propia aplicación, [Registre su aplicación de cliente nativo en Azure](https://msdn.microsoft.com/library/azure/dn132599.aspx#BKMK_Adding). 

Especifique el identificador URI de redireccionamiento al registrar la aplicación.
A continuación, obtenga el Id. de cliente desde la página **CONFIGURAR**. La aplicación *debe* tener los permisos de **Enviar correo como un usuario** y **Leer y escribir correo de usuario**.

Para obtener más información, vea el [ejemplo de iOS-O365-Connect]()

## Limitaciones

* Compatibilidad de archivos más allá de ```.png``` y ```.jpg```
* Controlar un solo correo electrónico con varios datos adjuntos
* Paginación (obtener más de 50 correos electrónicos)
* Controlar la unicidad del nombre de carpeta

## Preguntas y comentarios

* Si tiene algún problema para ejecutar este ejemplo, [registre un problema](https://github.com/OfficeDev/O365-iOS-ArtCurator/issues).
* Para realizar preguntas generales acerca de las API de Office 365, publíquelas en [Stack Overflow](http://stackoverflow.com/). Asegúrese de que sus preguntas o comentarios se etiquetan con \[Office365] y \[outlook-restapi].

## Solución de problemas

Con la actualización de Xcode 7.0, la característica Seguridad de transporte de la aplicación está habilitada para los simuladores y dispositivos que ejecutan iOS 9. Consulte [Nota técnica de seguridad de transporte de la aplicación](https://developer.apple.com/library/prerelease/ios/technotes/App-Transport-Security-Technote/).

Para este ejemplo creamos una excepción temporal para el siguiente dominio en el plist:

- outlook.office365.com

Si estas excepciones no se incluyen, todas las llamadas a la API de Office 365 producirán un error en esta aplicación cuando se implementen en un simulador de iOS 9 en Xcode.

## Recursos adicionales

* [Introducción a las API de Office 365 en aplicaciones](http://aka.ms/get-started-with-js)
* [Información general sobre la plataforma de las API de Office 365](http://msdn.microsoft.com/office/office365/howto/platform-development-overview)
* [Centro para desarrolladores de Office](http://dev.office.com/)
* [Usar CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html)
* [Art Curator para Android](https://github.com/OfficeDev/O365-Android-ArtCurator)
* [Art Curator para teléfonos Windows](https://github.com/OfficeDev/O365-WinPhone-ArtCurator)
* [Art Curator para la Web (aplicación web Angular)](https://github.com/OfficeDev/O365-Angular-ArtCurator)

## Derechos de autor

Copyright (c) 2015 Microsoft. Todos los derechos reservados.


Este proyecto ha adoptado el [Código de conducta de código abierto de Microsoft](https://opensource.microsoft.com/codeofconduct/). Para obtener más información, vea [Preguntas frecuentes sobre el código de conducta](https://opensource.microsoft.com/codeofconduct/faq/) o póngase en contacto con [opencode@microsoft.com](mailto:opencode@microsoft.com) si tiene otras preguntas o comentarios.

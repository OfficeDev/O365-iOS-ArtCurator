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

[![Status da Compilação](https://travis-ci.org/OfficeDev/O365-iOS-ArtCurator.svg?branch=master)](https://travis-ci.org/OfficeDev/O365-iOS-ArtCurator)

Este exemplo demonstra como usar a API de Email do Outlook para obter emails e anexos do Office 365. Ele foi criado para iOS, [Android](https://github.com/OfficeDev/O365-Android-ArtCurator), [Web (aplicativo Web Angular)](https://github.com/OfficeDev/O365-Angular-ArtCurator) e [Windows Phone](https://github.com/OfficeDev/O365-WinPhone-ArtCurator). Confira nosso [artigo no Medium](https://medium.com/@iambmelt/14296d0a25be).
<br />
<br />
<br />
O exemplo do Art Curator oferece uma maneira diferente de exibir sua caixa de entrada. Imagine que você possui uma empresa que vende camisetas artísticas. Como proprietário da empresa, você recebe muitos emails de artistas com designs que eles querem que você compre. Atualmente, você usa seu cliente de email para abrir todas as mensagens e anexos. Em vez disso, é possível usar o exemplo do Art Curator para obter uma visualização prévia do anexo da caixa de entrada para que você possa escolher os designs de sua preferência. 

[![Office 365 iOS Art Curator](/readme-images/artcurator_ios.png)![Clique no exemplo para vê-lo em ação](/readme-images/artcurator_ios.png)

Este exemplo demonstra as seguintes operações da API de Email dos Serviços do Outlook: 

* [Obter pastas](https://msdn.microsoft.com/office/office365/APi/mail-rest-operations#GetFolders)
* [Obter mensagens](https://msdn.microsoft.com/office/office365/APi/mail-rest-operations#Getmessages) (incluindo filtragem e o uso da opção selecionar) 
* [Obter anexos](https://msdn.microsoft.com/office/office365/APi/mail-rest-operations#GetAttachments)
* [Atualizar mensagens](https://msdn.microsoft.com/office/office365/APi/mail-rest-operations#Updatemessages)
* [Criar e enviar mensagens](https://msdn.microsoft.com/office/office365/APi/mail-rest-operations#Sendmessages) (com e sem anexos) 


## Pré-requisitos

* [Xcode](https://developer.apple.com/xcode/downloads/) da Apple
* A instalação de [CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html) como um gerenciador de dependências.
* Uma conta do Office 365. Você pode assinar uma [assinatura de Desenvolvedor do Office 365](https://msdn.microsoft.com/en-us/library/office/fp179924.aspx) que inclua os recursos para começar a criar os aplicativos do Office 365.


**Anotação**<br/>
Você também deve garantir que a assinatura do Azure esteja vinculada ao seu locatário do Office 365. Confira a postagem do blog da equipe do Active Directory, [Criar e gerenciar vários Diretórios Ativos do Microsoft Azure](http://blogs.technet.com/b/ad/archive/2013/11/08/creating-and-managing-multiple-windows-azure-active-directories.aspx) para mais instruções. 

Nesta postagem, a seção Adicionando um novo diretório explica como fazer isso. Para saber mais, leia [Configurar o acesso ao Azure Active Directory para o Site do Desenvolvedor](https://msdn.microsoft.com/office/office365/howto/setup-development-environment#bk_CreateAzureSubscription).

## Configurando o projeto Xcode

* Clonar este repositório
* Use o CocoaPods para importar o ADAL iOS, o O365 iOS SDK e o SDWebImage
        
	     pod 'ADALiOS', '~> 1.2.1'
	     pod 'Office365/Outlook', '= 0.9.1'
	     pod 'Office365/Discovery', '= 0.9.1'
	     pod 'SDWebImage', '~>3.7'

 Este exemplo de aplicativo já contém um podfile que receberá os componentes (pods) do Office 365 e da ADAL no projeto. Basta navegar até o projeto a partir do **Terminal** e executar 
        
        pod install
        
   Para saber mais, confira o artigo **Usando o CocoaPods** em [Recursos adicionais](#AdditionalResources)
    
## Iniciar pela primeira vez

Este aplicativo contém informações sobre o aplicativo previamente registradas no Azure com as permissões **Enviar email como um usuário** e **Ler e gravar emails de usuários**.

As informações sobre o aplicativo estão definidas em ```Office365Client.m```.

    
        // Informações do aplicativo
        static NSString * const REDIRECT_URL_STRING = @"https://UseOnlyToRunTheArtCuratorSample";
        static NSString * const CLIENT_ID           = @"1feaa784-0130-48d9-adeb-776fc65888c5";
        static NSString * const AUTHORITY           = @"https://login.microsoftonline.com/common";
        
Para seu próprio aplicativo, [Registre o seu aplicativo de cliente nativo no Azure](https://msdn.microsoft.com/library/azure/dn132599.aspx#BKMK_Adding). 

Especifique o URI de redirecionamento ao registrar o seu aplicativo.
Em seguida, obtenha a ID do cliente na página **CONFIGURAR**. O aplicativo *deve* ter as permissões **Enviar email como usuário** e **Ler e escrever email de usuários**.

Para obter mais informações, confira [iOS-O365-Connect sample]()

## Limitações

* Suporte a arquivos além de ```.png``` e ```.jpg```
* Lidar com uma única mensagem de email com vários anexos
* Paginação (recebendo mais de 50 emails)
* Lidar com exclusividade de nome de pasta

## Perguntas e comentários

* Se você tiver problemas para executar este exemplo, [relate um problema](https://github.com/OfficeDev/O365-iOS-ArtCurator/issues)
* Para perguntas gerais sobre as APIs do Office 365, poste em [Stack Overflow](http://stackoverflow.com/). Não deixe de marcar as suas perguntas ou comentários com [Office365] e [outlook-restapi].

## Solução de problemas

Com a atualização do Xcode 7.0, a Segurança de Transporte do Aplicativo está habilitada para simuladores e dispositivos que estão executando o iOS 9. Confira [App Transport Security Technote](https://developer.apple.com/library/prerelease/ios/technotes/App-Transport-Security-Technote/).

Para este exemplo, criamos uma exceção temporária para o seguinte domínio na plist:

- outlook.office365.com

Se essas exceções não estiverem incluídas, todas as chamadas na API do Office 365 falharão neste aplicativo se ele for implantado em um simulador de iOS 9 no Xcode.

## Recursos adicionais

* [Introdução às APIs do Office 365 em aplicativos](http://aka.ms/get-started-with-js)
* [Visão geral da plataforma de APIs do Office 365](http://msdn.microsoft.com/office/office365/howto/platform-development-overview)
* [Centro de Desenvolvimento do Office](http://dev.office.com/)
* [Usando o CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html)
* [Art Curator para Android](https://github.com/OfficeDev/O365-Android-ArtCurator)
* [Art Curator para Windows Phone](https://github.com/OfficeDev/O365-WinPhone-ArtCurator)
* [Art Curator para Web (aplicativo Web Angular)](https://github.com/OfficeDev/O365-Angular-ArtCurator)

## Direitos autorais

Copyright © 2015 Microsoft. Todos os direitos reservados.


Este projeto adotou o [Código de Conduta do Código Aberto da Microsoft](https://opensource.microsoft.com/codeofconduct/). Para saber mais, confira [Perguntas frequentes sobre o Código de Conduta](https://opensource.microsoft.com/codeofconduct/faq/) ou contate [opencode@microsoft.com](mailto:opencode@microsoft.com) se tiver outras dúvidas ou comentários.

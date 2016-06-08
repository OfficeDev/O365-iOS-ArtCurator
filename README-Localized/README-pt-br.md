# O365 iOS Art Curator
[![Status da Compilação](https://travis-ci.org/OfficeDev/O365-iOS-ArtCurator.svg?branch=master)](https://travis-ci.org/OfficeDev/O365-iOS-ArtCurator)

Este exemplo demonstra como usar a API de Email do Outlook para obter emails e anexos do Office 365. Ele foi criado para iOS, [Android](https://github.com/OfficeDev/O365-Android-ArtCurator), [Web (aplicativo Web do Angular](https://github.com/OfficeDev/O365-Angular-ArtCurator) e [Windows Phone](https://github.com/OfficeDev/O365-WinPhone-ArtCurator). Confira nosso [artigo sobre o Medium](https://medium.com/@iambmelt/14296d0a25be).
<br />
<br />
<br />
A amostra do Art Curator oferece uma maneira diferente de exibir sua caixa de entrada. Imagine que você possui uma empresa que vende camisetas artísticas. Como proprietário da empresa, você recebe muitos emails de artistas com designs que eles querem que você compre. Atualmente, você usa seu cliente de email para abrir todas as mensagens e anexos. Em vez disso, é possível usar a amostra do Art Curator para obter uma exibição prévia do anexo da caixa de entrada para que você possa escolher os designs de sua preferência. 

[![Office 365 iOS Art Curator](../readme-images/artcurator_ios.png)](https://youtu.be/4LOvkweDfhY "Clique no exemplo para vê-lo em ação")

Este exemplo demonstra as seguintes operações a partir da API de Email dos Serviços do Outlook: 

* [Get folders](https://msdn.microsoft.com/office/office365/APi/mail-rest-operations#GetFolders)
* [Get messages](https://msdn.microsoft.com/office/office365/APi/mail-rest-operations#Getmessages) (incluindo filtragem e o uso da opção selecionar) 
* [Obter anexos](https://msdn.microsoft.com/office/office365/APi/mail-rest-operations#GetAttachments)
* [Atualizar mensagens](https://msdn.microsoft.com/office/office365/APi/mail-rest-operations#Updatemessages)
* [Criar e enviar mensagens](https://msdn.microsoft.com/office/office365/APi/mail-rest-operations#Sendmessages) (com e sem anexo) 


Pré-requisitos
==
* [Xcode](https://developer.apple.com/xcode/downloads/) da Apple
* Instalação do [CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html) como gerente de dependência.
* Uma conta do Office 365. Você pode se inscrever em uma [assinatura de Desenvolvedor do Office 365](https://msdn.microsoft.com/pt-br/library/office/fp179924.aspx) que inclui recursos para você começar a criar aplicativos do Office 365.


**Observação**<br/>
você também deve assegurar que a assinatura do Azure esteja vinculada ao locatário do Office 365. Para obter instruções, confira a postagem do blog da equipe do Active Directory, [Criando e Gerenciando Vários Microsoft Azure Active Directories](http://blogs.technet.com/b/ad/archive/2013/11/08/creating-and-managing-multiple-windows-azure-active-directories.aspx). 

Nesta postagem, a seção Adicionando um novo diretório explica como fazer isso. Para saber mais, você também pode ler o artigo [Configurar o acesso ao Azure Active Directory para seu Site do Desenvolvedor](https://msdn.microsoft.com/office/office365/howto/setup-development-environment#bk_CreateAzureSubscription).

Configurando o projeto Xcode
==
* Clonar esse repositório
* Use o CocoaPods para importar o ADAL iOS, o O365 iOS SDK e o SDWebImage
        
	     pod 'ADALiOS', '~> 1.2.1'
	     pod 'Office365/Outlook', '= 0.9.1'
	     pod 'Office365/Discovery', '= 0.9.1'
	     pod 'SDWebImage', '~>3.7'

 Este exemplo de aplicativo já contém um podfile que receberá os componentes (pods) do Office 365 e da ADAL no projeto. Basta navegar para o projeto a partir do **Terminal** e executar 
        
        pod install
        
   Para saber mais, confira **Usando o CocoaPods** em [Recursos Adicionais](#AdditionalResources)
    
Iniciar pela primeira vez
==

Este aplicativo contém informações sobre o aplicativo previamente registradas no Azure com as permissões **Enviar email como um usuário** e **Ler e gravar emails de usuários**.

As informações sobre o aplicativo estão definidas em ```Office365Client.m```.

    
        // Informações do aplicativo
        static NSString * const REDIRECT_URL_STRING = @"https://UseOnlyToRunTheArtCuratorSample";
        static NSString * const CLIENT_ID           = @"1feaa784-0130-48d9-adeb-776fc65888c5";
        static NSString * const AUTHORITY           = @"https://login.microsoftonline.com/common";
        
Para seu próprio aplicativo, [registre seu aplicativo cliente nativo no Azure](https://msdn.microsoft.com/library/azure/dn132599.aspx#BKMK_Adding). 

Especifique o URI de redirecionamento ao registrar seu aplicativo. Em seguida, obtenha a ID do cliente na página **CONFIGURAR**. 
O aplicativo *deve* ter as permissões **Enviar email como um usuário** and **Ler e gravar emails de usuários**.

Para saber mais, confira [exemplo do iOS-O365-Connect]()

Limitações
==
* Suporte a arquivos além de ```.png``` e ```.jpg```
* Lidar com uma única mensagem de email com vários anexos
* Paginação (recebendo mais de 50 emails)
* Lidar com exclusividade de nome de pasta

Perguntas e comentários
==
* Se você tiver problemas para executar este exemplo, [registre um problema](https://github.com/OfficeDev/O365-iOS-ArtCurator/issues)
* Para perguntas gerais sobre as APIs do Office 365, publique no [Stack Overflow](http://stackoverflow.com/). Verifique se suas perguntas ou seus comentários estão marcados com [Office365] e [outlook-restapi]

Solução de problemas
==
Com a atualização do Xcode 7.0, a Segurança de Transporte do Aplicativo está habilitada para simuladores e dispositivos que estão executando o iOS 9. Confira [App Transport Security Technote](https://developer.apple.com/library/prerelease/ios/technotes/App-Transport-Security-Technote/).

Para este exemplo, criamos uma exceção temporária para o seguinte domínio na plist:

- outlook.office365.com

Se essas exceções não estiverem incluídas, todas as chamadas na API do Office 365 falharão neste aplicativo se ele for implantado em um simulador de iOS 9 no Xcode.

Recursos adicionais
==
* [Introdução às APIs do Office 365 em aplicativos](http://aka.ms/get-started-with-js)
* [Visão geral de plataforma de APIs do Office 365](http://msdn.microsoft.com/office/office365/howto/platform-development-overview)
* [Centro de Desenvolvimento do Office](http://dev.office.com/)
* [Usando o CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html)
* [Art Curator para Android](https://github.com/OfficeDev/O365-Android-ArtCurator)
* [Art Curator para Windows Phone](https://github.com/OfficeDev/O365-WinPhone-ArtCurator)
* [Art Curator para Web (aplicativo Web do Angular](https://github.com/OfficeDev/O365-Angular-ArtCurator)

Direitos autorais
==
Copyright © 2015 Microsoft. Todos os direitos reservados.


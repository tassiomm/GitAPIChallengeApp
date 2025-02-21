# GitAPIChallengeApp

# Arquitetura
Desenvolvimento tres camadas: Presentation (Feature), Domain, Data). As camadas definem uma separação clara de responsabilidade entre a construção da view, a construção do modelo de dados e como os dados são disponibilizados. Uma camada de Networking alimenta DataSources em chamadas HTTP.

## Comunicação entre camadas
Desenvolvida a comunicação entre camadas  com Swift Concurrency `async/await`. A comunicação utilizando async/await combina a eficiência de uma solução pura em Swift com a legibilidade da concorência estruturada (`async/await`).

`Combine`: Enquanto a aplicação não é alimentada, um exemplo de implementação utilizado Combine está disponível pra uso na camada de Networking (`HTTPClient`)

# Modularização (SPM)
A modularização auxilia no desenvolvimento de aplicações escaláveis pois garante a independencia de partes da aplicação. O tempo de build também é melhorado já que um módulo buildado não fará uma nova build a menos que diretamenta modificado.

## AppUI: Para components de UI (desenvolvido com SwiftUI)
Componentes de UI pequenos, como também alguns mais complexos (ex. `AsyncImageCached`), podem ser encontrados  aqui. Aulixiares de UI também são definidos aqui, como `CustomColor` ou `Localized` (para facilitar a definição de uma string localizada).

Uma Feature é localizada através da inclusão de seu próprio arquivo de localização em módulo. Essa arquitetura define que cada Feature terá seu próprio arquivo de localização e uma função não pública Localized para buscar a string em seu próprio módulo.

## AppCore
É o que alimenta a aplicação pois define dependências de Networking, assim como camada de dados e domínio para regras de negócio. É definido pelas camadas mais internas da "Clean Architecture". Tipicamente pode ser definido por DataSources (APIs) e Providers.

## AppFeatures
Multiplos targets e produtos definem cada Feature. Uma feature é desenvolvida com SwiftUI para criar um fluxo de views consistente que entregam valor ao usuário.
        
- As view são alimentadas por TCA (The Composable Arquitecture) para definir uma separação clara entre responsabilidade entre view e regras de negócio/apresentação. TCA também garante testabilidade da view através da simução de ações sem preocupar com dependências externas.

- AppUI disponibiliza um componente que busca uma imagem de forma assíncrona evitando a interrupção da experiência do usuário.

- O componente AsyncImageCached provê uma experiência mais fluida ao garantir carregamento de imagens mais rápidas e evitar requests desnecessários (não obstruindo o endpoint).

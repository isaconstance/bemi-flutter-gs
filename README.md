# BEMI

## Sobre o projeto

O **BEMI** é um aplicativo mobile desenvolvido com Flutter e Dart, pensado para auxiliar pessoas idosas que vivem sozinhas, oferecendo recursos que contribuem para sua autonomia, segurança, organização e qualidade de vida.

A proposta surgiu da necessidade de facilitar o gerenciamento de atividades e informações importantes do cotidiano, especialmente aquelas relacionadas à saúde e aos contatos de emergência.

Por meio de uma interface simples, intuitiva e acessível, o aplicativo reúne funcionalidades que permitem ao usuário organizar seus documentos pessoais, acompanhar consultas médicas, visualizar avisos importantes e manter os contatos de familiares e pessoas de confiança sempre disponíveis.

## Objetivo de Desenvolvimento Sustentável (ODS)

O projeto está relacionado à **ODS 3 — Saúde e Bem-Estar**, estabelecida pela Organização das Nações Unidas (ONU), pois busca contribuir para a promoção da saúde, do bem-estar e de uma vida com mais autonomia para pessoas idosas.

## Arquitetura e Persistência

O projeto BEMI utiliza uma arquitetura baseada em API HTTP REST, com persistência de dados na nuvem por meio da plataforma JSONBin.io.

A integração é realizada utilizando a biblioteca http do Flutter, responsável por executar as requisições à API. Os dados são enviados e recebidos no formato JSON, enquanto os Providers fazem o gerenciamento dos estados e das informações utilizadas pelas telas.

URL base da API:

https://api.jsonbin.io/v3/b

Endpoints utilizados:
<img width="900" height="198" alt="image" src="https://github.com/user-attachments/assets/c0f88b4e-862d-44cb-b7b7-12481ddf89ed" />

A autenticação das requisições é realizada por meio de uma chave de acesso configurada nos serviços da aplicação.
A persistência permite que os documentos cadastrados e as informações de consultas sejam recuperados por meio da API, mantendo os dados disponíveis entre diferentes acessos ao aplicativo.
Telas do aplicativo

## As telas foram desenvolvidas com foco em uma navegação simples, textos legíveis, botões acessíveis e uma identidade visual consistente. A seguir, estão algumas das principais funcionalidades do aplicativo.

## Splash Screen

Apresenta a identidade visual do BEMI durante a abertura do aplicativo. Após alguns segundos, direciona o usuário para a tela de login.

<p align="center"> <img width="200" alt="splash" src="https://github.com/user-attachments/assets/c81e31c4-6718-4a5a-bb51-9e21b978aba4" /></p>

## Login e Cadastro

A tela de Login permite que o usuário informe seu e-mail e senha para acessar o aplicativo. Também oferece acesso à tela de cadastro.

A tela de Cadastro permite registrar as informações básicas do usuário, como nome, sobrenome, e-mail e senha, incluindo validações dos campos e confirmação de senha.

<p align="center"> 
<img width="200" alt="login" src="https://github.com/user-attachments/assets/b6d15023-caf6-4d69-8665-b49c9f53cc13" />
<img width="200" alt="cadastro" src="https://github.com/user-attachments/assets/ad60f434-360e-43b9-aea4-741489b2800f" />
<img width="200" alt="cadastro2" src="https://github.com/user-attachments/assets/2b1dae09-369c-4036-9d55-458e0a7cacfa" />
<img width="200" alt="cadastro1" src="https://github.com/user-attachments/assets/5c93b5f5-073c-4fd4-a813-5aab499c9087" />
</p>

## Tela inicial

A tela inicial reúne os principais recursos do BEMI, permitindo acessar documentos, consultas, avisos e contatos familiares.

Também apresenta informações de boas-vindas, um espaço demonstrativo do assistente BEMI e conteúdos relacionados à saúde e ao bem-estar, incluindo a referência ao Objetivo de Desenvolvimento Sustentável 3 (ODS 3).

<p align="center"> 
<img width="200" alt="home" src="https://github.com/user-attachments/assets/30a16ad5-8ac7-446b-84a0-ad5c6ff94676" />
<img width="200" alt="home1" src="https://github.com/user-attachments/assets/e06139a2-b2e8-418c-a98a-d021d2cbb881" />
<img width="200" alt="home2" src="https://github.com/user-attachments/assets/c45d5f84-3008-4c45-a0b1-c30f13259f1b" />
</p>

## Documentos

A funcionalidade de documentos permite consultar informações pessoais importantes, visualizar documentos cadastrados e acompanhar sua situação por meio de status, como OK, pendente e vencido.

Também é possível adicionar, editar e excluir documentos. O formulário permite informar o tipo de documento, a data de validade, a situação e observações.

As imagens apresentadas nos documentos de exemplo são ilustrativas e utilizadas para demonstrar a visualização dentro do aplicativo.

<p align="center">   
  <img width="200" alt="doc1" src="https://github.com/user-attachments/assets/b7182c35-a566-4ee3-9160-1dfbba24ff48" />
  <img width="200" alt="doc2" src="https://github.com/user-attachments/assets/bb63940a-b8da-4f70-9a90-b67132b3bffc" />
  <img width="200" alt="doc3" src="https://github.com/user-attachments/assets/8559c0a6-716e-4db1-a174-9b366e3f1342" />
  <img width="200" alt="doc4" src="https://github.com/user-attachments/assets/82014ab1-ebcb-4fbf-9af4-c22f0812a72d" />
</p>

## Consultas

A tela de Consultas reúne os compromissos de saúde do usuário, apresentando informações como especialidade médica, profissional responsável, data, horário, local e endereço.

Os dados são carregados a partir da API, facilitando a consulta das informações em um único lugar.

<p align="center">  
  <img width="200" alt="consultas" src="https://github.com/user-attachments/assets/17373446-1978-4283-be4b-8d9cd630303a" />
 </p>

## Avisos

A tela de Avisos apresenta lembretes relacionados às consultas cadastradas, permitindo visualizar informações importantes sobre os compromissos de saúde.

Também conta com orientações de segurança, incluindo recomendações para evitar golpes e proteger dados pessoais.

<p align="center">  
 <img width="200" alt="avisos" src="https://github.com/user-attachments/assets/913c2893-d906-44eb-983c-20f04f41d558" />
</p>

## Família e Contatos de Emergência

A tela de Família reúne contatos familiares demonstrativos, exibindo nomes e telefones para facilitar a identificação das pessoas que fazem parte da rede de apoio do usuário.

Também apresenta o número do SAMU (192) e um aviso de que o aplicativo não substitui os serviços oficiais de emergência.

<p align="center">  <img width="200" alt="emergencia" src="https://github.com/user-attachments/assets/2e5ca853-7df4-4d1b-8a49-101328954d0c" />
 </p>

## Minha Conta

A tela Minha Conta apresenta as informações básicas do usuário e disponibiliza opções relacionadas à personalização, acessibilidade e configurações do aplicativo.

Também permite encerrar a sessão e acessar a área de contatos familiares.

<p align="center"> <img width="200" alt="conta" src="https://github.com/user-attachments/assets/f78a7416-6656-45a0-8f73-e6cacf9ac648" />
 </p>

## Link do Pitch
https://youtu.be/520n4oWPWS0?si=yV1S8eoHzk_-RRrs
https://drive.google.com/drive/folders/10cydE1Pr29piTpBhmMKePHgN6MqBHeef?usp=drive_link

## Equipe
- Isabella Constance: RM 559219
- Daniela Grego: RM 555808


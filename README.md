# VCL Products Manager

Este projeto é uma aplicação desktop construída com **VCL (Visual Component Library)** no **Delphi/RAD Studio**, integrada com uma **API REST** que gerencia produtos, utilizando um banco de dados **PostgreSQL**. A aplicação permite realizar operações de CRUD (Create, Read, Update, Delete) em produtos, comunicando-se com a API através de requisições HTTP.

## Funcionalidades

- **Listar Produtos**: Exibe todos os produtos cadastrados na API.
- **Adicionar Produto**: Insere um novo produto com nome e preço.
- **Atualizar Produto**: Permite modificar os dados de um produto existente.
- **Excluir Produto**: Remove um produto da lista.

## Tecnologias Utilizadas

- **RAD Studio (Delphi)**: Utilizado para criar a aplicação desktop.
- **VCL (Visual Component Library)**: Biblioteca visual para a criação da interface.
- **TNetHTTPClient**: Componente responsável por fazer requisições HTTP (GET, POST, PUT, DELETE) para a API REST.
- **PostgreSQL**: Banco de dados utilizado pela API para armazenar os produtos.
- **API REST**: Aplicação backend construída em Node.js (ou outro framework) para fornecer os endpoints de CRUD de produtos.

## Instalação

### Pré-requisitos

- **RAD Studio / Delphi** instalado para compilar e rodar o projeto VCL.
- **Node.js** (ou outro ambiente para a API).
- **PostgreSQL** configurado e em execução.

# FitLife - Sistema de Gestão de Academias

## Descrição

O FitLife é um sistema web desenvolvido para auxiliar o gerenciamento de academias, permitindo o controle de alunos, planos, contratos, cobranças, professores, modalidades, turmas e avaliações físicas. O sistema foi desenvolvido como projeto da disciplina Laboratório de Desenvolvimento de Software, utilizando Python, Django, HTML e Trello.

## Problema Resolvido

Muitas academias realizam o controle de alunos, pagamentos e turmas de forma manual ou utilizando múltiplas ferramentas desconectadas. O FitLife centraliza essas informações em uma única plataforma, facilitando a gestão administrativa e operacional da academia.

## Tecnologias Utilizadas

- Python 
- Django
- HTML
- GitHub
- Trello

## Integrantes

- Ana Clara Alves Torres
- Caio César Lopes de Oliveira Moreira
- Daniel Dantas Duarte
- Diego César da Costa e Silva Gonçalves
- Gabriel Teixeira Martinho
- Letícia Pereira
- Maria Luiza de Oliveira de Araujo Morais
- Ruan Hilario Soares
- Ryan da Costa Figueira
- Yohann Marcelo Pereira Sarmento Mendes

## Funcionalidades

### Gestão de Alunos
- Cadastro de alunos
- Consulta de alunos
- Atualização cadastral

### Gestão Financeira
- Controle de cobranças
- Controle de faturas

### Gestão Acadêmica
- Cadastro de modalidades
- Gerenciamento de turmas
- Inscrição de alunos

## Instruções de Instalação

## Pré-requisitos
- Python 3.10+
- Git

## Instalação

### 1. Clone o repositório
git clone (https://github.com/ruanhilariorj1/fitlife-gestao-de-academia)
cd proj_django

### 2. Crie e ative o ambiente virtual
python -m venv .venv

### Windows
.venv\Scripts\activate

### Linux/Mac
source .venv/bin/activate

### 3. Instale as dependências
pip install -r requirements.txt

### 4. Aplique as migrações do banco de dados
python manage.py migrate

### 5. Crie um superusuário
python manage.py createsuperuser

### 6. (Opcional) Colete os arquivos estáticos
python manage.py collectstatic

## Instruções de Execução

Aplicar migrações:

python manage.py migrate

Executar servidor:

python manage.py runserver

## Telas do Sistema

## Estrutura do Projeto

```text
fitlife-gestao-de-academia/
│
├──config/
├──docs/
├──fitlife/
├──manage.py
├──requirements.txt
└──README.md
```

---
## Gerenciamento do Projeto

O desenvolvimento foi organizado utilizando a metodologia Kanban por meio da ferramenta Trello.

As atividades foram distribuídas em backlog, tarefas em andamento e tarefas concluídas para facilitar o acompanhamento da evolução do projeto.

## Documentação

A documentação completa do projeto está disponível em:

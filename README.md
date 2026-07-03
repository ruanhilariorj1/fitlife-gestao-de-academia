# FitLife - Sistema de Gestão de Academias

## Descrição

O FitLife é um sistema web desenvolvido para auxiliar o gerenciamento de academias, permitindo o controle de alunos, planos, contratos, cobranças, professores, modalidades e turmas. O sistema foi desenvolvido como projeto da disciplina Laboratório de Desenvolvimento de Software, utilizando Python, Django, HTML e Trello.

## Problema Resolvido

Muitas academias realizam o controle de alunos, pagamentos e turmas de forma manual ou utilizando múltiplas ferramentas desconectadas. O FitLife centraliza essas informações em uma única plataforma, facilitando a gestão administrativa e operacional da academia.

## Tecnologias Utilizadas

### Backend
- Python 3.13
- Django 6.0.6
- SQLite (banco de dados em desenvolvimento)

### Frontend
- HTML5 + CSS3
- Django Templates (sistema de templates nativo)
- Tabler Icons (biblioteca de ícones via CDN)

### Autenticação e Autorização
- Django Auth (sistema nativo de autenticação)
- Grupos e Permissões do Django

### Interface Admin
- Django Admin
- Jazzmin (tema para o painel administrativo)

### Ambiente e Ferramentas
- Python venv (ambiente virtual)
- Git + GitHub (versionamento)
- VS Code (editor de código)
- Docker (containerização)

### Gerenciamento de Tarefas
- Trello (organização do backlog e acompanhamento das tarefas)

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

### Login
![Login](docs/telas/login_fitlife.png)

### Home/Dashboard
![Home/Dashboard](docs/telas/home_dashboard.png)

### Lista de Alunos
![Lista de Alunos](docs/telas/lista_alunos.png)

### Cadastro de Alunos
![Cadastro de Alunos](docs/telas/cadastro_aluno.png)

### Detalhe do Aluno
![Detalhe do Aluno](docs/telas/detalhe_aluno.png)

### Editar Aluno
![Editar Aluno](docs/telas/editar_aluno.png)

### Excluir Aluno
![Excluir Aluno](docs/telas/excluir_aluno.png)

### Inscrever Aluno
![Inscrever Aluno](docs/telas/inscrever_aluno.png)

### Lista de Pagamentos
![Lista de Pagamentos](docs/telas/lista_pagamentos.png)

### Cadastro de Pagamentos
![Cadastro de Pagamentos](docs/telas/cadastro_pagamento.png)

### Detalhe do Pagamento
![Detalhe do Pagamento](docs/telas/detalhe_pagamento.png)

### Editar Pagamento
![Editar Pagamento](docs/telas/editar_pagamento.png)

### Lista de Turmas
![Lista de Turmas](docs/telas/lista_turmas.png)

### Cadastro de Turmas
![Cadastro de Turmas](docs/telas/cadastro_turma.png)

### Detalhe da Turma
![Detalhe da Turma](docs/telas/detalhe_tuma.png)

### Editar Turma
![Editar Turma](docs/telas/editar_turma.png)

### Lista de Professores
![Lista de Professores](docs/telas/lista_professores.png)

### Lista de Unidades
![Lista de Unidades](docs/telas/lista_unidades.png)

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

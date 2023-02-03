# SCRIPT DE CRIAÇÃO DE ESTRUTURA DE USUÁRIOS, DIRETÓRIOS E PERMISSÕES

No curso de Linux do Zero da Digital Innovation One, o professor Denilson Bonatti pediu para que os alunos criassem um script para facilitar a criação de usuários, diretórios e permissões em servidores Linux.

Por ter gostado muito do desafio, e já ter conhecimento em Shell Script, obtido no meu curso de graduação, resolvi criar o meu próprio script, com algumas funcionalidades extras.

O script foi criado para ser executado no terminal do Linux, para executá-lo, siga os passos abaixo:

- Faça o clone do repositório:
- `git clone https://github.com/mr-reinaldo/dio-projeto-script-gerenciamento.git`

- Entre na pasta do projeto:
- `cd dio-projeto-script-gerenciamento`

- Dê permissão de execução ao script:
- `chmod +x gerenciamento.sh`

Observação: O script deve ser executado com o usuário root, ou seja, com privilégios de administrador.

- Execute o script:
- `./gerenciamento.sh`

O script possui as seguintes opções:

- Criação de usuários
- Criação de diretórios
- Aplicação de permissões em usuários, grupos e diretórios.

O script possui as seguintes validações:

- Verificação se o usuário é root ou não.
- Verificação se o usuário já existe.
- Verificação se o diretório já existe.
- Verificação se o grupo já existe.

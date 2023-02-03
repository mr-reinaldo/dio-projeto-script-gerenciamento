#!/usr/bin/env bash
# Autor: mr-reinaldo
# Data: 03/02/2023
# Versão: 0.1
# Descrição: Script para gerenciamento de usuários, grupos e diretórios.

# Definição de cores
REDC='\033[0;31m'
GREENC='\033[0;32m'
NC='\033[0m'

# Variáveis
listar_diretorios=() # Array para armazenar os diretórios criados.
lista_usuarios=()    # Array para armazenar os usuários criados.
lista_grupos=()      # Array para armazenar os grupos criados.

# Funções de verificação de root
function eh_root() {
    if [ $(id -u) -ne 0 ]; then
        echo -e "${REDC}Você precisa ser root para executar este script!${NC}"
        echo -e "${REDC}Execute o comando: sudo ${0} ${@}${NC}"
        exit 1
    fi
}

# Funções de verifacação de execução de comandos
function codigo_de_retorno() {
    if [ $? -ne 0 ]; then
        echo -e "${REDC}Erro ao executar o comando!${NC}"
        exit 1
    fi
}

# Função para verificar se um grupo existe no sistema.
function grupo_existe() {
    getent group "${1}" &>/dev/null
    if [ $? -eq 0 ]; then
        echo -e "${GREENC}Grupo ${1} já existe no sistema!${NC}"
    else
        echo -e "${REDC}Grupo ${1} não existe no sistema!${NC}"
        echo -e "${REDC}Criando grupo ${1}...${NC}"
        groupadd "${1}" &>/dev/null
        codigo_de_retorno
        echo -e "${GREENC}Grupo ${1} criado com sucesso!${NC}"
    fi
}

# Função para verificar se um usuário existe no sistema.
function usuario_existe() {
    getent passwd "${1}" &>/dev/null
    if [ $? -eq 0 ]; then
        echo -e "${GREENC}Usuário ${1} já existe no sistema!${NC}"
    else
        echo -e "${REDC}Usuário ${1} não existe no sistema!${NC}"
        echo -e "${REDC}Criando usuário ${1}...${NC}"
        useradd ${1} -m -s /bin/bash -p "${2}" -G "${3}" &>/dev/null
        codigo_de_retorno
        echo -e "${GREENC}Usuário ${1} criado com sucesso!${NC}"
    fi
}

# Função para verificar se um diretório existe no sistema.
function diretorio_existe() {
    if [ -d "${1}" ]; then
        echo -e "${GREENC}Diretório ${1} já existe no sistema!${NC}"
    else
        echo -e "${REDC}Diretório ${1} não existe no sistema!${NC}"
        echo -e "${REDC}Criando diretório ${1}...${NC}"
        mkdir -p "${1}" &>/dev/null
        codigo_de_retorno
        echo -e "${GREENC}Diretório ${1} criado com sucesso!${NC}"
    fi
}

# Funções de Criação de Usuários
function criar_usuarios() {
    read -p "Digite o nome do usuário: " usuario
    read -p "Digite a senha do usuário: " senha
    read -p "Digite o nome do grupo: " grupo
    grupo_existe "${grupo}"
    hash_senha=$(openssl passwd -6 "${senha}")
    usuario_existe "${usuario}" "${hash_senha}" "${grupo}"
    lista_usuarios+=("${usuario}")
    lista_grupos+=("${grupo}")

}

# Funções de Criação de Diretórios
function criar_diretorios() {
    read -p "Digite o nome do diretório: " diretorio
    diretorio_existe "${diretorio}"
    listar_diretorios+=("${diretorio}")
}

# Funções de Criação de Permissões em diretŕios criados.
function permissoes_diretorios() {
    # Selecionar diretório
    # Selecionar usuário dono do diretório
    # Selecionar grupo dono do diretório
    # Solicitar permissões

    select diretorio in "${listar_diretorios[@]}"; do
        if [ -z "${diretorio}" ]; then
            echo -e "${REDC}Opção inválida!${NC}"
        else
            break
        fi
    done

    select usuario in "${lista_usuarios[@]}"; do
        if [ -z "${usuario}" ]; then
            echo -e "${REDC}Opção inválida!${NC}"
        else
            break
        fi
    done

    select grupo in "${lista_grupos[@]}"; do
        if [ -z "${grupo}" ]; then
            echo -e "${REDC}Opção inválida!${NC}"
        else
            break
        fi
    done

    read -p "Digite as permissões: " permissao

    chown "${usuario}":"${grupo}" "${diretorio}"
    codigo_de_retorno
    echo -e "${GREENC}O usuário ${usuario} e o grupo ${grupo} são donos do diretório ${diretorio}!${NC}"
    chmod "${permissao}" "${diretorio}"
    codigo_de_retorno
    echo -e "${GREENC}As permissões ${permissao} foram aplicadas no diretório ${diretorio}!${NC}"

}

# Menu de opções

while true; do
    eh_root
    clear
    cat <<EOF
    --------------------------------------------
    Script de Criação de Usuários e Diretórios
    --------------------------------------------

    $(date +%d/%m/%Y) - $(date +%H:%M:%S)

    1 - Criar Usuários
    2 - Criar Diretórios
    3 - Aplicar Permissões em Diretórios
    0 - Sair


EOF

    read -p "Escolha uma opção: " opcao
    case "${opcao}" in
    1)
        clear
        criar_usuarios
        ;;
    2)
        clear
        criar_diretorios
        ;;
    3)
        clear
        permissoes_diretorios
        ;;
    0)
        echo -e "${GREENC}Saindo do programa...${NC}"
        exit 0
        ;;
    *)
        echo -e "${REDC}Opção inválida!${NC}"
        ;;
    esac
    read -p "Pressione [ENTER] para continuar..."
done

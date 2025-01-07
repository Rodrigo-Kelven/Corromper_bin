#!/bin/bash

# Função para corromper arquivos binários
corromper_arquivo() {
    local arquivo="$1"

    # Obtém o tamanho do arquivo
    tamanho=$(stat -c%s "$arquivo")

    # Gera um número aleatório para determinar quantos bytes corromper
    bytes_corrompidos=$((RANDOM % tamanho))

    # Corrompe os primeiros 'bytes_corrompidos' bytes do arquivo
    dd if=/dev/urandom bs=1 count="$bytes_corrompidos" of="$arquivo" conv=notrunc

    echo "Arquivo '$arquivo' corrompido em $bytes_corrompidos bytes."
}

# Verifica se um diretório foi passado como argumento
if [ -z "$1" ]; then
    echo "Uso: $0 <diretório>"
    exit 1
fi

# Verifica se o diretório existe
if [ ! -d "$1" ]; then
    echo "Diretório não encontrado: $1"
    exit 1
fi

# Percorre todos os arquivos binários no diretório e subdiretórios
find "$1" -type f \( -name "*.bin" -o -name "*.exe" -o -name "*.dll" \) | while read -r arquivo; do
    corromper_arquivo "$arquivo"
done

echo "Todos os arquivos binários foram corrompidos."

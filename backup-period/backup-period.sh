#!/bin/bash

# Diretório onde os dumps serão salvos
MYSQLDIR="/var/lib//backup"

# Arquivo de controle com a data final do último dump
ARQUIVO_CONTROLE="$MYSQLDIR/data_controle.txt"

# Informações do banco de dados
DBUSER="user"
DBPASS="senha"
DATABASE="database"
TABLE="tabela"

# Se o arquivo de controle não existir, define a data de início como 01/12/2023
if [ ! -e "$ARQUIVO_CONTROLE" ]; then
    ULTIMA_DATA_BACKUP="2023-11-30"
else
    # Ler a data final do último dump do arquivo de controle
    ULTIMA_DATA_BACKUP=$(cat "$ARQUIVO_CONTROLE")
fi

# Calcular a nova data inicial e final para o backup
NOVA_DATA_INICIO=$(date -d "$ULTIMA_DATA_BACKUP + 1 day" "+%Y-%m-%d")
NOVA_DATA_FIM=$(date -d "$NOVA_DATA_INICIO + 3 days" "+%Y-%m-%d")

# Log das datas
echo "Data inicial do select: $NOVA_DATA_INICIO"
echo "Data final do select: $NOVA_DATA_FIM"
echo "Data gravada no arquivo de controle: $ULTIMA_DATA_BACKUP"

# Executar o dump da tabela especificada usando a data como filtro
mysqldump -u$DBUSER -p$DBPASS $DATABASE $TABLE --no-create-info --set-gtid-purged=OFF --where="call_start_time BETWEEN '$NOVA_DATA_INICIO 00:00:00' AND '$NOVA_DATA_FIM 23:59:59'" > "$MYSQLDIR/${TABLE}.${NOVA_DATA_INICIO}-${NOVA_DATA_FIM}.sql"


# Compactar o arquivo SQL em .tar.gz
tar -czf "$MYSQLDIR/${TABLE}.${NOVA_DATA_INICIO}-${NOVA_DATA_FIM}.tar.gz" "$MYSQLDIR/${TABLE}.${NOVA_DATA_INICIO}-${NOVA_DATA_FIM}.sql"

# Remover o arquivo SQL após compactação
rm "$MYSQLDIR/${TABLE}.${NOVA_DATA_INICIO}-${NOVA_DATA_FIM}.sql"

# Salvar a nova data final no arquivo de controle
echo "$NOVA_DATA_FIM" > "$ARQUIVO_CONTROLE"

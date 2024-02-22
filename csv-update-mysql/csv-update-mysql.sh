#!/bin/bash

# ConfiguraÃ§s do banco de dados
DB_HOST=""
DB_USER=""
DB_PASS=""
DB_NAME=""
TABLE_NAME=""
FIELD_NAME=""

#Script para localizar valor a ser alterado através da coluna 1 e setando valor que está na coluna 2

CSV_FILE="/home/piaia/lista1.csv"


IFS=";"


while read -r col1 col2
do

    SQL="UPDATE ${TABLE_NAME} SET ${FIELD_NAME}='${col2}' WHERE username='${col1}';"


    mysql -h ${DB_HOST} -u ${DB_USER} -p${DB_PASS} ${DB_NAME} -e "${SQL}"

done < ${CSV_FILE}
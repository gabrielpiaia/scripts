#!/bin/bash

source config.conf
YESTERDAY=$(date -d "yesterday" +%Y-%m-%d)

CSV_FILE="/tmp/NOVATECH_25223_$YESTERDAY.csv"
LOG_FILE="/var/log/export-cdr.log"

if [ -e "$CSV_FILE" ]; then
  echo "O arquivo $CSV_FILE já existe. Removendo..."
  rm "$CSV_FILE"
fi

mysql -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -D "sippulse_reports" -e "SELECT src_uri, callee_id, call_start_time, duration, rate, price, service_type, service FROM cdrs_report WHERE accountcode='${SUBSCRIBER}' AND call_start_time BETWEEN '${YESTERDAY} 00:00:00' AND '${YESTERDAY} 23:59:59' ORDER BY call_start_time INTO OUTFILE '${CSV_FILE}' FIELDS TERMINATED BY ';' LINES TERMINATED BY '\n';"

if [ $? -eq 0 ]; then
  echo "$(date '+%Y-%m-%d %H:%M:%S') - Exportação realizada com sucesso." > "$LOG_FILE"

  # Enviar o arquivo via SFTP
  /usr/bin/expect << EOF
spawn sftp $FTP_USER@$FTP_SERVER
expect "password:"
send "$FTP_PASSWORD\r"
expect "sftp>"
send "put $CSV_FILE $REMOTE_DIR\r"
expect "sftp>"
send "quit\r"
EOF

  if [ $? -eq 0 ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Enviado com sucesso para $FTP_SERVER" >> "$LOG_FILE"
    rm "$CSV_FILE"  # Exclui o arquivo CSV após o envio bem-sucedido
  else
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Falha ao enviar para $FTP_SERVER" >> "$LOG_FILE"
  fi
else
  echo "$(date '+%Y-%m-%d %H:%M:%S') - Falha na exportação dos dados." >> "$LOG_FILE"
fi
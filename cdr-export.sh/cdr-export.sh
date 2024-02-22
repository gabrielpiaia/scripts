#!/bin/bash


# Inclui as configurações
source config.conf


 YESTERDAY=$(date -d "yesterday" +%Y-%m-%d)
# Defina as variáveis
CSV_FILE="nome_do_assinante$YESTERDAY.csv"
LOG_FILE="export-cdr.log"

# Comando MySQL para exportar dados para CSV
mysql -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -D "$DATABASE" -e "SELECT * FROM $TABLE" > "$CSV_FILE"

# Verifica se a exportação foi bem-sucedida
if [ $? -eq 0 ]; then
  echo "$(date '+%Y-%m-%d %H:%M:%S') - Exportação realizada com sucesso." >> "$LOG_FILE"
  
  # Envio do arquivo por FTP
  ftp -inv $FTP_SERVER << EOF
  user $FTP_USER $FTP_PASSWORD
  cd $REMOTE_DIR
  put $CSV_FILE
  quit
EOF

  # Verifica se o envio por FTP foi bem-sucedido
  if [ $? -eq 0 ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Enviado com sucesso para $FTP_SERVER" >> "$LOG_FILE"
    
    # Se tudo ocorrer bem, exclui o arquivo CSV
    rm "$CSV_FILE"
  else
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Falha ao enviar para $FTP_SERVER" >> "$LOG_FILE"
  fi

else
  echo "$(date '+%Y-%m-%d %H:%M:%S') - Falha na exportação dos dados." >> "$LOG_FILE"
fi
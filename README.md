# Repositório de Scripts Shell

## Descrição
Este repositório contém uma coleção de scripts em shell que automatizam tarefas comuns de administração de sistemas, incluindo:

- **Backups Automatizados:** Scripts para realizar backups regulares de arquivos e bancos de dados, garantindo a segurança e integridade dos dados.
- **Coleta de Logs:** Automatização da coleta e gerenciamento de logs de sistemas, facilitando a análise e monitoramento de atividades.
- **Modificações no MySQL:** Scripts que utilizam listas em formato CSV para realizar modificações em tabelas do MySQL, tornando a manipulação de dados mais eficiente.

## Funcionalidades

### 1. Backups Automatizados
Os scripts permitem a criação de backups periódicos de diretórios específicos e bancos de dados MySQL, utilizando cron jobs para agendamento.

### 2. Coleta de Logs
Scripts que coletam logs de diferentes serviços, consolidando as informações em um único local para fácil acesso e análise.

### 3. Modificações no MySQL
Scripts que leem dados de arquivos CSV e executam operações de atualização, inserção ou exclusão em tabelas MySQL, simplificando o gerenciamento de dados.

## Estrutura dos Scripts
Os scripts são organizados de forma modular, com funções específicas para cada tarefa. Exemplos de nomes de scripts incluídos no repositório:

- `backup-period.sh`: Script para criar backups automáticos.
- `cdr-export.sh`: Script para exportação de dados CDR.
- `csv-update-mysql.sh`: Script que aplica modificações no MySQL baseadas em listas CSV.
- `export-ftp.sh`: Script para exportar dados via FTP.

# Marketing Analytics em R
# Módulo 1 - Coleta de Dados de Marketing e Análise Exploratória

# Carregando os dados
# Dataset: 51.243 observações e 3 variáveis
setwd("~/Dropbox/DSA/Business-Analytics/R/Cap03")
data = read.delim(file = 'compras.txt', header = FALSE, sep = '\t', dec = '.')

# Resumo dos dados
head(data)
summary(data)

# Adicionando cabeçalho e adicionando uma coluna extra com o ano da compra
colnames(data) = c('cliente_id', 'valor_compra', 'data_compra')
data$data_compra = as.Date(data$data_compra, "%Y-%m-%d")
data$ano_compra = as.numeric(format(data$data_compra, "%Y"))

# Resumo dos dados após modificação
head(data)
summary(data)
str(data)

# Explorando os dados de forma simples com linguagem SQL
install.packages("sqldf")
library(sqldf)

# Número de compras por ano
sqlqry = sqldf("SELECT ano_compra, COUNT(ano_compra) AS 'compras_por_ano' FROM data GROUP BY 1 ORDER BY 1")
barplot(sqlqry$compras_por_ano, names.arg = sqlqry$ano_compra)

# Valor médio das compras por ano
sqlqry = sqldf("SELECT ano_compra, AVG(valor_compra) AS 'media_compra' FROM data GROUP BY 1 ORDER BY 1")
barplot(sqlqry$media_compra, names.arg = sqlqry$ano_compra)

# Total de compras por ano
sqlqry = sqldf("SELECT ano_compra, SUM(valor_compra) AS 'total_compras' FROM data GROUP BY 1 ORDER BY 1")
barplot(sqlqry$total_compras, names.arg = sqlqry$ano_compra)

# Resumo 
sqlqry = sqldf("SELECT ano_compra,
                  COUNT(ano_compra) AS 'compras_por_ano',
                  AVG(valor_compra) AS 'media_compra',
                  SUM(valor_compra) AS 'total_compras'
           FROM data GROUP BY 1 ORDER BY 1")

print(sqlqry)







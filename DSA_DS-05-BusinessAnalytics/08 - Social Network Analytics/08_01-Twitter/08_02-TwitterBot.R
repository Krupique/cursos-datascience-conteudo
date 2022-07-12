# Social Network Analytics - Twitter Bot
# Coletando dados da web e twittando em tempo real

# Definindo o diretorio de trabalho
setwd("~/path/Twitter")
getwd()

# Instalando pacotes
# install.packages("rvest")
# install.packages("stringr")
# install.packages("dplyr")
# install.packages("twitteR")

# Carregando os pacotes
library(rvest)
library(stringr)
library(dplyr)
library(twitteR)

# Web Scraping
url <- "https://cran.r-project.org/web/packages"

# Lendo a url
page <- read_html(url)

# Obtendo o num de pacotes
n_packages <- page %>%
  html_text() %>% 
  str_extract("[[:digit:]]* available packages") %>% 
  str_extract("[[:digit:]]*") %>% 
  as.numeric()

print(n_packages)

# Num de pacotes lidos na ultima leitura
n_packages_last_time <- read.table(file = "n_packages.csv",stringsAsFactors = F, sep = ";")
n_packages_last_time <- n_packages_last_time$V2[nrow(n_packages_last_time)]

# Envia tweet somente se o num de pacotes mudou desde a ultima leitura
if(n_packages > n_packages_last_time) {

  # Definindo as chaves de acesso
  api_key <- "OQOuxCrWd78e0aJXAzXvDLZR7"
  api_secret <- "HJrn8kpeSj9yIgm7SiUovDnlkFZJvMo49z4ghbJCkZaw4ZMfab"
  access_token <- "703383646602981377-GpVDuuOScLxb7x7DdowUNVQOL2HHEtJ"
  access_token_secret <- "d9eAoYmjOuQFEC5PlZqjxqzdX4uDYfQX1Ng5Fopc9xB9w"
  
  # Autenticando no Twitter
  setup_twitter_oauth(api_key, api_secret, access_token, access_token_secret)
  
  # Time
  time <- Sys.time()
  
  # Cria o tweet
  tweet_text <- paste0("Olá a todos, são ", time, " e neste momento existem ", n_packages, " pacotes R no CRAN. Aqui é o TweetBot DSA em ação!")
  
  # Envia o tweet
  tweet(tweet_text)
  
  # Gravando no arquivo
  n_packages_df <- data.frame(time = Sys.time(), n = n_packages)
  write.table(n_packages_df, file = "n_packages.csv", row.names = FALSE,col.names = FALSE, append = TRUE, sep = ";")
  
}

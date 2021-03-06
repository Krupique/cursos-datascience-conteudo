# Identificando Clientes Alvo

# ***** Esta é a versão 2.0 deste script, atualizado em 04/08/2017 *****
# ***** Esse script pode ser executado nas versões 3.3.1, 3.3.2, 3.3.3 e 3.4.0 da linguagem R *****
# ***** Recomendamos a utilização da versão 3.4.0 da linguagem R *****

# Working Directory
setwd("~/Dropbox/DSA/Business-Analytics/R/Cap03")
getwd()

# Pacotes
install.packages("lattice")
install.packages("vcd")
install.packages("ROCR")
library(lattice)  # Visualização de Dados Multivariados
library(vcd)      # Visualização de variáveis categóricas
library(ROCR)     # Avaliação de classificadores binários

# Carregando o dataset com informações de clientes de uma instituição financeira
bank <- read.csv("bank.csv", sep = ";", stringsAsFactors = FALSE)

# Visualizando a estrutura do dataset
print(head(bank))
print(str(bank))
print(names(bank))

# Visualizando classe e atributos de uma variável
print(class(bank$age))
print(attributes(bank$age))  # NULL significa que não há atributos especiais

# Plot do Hitograma para uma variável
with(bank, hist(age))

# Examinando tabela de frequência para variáveis categórias/fator
# Visualizando o número de observações com dados missing (quando houver)
print(table(bank$job , useNA = c("always")))
print(table(bank$marital , useNA = c("always")))
print(table(bank$education , useNA = c("always")))
print(table(bank$default , useNA = c("always")))
print(table(bank$housing , useNA = c("always")))
print(table(bank$loan , useNA = c("always")))

# Tipos de empregos (admin., unknown, unemployed, management, housemaid, entrepreneur, student, blue-collar, self-employed, retired, technician, services)
# Dividindo todos os empregos em 3 categorias principais: "White Collar", "Blue Collar", "Other/Unknown"
white_collar_list <- c("admin.","entrepreneur","management","self-employed")  
blue_collar_list <- c("blue-collar","services","technician")
bank$jobtype <- rep(3, length = nrow(bank))
bank$jobtype <- ifelse((bank$job %in% white_collar_list), 1, bank$jobtype) 
bank$jobtype <- ifelse((bank$job %in% blue_collar_list), 2, bank$jobtype) 
bank$jobtype <- factor(bank$jobtype, levels = c(1, 2, 3), labels = c("White Collar", "Blue Collar", "Other/Unknown"))
with(bank, table(job, jobtype, useNA = c("always"))) 

# Definindo variáveis do tipo fator e definindo labels para os plots
bank$marital <- factor(bank$marital, labels = c("Divorced", "Married", "Single"))
bank$education <- factor(bank$education, labels = c("Primary", "Secondary", "Tertiary", "Unknown"))
bank$default <- factor(bank$default, labels = c("No", "Yes"))
bank$housing <- factor(bank$housing, labels = c("No", "Yes"))
bank$loan <- factor(bank$loan, labels = c("No", "Yes"))
bank$response <- factor(bank$response, labels = c("No", "Yes"))
    
# Selecionando subsets de casos (observações no dataset) de clientes que nunca receberam contato da equipe de vendas
bankwork <- subset(bank, subset = (previous == 0), select = c("response", "age", "jobtype", "marital", "education", "default", "balance", "housing", "loan"))

# Visualizando a estrutura do novo dataframe criado
print(head(bankwork))
print(str(bankwork))
print(summary(bankwork))


##### ---------- Examinando a relação entre idade e reposta às promoções ------------
pdf(file = "grafico01_targeting_customers_age_lattice.pdf", width = 8.5, height = 8.5)
lattice_plot_object <- histogram(~age | response, data = bankwork,
    type = "density", xlab = "Idade do Cliente do Banco", layout = c(1,2))
print(lattice_plot_object) 
dev.off()


##### ---------- Examinando a relação entre educação e reposta às promoções ------------
with(bankwork, print(table(education, response, useNA = c("always"))))

# Mosaic Plot com o pacote vcd
pdf(file = "grafico02_targeting_customers_education_mosaic.pdf", 
    width = 8.5, height = 8.5)
mosaic( ~ response + education, data = bankwork,
  labeling_args = list(set_varnames = c(response = "Resposta a Ofertas", 
  education = "Nível de Educação")),
  highlighting = "education",
  highlighting_fill = c("cornsilk","violet","purple","white","cornsilk","violet","purple","white"),
  rot_labels = c(left = 0, top = 0),
  pos_labels = c("center","center"),
  offset_labels = c(0.0,0.6))
dev.off()


##### ---------- Examinando a relação entre tipo de emprego e reposta às promoções ------------
with(bankwork, print(table(jobtype, response, useNA = c("always"))))
pdf(file = "grafico03_targeting_customers_jobtype_mosaic.pdf", width = 8.5, height = 8.5)
mosaic( ~ response + jobtype, data = bankwork,
  labeling_args = list(set_varnames = c(response = "Resposta a Ofertas", 
  jobtype = "Tipo de Emprego")),
  highlighting = "jobtype",
  highlighting_fill = c("cornsilk","violet","purple","cornsilk","violet","purple"),
  rot_labels = c(left = 0, top = 0),
  pos_labels = c("center","center"),
  offset_labels = c(0.0,0.6))
dev.off()


##### ---------- Examinando a relação entre entre o estado civil e reposta às promoções ------------
with(bankwork, print(table(marital, response, useNA = c("always"))))
pdf(file = "grafico04_targeting_customers_marital_mosaic.pdf", width = 8.5, height = 8.5)
mosaic( ~ response + marital, data = bankwork,
  labeling_args = list(set_varnames = c(response = "Resposta a Ofertas", 
  marital = "Marital Status")),
  highlighting = "marital",
  highlighting_fill = c("cornsilk","violet","purple","cornsilk","violet","purple"),
  rot_labels = c(left = 0, top = 0),
  pos_labels = c("center","center"),
  offset_labels = c(0.0,0.6))
dev.off()


##### ---------- Examinando a relação entre atraso no pagamento de crédito e reposta às promoções ------------
with(bankwork, print(table(default, response, useNA = c("always"))))
pdf(file = "grafico05_targeting_customers_default_mosaic.pdf", width = 8.5, height = 8.5)
mosaic( ~ response + default, data = bankwork,
  labeling_args = list(set_varnames = c(response = "Resposta a Ofertas", 
  default = "Possui atraso no pagamento de crédito?")),
  highlighting = "default",
  highlighting_fill = c("cornsilk","violet"),
  rot_labels = c(left = 0, top = 0),
  pos_labels = c("center","center"),
  offset_labels = c(0.0,0.6))
dev.off()


##### ---------- Examinando o saldo média da conta corrente dos clientes alvo ------------
pdf(file = "grafico06_targeting_customers_balance_lattice.pdf", width = 8.5, height = 8.5)
lattice_plot_object <- histogram(~balance | response, data = bankwork,
    type = "density", 
    xlab = "Saldo Média Anual da Conta Corrente", 
    layout = c(1,2))
print(lattice_plot_object)  
dev.off()


##### ---------- Examinando a relação entre financiamento de casa e reposta às promoções ------------
with(bankwork, print(table(housing, response, useNA = c("always"))))
pdf(file = "grafico07_targeting_customers_housing_mosaic.pdf", width = 8.5, height = 8.5)
mosaic( ~ response + housing, data = bankwork,
  labeling_args = list(set_varnames = c(response = "Resposta a Ofertas", 
  housing = "Possui financiamento?")),
  highlighting = "housing",
  highlighting_fill = c("cornsilk","violet"),
  rot_labels = c(left = 0, top = 0),
  pos_labels = c("center","center"),
  offset_labels = c(0.0,0.6))
dev.off()


##### ---------- Examinando a relação entre empréstimo pessoal e reposta às promoções ------------
with(bankwork, print(table(loan, response, useNA = c("always"))))
pdf(file = "grafico08_targeting_customers_loan_mosaic.pdf", width = 8.5, height = 8.5)
mosaic( ~ response + loan, data = bankwork,
  labeling_args = list(set_varnames = c(response = "Resposta a Ofertas", 
  loan = "Possui empréstimo pessoal?")),
  highlighting = "loan",
  highlighting_fill = c("cornsilk","violet"),
  rot_labels = c(left = 0, top = 0),
  pos_labels = c("center","center"),
  offset_labels = c(0.0,0.6))
dev.off()


# Criando um modelo preditivo com Regressão Logística

# Definindo a fórmula
bank_spec <- {response ~ age + jobtype + education + marital + default + balance + housing + loan}

# Criando o modelo
bank_fit <- glm(bank_spec, family = binomial, data = bankwork)
print(summary(bank_fit))
print(anova(bank_fit, test="Chisq"))

# Computando a probabilidade prevista do cliente responder a uma oferta
bankwork$Predict_Prob_Response <- predict.glm(bank_fit, type = "response") 

# Plot das previsões
pdf(file = "grafico09_targeting_customer_log_reg_density_evaluation.pdf", width = 8.5, height = 8.5)
plotting_object <- densityplot( ~ Predict_Prob_Response | response, 
                                data = bankwork, 
                                layout = c(1,2), aspect=1, col = "darkblue", 
                                plot.points = "rug",
                                strip = function(...) strip.default(..., style = 1),
                                xlab = "Probabilidade Previstas de Responder a Ofertas") 
print(plotting_object) 
dev.off()


# Computando o lift usando prediction() a partir do ROCR
bankwork_prediction <- prediction(bankwork$Predict_Prob_Response, bankwork$response)
bankwork_lift <- performance(bankwork_prediction , "lift", "rpp")
pdf(file = "grafico10_targeting_customers_lift_chart.pdf", 
    width = 8.5, height = 8.5)
plot(bankwork_lift, 
col = "blue", lty = "solid", main = "", lwd = 2,
    xlab = paste("Proporção de Clientes (Ordenados Por Probabilidade)",
    " Que Devem Aceitar Ofertas\n(Do Maior para o Menor)", sep = ""), 
    ylab = "Lift over Baseline Subscription Rate")
dev.off()


# Sugestões para o aluno:
# Experimente métodos alternativos de classificação, tais como redes neurais,
# SVM's e Random Forests. Compare o desempenho destes métodos com a regressão logística. 
# Utilizar métodos alternativos de comparação, incluindo área sob a curva ROC.
# Assegure-se de que a avaliação seja realizada usando dados de treinamento e de teste
# talvez utilizando multifold cross-validation.
# Confira o pacote R cvTools para fazer este trabalho.
# Examinar a importância das variáveis explicativas individuais
# na identificação de clientes alvo. Isto pode ser feito olhando para testes de
# significância estatística ou avaliação de importância de variáveis usando 
# árvores de classificação ou random forests



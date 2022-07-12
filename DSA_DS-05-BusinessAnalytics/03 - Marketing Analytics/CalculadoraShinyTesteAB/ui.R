# ui.R

# ***** Esta é a versão 2.0 deste script, atualizado em 04/08/2017 *****
# ***** Esse script pode ser executado nas versões 3.3.1, 3.3.2, 3.3.3 e 3.4.0 da linguagem R *****
# ***** Recomendamos a utilização da versão 3.4.0 da linguagem R *****

library(shiny)
shinyUI(pageWithSidebar(
  headerPanel("Teste AB Analyzer"),    
  sidebarPanel(
    h3('Digite o resultado esperado do seu experimento.'),
    numericInput('asin', 'Número de sucessos no Grupo A:', 0, min=0, max=9999),
    numericInput('afin', 'Número de falhas o Grupo A:', 0, min=0, max=9999),
    numericInput('bsin', 'Número de sucessos no Grupo B:', 0, min=0, max=9999),
    numericInput('bfin', 'Número de falhas o Grupo B:', 0, min=0, max=9999),
    submitButton('Analisar')
  ),
  mainPanel(
    h3('Analysis'),
    helpText('INSTRUÇÕES: Esta aplicação avalia os resultados de uma experiência que você já executou, de um grupo A e um grupo B que foram usados em um teste AB. Esta aplicação ajuda a informar se uma maneira de fazer as coisas (A) geralmente pode ser esperado para dar melhores resultados do que a outra maneira (B), em experiências futuras. Os resultados experimentais devem ser apenas resultados binários, tais como sucesso ou fracasso, 1 ou 0, sim ou não. Você deve fornecer quatro parâmetros: Primeiro é um número inteiro para o número de sucessos no grupo A. O segundo é um número inteiro para o número de falhas no grupo A. Terceiro é um número inteiro para o número de sucessos no grupo B. Quarto é um número inteiro para o número de falhas no grupo B. Esta função executa um teste de hipótese sobre os dados de resultados binários dos resultados experimentais de um grupo A e um grupo B. O teste de hipótese avalia se as médias dos dois grupos são iguais ou se é uma média mais alta do que a outra média, exceto pelo acaso. Os resultados experimentais utilizados com esta função precisam ser binários, ou seja, sucesso ou falha nos ensaios experimentais. Diferentes números de ensaios nos grupos A e B são perfeitamente aceitáveis. O sinal nos dados, se existir, tende a ser mais facilmente detectável e separável do ruído quando há um maior número de ensaios. O texto descritivo é a saída da função, tal como A é melhor do que B. '),
    h4('Você digitou'),
    textOutput('asout'),
    textOutput('afout'),
    textOutput('bsout'),
    textOutput('bfout'),
    h4('O que, quando cuidadosamente analisado, indica que'),
    verbatimTextOutput('amean'),
    verbatimTextOutput('bmean'),
    h4(verbatimTextOutput('abtext'))
  )
))
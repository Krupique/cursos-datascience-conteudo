# server.R

# ***** Esta é a versão 2.0 deste script, atualizado em 04/08/2017 *****
# ***** Esse script pode ser executado nas versões 3.3.1, 3.3.2, 3.3.3 e 3.4.0 da linguagem R *****
# ***** Recomendamos a utilização da versão 3.4.0 da linguagem R *****

bettertextA = 'A é melhor que B.' 
bettertextB = 'B é melhor que A.' 
neitherbettertext = 'Não posso dizer que um é melhor do que o outro. A diferença entre as médias dos dois grupos é indistinguível de ALEATORIEDADE.'

abtest.binary = function(a_s, a_f, b_s, b_f, conf.level=0.95, detail=FALSE) {       
  a_rate = a_s / (a_s + a_f)
  b_rate = b_s / (b_s + b_f)
  if (a_rate > b_rate) {
    x = c(a_s, b_s)
    n = c(a_s + a_f, b_s + b_f)
    bettertext = bettertextA
  } else {
    x = c(b_s, a_s)
    n = c(b_s + b_f, a_s + a_f)
    bettertext = bettertextB
  }        
  y = 0
  suppressWarnings(y <- prop.test(x=x, n=n, alternative='greater'))
  cutoffp = 1 - conf.level
  if (is.na(y$p.value)) {
    ret = neitherbettertext
  } else if (y$p.value <= cutoffp) {
    ret = bettertext
  } else {
    ret = neitherbettertext
  }
  if (detail) {
    ret = y
  }
  ret
}

shinyServer(
  function(input,output) {
    output$instructout <- renderPrint({'Instruções.'})
    output$asout <- renderPrint(input$asin)
    output$afout <- renderPrint(input$afin)
    output$bsout <- renderPrint(input$bsin)
    output$bfout <- renderPrint(input$bfin)
    output$abtext <- renderPrint({if (input$asin>0) abtest.binary(input$asin, input$afin, input$bsin, input$bfin)})
    output$amean <- renderPrint(paste('Taxa média de sucesso do Grupo A:', if (input$asin>0) round(input$asin/(input$asin + input$afin), 3)))
    output$bmean <- renderPrint(paste('Taxa média de sucesso do Grupo B:', if (input$asin>0) round(input$bsin/(input$bsin + input$bfin), 3)))
  }
)
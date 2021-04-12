

library(shiny)
#library(shinyjs)
library(aws.s3)
library(magrittr)

source("storage.R")

S3_path = "s3://piyushxx/piyushxx/airquality.csv"

#bucketlist(key = "mykey", secret = "mysecretkey")

options(shiny.maxRequestSize = 9 *1024^2)

shinyServer(function(input, output) {


  read_table1 <- reactive({
    
    if (input$S3 == T){

        #inFile <- input$data
        file1 <- file <- s3read_using(FUN = read.csv, object = S3_path)  
        file2 <- file1
        file1<- file1[1:input$obs,]
    
        
    }    
    })
  

  output$table1 <- renderTable({

    read_table1()

  })
  

 read_table <- eventReactive(input$view, {

    if(is.null(input$data))  {
       return(NULL)
    }
    inFile <- input$data

    file <- read.csv(inFile$datapath, header = input$header,
                     sep = input$sep, quote = input$quote)

    file<- file[1:input$obs,]

 })
  
 output$table <- renderTable({
    
    read_table()
    
  })

   output$downloadData <- downloadHandler(
      filename = function(){
      paste("Downloadfile","csv",sep=".")
      },
      
      content = function(file){
         write.csv(inputData(),file)
         
      }
   )
   
   # observeEvent(input$reset, {
   #   removeUI("#table")
   # })
 
#event Function
 plot1 <- eventReactive(input$Plot_Button,{
   
   if (input$S3 == T)
   {
     
     file1 <- file <- s3read_using(FUN = read.csv, object = S3_path)  
     file1<- file1[1:input$obs,]
     x<- file1[,1]
     y<- file1[,2]
     
     plot(x, y)
   }
   else 
   {
    
   if(is.null(input$data))  {
     return(NULL)
   }
   inFile <- input$data
   
   file <- read.csv(inFile$datapath, header = input$header,
                    sep = input$sep, quote = input$quote)
    
   
    
    file<- file[1:input$obs,]
    x<- file[,1]
    y<- file[,2]
    
    
    plot(x, y)
   }
    
 })
 
 output$plot <- renderPlot({
   
    plot1()
})
 
 # observeEvent(input$reset, {
 #   removeUI("#plot")
 # })

 LRplot <- eventReactive(input$linerregression, {
    
   if (input$S3 == T)
   {
     
     file1 <- file <- s3read_using(FUN = read.csv, object = S3_path)  
     file1<- file1[1:input$obs,]
     x<- file1[,1]
     y<- file1[,2]
     par(mfrow=c(2,2))
     plot(lm(x~y)) 
     points(x, y, pch = 16, cex = 0.8, col = "red")
     
   }
   else {
   inFile <- input$data
    
    
    if(is.null(input$data))     
       return(NULL) 
    file <- read.csv(inFile$datapath, header = input$header,
                     sep = input$sep, quote = input$quote)
    
    file<- file[1:input$obs,]
    x<- file[,1]
    y<- file[,2]
    
    par(mfrow=c(2,2))
    plot(lm(x~y)) 
    points(x, y, pch = 16, cex = 0.8, col = "red")
   }
 })
 output$LinearPlot <- renderPlot({
   
    LRplot()
 })
 
 #event Function
 
 summary1 <- eventReactive(input$summary ,{
    
   if(input$S3 ==T){
     
     file1 <- file <- s3read_using(FUN = read.csv, object = S3_path)  
     file1<- file1[1:input$obs,]
     summary(file1)
     
   }
   else{
   inFile <- input$data
    
    
    if(is.null(input$data))     
       return()
    
    
    file <- read.csv(inFile$datapath, header = input$header,
                     sep = input$sep, quote = input$quote)
    
    file<- file[1:input$obs,]
    
    
    summary(file)
   } 
 })
 
 output$summary <-renderPrint({
    summary1()
   
 })
 
 #event Function
 
 LRsummary <- eventReactive(input$modelsum ,{
    
   if (input$S3 == T)
     {
     
     file1 <- file <- s3read_using(FUN = read.csv, object = S3_path)  
     file1<- file1[1:input$obs,]
     x<- file1[,1]
     y<- file1[,2]
     summary(lm(x~y))
   } 
   
   else
     { 
       inFile <- input$data
    
    
    if(is.null(input$data))     
       return()
    
    file <- read.csv(inFile$datapath, header = input$header,
                     sep = input$sep, quote = input$quote)
    
    file<- file[1:input$obs,]
    x<- file[,1]
    y<- file[,2]
    
    
    summary(lm(x~y))
 }
    
 })
 
 output$Linearsummary <-renderPrint({
    LRsummary()
 })
 

 
})
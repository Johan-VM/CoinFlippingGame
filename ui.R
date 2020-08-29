library(shiny)
library(ggplot2)
library(shinyWidgets)
library(plotly)

shinyUI(fluidPage(
    setBackgroundColor(color = c("#f2ac6b", "#ff3d3d", "#f2ac6b"), gradient = "linear", direction = "bottom"),
    
    tags$style(HTML('body {font-family: Trebuchet MS,Lucida Grande,Lucida Sans Unicode,Lucida Sans,Tahoma,sans-serif}')),
    
    titlePanel(
        h2(strong("Coin Flipping Game"), align = "center", style = "color:#0f0947")
    ),
    
    sidebarLayout(
        sidebarPanel(
            numericInput(inputId = "p", label = h4(HTML("Enter the true <b>probability</b> of getting <b>Heads</b>:")), 
                value = 0.5, min = 0, max = 1),
            
            actionButton("flip", label = strong("Flip the coin!"), style = "color:#117985"),
            
            radioButtons("betting", label = h4(HTML("Choose the <b>type</b> of betting:")),
                choices = list("Fair game" = 1, "Manually input bets" = 2), selected = 1),
            
            sliderInput(inputId = "headsBet", label = h4(HTML("Select your <b>bet</b> on <b>Heads</b> [$]:")), 
                value = 5, min = 0, max = 10, step = 0.5),
            
            conditionalPanel(condition = "input.betting == 2", 
                sliderInput(inputId = "tailsBet", label = h4(HTML("Select your opponent's <b>bet</b> on <b>Tails</b> [$]:")), 
                    value = 5, min = 0, max = 10, step = 0.5))
        ),
        
        mainPanel(
            h3(strong(textOutput("result")), style = "color:#0f0947"),
            
            h3(strong(htmlOutput("totalEarned"))),
            
            plotOutput("drawPlot"),
            
            plotOutput("totalsPlot")
        )
    )    
))

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
                sliderInput(inputId = "tailsBet", value = 5, min = 0, max = 10, step = 0.5,
                    label = h4(HTML("Select your opponent's <b>bet</b> on <b>Tails</b> [$]:"))))
        ),
        
        mainPanel(
            tabsetPanel(id = "Tabs",
                tabPanel(
                    title = strong("Results", style = "color:#117985"),
                    
                    h3(strong(textOutput("result")), style = "color:#0e1236"),
                    
                    h3(strong(htmlOutput("totalEarned"))),
                    
                    plotOutput("drawPlot"),
                    
                    plotOutput("totalsPlot")
                ),
                
                tabPanel(
                    title = strong("About", style = "color:black"),
                    
                    h4(strong("This app simulates a coin flipping betting game. You bet on heads and your opponent bets 
                    on tails. You can modify the coin's true probability of getting heads, the amount of money you bet, 
                    and whether the game is fair or potentially unfair."), style = "color:black"),
                    
                    h4(strong("Keep in mind that entering an extreme probability (i.e., 0 for always tails and 1 for 
                    always heads) will make the game always unfair, so there is no point in betting for those two cases."), 
                        style = "color:black"),
                    
                    h4(strong(HTML("Developed by Johan V&aacute;squez Mazo. Powered by RStudio Shiny.")), 
                        style = "color:#0f0947"))
            )
        )
    )
))

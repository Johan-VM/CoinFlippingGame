library(shiny)
library(ggplot2)
library(shinyWidgets)
library(plotly)

shinyServer(function(input, output) {
    
    p <- reactive({input$p})
    q <- reactive({1-p()})
    
    HeadsBet <- reactive({input$headsBet})
    TailsBet <- reactive({
        if (input$betting == 1) {
            (q()/p())*HeadsBet()
        } else {
            input$tailsBet
        }
    })
    
    value <- reactiveValues(iteration = NULL, draw = NULL, int = NULL)
    observeEvent(input$flip, {
        value$iteration[input$flip] <- input$flip
        value$draw[input$flip] <- sample(c("Heads", "Tails"), size = 1, replace = TRUE, prob = c(p(), q()))
        value$int <- as.integer(factor(value$draw, levels = c("Tails", "Heads"))) - 1
    })
    
    earnings <- reactiveValues(heads = NULL, tails = NULL)
    observeEvent(input$flip, {
        earnings$heads[input$flip] <- TailsBet()*value$int[input$flip] - HeadsBet()*(1-value$int[input$flip])
        earnings$tails[input$flip] <- -earnings$heads[input$flip]
    })
    
    totalEarnings <- reactiveValues(heads = NULL, tails = NULL)
    observeEvent(input$flip, {
        totalEarnings$heads[1] <- 0
        totalEarnings$tails[1] <- 0
        totalEarnings$heads[input$flip + 1] <- totalEarnings$heads[input$flip] + earnings$heads[input$flip]
        totalEarnings$tails[input$flip + 1] <- totalEarnings$tails[input$flip] + earnings$tails[input$flip]
    })
    
    output$result <- renderText({
        if (!is.null(value$iteration)) {
            draw <- paste0("The coin landed on ", value$draw[length(value$iteration)], ".")
            if (earnings$heads[length(value$iteration)] > 0) {
                earning <- paste0("You win $ ", earnings$heads[length(value$iteration)], ".")
            } else {
                earning <- paste0("You lose $ ", -earnings$heads[length(value$iteration)], ".")
            }
            paste0(draw, " ", earning)
        }
    })
    
    output$totalEarned <- renderText({
        if (!is.null(value$iteration)) {
            if (totalEarnings$heads[input$flip + 1] > 0) {
                string <- paste0("You've won $ ", totalEarnings$heads[input$flip + 1], " in total.")
                paste("<span style=\"color:green\">", string, "</span>", sep = "")
            } else if (totalEarnings$heads[input$flip + 1] < 0) {
                string <- paste0("You've lost $ ", totalEarnings$heads[input$flip + 1], " in total.")
                paste("<span style=\"color:red\">", string, "</span>", sep = "")
            } else {
                paste0("You haven't won nor lost money.")
            }
        }
    })
    
    output$drawPlot <- renderPlot({
        if (!is.null(value$iteration)) {
            value_data <- data.frame(iteration = value$iteration, draw = value$draw)
            ggplot(value_data, aes(x = iteration, y = draw)) + geom_point(size = 3, color = "darkslategrey") + 
                theme_bw() + labs(x = "Iteration", y = "Coin flip result") + 
                theme(plot.background = element_rect(fill = "#ffd5b0")) + 
                theme(panel.background = element_rect(fill = "snow", color = "#0f0947", size = 2, linetype = "solid"), 
                    panel.grid.major = element_line(size = 0.5, linetype = 'solid', colour = "snow3"), 
                    panel.grid.minor = element_line(size = 0.5, linetype = 'solid', colour = "snow2")) + 
                theme(axis.text.x = element_text(color = "black", size = 11), 
                      axis.text.y = element_text(color = "black", size = 11),
                    axis.title.x = element_text(size = 12), axis.title.y = element_text(size = 12))
        }
    })
    
    output$totalsPlot <- renderPlot({
        if (!is.null(value$iteration)) {
            totals_data <- data.frame(iteration = value$iteration, heads = totalEarnings$heads[-1])
            totals_data$colors <- factor(sign(totals_data$heads), levels = c(-1, 0, 1))
            ggplot(totals_data, aes(x = iteration, y = heads, color = colors)) + geom_point(size = 3) + 
                theme_bw() + labs(x = "Iteration", y = "Your total earnings [$]") + 
                scale_color_manual(values = c("orangered", "midnightblue", "forestgreen")) + 
                theme(legend.position = "none") + 
                theme(plot.background = element_rect(fill = "#ffd5b0")) + 
                theme(panel.background = element_rect(fill = "snow", color = "#0f0947", size = 2, linetype = "solid"), 
                    panel.grid.major = element_line(size = 0.5, linetype = 'solid', colour = "snow3"), 
                    panel.grid.minor = element_line(size = 0.5, linetype = 'solid', colour = "snow2")) + 
                theme(axis.text.x = element_text(color = "black", size = 11), 
                      axis.text.y = element_text(color = "black", size = 11),
                    axis.title.x = element_text(size = 12), axis.title.y = element_text(size = 12))
        }
    })
})

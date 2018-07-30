#
# This is the user-interface definition of a Shiny web application showing the 
# total population by country. 
# This application let you choose a country and show actual and predicted 
# population mode and for a selected year. 
# You can run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

source("loaddata.R")

# Define UI for application that draws line chart showing actual and predicted 
# world population by coutry, 
shinyUI(fluidPage(
        # Application title
        titlePanel("Predict world population by country or group of countries"),
        # Sidebar with a slider input for number of bins 
        sidebarLayout(
                sidebarPanel(
                        # select input for country
                        selectInput("countryinput","Select the country", choices = sort(unique(populationdataset$countryname)),
                                    selected = "United Kingdom"),
                        # slider input for year
                        sliderInput("slideryear", "Select the year", 1960, 2040, value = 2010),
                        # checkbox for year showing/hiding the projected line
                        checkboxInput("showModel", "Show/Hide Predictive Model", value = TRUE),
                        # link to display the help page 
                        tags$a(href="help.html", "Click here for help about this Shiny App")
                        #tags$a(href="https://sukhenc.shinyapps.io/populationpredictor/help.html", "Click here for help about this Shiny App")
                        
                ),
                # Show a plot of the generated distribution
                mainPanel(
                        # heading for country profile 
                        h3("Contry Profile"),
                        # country profile table
                        fluidRow(
                                column(12,
                                       tableOutput('countrytable')
                                )
                        ),
                        # heading for plot
                        h3("Plot to show/predict total population in Millions"),
                        # display the plot 
                        plotOutput("plot1"),
                        # heading for Population Prediction
                        h3("Population Prediction"),
                        # population projection table
                        fluidRow(
                                column(6,
                                       tableOutput('projectedtable')
                                )
                        ),
                        tags$a(href="help.html", "Click here for help about this Shiny App")
                        
                )
        )
))
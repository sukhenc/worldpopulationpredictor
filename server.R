#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
source("loaddata.R")

# Define server logic required to draw the predictive model
shinyServer(function(input, output) {
        # reactive function to display the country profile table
        countrytablefun <- reactive({
                # collect the seleted input fields
                year1 <- input$slideryear
                country1 <- input$countryinput
                # get the data for the selected country and year 
                profile <- subset(populationdataset, countryname == country1 & year == year1)
                # population is NA for future years and set projected population 
                if(dim(profile)[1]==0){
                        profile <- subset(populationdataset,countryname == country1)[1,]
                        profile$year <- year1
                        profile$population <- NA
                }
                profile      
                
        })
        
        # reactive function to display the plot / chart
        plotfun <- reactive({
                # collect the seleted input fields
                year1 <- input$slideryear
                country1 <- input$countryinput
                # dataset for the selected country 
                datasubset <- subset(populationdataset, countryname == country1)
                # linear predictive model 
                predmodel <- lm(population ~ year, data = datasubset)
                # calculate the limits for x and y axis 
                minpopulation = min(datasubset$population)
                meanopulation = mean(datasubset$population)
                maxpopulation = max(datasubset$population) * 1.2
                # plot the population ~ year
                plot(x = datasubset$year, y = datasubset$population, xlab = "Year", 
                     ylab = "Total population in Millions", bty = "n", pch = 16,
                     xlim = c(1960, 2040), ylim = c(minpopulation, maxpopulation))
                # show the linear model if checkbox is checked 
                if(input$showModel){
                        abline(predmodel, col = "blue", lwd = 2)
                }
                # display the legent for actual and projected population 
                legend(2010, meanopulation, c("Projected population","Actual population"), pch = 16, 
                       col = c("red","black"), bty = "n", cex = 1.4)
                # draw a red dot to display the projected population 
                points(year1, predpopulationfun(), col = "red", pch = 16, cex = 2)
                
        })
        
        # reactive function to display the population projection table
        projectedtablefun <- reactive({
                # collect the seleted input fields
                year1 <- input$slideryear
                country1 <- input$countryinput
                # dataset for the selected country 
                profile <- subset(populationdataset, countryname == country1 & year == year1)
                # population is NA for future years and set projected population 
                if(dim(profile)[1]==0){
                        profile <- subset(populationdataset,countryname == country1)[1,]
                        profile$year <- year1
                        profile$population <- NA
                }
                profile$projectedpopulation <- predpopulationfun()
                select(profile, "countryname","year","population","projectedpopulation")     
                
        })
        
        # reactive function to calulate the population projection for a given year
        predpopulationfun <- reactive({
                # dataset for selected country
                country1 <- input$countryinput
                datasubset <- subset(populationdataset, countryname == country1)
                # linear model 
                predmodel <- lm(population ~ year, data = datasubset)
                # get predicted/projected population
                year1 <- input$slideryear
                predict(predmodel, newdata = data.frame(year = year1))
        })
        
        #function to render the country table
        output$countrytable <- renderTable({
                countrytablefun()
        })
        
        #function to render the plot
        output$plot1 <- renderPlot({
                plotfun()
        })
        
        #function to render the population projection table
        output$projectedtable <- renderTable({
                projectedtablefun()
        })
        
})

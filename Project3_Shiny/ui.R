library(ggplot2)
library(shinydashboard)
library(DT)
library(factoextra)
library(plotly)

# sidebar design
sidebar <- dashboardSidebar(
    sidebarMenu(
        menuItem("About", tabName = "about", icon = icon("futbol")),
        menuItem("Data", tabName = "data", icon = icon("table")),
        menuItem("Data Exploration", tabName = "explore", icon = icon("chart-bar")),
#        menuItem("PCA", tabName = "PCA", icon = icon("chart-pie")),
        menuItem("Modeling", tabName = "model", icon = icon("chart-line"))
    )
)

#_____________________________________________________________________________________

# body design  
body <- dashboardBody(
    tabItems(
        # start "about" tab
        tabItem(tabName = "about",
                tabsetPanel(
                    tabPanel("Purpose"),
                    tabPanel("Data")
                )
        ), # end "about" tab
        
        #_____________________________________________________________________________________
        
        # start "data" table tab
        tabItem(tabName = "data",
                fluidRow(
                    column(3,
                           box(width = 12#,
                        #       selectInput("temporary", 
                        #                   label = "temporary",
                        #                   choices = list()),
                        #       sliderInput(),
                        #       checkboxGroupInput()
                            )
                    ),
                    column(9,
                           downloadButton(),
                           br(),
                           br(),
                           DTOutput()
                    )
                )
        ), # end "data" table tab
        
        #_____________________________________________________________________________________
        
        # start "explore" tab
        tabItem(tabName = "explore",
                fluidRow(
                    column(3,
                           box(width = 12,
                               title = "temporary",
                               selectInput(),
                               sliderInput(),
                               selectInput(),
                               checkboxInput(),
                               conditionalPanel()
                           ),
                           box(width = 12,
                               title = "temporary",
                               selectInput(),
                               conditionalPanel(),
                               selectInput(),
                               sliderInput(),
                               sliderInput()
                           )
                    ),
                    column(9,
                           box(width = 12,
                               plotOutput(),
                           downloadButton(),
                           downloadButton()
                           )
                    ),
                    column(4,
                           h4(),
                           verbatimTextOutput()
                    ),
                    column(4,
                           conditionalPanel(
                               condition = "temporary",
                               h4(),
                               verbatimTextOutput()
                           )
                    ),
                    column(4,
                           conditionalPanel(
                               condition = "temporary",
                               h4(),
                               verbatimTextOutput()
                           )
                    ),
                    column(5,
                           h4(),
                           verbatimTextOutput()
                    )
                )
            
        ), # end explore tab
        
        #_____________________________________________________________________________________
        
        # start "model" tab
        tabItem(tabName = "model",
                tabsetPanel(
                    tabPanel("Modeling Info"
                        
                    ), # end tabPanel "modeling info"
                    tabPanel("Model Fitting"
                        
                    ), # end tabPanel "model fitting"
                    tabPanel("Prediction"
                        
                    ) # end tabPanel "prediction"
                        
                ) # end tabsetPanel
            
        ) # end "model" tab
        
    ) # end tabItems
) # end dashboardBody

#_____________________________________________________________________________________

# App arguments
dashboardPage(
    dashboardHeader(title = "temporary title"),
    sidebar,
    body
)
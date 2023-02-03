library(gridExtra)
library(scales)
library(shiny)
library(shinythemes)
library(shinyjs)

df_key_date <- read.csv("www/DATA/KEY_DATE.csv", 
                        header = T, stringsAsFactors = F, check.names = F)
var_gap <- max(as.numeric(as.Date(df_key_date$DATE[nrow(df_key_date)], 
                   format = "%m/%d/%Y") - Sys.Date()), 0)

ui <- shiny::navbarPage(
  # App Logo
  title = div(
    img(
      src = "RESOURCE/logo.png", 
      style = "margin-top:-1px; padding-right:10px; 
      padding-bottom:10px", height = 40
    )
  ), 
  windowTitle = "Draft Craft", 
  theme = shinytheme("cosmo"), 
  # Countdown module
  absolutePanel(
    top = 0, right = 15, style = "z-index:9999; text-align: right;", 
    p(
      span(strong(var_gap), style = "color:#F9CC0B;font-size:220%"), 
      HTML('&nbsp;'), 
      span("Days to go before the ", 
           style = "color:white;font-size:150%;font-family:Verdana"), 
      span(df_key_date$YEAR[nrow(df_key_date)], 
           style = "color:white;font-size:150%;font-family:Verdana"), 
      HTML('&nbsp;'), 
      span("NBA draft", 
           style = "color:white;font-size:150%;font-family:Verdana")
    )
  ), 
  tabPanel(
    strong("Draft Class")
  ), 
  tabPanel(
    strong("Team Performance")
  ), 
  tabPanel(
    strong("About")
  ), 
  hr(style = "border-color: #cbcbcb;"), 
  fluidRow(
    column(
      11, 
      p("Data used to generate this app are from nbastatR, obtain details from ", 
        tags$a(href = "https://rdrr.io/github/abresler/nbastatR/f/README.md", 
               'HERE', target = '_blank'), style = "font-size:85%;text-align:center"), 
      p("App created by ", 
        tags$a(href = "https://detyang.com", 'Det Yang', target = '_blank'), 
        img(src = "RESOURCE/personal_logo.png", height = 64), 
        "Find me on ", tags$a(href = "https://github.com/detyang", "Github", target = '_blank'), 
        style = "font-size:85%;text-align:center"), 
      p("Have a question? Spot an error? Send an ",
        tags$a(href = "mailto:detyang22@gmail.com", "Email", target = '_blank'), 
        style = "font-size:85%;text-align:center")
    )
  )
)
library(DT)
library(gridExtra)
library(plotly)
library(scales)
library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(shinyjs)
library(shinythemes)
library(shinyWidgets)


df_key_date <- read.csv("www/DATA/KEY_DATE.csv", 
                        header = T, stringsAsFactors = F, check.names = F)
df_player <- read.csv("www/DATA/PLAYER_META.csv",
                      header = T, stringsAsFactors = F, check.names = F)
var_gap <- max(as.numeric(as.Date(df_key_date$DATE[nrow(df_key_date)], 
                   format = "%m/%d/%Y") - Sys.Date()), 0)

ui <- navbarPage(
  theme = shinytheme("cosmo"), 
  # App Logo & Title
  title = div(
    img(
      src = "RESOURCE/logo.png", 
      style = "margin-top:-1px; padding-right:10px; 
      padding-bottom:10px", height = 40
    )
  ), 
  windowTitle = "Draft Craft", 
  # Draft Class tab
  tabPanel(
    strong("Draft Archive"), 
    fluidRow(
      column(
        9, 
        box(
          style = "background-color:#fff; border-color:#2c3e50; height:77vh", width = 12, 
          DT::dataTableOutput("tbl_drf")
        )
      ), 
      column(
        3, 
        box(
          style = "background-color:#fff; border-color:#2c3e50; height:77vh", width = 12, 
          radioGroupButtons(
            inputId = "gbtn_drf", label = NULL, 
            choices = c("Standard Mode", "Advanced Mode"), selected = "Standard Mode", 
            justified = TRUE, size = "lg", 
            checkIcon = list(
              yes = icon("square-check"),
              no = icon("square")
            )
          ), 
          hr(), 
          conditionalPanel(
            "input.gbtn_drf === 'Standard Mode'", 
            pickerInput(
              inputId = "year_drf", label = h4(strong("Select draft year")), 
              width = "100%", options = list(size = 5), 
              choices = c("All", unique(df_player$yearDraft)), selected = "All"
            ), 
            pickerInput(
              inputId = "round_drf", label = h4(strong("Select draft round")), 
              width = "100%", 
              choices = c("All", "First Round", "Second Round"), selected = "All"
            ), 
            pickerInput(
              inputId = "pick_drf", label = h4(strong("Select draft pick")), 
              width = "100%", options = list(size = 5), 
              choices = c("All", 1 : 30), selected = "All"
            ), 
            pickerInput(
              inputId = "team_drf", label = h4(strong("Select team")), 
              width = "100%", options = list(size = 5), 
              choices = c("All", sort(unique(df_player$nameTeam))), selected = "All"
            )
          )
        )
      )
    )
  ), 
  tabPanel(
    strong("Team Performance")
  ), 
  tabPanel(
    strong("About")
  ), 
  # Countdown module
  absolutePanel(
    top = 0, right = 35, style = "z-index:9999; text-align: right;", 
    p(
      span(strong(em(var_gap)), style = "color:#F9CC0B;font-size:220%"), 
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
  hr(style = "border-color: #cbcbcb;"), 
  fluidRow(
    column(
      11, 
      p("Data used in this app are from nbastatR, obtain more details from ", 
        tags$a(href = "https://rdrr.io/github/abresler/nbastatR/f/README.md", 
               'HERE', target = '_blank'), style = "font-size:85%;text-align:center"), 
      p("Created by ", 
        tags$a(href = "https://detyang.com", 'Det Yang', target = '_blank'), 
        tags$a(href = "https://detyang.com", 
               img(src = "RESOURCE/personal_logo.png", height = 42), target = "_blank"), 
        "Find me on", 
        tags$a(href = "https://github.com/detyang", "Github", target = "_blank"), 
        style = "font-size:85%;text-align:center"), 
      p("Have a question? Spot an error? Send an ",
        tags$a(href = "mailto:detyang22@gmail.com", "Email", target = '_blank'), 
        style = "font-size:85%;text-align:center")
    )
  )
)

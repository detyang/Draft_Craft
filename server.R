####SERVER.R module----

###Load packages----
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


### Functions----
## Preprocess player data table
fun_prep_drf <- function(df){
  df <- df[, c(1, 3, 4, 5, 6, 14, 15)]
  df <- df[, c(7, 1 : 6)]
  colnames(df) <- c("Headshot", "Year", "Round", "Pick", "Name", "From", "Team_abb")
  df <- df %>%
    mutate(
      Headshot = paste0("<img src=\"", Headshot, "\" width=\"60\"</img>")
    ) %>%
    mutate(
      Team = paste0("<img src=\"RESOURCE/teams_logo/", Team_abb, ".png\" width=\"45\"</img>")
    )
  return(df)
}
## Get data by selected attributes
fun_get_data_drf <- function(df, var_year, var_round, var_pick, var_team){
  var_year <- ifelse(var_year == "All", 0, var_year)
  var_round <- ifelse(var_round == "All", 0,
                      ifelse(var_round == "First Round", 1, 2))
  var_pick <- ifelse(var_pick == "All", 0, var_pick)
  var_team <- ifelse(var_team == "All", 0, 
                     df_team$slugTeam[which(df_team$nameTeam == var_team)])
  if(var_year != 0){
    df <- df[which(df$Year == var_year), ]
  }
  if(var_round != 0){
    df <- df[which(df$Round == var_round), ]
  }
  if(var_pick != 0){
    df <- df[which(df$Pick == var_pick), ]
  }
  if(var_team != 0){
    df <- df[which(df$Team_abb == var_team), ]
  }
  df <- df[, -7]
  return(df)
}

### Load data----
## Read players and teams dataset and run preprocess for player dataset
df_player <- read.csv("www/DATA/PLAYER_META.csv", 
                      header = T, stringsAsFactors = F, check.names = F)
df_team <- read.csv("www/DATA/TEAMS_META.csv", 
                    header = T, stringsAsFactors = F, check.names = F)
df_player_drf <- fun_prep_drf(df_player)


### server module
server <- function(input, output, session){
  ## Reactive draft data table based on user selection
  df_drf <- reactive({
    fun_get_data_drf(df_player_drf, input$year_drf, input$round_drf, 
                     input$pick_drf, input$team_drf)
  })
  
  ## Render table content in draft tab
  output$tbl_drf <- DT::renderDataTable(
    df_drf(), 
    options = list(
      initComplete = JS(
        "function(settings, json) {",
        "$(this.api().table().header()).css({'background-color': '#000', 'color': '#fff'});", "}"
      ), 
      scrollX = TRUE, pageLength = 30, 
      lengthMenu = c(15, 30, 60), 
      columnDefs = list(list(targets = '_all', className = 'dt-center'))
    ), 
    escape = FALSE, rownames = FALSE
  )
}

## includes code adapted from the following sources:
# https://github.com/

setwd("/Users/abigailhorn/Documents/GitHub/PM566/static/slides/11-interactive-viz")

# update data with automated script
source("ny_data_us.R") # run locally to update numbers, but not live on Rstudio server (to avoid possible errors on auto-updates)

# load required packages
if(!require(magrittr)) install.packages("magrittr", repos = "http://cran.us.r-project.org")
if(!require(rvest)) install.packages("rvest", repos = "http://cran.us.r-project.org")
if(!require(readxl)) install.packages("readxl", repos = "http://cran.us.r-project.org")
if(!require(dplyr)) install.packages("dplyr", repos = "http://cran.us.r-project.org")
if(!require(maps)) install.packages("maps", repos = "http://cran.us.r-project.org")
if(!require(ggplot2)) install.packages("ggplot2", repos = "http://cran.us.r-project.org")
if(!require(reshape2)) install.packages("reshape2", repos = "http://cran.us.r-project.org")
if(!require(ggiraph)) install.packages("ggiraph", repos = "http://cran.us.r-project.org")
if(!require(RColorBrewer)) install.packages("RColorBrewer", repos = "http://cran.us.r-project.org")
if(!require(leaflet)) install.packages("leaflet", repos = "http://cran.us.r-project.org")
if(!require(plotly)) install.packages("plotly", repos = "http://cran.us.r-project.org")
if(!require(geojsonio)) install.packages("geojsonio", repos = "http://cran.us.r-project.org")

# set mapping colour for each outbreak
covid_col = "#cc4c02"
covid_other_col = "#662506"

# import data
cv_states = read.csv("input_data/coronavirus_states.csv")

# add to datasets
cv_states$date = as.Date(cv_states$date, format="%Y-%m-%d")
cv_states = cv_states %>% mutate(naive_CFR = round((deaths*100/cases),2))
cv_states_today = subset(cv_states, date==max(cv_states$date)) %>% mutate(naive_CFR = round((deaths*100 / cases),2)) 
current_date = as.Date(max(cv_states$date),"%Y-%m-%d")


#######################################################################################################################################
#######################################################################################################################################




# assign colours to countries to ensure consistency between plots
# cls = rep(c(brewer.pal(8,"Dark2"), brewer.pal(10, "Paired"), brewer.pal(12, "Set3"), brewer.pal(8,"Set2"), brewer.pal(9, "Set1"), brewer.pal(8, "Accent"),  brewer.pal(9, "Pastel1"),  brewer.pal(8, "Pastel2")),4)
# cls_names = c(as.character(unique(cv_cases$country)), as.character(unique(cv_cases_continent$continent)), as.character(unique(cv_states$state)),"Global")
# country_cols = cls[1:length(cls_names)]
# names(country_cols) = cls_names


cv_states %>%
  filter(state=="California") %>% 
  plot_ly() %>% 
  add_histogram(x = ~new_cases)

### MAP FUNCTIONS ###
# function to plot cumulative COVID cases by date
cumulative_plot = function(cv_aggregated, plot_date) {
  plot_df = subset(cv_aggregated, date<=plot_date)
  g1 = ggplot(plot_df, aes(x = date, y = cases, color = state)) + geom_line() + geom_point(size = 1, alpha = 0.8) +
    ylab("cumulative cases") + theme_bw() +
    #scale_colour_manual(values=c(covid_col)) +
    scale_y_continuous(labels = function(l) {trans = l / 1000; paste0(trans, "K")}) +
    theme(legend.title = element_blank(), legend.position = "", plot.title = element_text(size=10),
          plot.margin = margin(5, 12, 5, 5))
  g1
}

plot.cum <- cumulative_plot(cv_states,plot_date = "2020-10-20")
ggplotly(plot.cum)

# function to plot new COVID cases by date
new_cases_plot = function(cv_aggregated, plot_date) {
  plot_df_new = subset(cv_aggregated, date<=plot_date)
  g1 = ggplot(plot_df_new, aes(x = date, y = new_cases, fill = state)) +
    geom_bar(position="stack", stat="identity") +
    ylab("new cases") + theme_bw() +
    #scale_fill_manual(values=c(covid_col)) +
    scale_y_continuous(labels = function(l) {trans = l / 1000; paste0(trans, "K")}) +
    theme(legend.title = element_blank(), legend.position = "", plot.title = element_text(size=10),
          plot.margin = margin(5, 12, 5, 5))
  g1
}

plot.new <- new_cases_plot(cv_states,plot_date = "2020-10-20")
ggplotly(plot.new)


#
# function to plot new cases by state
states_cases_plot = function(cv_states, start_point=c("Date", "Day of 100th confirmed case", "Day of 10th death"), plot_start_date) {
  #new_outcome = new_cases
  if (start_point=="Date") {
    g = ggplot(cv_states, aes(x = date, y = new_cases, fill = state, group = 1,
                              text = paste0(format(date, "%d %B %Y"), "\n", state, ": ",new_cases))) +
      xlim(c(plot_start_date,(current_date+1))) + xlab("Date")
  }
  
  if (start_point=="Day of 100th confirmed case") {
    cv_states = subset(cv_states, days_since_case100>0)
    g = ggplot(cv_states, aes(x = days_since_case100, y = new_cases, fill = state, group = 1,
                              text = paste0("Day ",days_since_case100, "\n", state, ": ",new_cases)))+
      xlab("Days since 100th confirmed case")
  }
  
  if (start_point=="Day of 10th death") {
    cv_states = subset(cv_states, days_since_death10>0)
    g = ggplot(cv_states, aes(x = days_since_death10, y = new_cases, fill = state, group = 1,
                              text = paste0("Day ",days_since_death10, "\n", state, ": ",new_cases))) +
      xlab("Days since 10th death")
  }
  
  g1 = g +
    geom_bar(position="stack", stat="identity") +
    ylab("new") + theme_bw() +
    #scale_fill_manual(values=country_cols) +
    theme(legend.title = element_blank(), legend.position = "", plot.title = element_text(size=10))
  ggplotly(g1, tooltip = c("text")) %>% layout(legend = list(font = list(size=11)))
}

start_point="Date"
plot_start_date=as.Date("2020-04-01")
plot.states <- states_cases_plot(cv_states, start_point=start_point, plot_start_date)


#####################
#####################

# function to plot cumulative cases by state
states_cases_cumulative = function(cv_cases, start_point=c("Date", "Day of 100th confirmed case", "Day of 10th death"), plot_start_date) {
  if (start_point=="Date") {
    g = ggplot(cv_cases, aes(x = date, y = cases, colour = state, group = 1,
                             text = paste0(format(date, "%d %B %Y"), "\n", state, ": ",cases))) +
      xlim(c(plot_start_date,(current_date+1))) + xlab("Date")
  }
  
  if (start_point=="Day of 100th confirmed case") {
    cv_cases = subset(cv_cases, days_since_case100>0)
    g = ggplot(cv_cases, aes(x = days_since_case100, y = cases, colour = state, group = 1,
                             text = paste0("Day ", days_since_case100,"\n", state, ": ",cases))) +
      xlab("Days since 100th confirmed case")
  }
  
  if (start_point=="Day of 10th death") {
    cv_cases = subset(cv_cases, days_since_death10>0)
    g = ggplot(cv_cases, aes(x = days_since_death10, y = cases, colour = state, group = 1,
                             text = paste0("Day ", days_since_death10,"\n", state, ": ",cases))) +
      xlab("Days since 10th death")
  }
  
  g1 = g + geom_line(alpha=0.8) + geom_point(size = 1, alpha = 0.8) +
    ylab("cumulative") + theme_bw() +
    #scale_colour_manual(values=country_cols) +
    theme(legend.title = element_blank(), legend.position = "", plot.title = element_text(size=10))
  ggplotly(g1, tooltip = c("text")) %>% layout(legend = list(font = list(size=11)))
}

start_point="Date"
plot_start_date=as.Date("2020-04-01")
plot.cum.states <- states_cases_cumulative(cv_states, start_point=start_point, plot_start_date)



# function to plot cumulative cases by state on log10 scale
country_cases_cumulative_log = function(cv_cases, start_point=c("Date", "Day of 100th confirmed case", "Day of 10th death"), plot_start_date)  {
  if (start_point=="Date") {
    g = ggplot(cv_cases, aes(x = date, y = cases, colour = state, group = 1,
                             text = paste0(format(date, "%d %B %Y"), "\n", state, ": ",cases))) +
      xlim(c(plot_start_date,(current_date+1))) + xlab("Date")
  }
  
  if (start_point=="Day of 100th confirmed case") {
    cv_cases = subset(cv_cases, days_since_case100>0)
    g = ggplot(cv_cases, aes(x = days_since_case100, y = cases, colour = state, group = 1,
                             text = paste0("Day ",days_since_case100, "\n", state, ": ",cases))) +
      xlab("Days since 100th confirmed case")
  }
  
  if (start_point=="Day of 10th death") {
    cv_cases = subset(cv_cases, days_since_death10>0)
    g = ggplot(cv_cases, aes(x = days_since_death10, y = cases, colour = state, group = 1,
                             text = paste0("Day ",days_since_death10, "\n", state, ": ",cases))) +
      xlab("Days since 10th death")
  }
  
  g1 = g + geom_line(alpha=0.8) + geom_point(size = 1, alpha = 0.8) +
    ylab("cumulative (log10)") + theme_bw() +
    scale_y_continuous(trans="log10") +
    #scale_colour_manual(values=country_cols) +
    theme(legend.title = element_blank(), legend.position = "", plot.title = element_text(size=10))
  ggplotly(g1, tooltip = c("text")) %>% layout(legend = list(font = list(size=11)))
}

country_cases_cumulative_log
start_point="Date"
plot_start_date=as.Date("2020-04-01")
plot.cum.states <- country_cases_cumulative_log(cv_states, start_point=start_point, plot_start_date)
plot.cum.states

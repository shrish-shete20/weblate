# Required libraries
library(httr)
library(jsonlite)
library(rvest)
library(readr)
library(tidyverse)
library(data.table)
library(dplyr)
Language_Statistics <- read_csv("/home/runner/work/weblate/weblate/Language Statisitics/Language_Statistics_new.csv")
# Weblate API configuration
api_token <- "wlu_s7fqhH2f9VgCCvIU2FQFlFMIZ27IH9GJwCg0"
api_url <- "https://translate.rx.studio/api/"

# API request: Fetch all languages
endpoint <- paste0(api_url, "users/")
headers <- add_headers(Authorization = paste("Token"," ",api_token))
response <- GET(url = endpoint, headers = headers, authenticate("shrishs21","kvell@2003"))
users <- content(response, "text", encoding = "UTF-8")
users <- fromJSON(users)
count<-users$count
name<-users$results$full_name[5:count]
username<-users$results$username[5:count]
data<-data.frame(name=name,username=username)
stats_endpoint<-paste0(endpoint,username,"/","statistics/")
stat<-numeric((count-4))
stats<-list()
for(i in 1:(count-4))
{
  stats_response<-GET(url=stats_endpoint[i],headers=headers)
  stat[i] <- content(stats_response, "text", encoding = "UTF-8")
  stats[[i]]<-fromJSON(stat[i])
}
translated<-numeric(count-4)
languages_count<-numeric(count-4)
for(i in 1:(count-4))
{
  translated[i]<-stats[[i]]$translated
  languages_count[i]<-stats[[i]]$languages
}
url<-"https://translate.rx.studio/user/"
url<-paste0(url,username,"/")
languages<-list()
for(i in 1:length(url))
{
  html<-read_html(url[i])
  language<-html%>%html_elements(".middle-dot-divider a")%>%html_text()
  for(lang in language)
  {
    if(!lang %in% Language_Statistics$Name)
    {
      language<-language[language!=lang]
    }
  }
  languages[[i]]<-language
}
data<-cbind(data,translated)
data$Lanaguages_Count<-languages_count
data2<-data.frame(data,stringsAsFactors = FALSE)
data2$Languages<-languages
data2$Languages[[3]]
typeof(data2$Languages)
data2 <- data2 %>%
  mutate(serial_number = row_number()) %>%
  select(serial_number, everything())

data2<-tibble(data2)
data2 <- data2 %>%
  group_by(serial_number)%>%
  mutate(Languages=paste(Languages))

write_csv(data2, "Statistics.csv")
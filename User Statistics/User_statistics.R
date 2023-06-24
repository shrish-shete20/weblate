# Required libraries
library(httr)
library(jsonlite)
library(rvest)
library(readr)
library(tidyverse)
library(data.table)
library(dplyr)
library(curl)
Language_Statistics <- read_csv("/home/runner/work/weblate/weblate/Language Statisitics/Language_Statistics_new.csv")
# Weblate API configuration
api_token <- "wlu_s7fqhH2f9VgCCvIU2FQFlFMIZ27IH9GJwCg0"
api_token2<-"wlu_U8k6Kk12pyhXuBeXOP6imHRFiPrUMwHgHari"
api_url <- "https://translate.rx.studio/api/"

# API request: Fetch all languages
endpoint <- paste0(api_url, "users/")
headers2 <- add_headers(Authorization = paste("Token",api_token2))
response <- GET(url = endpoint,authenticate("shrishs21","kvell@2003"))
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

timestamp<-c()
for(user in data2$username)
{
  url_timestamp<-paste0("https://translate.rx.studio/api/changes/?user=",user)
  response_timestamp <- GET(url = url_timestamp, headers = headers, authenticate("shrishs21","kvell@2003"))
  users_timestamp <- content(response_timestamp, "text", encoding = "UTF-8")
  users_timestamp <- fromJSON(users_timestamp)
  if(users_timestamp$count==0)
  {
    timestamp<-c(timestamp,"N/A")
  }else
  {
      timestamp<-c(timestamp,users_timestamp$results$timestamp[1])
  }
}
data2$created<-timestamp


created<-c()
for(user in data2$username)
{
  user<-"ShunWang"
  url<-paste0("https://translate.rx.studio/api/changes/?user=",user)
  h <- new_handle()
  handle_setopt(h, ssl_verifyhost = 0L, ssl_verifypeer = 0L)
  handle_setopt(h, customrequest = "GET")
  handle_setopt(h, httpheader = c("Authorization: Token wlu_U8k6Kk12pyhXuBeXOP6imHRFiPrUMwHgHari"))
  res <- curl_fetch_memory(url, handle = h)
  
  content <- rawToChar(res$content)
  users_last <- fromJSON(content)
  pages_count<-ceiling(users_last$count/50)
  if(pages_count!=0)
  {
    url_last<-paste0("https://translate.rx.studio/api/changes/?page=",pages_count,"&user=",user)
    res2<-curl_fetch_memory(url_last, handle = h)
    content2<-rawToChar(res2$content)
    last_users<-fromJSON(content2)
    remain<-users_last$count%%50
    if(remain==0)
    {
      remain=50
    }
    created<-c(created,last_users$results$timestamp[remain])
  }else
  {
    created<-c(created,"N/A")
  }
  print(user)
}
data2$Last_Activity<-created

write_csv(data2, "Statistics.csv")


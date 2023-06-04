
library(httr)
library(jsonlite)
library(rvest)


api_token <- "wwlu_U8k6Kk12pyhXuBeXOP6imHRFiPrUMwHgHari"
api_url <- "https://translate.rx.studio/api/"

endpoint <- paste0(api_url, "users/")
headers <- add_headers(Authorization = paste("Token", api_token))
response <- GET(url = endpoint, headers = headers)
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
languages<-numeric(count-4)
for(i in 1:(count-4))
{
  translated[i]<-stats[[i]]$translated
  languages[i]<-stats[[i]]$languages
}
url<-"https://translate.rx.studio/user/"
url<-paste0(url,username,"/")


#Assignment 4 - Michael Skogeng
rm(list=ls())

library(tidyverse)
library(dplyr)
library(rvest)

#Saving the URL
url <- "http://timeplan.uit.no/emne_timeplan.php?sem=20h&module%5B%5D=BED-2056-1&View=list"
scraped <- Sys.time()
webpage <- read_html(url)
str(webpage)

#Checking if the html link is valid
html_session("http://timeplan.uit.no/emne_timeplan.php?sem=20h&module%5B%5D=BED-2056-1&View=list")

#Getting the correct info from the webpage and turning it into a table
Calender <- tibble(webpage %>% html_nodes("td:nth-child(1)") %>% html_text())
colnames(Calender) <- c("Date")
Date_df <- str_remove_all(Calender$Date, "[Mandag]")
Course <- tibble(as.Date(Date_df, "%d.%m.%Y"))
colnames(Course) <- c("Class Dates")
View(Course)
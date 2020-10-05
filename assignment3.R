#Assignment 3 - Michael Skogeng
rm(list=ls())

library(tidyverse)
library(rvest)
library(dplyr)

#Reading the html
browseURL("https://datacamp.com/courses/tech:r")
browseURL("https://www.datacamp.com/courses/tech:python")

url1 <- "https://datacamp.com/courses/tech:r"
page1 <- read_html(url1)
str(page1)

url2 <- "https://www.datacamp.com/courses/tech:python"
page2 <- read_html(url2)
str(page2)

html_session("https://datacamp.com/courses/tech:r")
html_session("https://www.datacamp.com/courses/tech:python")

Rclasses <- page1 %>% html_nodes("[class*='course-block__title']") %>% html_text()
pythonclasses <- page2 %>% html_nodes("[class*='course-block__title']") %>% html_text()

Rclasses <- tibble(Course_Name=Rclasses, Tech='R', Language='R')
pythonclasses <- tibble(Course_Name=pythonclasses, Tech='Python', Language='Python')

combined <- bind_rows(Rclasses, pythonclasses)
View(combined)
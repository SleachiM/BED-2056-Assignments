#Assignment 5
rm(list=ls())
library(data.table)
library(tidyverse)
##Code by �. Myrland + Assignment 5
# Read the csv data
county_csv <- fread("http://data.ssb.no/api/v0/dataset/95274.csv?lang=no")
head(county_csv)

whole_country_csv <- fread("http://data.ssb.no/api/v0/dataset/95293.csv?lang=no")
head(whole_country_csv)
rm(county_csv, whole_country_csv)

# Or reading json, the whole country
library(rjstat)
url <- "http://data.ssb.no/api/v0/dataset/95276.json?lang=no"
results <- fromJSONstat(url)
table <- results[[1]]
table

###############################################################
rm(list = ls())

#install.packages("PxWebApiData")
library(PxWebApiData)

?ApiData

county <- ApiData("http://data.ssb.no/api/v0/dataset/95274.json?lang=no",
                  getDataByGET = TRUE)

whole_country <- ApiData("http://data.ssb.no/api/v0/dataset/95276.json?lang=no",
                         getDataByGET = TRUE)

# two similar lists, different labels and coding
head(county[[1]])
head(county[[2]])

head(whole_country[[1]])

# Use first list, binding both of the data
dframe <- bind_rows(county[[1]], whole_country[[1]])


# new names, could have used dplyr::rename()
names(dframe)
names(dframe) <- c("region", "date", "variable", "value")
str(dframe)

# Split date
dframe <- dframe %>% separate(date, 
                              into = c("year", "month"), 
                              sep = "M")
head(dframe)

# Make a new proper date variable
library(lubridate)
dframe <- dframe %>%  mutate(date = ymd(paste(year, month, 1)))
str(dframe)

# And how many levels has the variable?
dframe %>% select(variable) %>% unique()

# car::recode()
dframe <- dframe %>%  mutate(variable1 = car::recode(dframe$variable,
                                                     ' "Utleigde rom"="rentedrooms";
"Pris per rom (kr)"="roomprice";
"Kapasitetsutnytting av rom (prosent)"="roomcap";
"Kapasitetsutnytting av senger (prosent)"="bedcap";
"Losjiomsetning (1 000 kr)"="revenue";
"Losjiomsetning per tilgjengeleg rom (kr)"="revperroom";
"Losjiomsetning, hittil i år (1 000 kr)"="revsofar";
"Losjiomsetning per tilgjengeleg rom, hittil i år (kr)"="revroomsofar";
"Pris per rom hittil i år (kr)"="roompricesofar";
"Kapasitetsutnytting av rom hittil i år (prosent)"="roomcapsofar";
"Kapasitetsutnytting av senger, hittil i år (prosent)"="bedcapsofar" '))

dframe %>% select(variable1) %>% unique()
with(dframe, table(variable, variable1))

# dplyr::recode()
dframe <- dframe %>% mutate(variable2 = dplyr::recode(variable,
                                                      "Utleigde rom"="rentedrooms",
                                                      "Pris per rom (kr)"="roomprice",
                                                      "Kapasitetsutnytting av rom (prosent)"="roomcap",
                                                      "Kapasitetsutnytting av senger (prosent)"="bedcap",
                                                      "Losjiomsetning (1 000 kr)"="revenue",
                                                      "Losjiomsetning per tilgjengeleg rom (kr)"="revperroom",
                                                      "Losjiomsetning, hittil i år (1 000 kr)"="revsofar",
                                                      "Losjiomsetning per tilgjengeleg rom, hittil i år (kr)"="revroomsofar",
                                                      "Pris per rom hittil i år (kr)"="roompricesofar",
                                                      "Kapasitetsutnytting av rom hittil i år (prosent)"="roomcapsofar",
                                                      "Kapasitetsutnytting av senger, hittil i år (prosent)"="bedcapsofar"))

dframe %>% select(variable2) %>% unique()
with(dframe, table(variable, variable2))

# or mutate & ifelse, a bit cumbersome, but flexible
dframe <- 
  dframe %>%
  mutate(variable3 =
           ifelse(variable == "Utleigde rom", "rentedrooms",
                  ifelse(variable == "Pris per rom (kr)", "roomprice",
                         ifelse(variable == "Kapasitetsutnytting av rom (prosent)", "roomcap",
                                ifelse(variable == "Kapasitetsutnytting av senger (prosent)", "bedcap",
                                       ifelse(variable == "Losjiomsetning (1 000 kr)", "revenue",
                                              ifelse(variable == "Losjiomsetning per tilgjengeleg rom (kr)", "revperroom",
                                                     ifelse(variable == "Losjiomsetning, hittil i år (1 000 kr)", "revsofar",
                                                            ifelse(variable == "Losjiomsetning per tilgjengeleg rom, hittil i år (kr)", "revroomsofar",
                                                                   ifelse(variable == "Pris per rom hittil i år (kr)", "roompricesofar",
                                                                          ifelse(variable == "Kapasitetsutnytting av rom hittil i år (prosent)", "roomcapsofar", "bedcapsofar")))))))))))


dframe %>% select(variable3) %>% unique()
with(dframe, table(variable, variable3))


# recode region
dframe <- dframe %>% mutate(region = 
                              ifelse(region == "Heile landet",
                                     "Whole country", region))

mosaic::tally(~region, data = dframe)

# we now have the data in long format ready for data wrangling



# Assignment 5 ## dplyr::recode() for variable region

dframe %>% select(region) %>% unique()

#Again using dplyr::recode function
dframe <- dframe %>% mutate(Region = dplyr::recode(region,
                                                   "Viken" = "Viken",
                                                   "Oslo" = "Oslo",
                                                   "Innlandet" = "Innlandet",
                                                   "Vestfold og Telemark" = "Vestfold_and_Telemark",
                                                   "Agder" = "Agder",
                                                   "Rogaland" = "Rogaland",
                                                   "Vestland" = "Vestland",
                                                   "M�re og Romsdal" = "More_and_Romsdal",
                                                   "Tr�ndelag - Tr��ndelage" = "Trondelag",
                                                   "Nordland" = "Nordland",
                                                   "Troms og Finnmark - Romsa ja Finnm�rku" = "Troms_and_Finnmark",
                                                   "Svalbard" = "Svalbard",
                                                   "Hele landet" = "Whole_Country"))


dframe %>% select(region) %>% unique()

mosaic::tally(~region, data = dframe)

## Plot

library(ggplot2)
d <- data.frame(dframe$region,dframe$variable3,dframe$value,dframe$date)
d <- subset(d, dframe$variable3 == "roomcap")



print(ggplot(d,aes(x=dframe.date,y=dframe.value,color=dframe.region)) +
        geom_line() + labs(title= "Roomcap of Locations Vs Time",
                           y="Roomcap", x = "Time",colour = "Locations"))

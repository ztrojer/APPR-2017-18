# 2. faza: Uvoz podatkov

library(rvest)
library(gsubfn)
library(readr)
library(dplyr)
library(httr)
library(reshape2)

#sl <- locale("sl", decimal_mark = ",", grouping_mark = ".")

#Funkcija, ki uvozi tabelo 1: Proizvodnja električne energije po proizvodnih delih v EU
uvozi.tabela1 <- function () {
    stolpci1 <- c("LETO", "DRZAVA", "ENOTA", "PRODUKT", "TIP", "VREDNOST")
    tabela1 <- read_csv("podatki/proizvedena_e_energija/elektrika_proi.csv", locale=locale(encoding="UTF-8"),
                        col_names= stolpci1,
                        skip = 1,
                        na = c("0",":"))
    for (i in 1:ncol(tabela1)) {
      if (is.character(tabela1[[i]])) {
        Encoding(tabela1[[i]]) <- "UTF-8"
      }
    }
    tabela1$'PRODUKT' <- NULL
    tabela1$'ENOTA' <- NULL
    #tabela1$VREDNOST <- parse_integer(tabela1$VREDNOST)
    #tabela1 <- tabela1[c(2,1,4,3,5)]
    
    return(tabela1)
  }
  
  tabela1 <- uvozi.tabela1()


  
#Funkcija, ki uvozi tabelo 2: Poraba električne energije po panogi
uvozi.tabela2 <- function () {
    stolpci2 <- c("LETO", "DRZAVA", "ENOTA", "PRODUKT","TIP", "VREDNOST")
    tabela2 <- read_csv("podatki/poraba_e_energija/elektrika_por.csv", locale=locale(encoding="UTF-8"),
                        col_names= stolpci2,
                        skip = 1,
                        na = "0")
    for (i in 1:ncol(tabela2)) {
      if (is.character(tabela2[[i]])) {
        Encoding(tabela2[[i]]) <- "UTF-8"
      }
    }
    #tabela2$VREDNOST <- parse_integer(tabela2$VREDNOST)
    tabela2$'ENOTA' <- NULL
    tabela2$'PRODUKT' <- NULL
    #tabela2 <- tabela2[c(2,1,4,3,5)]
    
    return(tabela2)
  }
  
  tabela2 <- uvozi.tabela2()
  

#Funkcija, ki uvozi tabelo 4: Prodaja električnih vozil v Evropi
uvozi.tabela4 <- function() {
  link <- "http://www.eafo.eu/charts/6689/vehicles_bev_table_graph"
  json <- GET(link) %>% content()
  tabela4 <- json$data$rows %>% sapply(. %>% sapply(. %>% .$value)) %>% t() %>% data.frame()
  colnames(tabela4) <- json$data$cols %>% sapply(. %>% .$name)
  tabela4$Ranking <- parse_number(tabela4$Ranking, na = "Others")
}

tabela4 <- uvozi.tabela4


#Funkcija, ki uvozi tabelo 5: Prodaja električnih vozil - hibridov v Evropi
uvozi.tabela4 <- function() {
  link <- "http://www.eafo.eu/charts/6689/vehicles_phev_table_graph"
  json <- GET(link) %>% content()
  tabela5 <- json$data$rows %>% sapply(. %>% sapply(. %>% .$value)) %>% t() %>% data.frame()
  colnames(tabela5) <- json$data$cols %>% sapply(. %>% .$name)
  tabela5$Ranking <- parse_number(tabela5$Ranking, na = "Others")
}

tabela5 <- uvozi.tabela5

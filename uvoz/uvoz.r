# 2. faza: Uvoz podatkov

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
    #tabela1 <- tabela1[c(2,1,4,3,5)]
    tabela1 <- filter(tabela1, VREDNOST != "NA")
    tabela1$TIP <- gsub("Gross electricity generation Main activity electricity only -", "", tabela1$TIP)
    tabela1$DRZAVA <- gsub(" \\(28 countries\\)", "", tabela1$DRZAVA)
    tabela1$DRZAVA <- gsub(" \\(19 countries\\)", "", tabela1$DRZAVA)
    tabela1$DRZAVA <- gsub(" \\(until 1990 former territory of the FRG\\)", "", tabela1$DRZAVA)
    tabela1$DRZAVA <- gsub("Former Yugoslav Republic of Macedonia, the", "Former Yugoslav", tabela1$DRZAVA)
    tabela1$DRZAVA <- gsub(" \\(under United Nations Security Council Resolution 1244/99\\)", "", tabela1$DRZAVA)
    
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
    tabela2$'ENOTA' <- NULL
    tabela2$'PRODUKT' <- NULL
    #tabela2 <- tabela2[c(2,1,4,3,5)]
    
    tabela2 <- filter(tabela2, VREDNOST != "NA")
    tabela2$DRZAVA <- gsub(" \\(28 countries\\)", "", tabela2$DRZAVA)
    tabela2$DRZAVA <- gsub(" \\(19 countries\\)", "", tabela2$DRZAVA)
    tabela2$DRZAVA <- gsub(" \\(until 1990 former territory of the FRG\\)", "", tabela2$DRZAVA)
    tabela2$DRZAVA <- gsub("Former Yugoslav Republic of Macedonia, the", "Former Yugoslav", tabela2$DRZAVA)
    tabela2$DRZAVA <- gsub(" \\(under United Nations Security Council Resolution 1244/99\\)", "", tabela2$DRZAVA)
    
    return(tabela2)
}

tabela2 <- uvozi.tabela2()

#Funkcija, ki uvozi tabelo 3: Proizvodnja energije iz obnovljivih virov
uvozi.tabela3 <- function () {
  stolpci3 <- c("LETO", "DRZAVA", "ENOTA", "PRODUKT", "TIP", "VREDNOST")
  tabela3 <- read_csv("podatki/proizvodnja_zelena_e/energija_zelena.csv", locale=locale(encoding="UTF-8"),
                      col_names= stolpci3,
                      skip = 1,
                      na = c("0",":"))
  for (i in 1:ncol(tabela3)) {
    if (is.character(tabela3[[i]])) {
      Encoding(tabela3[[i]]) <- "UTF-8"
    }
  }
  tabela3$'ENOTA' <- NULL
  tabela3 <- filter(tabela3, VREDNOST != "NA")
  tabela3 <- filter(tabela3, TIP != "Gross inland consumption")
  tabela3$'TIP' <- NULL
  tabela3$DRZAVA <- gsub(" \\(28 countries\\)", "", tabela3$DRZAVA)
  tabela3$DRZAVA <- gsub(" \\(19 countries\\)", "", tabela3$DRZAVA)
  tabela3$DRZAVA <- gsub(" \\(until 1990 former territory of the FRG\\)", "", tabela3$DRZAVA)
  tabela3$DRZAVA <- gsub("Former Yugoslav Republic of Macedonia, the", "Former Yugoslav", tabela3$DRZAVA)
  tabela3$DRZAVA <- gsub(" \\(under United Nations Security Council Resolution 1244/99\\)", "", tabela3$DRZAVA)
  
  
  return(tabela3)
}

tabela3 <- uvozi.tabela3()

#Funkcija, ki uvozi tabelo 4: Prodaja električnih vozil v Evropi
uvozi.tabela4 <- function() {
  link <- "http://www.eafo.eu/charts/6689/vehicles_bev_table_graph"
  json <- GET(link) %>% content()
  tabela4 <- json$data$rows %>% sapply(. %>% sapply(. %>% .$value)) %>% t() %>% data.frame()
  colnames(tabela4) <- json$data$cols %>% sapply(. %>% .$name)
  tabela4$Ranking <- NULL
  tabela4 <- unite(tabela4, Make, Model, col = "Model", sep = " ")
  imena_s4 <- c("MODEL", "YTD_2017", "DELEZ_NA_TRGU", "YTD_2016", "2016", "2015", "2014", "2013", "2012", "2011")
  colnames(tabela4) <- imena_s4
  tabela4$MODEL[11] <- "Ostali"
  for (i in 1:ncol(tabela4)) {
    if (is.character(tabela4[[i]])) {
      Encoding(tabela4[[i]]) <- "UTF-8"
    }
  }
  tabela4$YTD_2017 <- parse_number(tabela4$YTD_2017)
  tabela4$YTD_2016 <- parse_number(tabela4$YTD_2016)
  tabela4$`2016` <- parse_number(tabela4$`2016`)
  tabela4$`2015`<- parse_number(tabela4$`2015`)
  tabela4$`2014`<- parse_number(tabela4$`2014`)
  tabela4$`2013` <- parse_number(tabela4$`2013`)
  tabela4$`2012` <- parse_number(tabela4$`2012`)
  tabela4$`2011` <- parse_number(tabela4$`2011`)
  #tabela4$DELEZ_NA_TRGU <- gsub(",","\\.", tabela4$DELEZ_NA_TRGU)
  #tabela4$DELEZ_NA_TRGU <- as.numeric(sub("%", "", tabela4$DELEZ_NA_TRGU))
  tabela4$DELEZ_NA_TRGU <- NULL
  tabela4$YTD_2016 <- NULL
  tabela4$YTD_2017 <- NULL
  tabela4 <- melt(tabela4, id = c("MODEL"))
  imena_ns4 <- c("MODEL", "LETO", "VREDNOST")
  colnames(tabela4) <- imena_ns4
  tabela4 <- filter(tabela4, VREDNOST != "0")
  tabela4$VREDNOST <- parse_integer(tabela4$VREDNOST)
  
  return(tabela4)
}

tabela4 <- uvozi.tabela4()

#Funkcija, ki uvozi tabelo 5: Prodaja električnih vozil - hibridov v Evropi
uvozi.tabela5 <- function() {
  link <- "http://www.eafo.eu/charts/6689/vehicles_phev_table_graph"
  json <- GET(link) %>% content()
  tabela5 <- json$data$rows %>% sapply(. %>% sapply(. %>% .$value)) %>% t() %>% data.frame()
  colnames(tabela5) <- json$data$cols %>% sapply(. %>% .$name)
  tabela5$Ranking <- NULL
  tabela5 <- unite(tabela5, Make, Model, col = "Model", sep = " ")
  for (i in 1:ncol(tabela5)) {
    if (is.character(tabela5[[i]])) {
      Encoding(tabela5[[i]]) <- "UTF-8"
    }
  }
  imena_s5 <- c("MODEL", "YTD_2017", "DELEZ_NA_TRGU", "YTD_2016", "2016", "2015", "2014", "2013", "2012", "2011")
  colnames(tabela5) <- imena_s5
  tabela5$MODEL[11] <- "Ostali"
  tabela5$YTD_2017 <- parse_number(tabela5$YTD_2017)
  tabela5$YTD_2016 <- parse_number(tabela5$YTD_2016)
  tabela5$`2016` <- parse_number(tabela5$`2016`)
  tabela5$`2015`<- parse_number(tabela5$`2015`)
  tabela5$`2014`<- parse_number(tabela5$`2014`)
  tabela5$`2013` <- parse_number(tabela5$`2013`)
  tabela5$`2012` <- parse_number(tabela5$`2012`)
  tabela5$`2011` <- parse_number(tabela5$`2011`)
  #tabela5$DELEZ_NA_TRGU <- gsub(",","\\.", tabela5$DELEZ_NA_TRGU)
  #tabela5$DELEZ_NA_TRGU <- as.numeric(sub("%", "", tabela5$DELEZ_NA_TRGU))
  tabela5$DELEZ_NA_TRGU <- NULL
  tabela5$YTD_2016 <- NULL
  tabela5$YTD_2017 <- NULL
  tabela5 <- melt(tabela5, id = c("MODEL"))
  imena_ns5 <- c("MODEL", "LETO", "VREDNOST")
  colnames(tabela5) <- imena_ns5
  tabela5 <- filter(tabela5, VREDNOST != "0")
  tabela5$VREDNOST <- parse_integer(tabela5$VREDNOST)
  
  return(tabela5)
}

tabela5 <- uvozi.tabela5()

#Skupna tabela 4 in 5
#tabela_avti <- bind_rows(tabela4, tabela5)

#Funkcija, ki uvozi tabelo 6: Delež električne energije iz obnovljivih virov
uvozi.tabela6 <- function() {
  stolpci6 <- c("LETO", "DRZAVA", "ENOTA", "PRODUKT", "VREDNOST")
  tabela6 <- read_csv("podatki/delez_zelene_e/delez_zelene_e.csv", locale=locale(encoding="UTF-8"),
                      col_names= stolpci6,
                      skip = 1,
                      na = c("0",":","0.0"))
  for (i in 1:ncol(tabela6)) {
    if (is.character(tabela6[[i]])) {
      Encoding(tabela6[[i]]) <- "UTF-8"
    }
  }
  tabela6$'ENOTA' <- NULL
  tabela6 <- filter(tabela6, VREDNOST != "NA")
  tabela6$'PRODUKT' <- NULL
  
  tabela6$DRZAVA <- gsub(" \\(28 countries\\)", "", tabela6$DRZAVA)
  tabela6$DRZAVA <- gsub(" \\(19 countries\\)", "", tabela6$DRZAVA)
  tabela6$DRZAVA <- gsub(" \\(until 1990 former territory of the FRG\\)", "", tabela6$DRZAVA)
  tabela6$DRZAVA <- gsub("Former Yugoslav Republic of Macedonia, the", "Former Yugoslav", tabela6$DRZAVA)
  tabela6$DRZAVA <- gsub(" \\(under United Nations Security Council Resolution 1244/99\\)", "", tabela6$DRZAVA)
  
  
  return(tabela6)
}
  
tabela6 <- uvozi.tabela6()


#Funkcija, ki uvozi tabelo 7: Poraba električne energije za toplotne črpalke
uvozi.tabela7 <- function() {
  stolpci7 <- c("LETO", "DRZAVA", "ENOTA", "PRODUKT", "TIP", "VREDNOST")
  tabela7 <- read_csv("podatki/toplotne_crpalke/topl_crp.csv", locale=locale(encoding="UTF-8"),
                      col_names= stolpci7,
                      skip = 1,
                      na = c("0",":"))
  for (i in 1:ncol(tabela7)) {
    if (is.character(tabela7[[i]])) {
      Encoding(tabela7[[i]]) <- "UTF-8"
    }
  }
  tabela7$'ENOTA' <- NULL
  tabela7$'PRODUKT' <- NULL
  tabela7$'TIP' <- NULL
  tabela7 <- filter(tabela7, VREDNOST != "NA")
  tabela7$DRZAVA <- gsub(" \\(28 countries\\)", "", tabela7$DRZAVA)
  tabela7$DRZAVA <- gsub(" \\(19 countries\\)", "", tabela7$DRZAVA)
  tabela7$DRZAVA <- gsub(" \\(until 1990 former territory of the FRG\\)", "", tabela7$DRZAVA)
  tabela7$DRZAVA <- gsub("Former Yugoslav Republic of Macedonia, the", "Former Yugoslav", tabela7$DRZAVA)
  tabela7$DRZAVA <- gsub(" \\(under United Nations Security Council Resolution 1244/99\\)", "", tabela7$DRZAVA)

  
  return(tabela7)
}

tabela7 <- uvozi.tabela7()
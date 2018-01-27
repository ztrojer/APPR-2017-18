# 2. faza: Uvoz podatkov

en <- locale("en", decimal_mark = ".", grouping_mark = ",")

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
  colnames(tabela4) <- c("PROIZVAJALEC", "MODEL", "YTD_2017", "DELEZ_2017",
                         "YTD_2016", 2016, "DELEZ_2016", 2015:2011)
  tabela4 <- unite(tabela4, PROIZVAJALEC, MODEL, col = MODEL, sep = " ")
  tabela4 <- tabela4[, c("MODEL", 2016:2011)]
  tabela4$MODEL[11] <- "Ostali"
  tabela4 <- melt(tabela4, id.vars = "MODEL", variable.name = "LETO", value.name = "VREDNOST") %>%
    mutate(LETO = parse_integer(LETO),
           VREDNOST = parse_integer(VREDNOST)) %>% filter(VREDNOST != 0)
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
  colnames(tabela5) <- c("PROIZVAJALEC", "MODEL", "YTD_2017", "DELEZ_2017",
                         "YTD_2016", 2016, "DELEZ_2016", 2015:2011)
  tabela5 <- unite(tabela5, PROIZVAJALEC, MODEL, col = MODEL, sep = " ")
  tabela5 <- tabela5[, c("MODEL", 2016:2011)]
  tabela5$MODEL[11] <- "Ostali"
  tabela5 <- melt(tabela5, id.vars = "MODEL", variable.name = "LETO", value.name = "VREDNOST") %>%
    mutate(LETO = parse_integer(LETO),
           VREDNOST = parse_integer(VREDNOST)) %>% filter(VREDNOST != 0)
  return(tabela5)
}

tabela5 <- uvozi.tabela5()

#Skupna tabela 4 in 5
#tabela_avti <- bind_rows(tabela4, tabela5)

#Funkcija, ki uvozi tabelo 6: Delež električne energije iz obnovljivih virov
uvozi.tabela6 <- function() {
  stolpci6 <- c("LETO", "DRZAVA", "ENOTA", "PRODUKT", "VREDNOST")
  tabela6 <- read_csv("podatki/delez_zelene_e/delez_zelene_e1.csv", locale=locale(encoding="UTF-8"),
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


# Funkcija, ki uvozi iz Wikipedije - število prebivalcev in površino države
uvozi.tabela8 <- function() {
  link <- "https://en.wikipedia.org/wiki/Area_and_population_of_European_countries"
  stran <- html_session(link) %>% read_html()
  tabela8 <- stran %>% html_nodes(xpath="//table[@class='wikitable sortable']") %>%
    .[[1]] %>% html_table(dec = ",")
  for (i in 1:ncol(tabela8)) {
    if (is.character(tabela8[[i]])) {
      Encoding(tabela8[[i]]) <- "UTF-8"
    }
  }
  
  colnames(tabela8) <- c("DRZAVA", "GOSTOTA_PREBIVALSTVA", "POVRSINA", "POPULACIJA")
  tabela8$'DRZAVA' <- gsub("France \\(European part\\)", "France", tabela8$'DRZAVA')
  tabela8$'GOSTOTA_PREBIVALSTVA' <- NULL
  for (col in c("POVRSINA", "POPULACIJA")) {
    tabela8[[col]] <- parse_number(tabela8[[col]], na = "-", locale = en)
  }
  for (col in c("DRZAVA")) {
    tabela8[[col]] <- factor(tabela8[[col]])
  }
  return(tabela8)
}

tabela8 <- uvozi.tabela8()

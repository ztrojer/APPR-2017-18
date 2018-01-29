library(shiny)

shinyUI(navbarPage(title="Električna energija",
                   tabPanel(title = "Delež iz obnovljivih virov",
                            mainPanel("Na spodnjem grafu si lahko ogledamo države, ki so dosegle normo (20%) deleža proizvedene energije iz obnovljivih virov"),
                            selectInput(inputId = 'leto',
                                        label = 'Leto:',
                                        choices = unique(tabela6$LETO),
                                        multiple = FALSE),
                            plotOutput('graf')),
                   
                   tabPanel(title = "Zemljevid deleža iz obnovljivih virov",
                            mainPanel("Na spodnjem zemljevidu si lahko ogledamo, kako se skozi leta spreminja delež električne energije iz obnovljivih virov."),
                            sliderInput(inputId = 'leto1',
                                        label = 'Leto:',
                                        value =  2008,
                                        min = 2004,
                                        max = 2016),
                            plotOutput('graf1')),
                   
                   tabPanel(title = "Proizvedena električna energija po proizvodnih delih",
                            mainPanel("Na spodnjem grafu si lahko ogledamo, iz katerih elektrarn je proizvedena električna energija v državi."),
                            selectInput(inputId = 'drzava',
                                        label = 'Država:',
                                        choices = unique(tabela1$DRZAVA),
                                        multiple = FALSE),
                            checkboxGroupInput(inputId = 'tip',
                                         label = 'Tip elektrarne:',
                                         choiceValues = list("Solar Photovoltaic","Nuclear","Hydro","Pumped Hydro","Wind","Combustible Fuels","Anthracite", "Other Bituminous Coal","Lignite/Brown Coal","Oil shale and oil sands","Gas / Diesel Oil","Natural Gas","Solid biofuels excluding charcoal","Biogases"),
                                         choiceNames = list("sončna elektrarna","jedrska elektrarna","hidroelektrarna","črpalna hidroelektrarna","vetrna elektrarna","gorljiva goriva","antracit", "bituminozni premog","rjavi premog","naftni skrilavec","plin in dizel","zemeljski plin","trda goriva brez premoga","bioplin")),
                            plotOutput('graf2'))
                   
))



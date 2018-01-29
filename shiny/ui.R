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
                   
                   tabPanel(title = "Zemljevid deleža iz obnovljivih virov",
                            mainPanel("Na spodnjem zemljevidu si lahko ogledamo, kako se skozi leta spreminja delež električne energije iz obnovljivih virov."),
                            selectInput(inputId = 'drzava',
                                        label = 'Država:',
                                        choices = unique(tabela1$DRZAVA),
                                        multiple = FALSE),
                            checkboxGroupInput(inputId = 'tip',
                                         label = 'Tip elektrarne:',
                                         choiceValues = list("Anthracite","Biogases", "Combustible Fuels", "Gas / Diesel Oil", "Geothermal", "Hydro", "Lignite/Brown Coal", "Natural Gas", "Other Bituminous Coal", "Pumped Hydro", "Solar Photovoltaic", "Solid biofuels excluding charcoal","Wind"),
                                         choiceNames = list("Anthracite","Biogases", "Combustible Fuels", "Gas / Diesel Oil", "Geothermal", "Hydro", "Lignite/Brown Coal", "Natural Gas", "Other Bituminous Coal", "Pumped Hydro", "Solar Photovoltaic", "Solid biofuels excluding charcoal","Wind")),
                            plotOutput('graf2'))
                   
))



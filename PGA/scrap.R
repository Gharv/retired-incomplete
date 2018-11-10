### Scrapes data directly from pgatour.com using a selenium web driver to go page by page
### Takes shot data for tournaments and will save it to a database in MySQL

library(dplyr)
library(rvest)
library(RSelenium)
library(progress)

remDr$screenshot(display=TRUE)
remDr$quit()
remDr$closeall()
remDr$closeServer()


#open docker in cmd and run command : docker run -d -p 4445:4444 selenium/standalone-chrome

remDr <- remoteDriver(remoteServerAddr = "192.168.99.100", port = 4445L, browser = 'chrome')
url <- 'http://www.pgatour.com/competition/2016/tour-championship/leaderboard.html'
remDr$open()
remDr$navigate(url)
Sys.sleep(10)
players <- remDr$findElements(using = 'css selector', '.col-auto .name .hidden-small')

shotsT <- NA
shotsFinish <- NA
pb <- progress_bar$new(total = ((length(players)-73)*3 + 73*5)-5*0) #roughly correct, based on 73 players making cut
for(i in 1:length(players)){
remDr$quit()
remDr$open()
remDr$navigate(url)
Sys.sleep(10)
players <- remDr$findElements(using = 'css selector', '.col-auto .name .hidden-small')
  

players[i][[1]]$clickElement()
playerName <- players[i][[1]]$getElementText()[[1]]
Sys.sleep(2)
# if(i != 1){
#   exit <- remDr$findElements(using = 'css selector', '.row-details-close')
#   exit[length(exit)-5][[1]]$clickElement()
# }
Sys.sleep(2)
pbp <- remDr$findElement(using = 'css selector', '.cell-shottracker .tab-active+ .tab') #clicks on the play by play button to show shot data
pbp$clickElement()
Player1 <- NA


#only gets first player round 1 (does not get second and beyond player)
roundSel <- remDr$findElements(using = 'xpath', "//*/option[@value = '1']") #finds the xpath of the round 1 button
Sys.sleep(2)
if(length(roundSel) != 0){
roundSel[length(roundSel)-2][[1]]$clickElement()
Sys.sleep(2)
#remDr$sendKeysToActiveElement(list(key = 'tab', key = 'enter'))

holeSel <- remDr$findElement(using = 'css selector', '.scorecards-box')
checkHole <- remDr$findElements(using = 'css selector', '.first-col+ .hole-selectable .hole-picker')
holeCheck <- as.numeric(checkHole[length(checkHole)-1][[1]]$getElementText())
holeCheck2 <- as.numeric(checkHole[length(checkHole)][[1]]$getElementText())
if(is.na(holeCheck)){
  visableHole <- holeCheck2
}
if(is.na(holeCheck2)){
  visableHole <- holeCheck
}
if(visableHole == 10){
  prev <- remDr$findElements(using = 'xpath', "//*/a[@class='scorecards-prev']")
  prev[[length(prev)]]$clickElement()
}
shotSelList <- remDr$findElements(using = 'xpath', "//*/a[@data-hole-number='1']")
#Sys.sleep(2)
shotSel1 <- shotSelList[length(shotSelList)][[1]]
#Sys.sleep(2)
shotSel1$clickElement()
#Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting second hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'enter'))
#Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting third hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'tab', key = 'enter'))
#Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting fourth hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'enter'))
#Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting fifth hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'enter'))
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting sixth hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'enter'))
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting seventh hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'enter'))
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting eigth hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'enter'))
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting ninth hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'enter'))
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting tenth hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'enter', key = 'tab', key = 'enter'))
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting elevnth hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'enter'))
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting twevelth hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'tab', key = 'enter'))
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting thirteenth hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'enter'))
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting fourteenth hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'enter'))
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting fifteenth hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'enter'))
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting sixteenth hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'enter'))
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting seventeenth hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'enter'))
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting eighteenth hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'enter'))
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)
pb$tick()
}


Sys.sleep(2)
roundSel <- remDr$findElements(using = 'xpath', "//*/option[@value = '2']")
Sys.sleep(2)
if(length(roundSel) != 0){
roundSel[length(roundSel)-2][[1]]$clickElement()
Sys.sleep(2)

#Selecting first hole and sraping shot data
holeSel <- remDr$findElement(using = 'css selector', '.scorecards-box')
checkHole <- remDr$findElements(using = 'css selector', '.first-col+ .hole-selectable .hole-picker')
holeCheck <- as.numeric(checkHole[length(checkHole)-1][[1]]$getElementText())
holeCheck2 <- as.numeric(checkHole[length(checkHole)][[1]]$getElementText())
if(is.na(holeCheck)){
  visableHole <- holeCheck2
}
if(is.na(holeCheck2)){
  visableHole <- holeCheck
}
if(visableHole == 10){
  prev <- remDr$findElements(using = 'xpath', "//*/a[@class='scorecards-prev']")
  #prev <- remDr$findElements(using = 'css selector', ".scorecards-prev")
  prev[[length(prev)]]$clickElement()
  }
shotSelList <- remDr$findElements(using = 'xpath', "//*/a[@data-hole-number='1']")
Sys.sleep(2)
shotSel1 <- shotSelList[length(shotSelList)][[1]]
Sys.sleep(2)
shotSel1$clickElement()
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting second hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'enter'))
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting third hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'tab', key = 'enter'))
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting fourth hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'enter'))
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting fifth hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'enter'))
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting sixth hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'enter'))
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting seventh hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'enter'))
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting eigth hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'enter'))
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting ninth hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'enter'))
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting tenth hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'enter', key = 'tab', key = 'enter'))
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting elevnth hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'enter'))
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting twevelth hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'tab', key = 'enter'))
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting thirteenth hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'enter'))
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting fourteenth hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'enter'))
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting fifteenth hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'enter'))
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting sixteenth hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'enter'))
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting seventeenth hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'enter'))
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting eighteenth hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'enter'))
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)
pb$tick()
}


Sys.sleep(2)

roundSel <- remDr$findElements(using = 'xpath', "//*/option[@value = '3']")
Sys.sleep(2)
if(length(roundSel) != 0){
roundSel[length(roundSel)-2][[1]]$clickElement()
Sys.sleep(2)
#Sys.sleep(2)

#Selecting first hole and sraping shot data

holeSel <- remDr$findElement(using = 'css selector', '.scorecards-box')
checkHole <- remDr$findElements(using = 'css selector', '.first-col+ .hole-selectable .hole-picker')
holeCheck <- as.numeric(checkHole[length(checkHole)-1][[1]]$getElementText())
holeCheck2 <- as.numeric(checkHole[length(checkHole)][[1]]$getElementText())
if(is.na(holeCheck)){
  visableHole <- holeCheck2
}
if(is.na(holeCheck2)){
  visableHole <- holeCheck
}
if(visableHole == 10){
  prev <- remDr$findElements(using = 'xpath', "//*/a[@class='scorecards-prev']")
  #prev <- remDr$findElements(using = 'css selector', ".scorecards-prev")
  prev[[length(prev)]]$clickElement()
}
shotSelList <- remDr$findElements(using = 'xpath', "//*/a[@data-hole-number='1']")
Sys.sleep(2)
shotSel1 <- shotSelList[length(shotSelList)][[1]]
Sys.sleep(2)
shotSel1$clickElement()
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting second hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'enter'))
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting third hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'tab', key = 'enter'))
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting fourth hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'enter'))
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting fifth hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'enter'))
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting sixth hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'enter'))
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting seventh hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'enter'))
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting eigth hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'enter'))
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting ninth hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'enter'))
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting tenth hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'enter', key = 'tab', key = 'enter'))
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting elevnth hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'enter'))
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting twevelth hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'tab', key = 'enter'))
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting thirteenth hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'enter'))
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting fourteenth hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'enter'))
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting fifteenth hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'enter'))
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting sixteenth hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'enter'))
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting seventeenth hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'enter'))
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting eighteenth hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'enter'))
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)
pb$tick()
}


Sys.sleep(2)
roundSel <- remDr$findElements(using = 'xpath', "//*/option[@value = '4']")
Sys.sleep(2)
if(length(roundSel) != 0){
roundSel[length(roundSel)-2][[1]]$clickElement()
Sys.sleep(2)
#Sys.sleep(2)

#Selecting first hole and sraping shot data

holeSel <- remDr$findElement(using = 'css selector', '.scorecards-box')
checkHole <- remDr$findElements(using = 'css selector', '.first-col+ .hole-selectable .hole-picker')
holeCheck <- as.numeric(checkHole[length(checkHole)-1][[1]]$getElementText())
holeCheck2 <- as.numeric(checkHole[length(checkHole)][[1]]$getElementText())
if(is.na(holeCheck)){
  visableHole <- holeCheck2
}
if(is.na(holeCheck2)){
  visableHole <- holeCheck
}
if(visableHole == 10){
  prev <- remDr$findElements(using = 'xpath', "//*/a[@class='scorecards-prev']")
  #prev <- remDr$findElements(using = 'css selector', ".scorecards-prev")
  prev[[length(prev)]]$clickElement()
}
shotSelList <- remDr$findElements(using = 'xpath', "//*/a[@data-hole-number='1']")
Sys.sleep(2)
shotSel1 <- shotSelList[length(shotSelList)][[1]]
Sys.sleep(2)
shotSel1$clickElement()
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting second hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'enter'))
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting third hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'tab', key = 'enter'))
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting fourth hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'enter'))
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting fifth hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'enter'))
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting sixth hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'enter'))
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting seventh hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'enter'))
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting eigth hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'enter'))
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting ninth hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'enter'))
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting tenth hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'enter', key = 'tab', key = 'enter'))
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting elevnth hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'enter'))
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting twevelth hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'tab', key = 'enter'))
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting thirteenth hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'enter'))
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting fourteenth hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'enter'))
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting fifteenth hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'enter'))
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting sixteenth hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'enter'))
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting seventeenth hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'enter'))
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)

#Selecting eighteenth hole and scraping shot data
remDr$sendKeysToActiveElement(list(key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'tab', key = 'enter'))
Sys.sleep(2)
pageSource <- read_html(remDr$getPageSource()[[1]])
Sys.sleep(1)
holeTemp <- pageSource %>% 
  html_nodes(".scroller") %>% 
  html_text(trim=TRUE)
holeTempClean <- holeTemp[[3]]
holeTempCleaner <- unlist(as.vector(strsplit(holeTempClean, "\\s{2,}")))
length(holeTempCleaner) <- 18
Player1 <- cbind(Player1, holeTempCleaner)
pb$tick()
}


Player <- Player1[-1]
shot <- Player[!is.na(Player)]
shots <- as.data.frame(shot)

#creating the playerName column
shots$playerName <- playerName

#creating the hole column
#use grepl over grep to return logic vaule(instead of numeric)
shots$hole <- NA
shots$shot <- as.character(shots$shot)
holeNumber <- 0
for(j in 1:length(shots$shot)){
  if(grepl("in the hole", shots$shot[j])) holeNumber <- holeNumber+1
    shots$hole[j] <- holeNumber
}

#create the holed column
#use gsub over sub to replace all occurances
shots$holed <- 0
for(j in 1:length(shots$shot)){
  if(grepl("in the hole", shots$shot[j])) shots$holed[j] <- 1
    shots$shot[j] <- gsub(" in the hole", "", shots$shot[j])
}

#create the distance column
shots$distance <- 0
for(j in 1:length(shots$shot)){
  temp <- gsub("Shot [0-9]+ ", "", shots$shot[j])
  temp <- gsub(",.*", "", temp)
  shots$distance[j] <- gsub("putt | to.*", "", temp)
  if(grepl("Shot", shots$distance[j])) shots$distance[j] <- 0
  if(grepl("Penalty", shots$distance[j])) shots$distance[j] <- 0
  if(grepl("Drop", shots$distance[j])) shots$distance[j] <- 0
}

#create the distance left column
shots$distanceLeft <- 0
for(j in 1:length(shots$shot)){
  #temp <- gsub("Shot [0-9]+ ", "", shots$shot[j])
  temp <- gsub(".*, ", "", shots$shot[j])#temp
  shots$distanceLeft[j] <- gsub(" to hole", "", temp)
  if(grepl("Shot", shots$distanceLeft[j])) shots$distanceLeft[j] <- 0
  if(grepl("Penalty", shots$distanceLeft[j])) shots$distanceLeft[j] <- 0
}

#putt to hole distance (different then shot distance)
shots$puttDistance <- 0
for(j in 1:length(shots$shot)){
  temp <- gsub("Shot [0-9]+ ", "", shots$shot[j])
  temp <- gsub(",.*", "", temp)
  temp <- gsub("putt ", "", temp)
  shots$puttDistance[j] <- gsub("putt ", "", temp)
  if(grepl("putt", shots$shot[j+1]) || grepl("green", shots$shot[j+1])) shots$puttDistance[j] <- shots$distanceLeft[j+1]
  if(grepl("Shot", shots$puttDistance[j])) shots$puttDistance[j] <- 0
  if(grepl("Penalty", shots$puttDistance[j])) shots$puttDistance[j] <- 0
  if(grepl("Drop", shots$puttDistance[j])) shots$puttDistance[j] <- 0
  if(grepl("yds", shots$puttDistance[j])) shots$puttDistance[j] <- 0
  if(grepl("to .*", shots$puttDistance[j])) shots$puttDistance[j] <- 0
}

shots$puttDistanceLeft <- 0
for(j in 1:length(shots$shot)){
  if(grepl("putt", shots$shot[j])){
    temp <- gsub(".*,", "", shots$shot[j])
    shots$puttDistanceLeft[j] <- gsub(" to hole", "", temp)
  }
  if(grepl("Shot", shots$puttDistanceLeft[j])) shots$puttDistanceLeft[j] <- 0
  if(grepl("Penalty", shots$puttDistanceLeft[j])) shots$puttDistanceLeft[j] <- 0
  if(grepl("Drop", shots$puttDistanceLeft[j])) shots$puttDistanceLeft[j] <- 0
  if(grepl("yds", shots$puttDistanceLeft[j])) shots$puttDistanceLeft[j] <- 0
}

shots$left <- 0
for(j in 1:length(shots$shot)){
  if(grepl("left", shots$shot[j])) shots$left[j] <- 1
}

shots$right <- 0
for(j in 1:length(shots$shot)){
  if(grepl("right", shots$shot[j])) shots$right[j] <- 1
}

shots$fairway <- 0
for(j in 1:length(shots$shot)){
  if(grepl("fairway", shots$shot[j])) shots$fairway[j] <- 1
}

shots$rough <- 0
for(j in 1:length(shots$shot)){
  if(grepl("rough", shots$shot[j])) shots$rough[j] <- 1
}

#have to take out the fairway counter
shots$fairwayBunker <- 0
for(j in 1:length(shots$shot)){
  if(grepl("fairway bunker", shots$shot[j])) {shots$fairwayBunker[j] <- 1 ; shots$fairway[j] <- 0}
}

shots$water <- 0
for(j in 1:length(shots$shot)){
  if(grepl("water", shots$shot[j])) shots$water[j] <- 1
}

shots$nativeArea <- 0
for(j in 1:length(shots$shot)){
  if(grepl("native area", shots$shot[j])) shots$nativeArea[j] <- 1
}

shots$fringe <- 0
for(j in 1:length(shots$shot)){
  if(grepl("fringe", shots$shot[j])) shots$fringe[j] <- 1
}

shots$green <- 0
for(j in 1:length(shots$shot)){
  if(grepl("green", shots$shot[j])) shots$green[j] <- 1
}

#have to take out the green counter
shots$greenSideBunker <- 0
for(j in 1:length(shots$shot)){
  if(grepl("green side bunker", shots$shot[j])) {shots$greenSideBunker[j] <- 1 ; shots$green[j] <- 0}
}

shots$front <- 0
for(j in 1:length(shots$shot)){
  if(grepl("front", shots$shot[j])) shots$front[j] <- 1
}

shots$rear <- 0
for(j in 1:length(shots$shot)){
  if(grepl("rear", shots$shot[j])) shots$rear[j] <- 1
}

shots$drop <- 0
for(j in 1:length(shots$shot)){
  if(grepl("Drop", shots$shot[j])) shots$drop[j] <- 1
}

shots$penalty <- 0
for(j in 1:length(shots$shot)){
  if(grepl("Penalty", shots$shot[j])) shots$penalty[j] <- 1
}


#convert ft and in to just yds for distance
for(j in 1:length(shots$distance)){
  if(grepl("yds", shots$distance[j])) shots$distance[j] <- (gsub(" yds", "", shots$distance[j]))
  if(grepl("ft", shots$distance[j]) && grepl("in", shots$distance[j])) shots$distance[j] <- (gsub(" ft [0-9]+ in.", "", shots$distance[j]))
  if(grepl("in", shots$distance[j]) && !grepl("ft", shots$distance[j])) shots$distance[j] <- 0
}
shots$distance <- as.numeric(shots$distance)
for(j in 1:length(shots$distance)){
  temp <- gsub(",.*", "", shots$shot[j])
  if(grepl("ft", temp)) shots$distance[j] <- round(shots$distance[j]/3, 1)
}

#convert ft and in to just yds for distanceLeft
for(j in 1:length(shots$distanceLeft)){
  if(grepl("yds", shots$distanceLeft[j])) shots$distanceLeft[j] <- (gsub(" yds", "", shots$distanceLeft[j]))
  if(grepl("ft", shots$distanceLeft[j]) && grepl("in", shots$distanceLeft[j])) shots$distanceLeft[j] <- (gsub(" ft [0-9]+ in.", "", shots$distanceLeft[j]))
  if(grepl("in", shots$distanceLeft[j]) && !grepl("ft", shots$distanceLeft[j])) shots$distanceLeft[j] <- 0.5
}
shots$distanceLeft <- as.numeric(shots$distanceLeft)
for(j in 1:length(shots$distanceLeft)){
  temp <- gsub(".*,", "", shots$shot[j])
  if(grepl("ft", temp)) shots$distanceLeft[j] <- round(shots$distanceLeft[j]/3, 1)
}

feet <- 0
inch <- 0
#convert ft and in to just ft for puttDistance
for(j in 1:length(shots$puttDistance)){
  if(grepl("in", shots$puttDistance[j]) || grepl("ft", shots$puttDistance[j])){
    feet <- 0
    if(grepl("ft", shots$puttDistance[j])) feet <- as.numeric(gsub(" ft.*", "", shots$puttDistance[j]))
    inch <- gsub(".*ft ", "", shots$puttDistance[j])
    inch <- as.numeric(gsub(" in.", "", inch))
    shots$puttDistance[j] <- round(feet + inch/12, 2)
  }
}

#convert ft and in to just ft for puttDistanceLeft
for(j in 1:length(shots$puttDistanceLeft)){
  if(grepl("in", shots$puttDistanceLeft[j]) || grepl("ft", shots$puttDistanceLeft[j])){
    feet <- 0
    if(grepl("ft", shots$puttDistanceLeft[j])) feet <- as.numeric(gsub(" ft.*", "", shots$puttDistanceLeft[j]))
    inch <- gsub(".*ft ", "", shots$puttDistanceLeft[j])
    inch <- as.numeric(gsub(" in.", "", inch))
    shots$puttDistanceLeft[j] <- round(feet + inch/12, 2)
  }
}

for(j in 1:length(shots$shot)){
  shots$shot[j] <- gsub("Shot ", "", shots$shot[j])
  shots$shot[j] <- gsub(" .*", "", shots$shot[j])
}

pb$tick()

shotsT <- rbind(shotsT,shots)
}
shotsFinish <- subset(shotsT, shot!="Player")
shotsFinish$puttDistance <- as.numeric(shotsFinish$puttDistance)
shotsFinish$puttDistanceLeft <- as.numeric(shotsFinish$puttDistanceLeft)
con_sql <- dbConnect(RMySQL::MySQL(), password = 'ticklemehomo', dbname = 'pga')
dbWriteTable(conn = con_sql, name = 'safeway_open_2017', value = shotsFinish)


remDr$screenshot(display=TRUE)
remDr$closeall()
remDr$closeServer()
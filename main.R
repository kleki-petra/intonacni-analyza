library(rPraat)

inputFolderPT <- "data_pt"
inputFolderTG <- "data_tg"

listFiles <- list.files(path = inputFolderPT, pattern = "\\.PitchTier$" , ignore.case = TRUE)
listFilesTG <- list.files(path = inputFolderTG, pattern = "\\.TextGrid$" , ignore.case = TRUE)

tab <- data.frame(file = listFiles)   # table with file names
tab$speaker <- NA
tab$sex <- NA
tab$age <- NA
tab$item <- NA
tab$median <- NA
tab$q5 <- NA
tab$q95 <- NA
tab$r95_5 <- NA # intonační rozpětí
tab$CSI <- NA
tab$durationPT <- NA # trvání na základě PT
tab$durationTG <- NA # trvání na základě TG
tab$syll <- NA
tab$syll_s_PT <- NA # tempo v syll za sekundu na základě pitch tier
tab$syll_s_TG <- NA # tempo v syll za sekundu na základě text gridu

pb <- txtProgressBar(min = 1, max = length(listFiles), initial = 1, style = 3)

for (I in seq_along(listFiles)) {
  setTxtProgressBar(pb, I)
  
  file <- listFiles[I]
  filePitchTier <- paste0(inputFolderPT, "/", file)
  
  casti <- strsplit(file, "_", fixed = TRUE)[[1]]
  tab$speaker[I] <- casti[1]
  tab$sex[I] <- casti[2]
  tab$age[I] <- as.numeric(casti[3])
  tab$item[I] <- strsplit(casti[4], ".", fixed = TRUE)[[1]][1]
  
  pt <- pt.read(filePitchTier)
  pt <- pt.Hz2ST(pt, ref = 50)
  
  tab$median[I] <- median(pt$f)
  tab$q5[I]    <- quantile(pt$f, 0.05)
  tab$q95[I]    <- quantile(pt$f, 0.95)
  tab$r95_5[I] <- tab$q95[I] - tab$q5[I]
  
  ptOrez <- pt.cut(pt, tStart = min(pt$t), tEnd = max(pt$t))
  
  tab$durationPT[I] <- ptOrez$tmax - ptOrez$tmin
    
  if (tab$item[I] == "D") {
    tab$syll[I] <- 26
  } else if (tab$item[I] == "E") {
    tab$syll[I] <- 21
    } else {
        next
  }
  
  CSI <- (sum(abs(diff(ptOrez$f)))) / tab$syll[I]
  tab$CSI[I] <- CSI
  tab$syll_s_PT[I] <- tab$syll[I] / tab$durationPT[I]
    
  fileTG <- substring(file, 1, nchar(file) - 9)
  fileTextGrid <- paste0(inputFolderTG, "/", fileTG, "TextGrid")
  
  if (file.exists(fileTextGrid) == FALSE){
    next
  }
    
  tg <- tg.read(fileTextGrid)
  
  seznam <- c("#SIL#", "#SP#", "")   # různé značení pauzy
  podminka <- !(tg$word$label %in% seznam)
  
  tab$durationTG[I] <- max(tg$word$t2[podminka]) - min(tg$word$t1[podminka])
  tab$syll_s_TG[I] <- tab$syll[I] / tab$durationTG[I]
}

# save results
library(writexl)
write_xlsx(tab, "table.xlsx")

library(dplyr)
tabX <- tab %>% group_by(speaker, age, sex)

tabMean <- tabX %>% summarise(
  median = mean(median),
  r95_5 = mean(r95_5),
  CSI = mean(CSI),
  durationPT = mean(durationPT),
  durationTG = mean(durationTG),
  syll_s_PT = mean(syll_s_PT),
  syll_s_TG = mean(syll_s_TG)
)

# save results
write_xlsx(tabMean, "table_mean.xlsx")

# grafy
library(tidyverse)
library(ggplot2)

ggplot(tabMean, aes(x = age, y = median, color = sex)) +
  geom_point() +
  stat_smooth(method = "lm", level = 0.95)

ggplot(tabMean, aes(x = age, y = r95_5, color = sex)) +
  geom_point() +
  stat_smooth(method = "lm", level = 0.95)

ggplot(tabMean, aes(x = age, y = CSI, color = sex)) +
  geom_point() +
  stat_smooth(method = "lm", level = 0.95)

ggplot(tabMean, aes(x = age, y = syll_s_PT, color = sex)) +
  geom_point() +
  stat_smooth(method = "lm", level = 0.95)

ggplot(tabMean, aes(x = age, y = syll_s_TG, color = sex)) +
  geom_point() +
  stat_smooth(method = "lm", level = 0.95)







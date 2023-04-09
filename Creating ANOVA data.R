#country: CANZUK, OECD w/ CANZUK, and non-OECD; discipline: basic (4) & applied (5)

setwd("H:\\Private\\XuanBa\\VUW\\Research\\Research Projects\\Indicators\\")

library(countrycode)

All_countries_abr <- codelist$iso3c
All_countries_abr <- All_countries_abr[!is.na(All_countries_abr)] #adjusted on 09/05/2022
All_countries_RCs <- rep(0,length(All_countries_abr))
All_countries_RCs_wUSA <- rep(0,length(All_countries_abr))
All_countries_OECDstatus <- rep('',length(All_countries_abr))

CANZUK <- c('AUS', 'CAN', 'GBR', 'NZL')
OECD <- c('AUT', 'BEL', 'CHL', 'CRI', 'CZE', 'DNK', 'EST', 'FIN', 'FRA', 'DEU', 'GRC', 'HUN', 'ISL', 'IRL', 'ISR', 'ITA', 'JPN', 'KOR', 'LUX', 'MEX', 'NLD', 'NOR', 'POL', 'PRT', 'SVK', 'SVN', 'ESP', 'SWE', 'CHE', 'TUR')
#nonCANZUK <- All_countries_abr[!(All_countries_abr %in% CANZUK)]
#nonOECD <- nonCANZUK[!(nonCANZUK %in% OECD)]

for (i in 1:length(All_countries_abr))
{
  if (All_countries_abr[i] %in% CANZUK)
  {
    All_countries_OECDstatus[i] <- 'CANZUK'
  }
  else
  {
      All_countries_OECDstatus[i] <- 'nonCANZUK'  
  }
}


#Processing the main file
# bilateral_file_2015 <- "Dimensions_bilateral_2015.csv"
# output_file <- "Dimensions_bilateral_2015-ANOVA.csv"
# 
# print(paste("Opening bilateral file: ",bilateral_file_2015))
# data <- read.csv(bilateral_file_2015, header = FALSE,sep=",")
# 
# data_nonOECD <- data[!(data[3] %in% OECD)]
# 
# Countries_credits <- c(data$V3, data$V4)
# for (i in 1: length(Countries_credits))
# {
#   position_country <- grep(Countries_credits[i],All_countries_abr) 
#   All_countries_RCs[position_country] <- All_countries_RCs[position_country]+1
# }
# 
# List_1 <- data[data[3]=='USA',]
# List_2 <- data[data[4]=='USA',]
# RCs_wUSA <- c(List_1$V4, List_2$V3)
# OECD_wUSA <- RCs_wUSA[RCs_wUSA %in% OECD]
# for (j in 1: length(RCs_wUSA))
# {
#   position_country <- grep(RCs_wUSA[j],All_countries_abr) 
#   All_countries_RCs_wUSA[position_country] <- All_countries_RCs_wUSA[position_country]+1
# }
# 
# my_data <- cbind(All_countries_abr,All_countries_RCs,All_countries_RCs_wUSA, All_countries_OECDstatus)
# #some steps to produce the nonOECD_shortlist below will be updated

nonOECD_shortlist <- c('CHN','BRA','IND','RUS','TWN','SGP','SAU','ZAF','IRN','ARG','THA','COL','EGY','PAK','MYS','ROU','QAT','UKR','SRB','HRV','ARE','ARM','KEN','GEO','PER','BGR','BLR','LBN','NGA','LTU')

nonOECD <- nonOECD_shortlist

nonCANZUK <- c(OECD,nonOECD)

#Processing the Basic file, CANZUK 
bilateral_file_2015 <- "Dimensions_bilateral_2015-Basic-v2.csv"
output_file <- "Dimensions_bilateral_2015-Basic-CANZUK.csv"

print(paste("Opening bilateral file: ",bilateral_file_2015))
data <- read.csv(bilateral_file_2015, header = FALSE,sep=",")

All_countries_CANZUK <- rep(0,length(CANZUK))
All_countries_CANZUK_wUSA <- rep(0,length(CANZUK))

Countries_credits <- c(data$V3, data$V4)
Countries_credits_CANZUK <- Countries_credits[Countries_credits %in% CANZUK]
for (i in 1: length(Countries_credits_CANZUK))
{
  position_country <- grep(Countries_credits_CANZUK[i],CANZUK) 
  All_countries_CANZUK[position_country] <- All_countries_CANZUK[position_country]+1
}

List_1 <- data[data[3]=='USA',]
List_2 <- data[data[4]=='USA',]
RCs_wUSA <- c(List_1$V4, List_2$V3)
CANZUK_wUSA <- RCs_wUSA[RCs_wUSA %in% CANZUK]
for (j in 1: length(CANZUK_wUSA))
{
  position_country <- grep(CANZUK_wUSA[j],CANZUK) 
  All_countries_CANZUK_wUSA[position_country] <- All_countries_CANZUK_wUSA[position_country]+1
}

#my_data <- cbind(CANZUK,All_countries_CANZUK,All_countries_CANZUK_wUSA)
#write.table(my_data, file = output_file, sep=",",append = T,row.names = F, col.names = F)
Basic_CANZUK <- All_countries_CANZUK_wUSA/All_countries_CANZUK


#Processing the Basic file, nonCANZUK 
bilateral_file_2015 <- "Dimensions_bilateral_2015-Basic-v2.csv"
output_file <- "Dimensions_bilateral_2015-Basic-nonCANZUK.csv"

print(paste("Opening bilateral file: ",bilateral_file_2015))
data <- read.csv(bilateral_file_2015, header = FALSE,sep=",")


All_countries_nonCANZUK <- rep(0,length(nonCANZUK))
All_countries_nonCANZUK_wUSA <- rep(0,length(nonCANZUK))

Countries_credits <- c(data$V3, data$V4)
Countries_credits_nonCANZUK <- Countries_credits[Countries_credits %in% nonCANZUK]
for (i in 1: length(Countries_credits_nonCANZUK))
{
  position_country <- grep(Countries_credits_nonCANZUK[i],nonCANZUK) 
  All_countries_nonCANZUK[position_country] <- All_countries_nonCANZUK[position_country]+1
}

List_1 <- data[data[3]=='USA',]
List_2 <- data[data[4]=='USA',]
RCs_wUSA <- c(List_1$V4, List_2$V3)
nonCANZUK_wUSA <- RCs_wUSA[RCs_wUSA %in% nonCANZUK]
for (j in 1: length(nonCANZUK_wUSA))
{
  position_country <- grep(nonCANZUK_wUSA[j],nonCANZUK) 
  All_countries_nonCANZUK_wUSA[position_country] <- All_countries_nonCANZUK_wUSA[position_country]+1
}

#my_data <- cbind(nonCANZUK,All_countries_nonCANZUK,All_countries_nonCANZUK_wUSA)
#write.table(my_data, file = output_file, sep=",",append = T,row.names = F, col.names = F)
Basic_nonCANZUK <- All_countries_nonCANZUK_wUSA/All_countries_nonCANZUK


#Processing the Applied file, CANZUK 
bilateral_file_2015 <- "Dimensions_bilateral_2015-Applied-v2.csv"
output_file <- "Dimensions_bilateral_2015-Applied-CANZUK.csv"

print(paste("Opening bilateral file: ",bilateral_file_2015))
data <- read.csv(bilateral_file_2015, header = FALSE,sep=",")

All_countries_CANZUK <- rep(0,length(CANZUK))
All_countries_CANZUK_wUSA <- rep(0,length(CANZUK))

Countries_credits <- c(data$V3, data$V4)
Countries_credits_CANZUK <- Countries_credits[Countries_credits %in% CANZUK]
for (i in 1: length(Countries_credits_CANZUK))
{
  position_country <- grep(Countries_credits_CANZUK[i],CANZUK) 
  All_countries_CANZUK[position_country] <- All_countries_CANZUK[position_country]+1
}

List_1 <- data[data[3]=='USA',]
List_2 <- data[data[4]=='USA',]
RCs_wUSA <- c(List_1$V4, List_2$V3)
CANZUK_wUSA <- RCs_wUSA[RCs_wUSA %in% CANZUK]
for (j in 1: length(CANZUK_wUSA))
{
  position_country <- grep(CANZUK_wUSA[j],CANZUK) 
  All_countries_CANZUK_wUSA[position_country] <- All_countries_CANZUK_wUSA[position_country]+1
}

#my_data <- cbind(CANZUK,All_countries_CANZUK,All_countries_CANZUK_wUSA)
#write.table(my_data, file = output_file, sep=",",append = T,row.names = F, col.names = F)
Applied_CANZUK <- All_countries_CANZUK_wUSA/All_countries_CANZUK


#Processing the Applied file, nonCANZUK 
bilateral_file_2015 <- "Dimensions_bilateral_2015-Applied-v2.csv"
output_file <- "Dimensions_bilateral_2015-Applied-nonCANZUK.csv"

print(paste("Opening bilateral file: ",bilateral_file_2015))
data <- read.csv(bilateral_file_2015, header = FALSE,sep=",")


All_countries_nonCANZUK <- rep(0,length(nonCANZUK))
All_countries_nonCANZUK_wUSA <- rep(0,length(nonCANZUK))

Countries_credits <- c(data$V3, data$V4)
Countries_credits_nonCANZUK <- Countries_credits[Countries_credits %in% nonCANZUK]
for (i in 1: length(Countries_credits_nonCANZUK))
{
  position_country <- grep(Countries_credits_nonCANZUK[i],nonCANZUK) 
  All_countries_nonCANZUK[position_country] <- All_countries_nonCANZUK[position_country]+1
}

List_1 <- data[data[3]=='USA',]
List_2 <- data[data[4]=='USA',]
RCs_wUSA <- c(List_1$V4, List_2$V3)
nonCANZUK_wUSA <- RCs_wUSA[RCs_wUSA %in% nonCANZUK]
for (j in 1: length(nonCANZUK_wUSA))
{
  position_country <- grep(nonCANZUK_wUSA[j],nonCANZUK) 
  All_countries_nonCANZUK_wUSA[position_country] <- All_countries_nonCANZUK_wUSA[position_country]+1
}

#my_data <- cbind(nonCANZUK,All_countries_nonCANZUK,All_countries_nonCANZUK_wUSA)
#write.table(my_data, file = output_file, sep=",",append = T,row.names = F, col.names = F)
Applied_nonCANZUK <- All_countries_nonCANZUK_wUSA/All_countries_nonCANZUK



AffinityIndex <- c(Basic_CANZUK, Basic_nonCANZUK, Applied_CANZUK, Applied_nonCANZUK)*100
country <- factor(rep(rep(c('CANZUK', 'non-OECD'),c(4,60)), times=2))
discipline <- factor(c(rep(c('Basic', 'Applied'), c(64,64))))
IRC.ANOVA <- aov(AffinityIndex ~ country*discipline)
summary(IRC.ANOVA)


plot(x=IRC.ANOVA$fitted.values, y = IRC.ANOVA$residuals)
abline(h=0, lty=2)

qqnorm(IRC.ANOVA$residuals)
qqline(IRC.ANOVA$residuals)

logIRC.ANOVA <- aov(log(AffinityIndex) ~ discipline*country)
summary(logIRC.ANOVA)

plot(x=logIRC.ANOVA$fitted.values, y = logIRC.ANOVA$residuals)
abline(h=0, lty=2)

qqnorm(logIRC.ANOVA$residuals)
qqline(logIRC.ANOVA$residuals)

interaction.plot(x.factor = country, trace.factor = discipline, fun=mean, response = log(AffinityIndex))


Sys.time()

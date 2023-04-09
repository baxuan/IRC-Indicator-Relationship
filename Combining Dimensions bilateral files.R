#Basic (4): Mathematical Sciences, Physical Sciences, Chemical Sciences, and Earth Sciences
#Applied (5): Agricultural and Veterinary Sciences, Information and Computing Sciences, Engineering, Technology, and Medical and Health Sciences

setwd("H:\\Private\\XuanBa\\VUW\\Research\\Research Projects\\Indicators\\")

Sys.time()

substrRight <- function(x, n){
  substr(x, nchar(x)-n+1, nchar(x))}

substrLeft = function(text, num_char) {
  substr(text, 1, num_char)
}


basic_file_2015 <- "Dimensions_bilateral_2015-Basic-v2.csv"
file_folder <-"H:\\Private\\XuanBa\\VUW\\Research\\Research Projects\\Indicators\\server\\Basic\\"

file_list <- list.files(file_folder)

for (file in file_list)
{
  print(paste("Processing file: ",file))
  current_file <- paste(file_folder,file, sep='')
  data <- read.csv(current_file, header = FALSE,sep=",")
  year2015_data <- data[substrRight(substrLeft(data$V1,29),4)=="2015" ,]
  year2015_data <- year2015_data[,!names(year2015_data)=="V2"]
  write.table(year2015_data, file = basic_file_2015, sep=",",append = T,row.names = F, col.names = F)
}



applied_file_2015 <- "Dimensions_bilateral_2015-Applied-v2.csv"
file_folder <-"H:\\Private\\XuanBa\\VUW\\Research\\Research Projects\\Indicators\\server\\Applied\\"

file_list <- list.files(file_folder)

for (file in file_list)
{
  print(paste("Processing file: ",file))
  current_file <- paste(file_folder,file, sep='')
  data <- read.csv(current_file, header = FALSE,sep=",")
  year2015_data <- data[substrRight(substrLeft(data$V1,29),4)=="2015" ,]
  year2015_data <- year2015_data[,!names(year2015_data)=="V2"]
  write.table(year2015_data, file = applied_file_2015, sep=",",append = T,row.names = F, col.names = F)
}

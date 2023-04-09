
setwd("H:\\Private\\XuanBa\\VUW\\Research\\Research Projects\\Indicators\\")

library(countrycode)

current_folder <-"H:\\Private\\XuanBa\\VUW\\Research\\Research Projects\\Indicators\\server\\old\\results\\"

file_list <- list.files(current_folder)
print("List of files to process: ")
print(list_file)

bilateral_file_2015 <- "Dimensions_bilateral_2015.csv"

All_countries_abr <- codelist$iso3c
All_countries_abr <- All_countries_abr[!is.na(All_countries_abr)] #adjusted on 09/05/2022
All_countries_count <- rep(0,length(All_countries_abr))

for (file in file_list)
{
  print(paste("Processing file: ",file))
  current_file <- paste(current_folder,file, sep='')
  data <- read.csv(current_file, header = FALSE,sep=",")
  year2015_data <- data[substrRight(substrLeft(data$V1,29),4)=="2015" ,]
  year2015_data <- year2015_data[,!names(year2015_data)=="V2"]
  
  n_row <- nrow(year2015_data)
  
  i <- 1
  while (i <= n_row)
    All_countries_count_temp <- rep(0,length(All_countries_abr)) # added on 09/05/2022
    Country_list <- year2015_data$V5[i]
    #print(Country_list)
    
    if (!is.null(Country_list))
    {
      if ((Country_list!="") & (!is.na(Country_list)))
      {
        for (j in 1: length(All_countries_abr)) # update counts to All_countries_count_temp for this i iteration
        {
          position_country <- grep(All_countries_abr[j],Country_list)
          if (length(position_country)>0)
          {
            All_countries_count_temp[j] <- 1 #edited on 11/05/2022
            #print(All_countries_abr[j])
          }
        }
        if (sum(All_countries_count_temp)>1) #there are more than one country involved in the research collaboration
        {
          #Updating number of documents by country involved
          All_countries_count <- All_countries_count + All_countries_count_temp
          #print(All_countries_count)
          
          
          #Updating number of documents by document type
          doc_type <- CANZUK_19512017_df[i,2]
          position_doc_type <- which(All_doc_type==doc_type)
          All_doc_type_count[position_doc_type] <- All_doc_type_count[position_doc_type] +1
          
          #Updating number of documents in the three periods (1951-1980, 1981-2000, 2001-2017) in the MAG dataset
          if ((CANZUK_19512017_df[i,1]<=1950)) #double check
          {
            N_o_document_before_1951 <- N_o_document_before_1951 +1
          }else
            if ((CANZUK_19512017_df[i,1]>1950) & (CANZUK_19512017_df[i,1]<=1980))
            {
              N_o_document_1951_1980 <- N_o_document_1951_1980 +1
            }else
              if ((CANZUK_19512017_df[i,1]>1980) & (CANZUK_19512017_df[i,1]<=2000))
              {
                N_o_document_1981_2000 <- N_o_document_1981_2000 +1
              }else
                if ((CANZUK_19512017_df[i,1]>2000) & (CANZUK_19512017_df[i,1]<=2017))
                {
                  N_o_document_2001_2017 <- N_o_document_2001_2017 +1
                }else
                  if ((CANZUK_19512017_df[i,1]>2017))
                  {
                    N_o_document_after_2017 <- N_o_document_after_2017 +1
                  }
        }
      }
    }
    i <- i+1
    #readline()
  }
  
  Sys.time()
  
}

All_countries_abr_df <- data.frame(matrix(unlist(All_countries_abr), nrow=length(All_countries_abr), byrow=TRUE),stringsAsFactors=FALSE)
Documents_per_country_df <- cbind(All_countries_abr_df,All_countries_count)
colnames(Documents_per_country_df) <- c("Country","Number of documents")
write.csv(Documents_per_country_df,"Documents_per_country_CANZUK_19512017_IRC_revised.csv",row.names = FALSE)


All_doc_type_df <- data.frame(matrix(unlist(All_doc_type), nrow=length(All_doc_type), byrow=TRUE),stringsAsFactors=FALSE)
Documents_per_doc_type_df <- cbind(All_doc_type_df,All_doc_type_count)
colnames(Documents_per_doc_type_df) <- c("Doc_type","Number of documents")
write.csv(Documents_per_doc_type_df,"Documents_per_doc_type_CANZUK_19512017_IRC_revised.csv",row.names = FALSE)

Period_name <- c("-1951", "1951-1980","1981-2000","2001-2017","2018-")
Period_count <- c(N_o_document_before_1951, N_o_document_1951_1980, N_o_document_1981_2000, N_o_document_2001_2017, N_o_document_after_2017)
Documents_per_period_df <- cbind(Period_name,Period_count)
colnames(Documents_per_period_df) <- c("Period","Number of documents")
write.csv(Documents_per_period_df,"Documents_per_period_CANZUK_19512017_IRC_revised.csv",row.names = FALSE)

Sys.time()

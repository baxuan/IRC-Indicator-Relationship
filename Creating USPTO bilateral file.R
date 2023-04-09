
setwd("D:\\Private stuff\\USPTO\\")

Sys.time()
library(jsonlite)            	# for opening json files
library(countrycode)        	# for identifying countries' names
#library(zipcode)              # for identifying the US's zip codes
library(stringr)            	# for processing strings
library(dplyr)			          # for grouping and summarizing
library(RCurl)			          # for composing general HTTP requests

current_folder <- "D:\\Private stuff\\USPTO\\results\\"

substrRight <- function(x, n){
  substr(x, nchar(x)-n+1, nchar(x))}

substrLeft = function(text, num_char) {
  substr(text, 1, num_char)
}

file_list <- list.files(current_folder)
rev_file_list <- rev(file_list)

for (file in rev_file_list)
{
  current_file <- paste(current_folder,file, sep='')
  #bilateral_file <- paste(substrLeft(file, (nchar(file)-5)),"_bilateral.csv",sep="")
  bilateral_file <- "USPTO_bilateral.csv"
  for_test_errors <- "USPTO_errors.txt"
  stored_year <- substrLeft(file, 4)
  print(current_file)
  con = file(current_file, "r")
  while ( TRUE ) 
  {
    line = readLines(con, n = 1)
    if ( length(line) == 0 ) {
      break
    }
    
    patent_list <- NULL 
    #patent_list <- jsonlite::fromJSON(line)
    mod1 <- try({
      patent_list <- jsonlite::fromJSON(line)
    }, TRUE)
    
    if(isTRUE(class(mod1)=="try-error")) 
    { 
      print(paste('Error in determining country of ',p_address))
      write.table(data.frame(file, stringsAsFactors = F), file = for_test_errors, sep=",",append = T,row.names = F, col.names = F)
    } 
    else 
    { 
    
    n_patent <- nrow(patent_list)
    if (is.null(n_patent))
    {
      n_patent <- 0
    }
    if (n_patent>0)
    {
      for (i in 1:n_patent)
      {
        p_year <-""
        p_n_country <- 0
        Country1 <- ""
        Country2 <- ""
        
        #print("Patent: ")
        #print(patent_list$inventors[i][[1]]$country)
        if (length(patent_list$inventors[i][[1]]$country)>1)
        {
        if (!is.null(patent_list$bibliographic_information[i,]$date))
        {
          p_year <- substrLeft(patent_list$bibliographic_information[i,]$date,4)
        }
        # na_posiotions <- which(is.na(patent_list$inventors[i][[1]]$country))
        # if (length(na_posiotions)>0)
        # {
        #   for (l in 1:length(na_posiotions))
        #   {
        #     if (!is.na(patent_list$inventors[i][[1]]$state[c(na_posiotions[l])]) | !is.na(patent_list$inventors[i][[1]]$city[c(na_posiotions[l])]))
        #     {
        #       p_address <- paste(patent_list$inventors[i][[1]]$city[c(na_posiotions[l])], "," , patent_list$inventors[i][[1]]$state[c(na_posiotions[l])])
        #       
        #         
        #       my_query <- paste('https://query.wikidata.org/sparql?format=json&query=',RCurl::curlEscape(paste('PREFIX
        #                                                                                                            schema: <http://schema.org/> PREFIX wdt:
        #                                                                                                            <http://www.wikidata.org/prop/direct/> SELECT ?countryLabel WHERE
        #                                                                                                            {<https://en.wikipedia.org/wiki/',gsub(' ','_',gsub("\\|","",gsub("\\\\","",p_address))),'> schema:about
        #                                                                                                            ?datalink. ?datalink wdt:P17 ?country. SERVICE wikibase:label {
        #                                                                                                            bd:serviceParam wikibase:language "en" .}}',sep='')),sep='')
        #       mod2 <- try({
        #           country_label <- fromJSON(url(my_query))
        #         }, TRUE)
        #         
        #       if(isTRUE(class(mod2)=="try-error")) 
        #         { 
        #         print(paste('Error in determining country of ',p_address))
        #         #readline()
        #         } 
        #         else { 
        #           if(length(country_label$results$bindings$countryLabel$value) >0){
        #             country_name <- country_label$results$bindings$countryLabel$value[1]
        #             country_code <- countrycode(country_name, 'country.name', 'iso2c')
        #             
        #             print(paste('Original country list: ',patent_list$inventors[i][[1]]$country))
        #             patent_list$inventors[i][[1]]$country <- replace(patent_list$inventors[i][[1]]$country,l,country_code)  
        #             print(paste('New country list: ',patent_list$inventors[i][[1]]$country))          
        #             #readline()
        #           }
        #           else
        #           {
        #             print(paste('Error in determining country of ',p_address))
        #             #readline()
        #           }
        #         } 
        #     }
        #   }
        # }
        
        country_list <- patent_list$inventors[i][[1]]$country
        notna_country_list <- country_list[!is.na(country_list)]
        unique_country_list <- unique(notna_country_list)
        n_country <- length(unique_country_list)
        p_n_country <- n_country
        if (n_country>1)
        {
          #print("list of unique countries: ")
          #print(unique_country_list)
          if (length(patent_list$inventors[i][[1]]$country)!=length(unique_country_list))
          {
            #readline()
          }
          for (m in 1:(n_country-1))
            for (n in (m+1):n_country)
            {
              Country1 <- unique_country_list[m]
              Country2 <- unique_country_list[n]
              if (Country1!=Country2)
              {
                if (Country1>Country2)
                {
                  temp <- Country1
                  Country1 <- Country2
                  Country2 <- temp
                }
                write.table(data.frame(file, stored_year, p_year, p_n_country, Country1, Country2, stringsAsFactors = F), file = bilateral_file, sep=",",append = T,row.names = F, col.names = F)
              }
            }
          #readline()
        }
        #readline()
      }
      }
    }
  }#else
  }
  close(con)
}

Sys.time()


setwd("D:\\")

Sys.time()
library(jsonlite)            	# for opening json files
library(countrycode)        	# for identifying countries' names
#library(zipcode)              # for identifying the US's zip codes
library(stringr)            	# for processing strings
library(dplyr)			          # for grouping and summarizing
#library(RCurl)			          # for composing general HTTP requests

discipline <- "01"
current_folder <- paste("H:\\Dimensions\\Round 5\\",discipline,"\\", sep='')

substrRight <- function(x, n){
  substr(x, nchar(x)-n+1, nchar(x))}

substrLeft = function(text, num_char) {
  substr(text, 1, num_char)
}

file_list <- list.files(current_folder)

for (file in file_list)
{
  current_file <- paste(current_folder,file, sep='')
  bilateral_file <- paste("Dimensions_bilateral_",discipline,".csv",sep='')
  for_test_errors <- paste("Dimensions_errors_", discipline, ".txt",sep='')
  p_year <- substrLeft(substrRight(file,8), 4)
  print(current_file)
  con = file(current_file, "r")
  while ( TRUE ) 
  {
    line = readLines(con, n = 1)
    if ( length(line) == 0 ) {
      break
    }
    
    publication_list <- NULL 
    #publication_list <- jsonlite::fromJSON(line)
    mod1 <- try({
      publication_list <- jsonlite::fromJSON(line)
    }, TRUE)
    
    if(isTRUE(class(mod1)=="try-error")) 
    { 
      print(paste('Error in determining country of ',p_address))
      write.table(data.frame(file, stringsAsFactors = F), file = for_test_errors, sep=",",append = T,row.names = F, col.names = F)
    } 
    else 
    { 
    
    n_publication <- nrow(publication_list)
    if (is.null(n_publication))
    {
      n_publication <- 0
    }
    if (n_publication>0)
    {
      for (i in 1:n_publication)
      {
        p_n_country <- 0
        Country1 <- ""
        Country2 <- ""
        
        p_n_affiliation <- length(publication_list$author_affiliations[i][[1]][[1]]$affiliations)
        
        if (p_n_affiliation>1)
        {
        # na_posiotions <- which(is.na(publication_list$inventors[i][[1]]$country))
        # if (length(na_posiotions)>0)
        # {
        #   for (l in 1:length(na_posiotions))
        #   {
        #     if (!is.na(publication_list$inventors[i][[1]]$state[c(na_posiotions[l])]) | !is.na(publication_list$inventors[i][[1]]$city[c(na_posiotions[l])]))
        #     {
        #       p_address <- paste(publication_list$inventors[i][[1]]$city[c(na_posiotions[l])], "," , publication_list$inventors[i][[1]]$state[c(na_posiotions[l])])
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
        #             print(paste('Original country list: ',publication_list$inventors[i][[1]]$country))
        #             publication_list$inventors[i][[1]]$country <- replace(publication_list$inventors[i][[1]]$country,l,country_code)  
        #             print(paste('New country list: ',publication_list$inventors[i][[1]]$country))          
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
        
        affiliation_list <- publication_list$author_affiliations[i][[1]][[1]]$affiliations
        country_list <- NULL
        for (j in 1:p_n_affiliation)
        {
          country_list <- c(country_list,publication_list$author_affiliations[i][[1]][[1]]$affiliations[[j]]$country)
        }
        notna_country_list <- country_list[!is.na(country_list)]
        unique_country_list <- unique(notna_country_list)
        n_country <- length(unique_country_list)
        p_n_country <- n_country
        if (n_country>1)
        {
          #print("list of unique countries: ")
          #print(unique_country_list)
          if (length(publication_list$inventors[i][[1]]$country)!=length(unique_country_list))
          {
            #readline()
          }
          for (m in 1:(n_country-1))
            for (n in (m+1):n_country)
            {
              Country1 <- countrycode(unique_country_list[m], 'country.name', 'iso3c')
              Country2 <- countrycode(unique_country_list[n], 'country.name', 'iso3c')
              if (Country1!=Country2)
              {
                if (Country1>Country2)
                {
                  temp <- Country1
                  Country1 <- Country2
                  Country2 <- temp
                }
                write.table(data.frame(file, p_year, p_n_country, Country1, Country2, stringsAsFactors = F), file = bilateral_file, sep=",",append = T,row.names = F, col.names = F)
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

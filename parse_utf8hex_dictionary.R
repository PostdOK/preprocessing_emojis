#Goal of this script is to download a new utf8hex-dictionary and prepare it for my script_dictionary_unicode function

#First
#Extract utf8hex-dictionaries e.g. from www.utf8-chartable.de. (Credits to Micha Koellerwirth)
#needs rvest packake
library(rvest)

#For this example I dowload the dingbats dictionary. Rather spoken, I want to have the third table of this site
#Note: at utf8-chartable it is always the third table, if you use the default settings
UTF_Page<-read_html("https://www.utf8-chartable.de/unicode-utf8-table.pl?start=9984")
tables_UTF_Page <- html_nodes(UTF_Page, "table")
table_UTF.df <- UTF_Page %>%
  html_nodes("table") %>%
  .[[3]] %>%
  html_table(fill = TRUE)

#Second
#Convert table to the style I need for my function add_new_dictionary. 
#Note: I remove the "character"-column and rows without a description
colnames(table_UTF.df)[1]<-"unicode"
colnames(table_UTF.df)[3]<-"r_encoding"
colnames(table_UTF.df)[4]<-"description"
table_UTF.df<-table_UTF.df[nchar(table_UTF.df$description)>0,]
table_UTF.df<-table_UTF.df[c("description","r_encoding","unicode")]
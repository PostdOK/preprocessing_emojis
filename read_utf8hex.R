read_utf8hex<-function(dataframe_w_text, ascii_TRUE = TRUE){
  #Converts utf8hex into "*description of utf8hex* " style
  #needs data.frame with a text column and information (TRUE, FALSE) if text has been transformed to ascii already
  #needs packages stringr, dplyr
  
  #transformation to ascii if it has not happened yet
  if (ascii_TRUE==FALSE){
    dataframe_w_text$text<-iconv(dataframe_w_text$text, from = "latin1", to = "ascii", sub = "byte")
  }
  
  #The actual transforming loops. Pretty time consuming, but haven’t found a better solution yet.
  #In addition: emojis now can consist of sequences of utf8hex codepoints
  #These codepoints could stand alone as well
  #Thus, the dictionary is sorted by the length of the complete utf8hex codes in decreasing order
  for (i in 1:nrow(dataframe_w_text)){
    if (str_count(dataframe_w_text$text[i],"<")>0){
      for (j in 1:nrow(emDict_raw)){
        dataframe_w_text$text[i]<-gsub(emDict_raw$r_encoding[j],paste("*",emDict_raw$description[j],"* ",sep = ""),dataframe_w_text$text[i])
      }
    }
  }
  
  return(dataframe_w_text)
}
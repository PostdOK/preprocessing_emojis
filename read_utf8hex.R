read_utf8hex<-function(dataframe_w_text, ascii_TRUE = TRUE){
  #Converts utf8hex into "*description of utf8hex* " style
  #needs data.frame with a text column and information (TRUE, FALSE) if text has been transformed to ascii already
  #needs packages stringr, dplyr
  
  #transformation to ascii if it has not happened yet
  if (ascii_TRUE==FALSE){
    dataframe_w_text$text<-iconv(dataframe_w_text$text, from = "latin1", to = "ascii", sub = "byte")
  }
  
  #convert emojis (or other utf8hex elements) to a description of them
  #emojis now can consist of sequences of utf8hex codepoints
  #These codepoints could stand alone as well. Thus, one has to proceed from "long" to "short"
  for (i in 1:nrow(dataframe_w_text)){
    if (str_count(dataframe_w_text$text[i],"<")>0){
      tweet_w_emoji<-dataframe_w_text$text[i]
      #look for patterns that can be codepoint. I suggest to look for connections between codepoints
      connections<-gregexpr("><",tweet_w_emoji)
      #Check, if there is text between emojis, which is the case if there are more than four characters between two connections
      #This information is then stored in "splits"
      connections_schub<-connections[[1]][2:length(connections[[1]])]
      connections_check<-connections_schub-connections[[1]][1:length(connections_schub)]
      splits<-which(connections_check!=4)
      #Using splits, we define the positions where we expect emojis (or other utf8hex elements)
      emojisPosition<-list()
      if (length(splits)>0){
        splits[length(splits)+1]<-length(connections[[1]])
        emojisPosition[[1]]<-c((connections[[1]][1])-3,(connections[[1]][splits[1]])+4)
        j=2
        while (j <= length(splits)){
          emojisPosition[[j]]<-c(connections[[1]][splits[j-1]+1]-3,connections[[1]][splits[j]]+4)
          j=j+1
        }
      } else {emojisPosition[[1]]<-c(connections[[1]][1]-3,connections[[1]][length(connections[[1]])]+4)}
      #We then look for the emojis in each position and substitute them, if they are in our dictionary
      #CorrectPosition is necessary, as the position of the emojis (or other utf8hex elements) can change because of that
      CorrectPosition=0
      for (k in 1:length(emojisPosition)){
        emojisPosition[[k]][1]=emojisPosition[[k]][1]+CorrectPosition
        emojisPosition[[k]][2]=emojisPosition[[k]][2]+CorrectPosition
        str_before=ifelse(emojisPosition[[k]][1]==1,"",substr(tweet_w_emoji,1,emojisPosition[[k]][1]-1))
        str_after<-ifelse(emojisPosition[[k]][2]==nchar(tweet_w_emoji),"",substr(tweet_w_emoji,emojisPosition[[k]][2]+1,nchar(tweet_w_emoji)))
        m=NA
        solved=0
        wholesplit<-substr(tweet_w_emoji,emojisPosition[[k]][1],emojisPosition[[k]][2])
        remainder<-wholesplit
        while (nchar(remainder)>=4){
          m=match(remainder,emDict_raw$r_encoding)
          emoji=ifelse(!is.na(m),paste(" *",emDict_raw$description[m],"* ",sep = ""),NA)
          if (!is.na(emoji)){
            solved=solved+nchar(remainder)
            tweet_w_emoji<-paste(str_before,emoji,str_after,sep = "")
            str_before<-paste(str_before,emoji,sep = "")
          }
          remainder=ifelse(is.na(emoji),substr(remainder,1,nchar(remainder)-4),substr(wholesplit,solved+1,nchar(wholesplit)))
        }
        CorrectPosition<-nchar(str_before)-emojisPosition[[k]][2]
      }
      dataframe_w_text$text[i]=tweet_w_emoji
    }
  }
  
  return(dataframe_w_text)
}

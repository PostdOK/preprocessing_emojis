#Required packages and settings. Note, stringAsFactors=FALSE will soon be the default for R
library(dplyr)
library(stringr)
options(stringsAsFactors = FALSE)

# download and prepare a dictionary. if you use a dictionary you downloaded and added with my parse_utf8hex_dictionary
# and add_new_dictionary functions you can skip until line 43.
# for this example, I use the dictionary of Jessica aka “today-is-a-good-day”
# (https://github.com/today-is-a-good-day)
# you can download it this way (note that I drop some columns, as did Jessica):

emoji_Dictionary <-
  read.csv2(
    "https://raw.githubusercontent.com/today-is-a-good-day/emojis/master/emojis.csv"
  ) %>%
  select(description = EN, r_encoding = utf8, unicode)

# Now, as I revise the dictionary for my purposes, the script becomes quite different
# Thus, double-check if you use Jessica’s script
# Steps
# Step 1: As this is a text classification problem, I want to have each emoji as one word, looking like this
# *winking_face*
# Thus, I add underscores instead of spaces and remove colons
emoji_Dictionary$description<-gsub(" ","_",emoji_Dictionary$description)
emoji_Dictionary$description<-gsub(":","",emoji_Dictionary$description)

# Step 2: I drop those lines that only include the translation for skin tones. 
# Note that I keep the information for all other rows
skin_tones <- c("light_skin_tone", 
                "medium-light_skin_tone", 
                "medium_skin_tone",
                "medium-dark_skin_tone", 
                "dark_skin_tone")
emoji_Dictionary <- emoji_Dictionary %>%
  filter(!description %in% skin_tones)

# Step 3: Clean dictionary
# In this dictionary ' is masked as â€™, " as â€œ or â€ (Mojibakes). I convert them all to '
emoji_Dictionary$description<-gsub("â€™","'",emoji_Dictionary$description)
emoji_Dictionary$description<-gsub("â€œ","'",emoji_Dictionary$description)
emoji_Dictionary$description<-gsub("â€","'",emoji_Dictionary$description)

# Preparing the text and the dictionary.
#
# text is just converted to ASCII.
#
# For the dictionary I add a column with the length of each string to sort them.
# This is important because emojis now can consist of sequences of utf8hex codepoints, which could stand alone as well.
# Thus, the dictionary is sorted by the length of the complete utf8hex codes in decreasing order
text<-iconv(text, from = "latin1", to = "ascii", sub = "byte")
emoji_Dictionary[,"nCharDescp"]<-nchar(emoji_Dictionary$r_encoding)
emoji_Dictionary<-emoji_Dictionary[order(emoji_Dictionary$nCharDescp, decreasing = TRUE),]

# Now I can transform all emojis into the desired form, using my ugly loop. I promise to fix that soon
for (i in 1:nrow(emoji_Dictionary)){
  if (str_count(emoji_Dictionary$text[i],"<")>0){
    for (j in 1:nrow(emDict_raw)){
      emoji_Dictionary$text[i]<-gsub(emDict_raw$r_encoding[j],paste("*",emDict_raw$description[j],"* ",sep = ""),emoji_Dictionary$text[i])
    }
  }
}

# Manual replacing 
# Sometimes things need to be transformed manually. Here are some examples:
# 
# Example 1: remove variation selectors. except you need the information -> then replace
# e.g. the text style variation selector (15)
emoji_Dictionary$description<-gsub("<ef><b8><8e>","",emoji_Dictionary$description)
# Example 2: Letters with accent or diaeresis. If there is a dictionary out there, please let me know
# e.g. accent aigu (acute accent) over e and diaeresis over o
emoji_Dictionary$description<-gsub("<c3><a8>","e",emoji_Dictionary$description)
emoji_Dictionary$description<-gsub("<c3><b6>","o",emoji_Dictionary$description)
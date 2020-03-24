add_new_unicode_dictionary <-
  function(newDictionary, existingDictionary) {
    #Add new unicode dictionary, after importing it from csv or url
    #Must have with the three columns unicode, r_encoding, description
    #needs dplyr package
    library(dplyr)
    
    #convert import into ascii-form
    newDictionary$description <- tolower(newDictionary$description)
    newDictionary$description <- gsub(" ", "_", newDictionary$description)
    newDictionary$r_encoding <- gsub(" ", "><", newDictionary$r_encoding)
    newDictionary$r_encoding <-
      paste("<", newDictionary$r_encoding, ">", sep = "")
    #I add an nCharDescp column to enable correct processing later.
    #See read_emojis.R and read_utf8hex.R for further information
    newDictionary[, "nCharDescp"] <- nchar(newDictionary$r_encoding)
    #reorder columns to the order I use for the existing dictionary
    newDictionary <-
      newDictionary[c("description", "r_encoding", "unicode", "nCharDescp")]
    
    #add to existing dictionary
    StartAdd <- nrow(existingDictionary) + 1
    EndAdd <- nrow(existingDictionary) + nrow(newDictionary)
    existingDictionary[StartAdd:EndAdd, ] <- newDictionary[1:EndAdd, ]
    #remove duplicates (if any)
    existingDictionary <- existingDictionary %>%
      distinct(r_encoding, .keep_all = TRUE)
    
    #resort and return supplemented dictionary
    #see read_emojis.R and read_utf8hex.R for further information
    existingDictionary <-
      existingDictionary[order(existingDictionary$nCharDescp, decreasing = TRUE), ]
    return(existingDictionary)
  }
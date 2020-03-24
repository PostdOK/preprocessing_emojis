# preprocessing_emojis
Scripts to preprocess text data that includes emojis and other special characters.

## Goal
Preprocess text data, mostly tweets, that includes **emojis** and other special characters, e.g. **dingbats** or **Mathematical Alphanumeric Symbols**. I started to do so for automated text classification issues, but it can be used for a variety of text mining issues, including all the fancy low level stuff like *wordclouds* or *term frequencies*

## Content
This repository includes lots of code to extent or build utf8hex-dictionaries, as well as some dictionaries as .csv-files, and code to preprocess emojis and other special characters for text mining purposes.

My starting point for utf8hex-dictionaries was the dictionary of “today-is-a-good-day” (https://github.com/today-is-a-good-day), which you can find here: https://github.com/today-is-a-good-day/emojis/blob/master/emojis.csv

For the preprocessing there was no starting point in terms of existing code.

### Extend (or build) dictionaries
The Script ***parse_utf8hex_dictionary.R*** can be used to parse dictionaries from https://www.utf8-chartable.de (Credits to Micha Köllerwirth). However, it can be customized for other sources as well.

The function ***add_new_dictionary.R*** is adding new utf8hex-dictionaries to existing utf8hex-dictionaries. 

### Transform text with emojis and other sc
The functions ***read_emojis.R*** (not uploaded yet) and ***read_utf8hex.R*** transforms utf8hex codes into text that can be used for text mining purposes, especially automated text classification. read_emojis.R is equal to read_utf8hex.R - I added it as an extra file with a different name to improve visibility.

I'll also add a script dealing with further issues manually in the near future.

## Further Notes
I'll share my text classification scripts after the respective research is published, if possible.

# sort bibliography

library(RefManageR)

mybib <- ReadBib("multilevel-thinking.bib")

mybib <- sort(mybib, sorting = "nyt") # sort by name - year - title

WriteBib(mybib, file = "multilevel-thinking.bib")

# use pandoc to convert to PDF

# getwd()
# 
# library(rmarkdown)
# 
# list.files (path = "./docs")
# 
# 
# pandoc_convert(input = "/Users/agrogan/Desktop/GitHub/multilevel-thinking/docs/Multilevel-Thinking.docx",
#                # to = "pdf",
#                output = "/Users/agrogan/Desktop/GitHub/multilevel-thinking/docs/Multilevel-Thinking.pdf")
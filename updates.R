# use pandoc to conver to PDF

getwd()

library(rmarkdown)

list.files (path = "./docs")


pandoc_convert(input = "/Users/agrogan/Desktop/GitHub/multilevel-thinking/docs/Multilevel-Thinking.docx",
               # to = "pdf",
               output = "/Users/agrogan/Desktop/GitHub/multilevel-thinking/docs/Multilevel-Thinking.pdf")
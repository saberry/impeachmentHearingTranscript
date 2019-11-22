library(rvest)

# All transcripts from rev.com #

taylorKentTestimony <- "https://www.rev.com/blog/impeachment-hearings-first-day-transcript-bill-taylor-george-kent-testimony-transcript"

yovanovitchTestimony <- "https://www.rev.com/blog/impeachment-hearing-transcript-day-2-marie-yovanovitch-testimony"

vindmanWilliamsTestimony <- "https://www.rev.com/blog/impeachment-hearing-day-3-transcript-alexander-vindman-jennifer-williams-testify"

volkerMorrisonTestimony <- "https://www.rev.com/blog/impeachment-hearing-day-3-transcript-kurt-volker-tim-morrison-testify"

sondlandTestimony <- "https://www.rev.com/blog/impeachment-hearing-day-4-transcript-gordon-sondland-testifies"

hillHolmesTestimony <- "https://www.rev.com/blog/impeachment-hearing-day-5-transcript-fiona-hill-and-david-holmes-testimony"

allLinks <- ls(pattern = "Testimony$")

textParse <- function(link) {
  
  link <- eval(as.name(link))
  
  out <- read_html(link) %>% 
    html_nodes("p") %>% 
    html_text() %>% 
    .[which(grepl("\\([0-9]{2}:[0-9]{2}\\)", .))] %>% 
    data.frame(original = ., 
               person = regmatches(., regexpr(".*(?=:\\s\\([0-9])", ., perl = TRUE)),
               timeStamp = regmatches(., regexpr("(?<=\\()[0-9]{2}:[0-9]{2}(?=\\))", ., perl = TRUE)),
               comment = regmatches(., regexpr("(?<=\\([0-9]{2}:[0-9]{2}\\)\\s).*", ., perl = TRUE)),
               stringsAsFactors = FALSE)
  
  return(out)
}

allResults <- lapply(allLinks, function(x) textParse(x))


mapply(write.csv, x = allResult, file = paste("data/", allLinks, ".csv", sep = ""))

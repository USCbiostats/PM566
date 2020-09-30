library(httr)
library(xml2)
library(data.table)
library(stringr)

list_cross_ref <- function(issue, repo = "USCbiostats/PM566", timeout = 60) {

  message("Connecting to GitHub...", appendLF = FALSE)
  issues <- GET(
    sprintf("https://github.com/%s/issues/%i", repo, issue),
    config = config(connecttimeout = timeout)
    )
  message("done.")
  
  
  
  page  <- content(issues)
  
  # Checking if there's anything to parse
  items <- xml_find_all(page, xpath = '//*[@class="TimelineItem"]')
  
  if (xml_length(items) == 0)
    stop("No cross-reference to be analized.")
  
  items <- lapply(as.character(items), read_html)
  
  # Getting the times
  times <- lapply(items, xml_find_first, xpath = "//relative-time")
  times <- sapply(times, xml_attr, attr = "datetime")
  
  # Getting the users
  users <- lapply(items, xml_find_first, xpath='//*[starts-with(@class, "author")]')
  users <- sapply(users, xml_attr, attr = "href")
  users <- stringr::str_remove(users, "^/")
  
  # Getting the title
  details <- lapply(items, xml_find_first, xpath='//*[starts-with(@class, "commit-message")]//a')
  titles <- sapply(details, xml_attr, attr = "title")
  
  # Getting URL
  links <- sapply(details, xml_attr, attr = "href")
  links <- paste0("https://github.com", links)
 
  # Creating database
  dat <- data.table(
    user      = users,
    title     = titles,
    link      = links,
    timestamp = times
  )
  
  # Masking the original url
  dat[, title := str_replace(
    title, paste0("https://github.com/", repo, "/issues/", issue),
    paste0("#", issue))]
  
  # Removing newline
  dat[, title := str_replace_all(title, "\\n+", " ")]
  
  # Tagging the commits
  dat[, type := fifelse(
    str_detect(tolower(title), "hw|assignme"), "homework",
    fifelse(
      str_detect(tolower(title), "lab"),
      "lab", NA_character_
    )
  )]
  
  # Processing the time
  dat[, timestamp := as.POSIXct(timestamp, format = "%Y-%m-%dT%H:%M:%OS")]
  
  return(dat)
   
}


library(data.table)
library(httr)
library(stringr)


list_cross_ref_api <- function(
  issue,
  repo    = "USCbiostats/PM566",
  baseurl = "https://api.github.com/repos",
  ...
  ) {
  
  # Checking the arguments of curl -X GET
  dots <- list(...)
  if ("config" %in% names(dots))
    dots$config <- c(dots$config, httr::add_headers(
      Accept = "application/vnd.github.mockingbird-preview+json"
    ))
  else
    dots$config <- httr::add_headers(
      Accept = "application/vnd.github.mockingbird-preview+json"
    )
  
  dots$url <- sprintf("%s/%s/issues/%d/timeline", baseurl, repo, issue)
  
  response <- tryCatch(do.call(httr::GET, dots), error = function(e) e)
  
  if (inherits(response, "error")) {
    warning("httr::GET failed.")
    return(NULL)
  }
  
  response <- httr::content(response)
  
  # Basic information
  timeline <- data.table(
    user       = sapply(response, function(r) r$actor$login),
    created_at = sapply(response, "[[", "created_at"),
    event      = sapply(response, "[[", "event"),
    commit_url = sapply(response, function(r) {
      if (length(r$commit_url))
        r$commit_url
      else
        NA_character_
    }),
    commit_id = sapply(response, function(r) {
      if (length(r$commit_id))
        r$commit_id
      else
        NA_character_
    })
  )
  
  timeline[, repo := str_extract(commit_url, "(?<=\\.com/repos/).+(?=/commits/)")]
  timeline[, commit_url := fifelse(
    !is.na(repo),
    sprintf("https://github.com/%s/commit/%s", repo, commit_id),
    NA_character_)
    ]
  
  # Now getting the contents of the commit:
  message("Getting the details of the commits...", appendLF = FALSE)
  files <- matrix(NA_character_, nrow = nrow(timeline), ncol = 2)
  for (i in 1:nrow(timeline)) {
    message(i, ", ", appendLF = FALSE)
    tmp <- commit_info(timeline$commit_id[i], timeline$repo[i], ...)
    if (length(tmp))
      files[i, ] <- tmp
  }
  message("done.")
  
  timeline$message <- files[,1]
  timeline$files   <- files[,2]
  
  # Checking which ones were about a lab
  timeline[, type := fifelse(
    grepl("lab", tolower(message)), "lab",
    fifelse(grepl("hw|assignme", tolower(message)), "homework", NA_character_)
  )]
  
  timeline
  
}

commit_info <- function(
  commit,
  repo    = "USCbiostats/PM566",
  baseurl = "https://api.github.com/repos",
  ...
  ) {
  
  # Checking the arguments of curl -X GET
  dots <- list(...)
  if ("config" %in% names(dots))
    dots$config <- c(dots$config, httr::add_headers(
      Accept = "application/vnd.github.mockingbird-preview+json"
    ))
  else
    dots$config <- httr::add_headers(
      Accept = "application/vnd.github.mockingbird-preview+json"
    )
  
  dots$url <- sprintf("%s/%s/commits/%s", baseurl, repo, commit)
  
  response <- tryCatch(do.call(httr::GET, dots), error = function(e) e)
  
  if (inherits(response, "error")) {
    warning("httr::GET failed.")
    return(NULL)
  }
  
  commit <- httr::content(response)
  
  files <- lapply(commit$files, function(f) {
    sprintf("[%s](%s)", f$filename, f$blob_url)
  })
  
  c(
    message = commit$commit$message,
    files   = paste(files, collapse = ", ")
  )
  
}

# ans <- list_cross_ref_api(25)

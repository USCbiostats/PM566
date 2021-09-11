library(blogdown)

# Listing things to build
things <- list.files("content/class", pattern = "*Rmd", full.names = TRUE)

things <- c(things, list.files("content/reading", pattern = "*Rmd", full.names = TRUE))

things <- c(things, path.expand("content/syllabus/index.Rmd"))


build_site(build_rmd = things)


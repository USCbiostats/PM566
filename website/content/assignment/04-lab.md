---
title: "Lab 04 - Data Visualization"
output: html_document
link-citations: yes
---


```r
# Set to TRUE if you want the blocks to be evaluated 
EVAL <- FALSE
ECHO <- EVAL
```




# Learning Goals

- Read in and prepare the meteorological dataset
- Create several graphs with different `geoms()` in `ggplot2`
- Create a facet graph
- Conduct some customizations to the graphs
- Create a more detailed map using `leaflet()`


# Lab Description

We will again work with the meteorological data presented in lecture.

**The objective of the lab is to examine the association between weekly average dew point temperature and wind speed in four regions of the US and by elevation.**

# Steps

### 1. Read in the data

First download and then read in with data.table:fread()


```r
if (!file.exists("met_all.gz"))
  download.file(
    url = "https://raw.githubusercontent.com/USCbiostats/data-science-data/master/02_met/met_all.gz",
    destfile = "met_all.gz",
    method   = "libcurl",
    timeout  = 60
    )
met <- data.table::fread("met_all.gz")
```

### 2. Prepare the data

- Remove temperatures less than -17C
- Make sure there are no missing data in the key variables coded as 9999, 999, etc
- Generate a date variable using the functions `as.Date()` (hint: You will need the following to create a date `paste(year, month, day, sep = "-")`).
- Using the `data.table::week` function, keep the observations of the first week of the month.
- Compute the mean by station of the variables `temp`, `rh`, `wind.sp`, `vis.dist`, `dew.point`, `lat`,
`lon`, and `elev`.
- Create a region variable for NW, SW, NE, SE based on lon = -98.00 and lat = 39.71 degrees
- Create a categorical variable for elevation as in the lecture slides



### 3. Use `geom_violin` to examine the wind speed and dew point temperature by region

You saw how to use `geom_boxplot` in class. Try using `geom_violin` instead (take a look at the help).
(hint: You will need to set the `x` aesthetic to 1)

- Use facets
- Make sure to deal with `NA` category
- Describe what you observe in the graph




### 4. Use `geom_jitter` with `stat_smooth` to examine the association between dew point temperature and wind speed by region

- Colour points by region
- Make sure to deal with `NA` category
- Fit a linear regression line by region
- Describe what you observe in the graph




### 5. Use `geom_bar` to create barplots of the weather stations by elevation category coloured by region

- Bars by elevation category using `position="dodge"`
- Change colours from the default. Colour by region using `scale_fill_brewer` see [this](http://rstudio-pubs-static.s3.amazonaws.com/5312_98fc1aba2d5740dd849a5ab797cc2c8d.html)
- Create nice labels on axes and add a title
- Describe what you observe in the graph
- Make sure to deal with `NA`



### 6. Use `stat_summary` to examine mean dew point and wind speed by region with standard deviation error bars

- Make sure to remove `NA`
- Use fun.data="mean_sdl" in `stat_summary`
- Add another layer of `stats_summary` but change the geom to `"errorbar"` (see the help).
- Describe the graph and what you observe



- Dew point temperature is...
- Wind speed is...

### 7. Make a map showing the spatial trend in relative h in the US

- Make sure to remove `NA`
- Use leaflet()
- Make a colour palette with custom colours
- Use `addMarkers` to include the top 10 places in relative h (hint: this will be useful `rank(-rh) <= 10`)
- Add a legend



- Describe trend in RH across the US

### 8. Use a ggplot extension

- Pick and extension (except cowplot) from [here](https://exts.ggplot2.tidyverse.org/gallery/) and make a plot of your choice using the met data (or met_avg)
- Might want to try examples that come with the extension first (e.g. ggtech, gganimate, ggforce)


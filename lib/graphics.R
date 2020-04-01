dv_colors <- list(blue = "#0D0887",
                  purple = "#6600A7",
                  magenta = "#AB2494",
                  pink = "#DA5B69",
                  orange = "#F9983E",
                  yellow = "#F7E225")


update_geom_defaults("label", list(family = "Oswald Light", face = "plain"))
update_geom_defaults("text", list(family = "Oswald Light", face = "plain"))

theme_dv <- function(base_size = 11, base_family = "Oswald") {
  ret <- theme_bw(base_size, base_family) +
    theme(plot.title = element_text(size = rel(1.4), face = "plain",
                                    family = "Oswald SemiBold"),
          plot.subtitle = element_text(size = rel(1), face = "plain",
                                       family = "Oswald Light"),
          plot.caption = element_text(size = rel(0.8), color = "grey50", face = "plain",
                                      family = "Oswald Light",
                                      margin = margin(t = 10)),
          plot.tag = element_text(size = rel(1), face = "plain", color = "grey50",
                                  family = "Oswald SemiBold"),
          strip.text = element_text(size = rel(0.8), face = "plain",
                                    family = "Oswald Medium"),
          strip.text.x = element_text(margin = margin(t = 1, b = 1)),
          panel.border = element_blank(), 
          strip.background = element_rect(fill = "#ffffff", colour = NA),
          axis.ticks = element_blank(),
          axis.title.x = element_text(margin = margin(t = 10)),
          axis.title.y = element_text(margin = margin(r = 10)),
          legend.margin = margin(t = 0),
          legend.title = element_text(size = rel(0.8)),
          legend.position = "bottom")
  
  ret
}

FROM rocker/tidyverse:latest

RUN Rscript -e 'utils::install.packages("blogdown");blogdown::install_hugo()'

CMD ["bash"]


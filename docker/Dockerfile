FROM rocker/tidyverse:latest

RUN Rscript -e 'utils::install.packages("blogdown");blogdown::install_hugo()'

RUN apt-get update && apt-get install -y --no-install-recommends libxt6
RUN Rscript -e 'utils::install.packages("Rcpp")'

CMD ["bash"]


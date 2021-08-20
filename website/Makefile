cntr:=uscbiostats/pm566:latest
update:
	docker run --rm -i -v ${PWD}:/home/mnt \
		-w /home/mnt ${cntr} \
		Rscript -e 'library(blogdown);build_site(build_rmd=filter_timestamp(list.files("content/class/", pattern = "*Rmd", full.names=TRUE)))'
run:
	docker run --rm -i -v ${PWD}:/home/mnt \
		-w /home/mnt ${cntr} R --vanilla

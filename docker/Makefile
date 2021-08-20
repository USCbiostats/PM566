build:
	docker build -t uscbiostats/pm566:latest -f Dockerfile.rstudio . &&\
		docker build -t uscbiostats/pm566:website -f Dockerfile .
push: build
	docker push uscbiostats/pm566:latest; docker push uscbiostats/pm566:website 

run:
	docker run -d -p 8787:8787 -e PASSWORD=12331 \
		-v ${PWD}/..:/home/rstudio/george \
		uscbiostats/pm566:latest

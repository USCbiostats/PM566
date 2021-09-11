run:
	docker run --rm -d -p 8787:8787 -e PASSWORD=123 \
		--name rstudio-docker \
		-v ${PWD}/..:/home/rstudio/ \
		uscbiostats/pm566:latest && \
		sleep 5 && \
		echo "Now go to localhost:8787" && \
		echo "user: rstudio\npass: 123"

stop:
	docker stop rstudio-docker

build: clean
	docker build -t uscbiostats/pm566:latest -f Dockerfile.rstudio . &&\
		docker build -t uscbiostats/pm566:website -f Dockerfile .

.PHONY: clean
clean:
	sudo rm -rf ../.local/ && sudo rm -rf ../.config/


push: build
	docker push uscbiostats/pm566:latest; docker push uscbiostats/pm566:website 
 


# UID := ${UID}
build:
	docker build -t uscbiostats/pm566:latest -f Dockerfile.rstudio . &&\
		docker build -t uscbiostats/pm566:website -f Dockerfile .
push: build
	docker push uscbiostats/pm566:latest; docker push uscbiostats/pm566:website 
 
run:
	docker run --rm -d -p 8787:8787 -e PASSWORD=123 \
		-v ${PWD}/..:/home/rstudio/ \
		uscbiostats/pm566:latest && \
		echo "Now go to localhost:8787" & \
		echo "user: rstudio\npass: 123"

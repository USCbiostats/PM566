Images for building and running the class

## Website Building

This image is used to build the website only

`uscbiostats/pm566:website`

## Interactive Session

`uscbiostats/pm566:latest`

```bash
docker run --rm -d -p 8787:8787 -e PASSWORD=12331 uscbiostats/pm566:latest
```

Once the image starts, go to your browser and type `localhost:8787`. The
`username` is rstudio and the password, well, `12331`.

If you want to map an specific folder, you can go ahead and type

```bash
docker run -d --rm -p 8787:8787 -e PASSWORD=12331 -v ${PWD}/..:/home/rstudio/ \
	 --name pm566 uscbiostats/pm566:latest
```

This will map the current directory, PWD, to /home/rstudio/.

You can stop the instance using:

```bash
docker stop pm566
```

If you are using [Docker in Rootless mode](https://docs.docker.com/engine/security/rootless),
you must make sure that the docker daemon has read/write permission to the mounted
volume. A quick-n-dirty fix is using `chmod -R 0777 ../PM566/` which will give
read/write privileges to all users.


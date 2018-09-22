# when you run 'make' alone, run the 'css' rule (at the
# bottom of this makefile)
all: docker.status

# .PHONY is a special command, that allows you not to
# require physical files as the target (allowing us to
# use the 'all' rule as the default target).
.PHONY: all

docker.update: docker.destroy docker.pull docker.up

docker.iter: docker.down docker.up

docker.up:
	docker-compose up -d

docker.destroy:
	docker-compose down --volumes --rmi 'local'

docker.down:
	docker-compose down

docker.status:
	docker-compose ps

docker.logs:
	docker-compose logs # Use docker-compose logs -f if you want to 'tail' the log output.

docker.pull:
	docker-compose pull

docker:
	docker buildx build --platform linux/amd64 -t py27-multi .

sif:
	apptainer build py27.sif docker-daemon://py27-multi:latest



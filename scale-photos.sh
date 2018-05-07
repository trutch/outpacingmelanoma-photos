/bin/bash 

docker run -it \
	-v `pwd`:/srv outpacingmelanoma/photos:latest \
	--name 'outpacing-photos-2018' \
	--net=host \
	scale['2018']

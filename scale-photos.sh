/bin/bash 

docker run -it \
	-v `pwd`:/srv outpacingmelanoma/photos:latest \
	-v /home/rutschman/Dropbox/2018-outpacing-photos:/photos \
	outpacingmelanoma/photos:latest \
	--name 'outpacing-photos-2018' \
	--net=host \
	scale['2018']

/in/bash 

docker run -it \
	-v `pwd`:/srv \
	-v /home/rutschman/Dropbox/2018-outpacing-photos:/photos \
	outpacingmelanoma/photos:latest \
	--name 'outpacing-photos-2018' \
	--net=host \
	scale['2018']

/bin/bash 

docker run -it \
	-v `pwd`:/srv outpacingmelanoma/photos:0.0.1-0 \
	--name 'outpacing-photos-2018' \
	--net=host \
	/bin/bash

require 'fileutils'
require 'bundler'
require 'yaml'
require 'pry'

Bundler.require(:default)

Dotenv.load
APPLICATION_ROOT = File.expand_path(__dir__)

Dir.glob("#{APPLICATION_ROOT}/lib/*.rb").each { |r| load r}
Dir.glob("#{APPLICATION_ROOT}/lib/tasks/*.rake").each { |r| import r }  

####### SCALE PHOTOS ########
desc "Scale down Photos"
task :scale_down, [:year]  do |t, args|
	# Quit if year isn't supplied
  if args[:year].nil?
		puts "Need to supply the year as argument"
		exit 1
  end
	# Only want directory with the full size images
	photo_dir = "/home/trutch/Projects/outpacingmelanoma-photos/data/#{args[:year]}/full"
	binding.pry
	# FNM_CASEFOLD is to allow for case-insensitive matching
	photos = Dir.glob("#{photo_dir}/Community Faces KC/*.jp*", File::FNM_CASEFOLD)
	progressbar = Helpers.progress_bar("Scaling Photos", photos.length)
	photos.each do |photo|
		progressbar.log "Current: #{photo}"
		# Make Thumbnail out of full size photo
		Helpers.make_thumbnail(photo)
		# Make Scaled photo out of full size photo
		Helpers.make_scale(photo)
	  progressbar.increment
		resident_memory=`ps -o rss= -p #{Process.pid}`.to_i
		GC.start if resident_memory > 1284840
	end
end

####### CONVERT PHOTOS to jpg ########
desc "Convert Photos"
task :convert, [:year]  do |t, args|
	# Only want directory with the full size images
	photo_dir = "/home/trutch/Dropbox/Design/outpacingmelanoma/2020/2020 Virtual photos"
	# FNM_CASEFOLD is to allow for case-insensitive matching
	photos = Dir.glob("#{photo_dir}/**/*.png", File::FNM_CASEFOLD)
	progressbar = Helpers.progress_bar("Converting Photos", photos.length)
	photos.each do |photo|
		progressbar.log "Current: #{photo}"
		# Make Thumbnail out of full size photo
		Helpers.convert_image(photo)
	  progressbar.increment
		resident_memory=`ps -o rss= -p #{Process.pid}`.to_i
		GC.start if resident_memory > 1284840
	end
end

desc "Fix Orientation"
task :fix_orientation do
	# Only want directory with the full size images
	photo_dir = "/home/trutch/Projects/outpacingmelanoma-photos/data/2020/thumbnails"
	# FNM_CASEFOLD is to allow for case-insensitive matching
	photos = Dir.glob("#{photo_dir}/**/*.jpg", File::FNM_CASEFOLD)
	progressbar = Helpers.progress_bar("Converting Photos", photos.length)
	photos.each do |photo|
		progressbar.log "Current: #{photo}"
		# Fix the orientaiton of the image
		Helpers.fix_orientation(photo)
	  progressbar.increment
		resident_memory=`ps -o rss= -p #{Process.pid}`.to_i
		GC.start if resident_memory > 1284840
	end
end




desc "Update paths in AWS" 
task :update_2014 do
	photo_classes = ["thumbnails","scaled","full"]
	photo_dir = "./2014/scaled"
	photos = Dir.glob("#{photo_dir}/**/*.jpg", File::FNM_CASEFOLD)
	bucket = "outpacingmelanoma_photos"
	# Collect Filenames
	photo_info = photos.collect {|photo| b=photo.split('/'); { type: b[-2], file: b.last } }
	# Initialize client with proper bucket
	s3 = S3.new({ bucket: bucket })
	object_list =  []
	# Collect keys that start with 2014 and end in jpg
	response = s3.client.list_objects(bucket: bucket)
	object_list << response.contents
	while response.next_page? do
		puts Time.now
		response = response.next_page
		object_list.push response.contents
	end
	objects = object_list.flatten.select {|obj| obj.key =~ /^2014\/(full|thumbnails|scaled)\/.*\.(JPG|jpg)/ }
	keys = objects.collect {|obj| obj.key }
	# For each key, match local photo info and copy to new path
	keys.each do |key|
		filename = key.split('/').last
		# Find match
		match = photo_info.find { |photo| photo[:file] == filename }
		puts "Starting on #{filename}"
		photo_classes.each do |photo_class|
			puts "---- No Match Found for: #{filename} ----" if match.nil?	
			if match
				old_key = "2014/#{photo_class}/#{filename}"
				# Select Object
				new_key = "#{bucket}/2014/#{photo_class}/#{match[:type]}/#{filename}" rescue binding.pry
				begin 
					aws_object = s3.bucket.object(old_key)
					# Move to new path
					move_response = aws_object.move_to(new_key)
					if move_response.successful?
						puts "#{old_key} successfully moved to #{new_key}"
					end
				rescue => e
					puts old_key
					puts e.message
				end
			end
		end
	end
end

desc "Create YAML Manifest"
task :manifest do
  target_bucket = 'outpacingmelanoma'
  s3 = Aws::S3::Resource.new(region: 'us-east-1')
  bucket = s3.bucket(target_bucket)
#	photo_dir = "./data/2021/full"
	photos = bucket.objects.select { |obj| obj.key =~ /^photos\/2021\/full/ }
#	photos = Dir.glob("#{photo_dir}/**/*.jp*", File::FNM_CASEFOLD)
	# Initialize hash object to collect photos
	photo_collection = Array.new
	photos.each do |photo|
		# Split up filename by slashes
		file_elements = photo.key.split("/")
		photo_collection << {
			url: { full: photo.public_url,
					scaled: photo.public_url.gsub(/full/, "scaled"),
					thumbnail: photo.public_url.gsub(/full/, "thumbnails"),
		  },
			category: URI.decode(file_elements[-2])
		}
	end
	# Open YAML File and Write Object to it
	File.open('./2021_photos.yml', 'w') { |f|
		f.write photo_collection.to_yaml
	}
end


require 'fileutils'
require 'bundler'
require 'yaml'

Bundler.require(:default)

Dotenv.load

Dir.glob(['lib/*.rb']).each { |r| load r}
Dir.glob('lib/tasks/*.rake').each { |r| import r }  

####### SCALE PHOTOS ########
desc "Scale down Photos"
task :scale_down, [:year]  do |t, args|
	# Only want directory with the full size images
	photo_dir = "/photos"
	# FNM_CASEFOLD is to allow for case-insensitive matching
	photos = Dir.glob("#{photo_dir}/**/*.jpg", File::FNM_CASEFOLD)
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
	#photo_dir = "#{ENV['LOCAL_BUCKET']}/full"
	photo_dir = "./2013/full"
	photos = Dir.glob("#{photo_dir}/**/*.jpg", File::FNM_CASEFOLD)
	# Initialize hash object to collect photos
	photo_collection = Array.new
	photos.each do |photo|
		# Split up filename by slashes
		file_elements = photo.split("/")
		photo_collection << {
			filename: file_elements[-1],
			category: file_elements[-2],
			display_category: file_elements[-2].split('_').map(&:capitalize).join(' ')
		}
	end
	# Open YAML File and Write Object to it
	File.open('./2013_photos.yml', 'w') { |f|
		f.write photo_collection.to_yaml
	}
end


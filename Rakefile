require 'fileutils'
require 'bundler'
require 'yaml'

Bundler.require(:default)

Dotenv.load

Dir.glob(['lib/*.rb']).each { |r| load r}
Dir.glob('lib/tasks/*.rake').each { |r| import r }  

desc "Scale down Photos"
task :scale do
	# Only want directory with the full size images
	photo_dir = "#{ENV['LOCAL_BUCKET']}/full"
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
	end
end

desc "Create YAML Manifest"
task :manifest do
	photo_dir = "#{ENV['LOCAL_BUCKET']}/full"
	photos = Dir.glob("#{photo_dir}/**/*.jpg", File::FNM_CASEFOLD)
	# Initialize hash object to collect photos
	photo_collection = Array.new
	photos.each do |photo|
		# Split up filename by slashes
		file_elements = photo.split("/")
		photo_collection << {
			filename: file_elements[-1],
			category: file_elements[-2]
		}
	end
	# Open YAML File and Write Object to it
	File.open('./2017_photos.yml', 'w') { |f|
		f.write photo_collection.to_yaml
	}
end


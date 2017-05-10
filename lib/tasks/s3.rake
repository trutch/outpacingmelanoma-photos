require 'pathname'

namespace :s3 do
  config = {region: ENV['AWS_REGION'], key: ENV['AWS_ACCESS_KEY_ID'], secret: ENV['AWS_SECRET_ACCESS_KEY'], bucket: ENV['BUCKET'] }
  Aws.config.update({region: config[:region], credentials: Aws::Credentials.new(config[:key], config[:secret])})

	task :sync_remote_bucket do
		target_folder = ENV['LOCAL_BUCKET']
    bucket = Aws::S3::Resource.new.bucket(config[:bucket])
    # Iterate.
    bucket.objects.each do |obj| 
			begin 
  			# Download file to local folder
				puts "#{obj.key}"
				pn = Pathname.new("#{ENV['LOCAL_BUCKET']}/#{obj.key}")
				if pn.exist?
					next
				else
			    obj.get( { response_target: "#{ENV['LOCAL_BUCKET']}/#{obj.key}" } )
				end
			rescue => e
				new_dir = obj.key.split("/").first
				FileUtils.mkdir("#{ENV['LOCAL_BUCKET']}/#{new_dir}")
				retry
			end
		end
	end

	# Sync Local Folder to Remote Bucket
	task :sync_local_bucket do
		target_bucket = 'outpacingmelanoma_photos'
		s3 = Aws::S3::Resource.new(region: 'us-east-1')
		bucket = s3.bucket(target_bucket)
  	photos = Dir.glob("#{ENV['LOCAL_BUCKET']}/thumbnails/**/*.jpg", File::FNM_CASEFOLD)
    # Create progress bar object 
		progress = Helpers.progress_bar("Sync to S3 Bucket", photos.length)
		photos.each do |photo|
		  progress.log "Current: #{photo}"
  		# Split up filename by slashes
  		file_elements = photo.split("/")
			# Set key name
			key = file_elements[-4..-1].join("/")
			# Create object variable
			obj = bucket.object(key)
			# Upload file 
			obj.upload_file(photo)
		  progress.increment
		end
	end
end


# ============
# # Create file.
# obj = bucket.object(path)
# obj.put(body: 'hello')
#
# # Check if file exists.
# bucket.object(path).exists?
#
# # Get URL for.
# obj.presigned_url(:get, expires_in: 3600)
#

module Helpers
	# Make thumbnail photos
	def self.make_thumbnail(filename)
		directory = filename.split("/").first
		thumbnail_filename = filename.gsub /#{directory}\/full/, "#{directory}/thumbnails"
		# Set up pathname based on thumnail filename
		pn = Pathname.new(thumbnail_filename)
		# Skip creation of thumbnail if it exists
		return if pn.exist?
		img = Magick::Image::read(filename).first
		thumbnail = img.resize_to_fill(200,150)
		begin
  	  # Save thumbnail to file
  		thumbnail.write thumbnail_filename
		rescue => e
			dir = thumbnail_filename.split("/")
			dir.pop
			FileUtils.mkdir_p(dir.join("/"))
			retry
		end
		# Destroy the image to free up memory
		img.destroy!
		thumbnail.destroy!
	end

	# Scale photos to sane size
	def self.make_scale(filename)
		directory = filename.split("/").first
		scaled_filename = filename.gsub /#{directory}\/full/, "#{directory}/scaled"
		# Set up pathname based on scaled filename
		pn = Pathname.new(scaled_filename)
		# Skip creation of scaled file if it exists
		return if pn.exist?
		img = Magick::Image::read(filename).first
		scaled = img.scale(0.4)
		begin
  		scaled.write scaled_filename
		rescue => e
			dir = scaled_filename.split("/")
			dir.pop
			FileUtils.mkdir_p(dir.join("/"))
			retry
		end
		# Destroy the image to free up memory
		img.destroy!
		scaled.destroy!
	end

	def self.progress_bar(title, total_size)
	  ProgressBar.create(
			:title => title,
			:starting_at => 0,
			:total => total_size,
			:format => '%a %bᗧ%i %c of %C (%p%%) %t',
			:progress_mark  => ' ',
			:remainder_mark => '･')
	end
end

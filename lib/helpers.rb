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
		thumbnail = img.scale(0.09)
	  # Save thumbnail to file
		img.write thumbnail_filename
		# Destroy the image to free up memory
		img.destroy!
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
		img.write scaled_filename
		# Destroy the image to free up memory
		img.destroy!
	end
end

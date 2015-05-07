module Helpers
	def self.make_thumbnail(filename)
		directory = filename.split("/").first
		img = Magick::Image::read(filename).first
		thumbnail = img.scale(0.09)
		thumbnail_filename = filename.gsub /#{directory}\/full/, "#{directory}/thumbnails"
		save_file(thumbnail_filename, thumbnail)
	end
	def self.make_scale(filename)
		directory = filename.split("/").first
		img = Magick::Image::read(filename).first
		scaled = img.scale(0.4)
		scaled_filename = filename.gsub /#{directory}\/full/, "#{directory}/scaled"
		save_file(scaled_filename, scaled)
	end
	def self.save_file(filename, image)
		# Check if Directory exists and create if it doesn't
		directory = File.dirname(filename)
		FileUtils.mkdir_p(directory) unless Dir.exists?(directory) 
		image.write filename
	end
end

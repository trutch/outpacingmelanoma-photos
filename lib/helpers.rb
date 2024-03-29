module Helpers
	# Fix orientation on images
	def self.fix_orientation(filename)
		directory = filename.split('/')[0..2].join('/')
		# Set up pathname based on filename
		pn = Pathname.new(filename)
		# Skip creation of thumbnail if it exists
		img = Magick::Image::read(filename).first
		# Only rotate the ones that need it
		if img.orientation.to_i != 1
			oriented_image = img.auto_orient
			oriented_image.write filename
		  oriented_image.destroy!
	  end
		img.destroy!
		begin
 		  oriented_image.destroy!
			puts "Oriented #{filename}"
		rescue => e
		end
	end

	# Convert image
	def self.convert_image(filename)
		# Create new jpg filename
		new_filename = filename.gsub(/\.png/, '.jpg')
		img = Magick::Image::read(filename).first
    img.format = 'JPEG'
		img.write(new_filename) { self.quality = 100 }
		File.delete(filename)
  end

	# Make thumbnail photos
	def self.make_thumbnail(filename)
		directory = filename.split('/')[0..6].join('/')
		thumbnail_filename = filename.gsub /#{directory}\/full/, "#{directory}/thumbnails"
		# Set up pathname based on thumnail filename
		pn = Pathname.new(thumbnail_filename)
		# Skip creation of thumbnail if it exists
		return if pn.exist?
		img = Magick::Image::read(filename).first
		thumbnail = img.resize_to_fill(200,200)
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
		directory = filename.split('/')[0..6].join('/')
		scaled_filename = filename.gsub /#{directory}\/full/, "#{directory}/scaled"
		# Set up pathname based on scaled filename
		pn = Pathname.new(scaled_filename)
		# Skip creation of scaled file if it exists
		return if pn.exist?
		img = Magick::Image::read(filename).first
		scaled = img.scale(0.4)
		# Scale image to 40% of original size
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

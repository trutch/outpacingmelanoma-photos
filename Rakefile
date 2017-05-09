require 'fileutils'
require 'bundler'
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
	progressbar = ProgressBar.create(
		:title => "Scaling Photos",
		:starting_at => 0,
		:total => photos.length,
		:format => '%a %bᗧ%i %c of %C (%p%%) %t',
		:progress_mark  => ' ',
		:remainder_mark => '･')
	photos.each do |photo|
		progressbar.log "Current: #{photo}"
		# Make Thumbnail out of full size photo
		Helpers.make_thumbnail(photo)
		# Make Scaled photo out of full size photo
		Helpers.make_scale(photo)
	  progressbar.increment
	end
end

desc "Create JSON Manifest"
task :marshall do

end



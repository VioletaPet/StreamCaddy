class ProcessBackdropsJob < ApplicationJob
  queue_as :default

  def perform(media_id, backdrops_data)
    # Do something later
    media = Media.find(media_id)
    return if media.backdrops.attached?

    if backdrops_data
      backdrops_data.each do |backdrop|
        backdrop_url = "https://image.tmdb.org/t/p/original#{backdrop['file_path']}"
        media.backdrops.attach(io: URI.open(backdrop_url), filename: File.basename(backdrop_url), content_type: 'image/jpeg')
      end
    end
  end
end

class ProcessCastAssociationsJob < ApplicationJob
  queue_as :default

  def perform(media_id, cast_data)
    # Do something later
    media = Media.find(media_id)
    return if media.actors.exists?

    cast_data.each do |cast_member|
      member_details = TmdbService.fetch_cast_member_details(cast_member['id'])
      actor = Actor.find_or_create_by(api_id: cast_member['id']) do |a|
        a.name = cast_member['name']
        a.bio = member_details['biography']

      end
      if cast_member['profile_path'].present? && !actor.photos.attached?
        profile_url = "https://image.tmdb.org/t/p/original#{cast_member['profile_path']}"
        actor.photos.attach(io: URI.open(profile_url), filename: File.basename(profile_url), content_type: 'image/jpeg')
      end
      MediaActor.create!(media_id: media['id'], actor_id: actor['id'], character: cast_member['character'])
    end
  end
end

module MetaTagsHelper

  def meta_title
    content_for?(:title) ? content_for(:title) : DEFAULT_META['meta_title']
  end

  def meta_description
    content_for?(:description) ? content_for(:description) : DEFAULT_META['meta_description']
  end

  def meta_image
    meta_image = (content_for?(:image) ? content_for(:image) : DEFAULT_META['meta_image'])
    meta_image.starts_with?('http') ? meta_image : image_url(meta_image)
  end
end

def title_builder
  title = " - #{ENV['WEBSITE_TITLE']}"
  if @note && @note.title != nil
    @note.title + title
  elsif @character && @character.name != nil
    @character.name + title
  elsif @scene && @scene.title != nil
    @scene.title + title
  elsif @chapter && @chapter.title != nil
    @chapter.title + title
  elsif @campaign && @campaign.title != nil
    @campaign.title + title
  else
    "#{ENV['WEBSITE_TITLE']} - Asynchronous table-top gaming."
  end
end

def url_builder(*args)
  url = "/#{args.first.cid}"
  args.each do |arg|
    url += "/#{arg.slug}"
  end
  url
end

def flash_type(name)
  type = case name
         when :error then 'is-danger'
         when :notice then 'is-warning'
         when :success then 'is-success'
         else ''
         end
  type
end

def cloudfront_url(image, type)
  baseurl = ENV['AWS_CLOUDFRONT_BASEURL']
  image ||= 'placeholder.png'
  url = case type
        when :campaign then "campaign-images/#{image}"
        when :user then "user-avatars/#{image}"
        when :character then "character-portraits/#{image}"
        end
  "https://#{baseurl}/#{url}"
end

def slug_sanitize(slug)
  forbiddon_slugs = [
    'characters', 'edit', 'new', 'delete', 'add', 'dice', 'note', 'join_link',
    'refresh', 'ooc', 'count', 'history', 'members'
  ]
  if forbiddon_slugs.include?(slug)
    slug += '-' + SecureRandom.urlsafe_base64(4, false)
  end
  slug.downcase!
  slug = slug.gsub(/\s/, '-')
  slug = slug.gsub(/[^a-zA-Z0-9\-]/, '')
  slug
end

def last_visit(scene, campaign)
  if scene.slug == campaign.chapters.last.scenes.last.slug
    session[campaign.cid] = Time.now
  end
end

def new_posts(campaign, last_visit)
  new_posts = 0
  campaign.chapters.all.each do |chapter|
    chapter.scenes.all.each do |scene|
      new_posts += new_posts + scene.posts.where(
        'created_at > ?', last_visit).count
    end
  end
  new_posts
end

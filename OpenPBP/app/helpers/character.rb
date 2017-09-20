def random_character_name
  first_prefix = ['Alar', 'Adri', 'Ruther', 'Nico', 'Fitz', 'Kev', 'Ja', 'Jon', 'Jam']
  first_affix = ['es', 'son', 'in', 'las', 'ford', 'el', 'ia', '']
  last_prefix = ['Battag', 'Thisel', 'Fire', 'Tempar', 'Solon']
  last_affix = ['lia', 'witz', 'song', 'ro', 'are', 'son', '']

  first_prefix.sample + first_affix.sample + ' ' + last_prefix.sample + last_affix.sample
end

def chat_as(campaign, user_id)
  chat_as_options = []
  display_name = User.find_by_id(user_id).display_name
  chat_as_options << [display_name, display_name]
  primary  = campaign.characters.where(user_id: user_id).find_by_default(true)
  chat_as_options << [primary.name, primary.name]
  characters = campaign.characters.where(user_id: user_id).where(default: false).where(retired: false)
  characters.each do |character|
    chat_as_options << [character.name, character.name]
  end
  select_tag :name, options: chat_as_options
end

def post_as(campaign, user_id, name)
  post_as_options = []
  primary  = campaign.characters.where(user_id: user_id).find_by_default(true)
  post_as_options << [primary.name, primary.charid]
  characters = campaign.characters.where(user_id: user_id).where(default: false).where(retired: false)
  characters.each do |character|
    post_as_options << [character.name, character.charid]
  end
  select_tag name, options: post_as_options
end

def safe_names(campaign, user_id)
  names = []
  names << User.find(user_id).display_name
  characters = campaign.characters.where(user_id: user_id)
  characters.each do |character|
    names << character.name
  end
  names
end
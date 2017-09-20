class PostRoll < ActiveRecord::Base
  serialize :rolled_dice
  serialize :results
  serialize :modifier

  belongs_to :user
  belongs_to :post

  def new_roll(params, user_id)
    dice = Dice.new
    dice.pool = params[:pool]
    if dice.parse == true
      self.user_id = user_id
      self.rolled_dice = dice.rolled_dice
      self.results = dice.results
      self.modifier = dice.modifier
      true
    else
      false
    end
  end
end

class Dice
  attr_accessor :pool
  attr_reader :rolled_dice, :results, :modifier

  def initialize
    @rolled_dice = []
    @results = []
    @modifier = ''
  end

  def parse
    @modifier = @pool.scan(/[(kh|>|+|\-)]+\d+$/)
    dice_pool_sets = @pool.scan(/\d+[d]\d+/)
    dice_pool_sets.each do |set|
      set = set.split('d')
      set[0].to_i.times do
        @rolled_dice << "d#{set[1]}"
        @results << rand(set[1].to_i) + 1
      end
    end
    @rolled_dice != [] && @results != []
  end
end

def success_check(result, modifier)
  modifier = modifier.delete('>')
  if result > modifier.to_i
    'success'
  elsif result == 1
    'fail'
  end
end

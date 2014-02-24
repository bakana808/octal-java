proc(_loot_giveRandCommon, @player,

	@roll = rand(0, 99)
	
	if(@roll < 25) { _give_gold(@player, 1) } else
	if(@roll < 50) { _give_health(@player, 2) } else
	if(@roll < 75) { _give_health(@player, 1) } else
	if(@roll < 90) { _item_give(Bomb, @player) } else
	if(@roll < 95) { _item_give(Heal, @player) }
	
)

proc(_give_health, @player, @hearts,

	@max = get_max_health(pinfo(@player)[13])

	@hp = min(@max, pinfo(@player)[5] + @hearts)

	@full_hearts = floor(@hearts / 2)
	@half_hearts = @hearts % 2
	
	@msg = color(7) . 'You have found: ' . color(c)
	
	if(@full_hearts == 0 && @half_hearts == 1) {
		@msg .= 'Half a heart'
	} else 
	
	if(@full_hearts == 1 && @half_hearts == 0) {
		@msg .= @full_hearts . ' heart'
	} else
	
	if(@full_hearts > 1 && @half_hearts == 0) {
		@msg .= @full_hearts . ' hearts'
	} else 
	
	if(@full_hearts > 0 && @half_hearts > 0) {
		@msg .= @full_hearts . ' and a half hearts'
	}

	set_phealth(@player, @hp)
	if(@msg != '', tmsg(@player, @msg))

)

proc(_give_gold, @player, @gold,

	@msg = color(7) . 'You have found: ' . color(6)
	
	if(@gold == 1) {
		@msg .= @gold . ' gold coin'
	} else 
	if(@gold > 1) {
		@msg .= @gold . ' gold coins'
	}
	
	@old_gold = get_pscore(INFO, color(6) . 'Gold', @player)
	@old_gold += @gold
	set_pscore(INFO, color(6) . 'Gold', @gold, @player)

	if(@msg != '', tmsg(@player, @msg))

)

proc(_gm_load, @gamemode,

	#CHOOSES GAMEMODE AND MAP
	
		@info = array()

		@gamemode = yml_decode(read('gamemodes/rush_test.yml'))  
		export('ocp.gm.loaded.gamemode', @gamemode)
		
		@map = yml_decode(read('maps/'.@gamemode['gm_map'].'.yml'))
		export('ocp.gm.loaded.map', @map)

		switch(@gamemode['win-score'],
			-1,
				@win_score = '',
				@win_score = 'Get a score of '.@gamemode['win-score']
		)
		
		switch(@gamemode['win-last'],
			1,
				@win_last = 'Be the only player alive',
				@win_last = ''
		)
		
		switch(@gamemode['respawntime'],
			-1,
				@respawn = 'No Respawns',
			0,
				@respawn = 'Instant Respawns',
				@respawn = 'Respawn: '.@gamemode['respawntime'].' seconds'
		)
		
		if(@gamemode['score-kill'] == 0,
			@score_kill = '',
			@score_kill = 'Score for a kill: '.@gamemode['score-kill']
		)
		
		if(@gamemode['score-death'] == 0,
			@score_death = '',
			@score_death = 'Score for a death: '.@gamemode['score-death']
		)
		
		if(@gamemode['score-suicide'] == 0,
			@score_suicide = '',
			@score_suicide = 'Score for a suicide: '.@gamemode['score-suicide']
		)

		if(@win_score != '', 					@info[] = _adv_string_fill(color(6) . @win_score, 310, 2))
		if(@win_score != '' && @win_last != '', @info[] = _adv_string_fill(color(7) . 'or', 310, 2))
		if(@win_last != '', 					@info[] = _adv_string_fill(color(6) . @win_last, 310, 2))
												@info[] = _adv_string_fill(color(e) . @respawn, 310, 2)
		if(@score_kill != '', 					@info[] = _adv_string_fill(color(a) . @score_kill, 310, 2))
		if(@score_death != '', 					@info[] = _adv_string_fill(color(a) . @score_death, 310, 2))
		if(@score_suicide != '', 				@info[] = _adv_string_fill(color(a) . @score_suicide, 310, 2))
		
	#LOADS WEAPONS AND POSSIBLE MODS

		@mods = _gm_weapon_mod(array())
		@weapons = _gm_weapon_load() 

		foreach(import('ocp.gm.mods'), @mod,
			@info[] = _adv_string_fill(color(d) . 'Mod ' . @mod[name] . ' enabled.', 306, 2)
		)

	#LOADS REGIONS
	
		foreach(get_worlds(), @world,
			foreach(sk_all_regions(@world), @region,
				if(@region != '__global__', sk_region_remove(@world, @region))
			)
		)
		
	#LOADS OTHER VALUES

		export('ocp.gm.info', @info)
		
		export('ocp.gm.bullets', array())
		export('ocp.gm.game.playing', false)
		export('ocp.gm.game.rounds', 0)
		
		export('ocp.gm.teams', associative_array()) #The teams each player in the array belong to.
		
		export('ocp.gm.players', all_players()) #Players
		
		export('ocp.gm.player.stats', associative_array()) #Player Stats
		export('ocp.gm.player.score', associative_array()) #Player Score
		
		export('ocp.gm.player.lasthit', associative_array())
		export('ocp.gm.player.kill.streak', associative_array())
		
		export('ocp.gm.player.lastkill', associative_array())
		export('ocp.gm.player.kill.chain', associative_array())
		
		export('ocp.gm.player.ammo', associative_array())
		export('ocp.gm.player.alive', associative_array()) #Players in this array are spawned in the game

		export('ocp.gm.player.vanish', array()) #Players in this array are invisible
		
		_gm_stats_reset()
		
		#try(remove_objective(SCORE))
		#create_objective(SCORE, DUMMY)
		#set_objective_display(SCORE, array(displayname: 'Score', slot:SIDEBAR))

		foreach(all_entities(), @id, try(entity_remove(@id)))
		
		_gm_spawn()

		_gm_check()

)

proc(_gm_weapon_mod, @files,

	@mods = import('ocp.gm.mods')
	if(@mods == null, @mods = array())
	@loaded = array()

	foreach(@files, @file,
		try(

			@mod = yml_decode(read('modifiers/'.@file.'.yml'))
			
			@mods[] = @mod
			@loaded[] = colorize(@mod[name]), 
			@ex, console(@ex)
		)
	)
	
	export('ocp.gm.mods', @mods)
	
	return(@loaded)
	
)

proc(_gm_weapon_load, @force,

	@weapons = yml_decode(read('weapons.yml'))
	
	@mods = import('ocp.gm.mods')
	
	@settings = 
		array(
			'name': 'SHOT',
			'color': 'f',
			'item': '1',
			'ammo': 20,
			'ammo-name': 'BULLETS',
			'ammo-item': '35:0',
			'ammo-inc': 5,
			'cooldown': 1,
			'knockback-x': 0,
			'knockback-y': 0,
			'shot-damage': 2,
			'melee-damage': 5,
			'melee-cooldown': 0.5,
			'splash-cursor': 0,
			'splash-damage': 20,
		)	
		
	foreach(@weapons, @id, @array,
		
		if(array_index_exists(@weapons, @id),
			@weapon = @weapons[@id],
			continue()
		)

		foreach(@settings, @key, @value,
			if(!array_index_exists(@array, @key), @weapon[@key] = @value)
		)	
		
		foreach(@mods, @mod,
			if(array_index_exists(@mod[weapons], @id),
				foreach(@mod[weapons][@id], @key, @value,
					if(array_index_exists(@array, @key), @weapon[@key] = @value)
				)
			)
		)
		
		export('ocp.gm.weapons.' . @id, @weapon)
		
	)

	return(@weapons)
	
)

proc(_gm_equip, @player,

	@inv = _emptyinv()

	foreach(range(0, 9), @id, 
		@w = import('ocp.gm.weapons.' . @id)
		if(is_array(@w),
			@item = split(':', @w['item'])
			@inv[@id] = array(type: @item[0], data: @item[1]),
			@inv[@id] = null
		)
	)

	@team = _gm_team(@player)
	@colors = _gm_teams_color(@team)

	@inv[103] = array(type: 298, data:-999)
	@inv[102] = array(type: 299, data:-999)
	@inv[101] = array(type: 300, data:-999)
	@inv[100] = array(type: 301, data:-999)		
		
	set_pinv(@player, @inv)
		
		set_itemmeta(@player, 103, array(color: @colors[2]))
		set_itemmeta(@player, 102, array(color: @colors[2]))
		set_itemmeta(@player, 101, array(color: @colors[2]))
		set_itemmeta(@player, 100, array(color: @colors[2]))

	_gm_reset_ammo(@player)

)

proc(_gm_updatehand, @player, @id,

	@ammo_array = import('ocp.gm.player.ammo.' . @player)
	
	if(@id == '', @range = range(0, 9), @range = array(@id))
	
	@inv = pinv(@player)

	foreach(@range, @id,
	
		if(@inv[@id] == null, continue())
		
		@w = import('ocp.gm.weapons.' . @id)
		
		if(@w == null, continue())
		
		@lore = array(
			color(r) . color(l) . 'DMG: ' . color(r) . @w['shot-damage'], 
			color(r) . color(l) . 'MELEE: ' . color(r) . @w['melee-damage'],
			color(r) . color(l) . 'COOL: ' . color(r) . @w['cooldown'] . 's'
		)
		
		@name = @w['name']
		@ammo = @ammo_array[@id]
		
		if(@ammo != 0,
			@color = color(@w['color']) . color(l),
			@color = color(8) . color(l)
		)
		
		if(@ammo == -1, @ammo_tag = '', @ammo_tag = ' (' . @ammo . ')')
		
		#set_itemmeta(@player, @id, array(display: @color . '<' . _adv_string_fill(@color . @name, 80, 2) . @color . '|' . _adv_string_fill(@color . @ammo, 40, 2) . '>', lore: @lore)),
		set_itemmeta(@player, @id, array(display: @color . @name . @ammo_tag, lore: @lore))
		
	)
	
	set_pinv(@player, pinv(@player))
	return(true)
)

proc(_gm_reset_ammo, @player,
	
	@ammo_array = array()
	
	foreach(range(0, 9), @id, 	
		@w = import('ocp.gm.weapons.' . @id)
		if(is_array(@w), @ammo_array[@id] = @w['ammo'])
	)
	
	export('ocp.gm.player.ammo.' . @player, @ammo_array)
	
	_gm_updatehand(@player)	
	
)
		

proc(_gm_give_ammo, @player, @id, @increment,

	@w = import('ocp.gm.weapons.' . @id)
	
	if(@w['ammo'] == -1, return(false))
	
	@ammo_name = @w['ammo-name']
	
	if(!is_numeric(@increment), @increment = @w['ammo-inc'])
	
	@ammo_array = import('ocp.gm.player.ammo.' . @player)
	@ammo_array[@id] += @increment
	export('ocp.gm.player.ammo.' . @player, @ammo_array)
	
	tmsg(@player, color(o) . 'You\'ve obtained ' . color(@w['color']) . color(o) . '+' . @increment . ' ' . @ammo_name)
	
	_gm_updatehand(@player, @id)
	
)

proc(_gm_take_ammo, @player, @id, @decrement,

	@w = import('ocp.gm.weapons.' . @id)
	
	if(@w['ammo'] == -1, return(false))

	if(!is_numeric(@decrement), @decrement = 1)
	
	@ammo_array = import('ocp.gm.player.ammo.' . @player)
	if(@ammo_array[@id] == 0, return(false))
	@ammo_array[@id] -= @decrement
	
	export('ocp.gm.player.ammo.' . @player, @ammo_array)
	
	_gm_updatehand(@player, @id)
	
)

proc(_gm_has_ammo, @player, @id,

	@ammo_array = import('ocp.gm.player.ammo.' . @player)
	if(@ammo_array[@id] == 0, 
		play_sound(ploc(@player), array(sound:SHEEP_SHEAR, pitch:2))
		return(false), 
		return(true)
	)

)

proc(_gm_cooldown, @player, @id,

	@w = import('ocp.gm.weapons.' . @id)

	@seconds = @w['cooldown']
	
	if(!_gm_canshoot(@player))
	{ return(false) }
	else 
	{

		if(@seconds > 0,
			_gm_setshoot(@player, false)	
			_gm_timer_log(
				set_timeout(integer(1000 * @seconds),
					closure(
						_gm_setshoot(@player, true)
						if(@seconds > 0.5, play_sound(ploc(@player), array(sound:SHEEP_SHEAR, pitch:0), @player))
					)
				)
			)
		)

		return(true)
	}
	
)

proc(_gm_hurt_effects, @player, @attacker,

	play_sound(ploc(@player), array(sound: HURT))
	if(@player != @attacker && @attacker != '')
	{ play_sound(ploc(@attacker), array(sound: FALL_BIG, pitch: 0, volume:2), @attacker) }
	make_effect(_vec_add(ploc(@player), array(0,2,0)), 'STEP_SOUND:152')

)

proc(_gm_hurt, @player, @damage, @attacker, @id,

	@gamemode = import('ocp.gm.loaded.gamemode')
	
	if(!_gm_canhurt(@player), return())
	if(@gamemode['teams-enable'] == 1 && @gamemode['teams-ff'] == 0 && _gm_team(@player) == _gm_team(@attacker), return())
	if(@player == @attacker, @damage = @damage * @gamemode['self-damage-mult'])
	
	#==[HEALTH CALCULATION]==#
	
	@hp = plevel(@player) - ceil(@damage)
	set_plevel(@player, @hp)
	@percent = min(round((@hp / 100) * 100), 100)
	set_pexp(@player, @percent)
	
	#==[HURT EFFECTS]==#
	
	@lasthit = import('ocp.gm.player.lasthit.' . @player)
	if(is_numeric(@lasthit) && time() - @lasthit >= 500,
		_gm_hurt_effects(@player, @attacker)
	)
	export('ocp.gm.player.lasthit.' . @player, time())

	#====[PLAYER IS DEAD CODE]====================================================================================================================#
	
	if(@hp < 1,  

		#==[DISTANCE CALCULATION]==#

		if(@attacker == '',
			@distance = 0,
			@distance = round(_vec_dist(ploc(@attacker), ploc(@player)))
		)
		
		#==[HUMLIATION]==#

		if(@attacker != '' && @id == 7,
			_gm_award_humiliation(@attacker, @player)
		)
		
		#==[KILLJOY]==#

		if(import('ocp.gm.player.kill.streak.' . @player) >= 5,
			_gm_award_killjoy(@attacker, @player)
		)
	
	
		#==[KILLSTREAK]==#
		
		export('ocp.gm.player.kill.streak.' . @player, 0)
		
		if(@attacker != '',
			@killstreak = import('ocp.gm.player.kill.streak.' . @attacker)
			if(!is_numeric(@killstreak), @killstreak = 0)
			export('ocp.gm.player.kill.streak.' . @attacker, @killstreak += 1)
			
			_gm_award_killstreak(@attacker, @killstreak)
		)

		if(is_numeric(@id),
			@w = import('ocp.gm.weapons.' . @id)
			@weapon = @w['name']
			@color = color(@w['color'])
			
			@ammo_item = split(':', @w['ammo-item'])
				if(@w['ammo'] != -1 && @player != @attacker,
				drop_item(ploc(@player), array(type:@ammo_item[0], data:@ammo_item[1]))
			),
			
			@weapon = 'UNKNOWN'
			@color = color(8)
		)

		if(@player == @attacker,
		
			broadcast(colorize(color(o) . @player . ' has sent themself to oblivion.'))
			_gm_score(@player, @gamemode['score-suicide']),
			
			broadcast(colorize(color(o) . @attacker . @color . color(o) . ' [' . @weapon . '] ' . color(r) . color(o) . @player))
			if(@attacker != '',
				_gm_stats_kill(@attacker, 1)
				_gm_score(@attacker, @gamemode['score-kill'])
			)
			_gm_score(@player, @gamemode['score-death'])
			
		)
			
		_gm_stats_death(@player, 1)
			
		play_sound(ploc(@player), array(sound:WITHER_HURT, pitch:1))

		_gm_spectate(@player)
		
		_gm_round_check()
	
		play_sound(ploc(@player), array(sound:WITHER_HURT, pitch:1), @player)
		
	)
	
)

#=================================================================================================================================================
# Team Functions
#=================================================================================================================================================

proc(_gm_team_shuffle,

	@gamemode = import('ocp.gm.loaded.gamemode')
	
	if(@gamemode['teams-enable'] == 1, 
		@teams = @gamemode['teams-amount'],
		@teams = 1
	)

	@player_teams = import('ocp.gm.teams')

	@players = array_rand(all_players(), array_size(all_players()), false)

	@current_team = 0
	
	foreach(@players, @player,
	
		@colors = _gm_teams_color(@current_team)
	
		@player_teams[@player] = @current_team
		
		@current_team++
		if(@current_team >= @teams, @current_team = 0)
		
		if(@gamemode['teams-enable'] == 1,
			broadcast(colorize('&f'.@player.'&7 has joined '.@colors[1].'Team '.@colors[0] . '&7.'))
		)
		
	)

	export('ocp.gm.teams', @player_teams)

	return(@player_teams)
	
)

proc(_gm_team_leave, @player, 

	@array = import('ocp.gm.teams')
	
	@team = @array[1][@player]
	
	array_remove(@array[0][@team], @player)
	array_remove(@array[1], @player)
	
	export('ocp.gm.teams', @array)
	return(@array)
	
)

proc(_gm_team_join, @player,

	@player_teams = import('ocp.gm.teams')
	@gamemode = import('ocp.gm.loaded.gamemode')
	
	@team_sizes = array()
	
		foreach(array_unique(array_normalize(@player_teams)), @team,
				@team_sizes[@team] = array_size(array_indexes(@player_teams, @team))
		)
		
		@team_pick = 0

		foreach(@team_sizes, @team, @size,
			if(@size < @team_sizes[@team_pick],
				@team_pick = @team 
			)
		)
		
	@player_teams[@player] = @team_pick

	export('ocp.gm.teams', @player_teams)
	
	@colors = _gm_teams_color(@pick)
	
	if(@gamemode['teams-enable'] == 1,
		broadcast(colorize('&f'.@player.'&7 has joined '.@colors[1].'Team '.@colors[0] . '&7.'))
	)	

	return(@player_teams)
	
)

proc(_gm_teams_color, @team,

	@gamemode = import('ocp.gm.loaded.gamemode')
	
	if(@gamemode['teams-enable'] == 0, return(array('White', color(f), array(r:255,g:255,b:255))))

	switch(@team,
		1,
			return(array('Diamond', color(b), array(r:0,g:0,b:255))),
			return(array('Redstone', color(c), array(r:255,g:0,b:0))),
	)
	
)

proc(_gm_status,

	switch(array_size(@arguments),
		0,
			return(),
		1,
			if(is_boolean(@boolean),
				@boolean = @arguments[0],
				@player = @arguments[0]
			),
			
			@player = @arguments[0]
			@boolean = @arguments[1]
	)

	if(@player == '',
			
		@players = all_players(),
		@players = array(@player)
		
	)
	
	foreach(@players, @player,
		
		@alive = import('ocp.gm.player.alive')
		@team = _gm_team(@player)
		
		if(is_boolean(@boolean),

			if(@boolean,
				@alive[@player] = @team,
				array_remove(@alive, @player)
			)

			export('ocp.gm.player.alive', @alive),
			if(array_index_exists(@alive, @player),
				return(true),
				return(false)
			)
		)
	)
	
)

proc(_gm_team, @player,

	@teams = import('ocp.gm.teams')
	
	try(
		return(@teams[1][@player]),
		return(0)
	)
	
)

proc(_gm_show_objective, @player,

	if(@player == '', @players = all_players(), @players = array(@player))
	@gamemode = import('ocp.gm.loaded.gamemode')
	@map = import('ocp.gm.loaded.map')

	foreach(@players, @player,
		tmsg(@player, colorize('&8+---------------------------------------------------+'))
		tmsg(@player, colorize('&8`&8|' . _adv_string_fill(color(l) . @gamemode['gm_name'] . color(e) . ' on ' . color(l) . @map[name] . color(e) . '.', 310, 2) . '&8|'))
		tmsg(@player, colorize('&8+---------------------------------------------------+'))

		foreach(import('ocp.gm.info'), @line,
			tmsg(@player, colorize('&8`&8|' . @line . '&8|'))
		)

		tmsg(@player, colorize('&8+---------------------------------------------------+'))
		
	)
	
)

proc(_gm_check, 

	@gamemode = import('ocp.gm.loaded.gamemode')
	@map = import('ocp.gm.loaded.map')
	
		@teams = @gamemode['teams-enable']
		@teams_amount = @gamemode['teams-amount']
		
		@players_min = @gamemode['players-min']
		
	if(@teams == 1,
		@total_min = @teams_amount * @players_min,
		@total_min = @players_min
	)
	
	@total = array_size(all_players())

	if(@total >= @total_min,

		if(@gamemode['teams-enable'],
			_gm_team_shuffle(@gamemode['teams-amount']),
			_gm_team_shuffle(0)
		)

		_gm_show_objective()
		
		set_timeout(5000,
			closure(
				_gm_score_reset()
				_gm_start(true)
			)
		)
		
		return(true),
		
		broadcast(colorize('&8+---------------------------------------------------+'))
		broadcast(colorize('&8`&8|' . _adv_string_fill(color(f) . color(l) . 'Waiting for more players...' . color(7) . color(l) . ' (' . @total . ' / ' . @total_min . ')' . color(r), 312, 2) . '&8|'))
		broadcast(colorize('&8+---------------------------------------------------+'))
		
		return(false)
	)
)

proc(_gm_start,

	export('ocp.gm.game.playing', true)
	@rounds = import('ocp.gm.game.rounds')
	@rounds += 1

	@gamemode = import('ocp.gm.loaded.gamemode')
	@map = import('ocp.gm.loaded.map')

	_gm_spawn()

	#foreach(all_players(), @player,

		#set_pscore(SCORE, @player, 0)

	#)
	
	export('ocp.gm.game.rounds', @rounds)

	_gm_round_countdown()
	
)
	
proc(_gm_spawn, @player,

	if(@player != '' && !ponline(@player), return())
	
	try(

		@map = import('ocp.gm.loaded.map')
		@gamemode = import('ocp.gm.loaded.gamemode')
		@spawnpoints = @map['player-spawnpoints']
		
		@alive = import('ocp.gm.player.alive')
		
		if(@player == '',
		
			@players = all_players()
		
			@rand_spawns = array_rand(@spawnpoints, array_size(@spawnpoints), false)
			
			@index_player = 0
			@index_spawn = 0
			
			#======[SPAWN ALL CODE]=======================================================#
			
			while(@index_player < array_size(@players),
			
				@spawn = @rand_spawns[@index_spawn]
				@player = @players[@index_player]
				
				_gm_status(@player, true)
				
				_gm_vanish(@player, false)
				_gm_sethurt(@player, true)
				_gm_heal(@player)

				_gm_equip(@player)

				@spawn[position][3] = @map['world']

				set_ploc(@player, @spawn[position])
				pfacing(@player, @spawn[angles][0], @spawn[angles][1])
				
				play_sound(ploc(@player), array(sound: ZOMBIE_UNFECT, pitch: 1))
				
				@index_player += 1
				@index_spawn += 1
				
				if(@index_spawn == array_size(@rand_spawns), @index_spawn = 0)
				
			),
			
			#======[SPAWN SINGLE CODE]====================================================#
			
			_gm_status(@player, true)
			
			_gm_vanish(@player, false)
			_gm_sethurt(@player, true)
			_gm_heal(@player)

			_gm_equip(@player)
			
			if(@gamemode['teams-enable'],
			
				@pick = array_rand(@spawnpoints, 1, false)[0]
				
				@random = array_rand(@spawnpoints, array_size(@spawnpoints), false)

				foreach(@random, @name, @spawn, if(@spawn[team] == @team, @pick = @spawn break())),
				
				@pick = array_rand(@spawnpoints, 1, false)[0]	
					
				@vectors = array()

				foreach(array_keys(@alive), @enemy, @vectors[] = ploc(@enemy))			
				
				@anchor = _vec_average(@vectors)
				
				foreach(@spawnpoints, @spawn,
					@dist_old = _vec_dist(@pick[position], @anchor)

					@dist_new = _vec_dist(@spawn[position], @anchor)

					if(@dist_new >= @dist_old, @pick = @spawn)
				),			
					
			)
			
			@pick[position][3] = @map['world']
			
			set_ploc(@player, @pick[position])
			pfacing(@player, @pick[angles][0], @pick[angles][1])
			
			play_sound(ploc(@player), array(sound: ZOMBIE_UNFECT, pitch: 1))
			
		),
		
		@ex, console(@ex)
		
	)
)

proc(_gm_spectate, @player, @nomsg,

	set_pvelocity(@player, array(0,0,0))

	_gm_vanish(@player, true)
	_gm_sethurt(@player, false)
	_gm_status(@player, false)

	_gm_heal(@player)

	@map = import('ocp.gm.loaded.map')

	@pick = array_rand(@map['spectator-spawnpoints'], 1, false)[0]
	
	set_ploc(@player, @pick[position])
	pfacing(@player, @pick[angles][0], @pick[angles][1])
	
	if(!@nomsg,
	
		@gamemode = import('ocp.gm.loaded.gamemode')
		
		if(import('ocp.gm.game.playing'),
			@respawn = @gamemode['respawntime'],
			@respawn = 0
		)

		switch(@respawn,
			-1,
				tmsg(@player, colorize('&aYou will respawn during the next round.')),
			
			0,
				_gm_spawn(@player),		
				
				tmsg(@player, colorize('&aYou will respawn in &f'.@respawn.' &aseconds.'))

				_gm_timer_log(
					set_timeout(@respawn * 1000,
						closure(
							if(@gamemode['teams-enable'],
								_gm_spawn(@player),
								_gm_spawn(@player, true)
							)
						)
					)
				)
		)
	)
	
)

proc(_gm_round_check, @player,

	if(!import('ocp.gm.game.playing'), return())

	@score_players = import('ocp.gm.player.score')
	
	@gamemode = import('ocp.gm.loaded.gamemode')
	
	#@team = _gm_team(@player)
	#@colors = _gm_teams_color(@team)
	
	#if(@gamemode['teams-enable'],
		#@score = @stats_teams[@team][2],
	#)
	
	@win_score = @gamemode['win-score']
	@win_last = @gamemode['win-last']

	if(@win_score != -1,
		foreach(@score_players, @player, @score,
			if(@score >= @win_score, 
				@winner = @player
				break()
			)
		)
	)
	
	@alive = import('ocp.gm.player.alive')

	if(array_size(@alive) == 1 && @win_last == 1, @winner = array_keys(@alive)[0])
	
	if(@winner != '', _gm_round_end(@winner))
	
)

proc(_gm_round_end, @winner,

	_gm_timer_clear()

	@players = all_players()
	
	foreach(@players, @player,
		_gm_spectate(@player, true)
		play_sound(ploc(@player), array(sound:'WITHER_SPAWN', pitch:0), @player)
	)

	@round = import('ocp.gm.game.rounds')
	@stats = import('ocp.gm.player.stats')
	@scores = import('ocp.gm.player.score')
	
	broadcast(colorize('&6+---------------------------------------------------+'))
	#if(@gamemode['teams-enable'],
		#broadcast(colorize('&0`&6| ' . _adv_string_fill(@colors[1].'&lTeam ' . @colors[0] . color(f) . ' wins round ' . @round . '!', 304, 2) . '&0`&6|')),
		broadcast(colorize('&8`&6| ' . _adv_string_fill(color(f) . color(l) . @winner. ' wins the round!' . color(r), 304, 2) . '&8`&6|'))
	#)
	broadcast(colorize('&8+---------------------------------------------------+'))	
	broadcast(colorize('&8`&8|&f ' . _adv_string_fill(color(7) . color(l) . 'Player' . color(r), 106, 0) . _adv_string_fill(color(7) . color(l) . 'Kills' . color(r), 50, 0) . _adv_string_fill(color(7) . color(l) . 'Deaths' . color(r), 50, 0) . _adv_string_fill(color(7) . color(l) . 'Ratio' . color(r), 50, 0) . _adv_string_fill(color(7) . color(l) . 'Score' . color(r), 50, 0) . '&8|'))
	broadcast(colorize('&8+---------------------------------------------------+'))
	
	@order = _gm_score_order()
	
	foreach(range(3), @i,
		try(@player = @order[@i], continue())
		@score = @scores[@player]
		@stat = @stats[@player]
		@ratio = _gm_stats_ratio(@player)
		@line = '&8`&8|&f ' . _adv_string_fill(@player, 106, 0) . _adv_string_fill(@stat[0].'', 50, 0) . _adv_string_fill(@stat[1].'', 50, 0) . _adv_string_fill(@ratio.'', 50, 0) . _adv_string_fill(@score.'', 50, 0) . '&8|'
		broadcast(colorize(@line))
	)
	
	broadcast(colorize('&8+---------------------------------------------------+'))
	
	_gm_score_reset()
		
	foreach(all_players(), @player,
		_gm_setshoot(@player, false)
		_gm_sethurt(@player, false)
	)

	set_timeout(5000, closure(_gm_start()))
		
)

proc(_gm_game_end, @force,

	if(@force,
	
		broadcast(colorize('&7The game has been forced to end.'))
		
	)
	
	broadcast(colorize('&7Ending game...'))
	
	set_timeout(1000,
		closure(
			_gm_load()
		)
	)	

)

proc(_gm_vanish, @player, @boolean,

	@vanished = import('ocp.gm.player.vanish')
	
	if(@boolean,
		@vanished[] = @player
		foreach(all_players(), @witness,
			raw_set_pvanish(@player, true, @witness)
		),
		array_remove_values(@vanished, @player)
		foreach(all_players(), @witness,
			raw_set_pvanish(@player, false, @witness)
		)
	)	
	
	export('ocp.gm.player.vanish', @vanished)
)

proc(_gm_sethurt, @player, @boolean,

	@hurt = import('ocp.gm.player.nohurt.' . @player)
	
	if(@boolean,
		@hurt = null,
		@hurt = true
	)
	
	export('ocp.gm.player.nohurt.' . @player, @hurt)

)

proc(_gm_canhurt, @player,

	@hurt = import('ocp.gm.player.nohurt.' . @player)

	if(@hurt == true,
		return(false),
		return(true)
	)
	
)

proc(_gm_setshoot, @player, @boolean,

	@shoot = import('ocp.gm.player.noshoot.' . @player)
	
	if(@boolean,
		@shoot = null,
		@shoot = true
	)
	
	export('ocp.gm.player.noshoot.' . @player, @shoot)

)

proc(_gm_canshoot, @player,

	@shoot = import('ocp.gm.player.noshoot.' . @player)

	if(@shoot == true,
		return(false),
		return(true)
	)
	
)

proc(_gm_stats_reset, @player,

	if(@player == '',
	
		@stats = associative_array()
		@players = all_players()
		foreach(@players, @player,
			@stats[@player] = array(0, 0)
		),
		
		@stats = import('ocp.gm.player.stats')
		@stats[@player] = array(0, 0)
	)

	export('ocp.gm.player.stats', @stats)
	
)

proc(_gm_stats_kill, @player, @int,

	@stats = import('ocp.gm.player.stats')

	@stats[@player][0] += @int
		
	export('ocp.gm.player.stats', @stats)
	
)

proc(_gm_stats_death, @player, @int,

	@stats = import('ocp.gm.player.stats')

	@stats[@player][1] += @int
		
	export('ocp.gm.player.stats', @stats)

)

proc(_gm_stats_ratio, @player,

	@stats = import('ocp.gm.player.stats')[@player]
	
	if(@stats[1] == 0, @stats[1] = 1)
	if(@stats[0] == 0, return(0))
	
	return(round(@stats[0] / @stats[1] * 100) / 100)
	
)

proc(_gm_score_reset, @player,

	if(@player == '',
	
		@score = associative_array()
		@players = all_players()
		foreach(@players, @player,
			@score[@player] = 0
		),
		
		@score = import('ocp.gm.player.score')
		@score[@player] = 0
	)

	export('ocp.gm.player.score', @score)
	
)

proc(_gm_score, @player, @int,

	@score = import('ocp.gm.player.score')

	try(@score[@player] += @int, @score[@player] = @int)
	
	#set_pscore(SCORE, @player, @score[@player])
		
	export('ocp.gm.player.score', @score)
	
	#if(@score[@player] >= 0, _gm_round_check())

)

proc(_gm_score_order,

	@scores = import('ocp.gm.player.score')
	@names = array()
	
	foreach(@scores, @player, @score,
		@names[] = @score . '><' . @player
	)
	
	@names = array_sort(@names, 'STRING_IC')
	array_reverse(@names)
	
	foreach(@names, @i, @string,
		@names[@i] = split('><', @string)[1]
	)
	
	return(@names)
	
)

proc(_gm_award_accuracy, @player,

	broadcast(color(e) . color(o) . @player . ' ACCURACY!')
	
)

proc(_gm_award_humiliation, @player, @victim,

	tmsg(@player, color(b) . color(o) . 'You\'ve HUMILIATED ' . @victim . '!')
	
)

proc(_gm_award_killjoy, @player, @victim,

	broadcast(color(a) . color(o) . @player . ' has ERASED ' . @victim . '!')
	
)

proc(_gm_award_multikill, @player,

	broadcast(color(d) . color(o) . @player . ' MULTIKILL!')
	
)

proc(_gm_award_killstreak, @player, @kills,

	switch(@kills,
		5,
			broadcast(color(6) . color(o) . @player . ' KILLING SPREE!'),
		10,
			broadcast(color(6) . color(o) . @player . ' RAMPAGE!'),
		15,
			broadcast(color(6) . color(o) . @player . ' DOMINATING!'),
		20,
			broadcast(color(6) . color(o) . @player . ' UNSTOPPABLE!'),
		25,
			broadcast(color(6) . color(o) . @player . ' GODLIKE!'),
	)
	
)
	

proc(_gm_heal, @player,

	_emptyinv(@player)

	@gamemode = import('ocp.gm.loaded.gamemode')

	set_pwalkspeed(@player, @gamemode['speed'])
	set_phealth(@player, 20)
	set_plevel(@player, @gamemode['health'])
	set_pexp(@player, 100)
	set_pmode(@player, ADVENTURE)
	set_pfood(@player, 20)
	
	
)

proc(_gm_clearuser, @player,

	_stats_reset(@player)

	@cooldowns = import('ocp.gm.player.noshoot')
	array_remove(@cooldowns, player())
	export('ocp.gm.player.noshoot', @cooldowns)
	
)

proc(_gm_timer_log, @int,

	@timers = import('ocp.gm.timers')
	
	if(@timers == null, @timers = array())
	
	@timers[] = @int
	
	export('ocp.gm.timers', @timers)
	
)

proc(_gm_timer_clear, @int,

	@timers = import('ocp.gm.timers')
	
	if(@timers == null, return(false))
	
	foreach(@timers, @timer,
		clear_task(@timer)
	)
	
	export('ocp.gm.timers', array())
	
)

proc(_gm_round_countdown,

	@players = all_players()
	@round = import('ocp.gm.game.rounds')
	
	@lores = array()
	
	@tag = color(f) . color(l) . '= Round ' . @round . ' ='
	foreach(@players, @player,
		@lores[@player] = array()
		_gm_sethurt(@player, false)
		_gm_setshoot(@player, false)
		foreach(range(1,8), @id,
				@lores[@player][@id] = get_itemmeta(@player, @id)
				try(set_itemmeta(@player, @id, array(display: @tag)))
		)
	)
	
	set_timeout(2000,
		closure(
			@tag = color(f) . color(l) . '[5]'
			foreach(@players, @player,
				foreach(range(1,8), @id,
						try(set_itemmeta(@player, @id, array(display: @tag)))	
				)
			)
		)
	)
	
	set_timeout(3000,
		closure(
			@tag = color(f) . color(l) . '[4]'
			foreach(@players, @player,
				foreach(range(1,8), @id,
						try(set_itemmeta(@player, @id, array(display: @tag)))												
				)
			)
		)
	)
	
	set_timeout(4000,
		closure(
			@tag = color(e) . color(l) . '[3]'
			foreach(@players, @player,
				try(play_sound(ploc(@player), array(sound: NOTE_PLING), @player))
				foreach(range(1,8), @id,
						try(set_itemmeta(@player, @id, array(display: @tag)))											
				)
			)
		)
	)
	
	set_timeout(5000,
		closure(
			@tag = color(6) . color(l) . '[2]'
			foreach(@players, @player,
				try(play_sound(ploc(@player), array(sound: NOTE_PLING), @player))
				foreach(range(1,8), @id,
						try(set_itemmeta(@player, @id, array(display: @tag)))												
				)
			)
		)
	)
	
	set_timeout(6000,
		closure(
			@tag = color(c) . color(l) . '[1]'
			foreach(@players, @player,
				try(play_sound(ploc(@player), array(sound: NOTE_PLING), @player))
				foreach(range(1,8), @id,
						try(set_itemmeta(@player, @id, array(display: @tag)))
				)
			)
		)
	)
	
	set_timeout(7000,
		closure(
			foreach(@players, @player,
				_gm_sethurt(@player, true)
				_gm_setshoot(@player, true)
				try(play_sound(ploc(@player), array(sound: NOTE_PLING, pitch:2), @player))
				foreach(range(1,8), @id,	
						try(set_itemmeta(@player, @id, @lores[@player][@id]))
				)
			)
		)
	)
)


#==[GUNBLADE]=====================================================================#

proc(_gm_fire_0, @player,

		if(!_gm_has_ammo(player(), 0) || !_gm_cooldown(player(), 0), die())

		@w = import('ocp.gm.weapons.0')

	#==[GUN FIRE]==#
		
		@vec = _forward(@player)

		@bullets = import('ocp.gm.bullets')
		
		@id = shoot_projectile(@player, SNOWBALL)
		set_entity_velocity(@id, _vec_mult(@vec, 5))
		
		@bullets[@id] = 0
		
		export('ocp.gm.bullets', @bullets)

	#==[GUN SOUND]==#
	
		play_sound(ploc(@player), array(sound:ZOMBIE_METAL, pitch:2))
		
	#==[AMMO DEPLETION]==#
		
		_gm_take_ammo(@player, 0)
	
)

proc(_gm_hit_0, @player, @attacker, @vec,

	@w = import('ocp.gm.weapons.0')
	
	_gm_hurt(@player, @w['melee-damage'], @attacker, 0)

	set_pvelocity(@player, array(@vec[0] * 2, @vec[1] * 0, @vec[2] * 2))
	
)

proc(_gm_shot_dir_0, @player, @attacker, @vec,

	@w = import('ocp.gm.weapons.0')
	
	_gm_hurt(@player, @w['shot-damage'], @attacker, 0)

	#set_pvelocity(@player, array(@vec[0] * 2, @vec[1] * 0, @vec[2] * 2))
	
)

proc(_gm_shot_ind_0, @player, @loc,

	make_effect(@loc, 'STEP_SOUND:41')
	
)

#==[LIGHTNIN0OLT]=====================================================================#

proc(_gm_fire_1, @player,

		if(!_gm_has_ammo(player(), 1) || !_gm_cooldown(player(), 1), die())

		@w = import('ocp.gm.weapons.1')

	#==[GUN SPLASH]==#

		#make_effect(pcursor(@player), 'STEP_SOUND:51')
		/*
		if(@w['splash-cursor'],
			@offset = _vec_add(pcursor(), array(@vec[0], @vec[1] * -0.995, @vec[2]))
			@offset = array(@offset[0], @offset[1], @offset[2])
			@hit = _explode(@offset, @w['splash-radius'], array(@w['splash-push-x'], @w['splash-push-y']), array(), 4)
			foreach(@hit, @target, @percent,
				@dmg = ceil(@w['splash-damage'] * @percent)
				execute(closure(_gm_hurt(@target, @dmg, @attacker, @weapid)))
			)
		)
		*/ 
		
	#==[GUN FIRE]==#
							
		@line = _vec_iterate_los(@player)

		execute(
			closure(
			
				@targets = all_entities()	
				@targeted = array()

				foreach(@line, @i, @l,
				
					if(mod(@i, 4) == 0, make_effect(@line[@i], 'STEP_SOUND:57'))

					foreach(@targets, @target,
					
						if(entity_type(@target) != PLAYER, continue())
					
						@t = entity_loc(@target)
						
						if(		
							(@l[0] - 0.75 <= @t[0] && @t[0] <= @l[0] + 1.75) && 
							
							(@l[1] - 1.5 <= @t[1] && @t[1] <= @l[1] + 2.5) && 
							
							(@l[2] - 0.75 <= @t[2] && @t[2] <= @l[2] + 1.75)
						)
						{
							if(@target != pinfo(@player)[13] && !array_contains(@targeted, @target),
								_gm_hurt(get_player_from_entity_id(@target), @w['shot-damage'], @player, 1)
								set_entity_velocity(@target, _forward(@player))
								@targeted[] = @target
							)
						}
						
					)
					
				)
			
				play_sound(ploc(@player), array(sound:ZOMBIE_REMEDY, pitch:1))
										
			)
		)

	#==[AMMO DEPLETION]==#
		
		_gm_take_ammo(@player, 1)	
)

proc(_gm_hit_1, @player, @attacker, @vec,

	@w = import('ocp.gm.weapons.1')
	
	_gm_hurt(@player, @w['melee-damage'], @attacker, 1)

	set_pvelocity(@player, array(@vec[0] * 2, @vec[1] * 0, @vec[2] * 2))
	
)

proc(_gm_shot_dir_1, @player, @attacker, @vec,

	@w = import('ocp.gm.weapons.1')
	
	_gm_hurt(@player, @w['shot-damage'], @attacker, 1)

	set_pvelocity(@player, array(@vec[0] * 3, @vec[1] * 1, @vec[2] * 3))
	
)

proc(_gm_shot_ind_1, @player, @loc,

	#make_effect(@loc, 'STEP_SOUND:44')
	
	return()
	
)

#==[FIREBALL]=====================================================================#

proc(_gm_fire_2, @player,

		if(!_gm_has_ammo(player(), 2) || !_gm_cooldown(player(), 2), die())

		@w = import('ocp.gm.weapons.2')

	#==[GUN FIRE]==#
		
		@vec = _forward(@player)

		@bullets = import('ocp.gm.bullets')
		
		@id = shoot_projectile(@player, SMALL_FIREBALL)
		set_entity_velocity(@id, _vec_mult(@vec, 0.2))
		
		@bullets[@id] = 2
		
		export('ocp.gm.bullets', @bullets)

	#==[GUN SOUND]==#
	
		play_sound(ploc(@player), array(sound:PISTON_EXTEND, pitch:0))
		
	#==[AMMO DEPLETION]==#
		
		_gm_take_ammo(@player, 2)	
)

proc(_gm_hit_2, @player, @attacker, @vec,

	@w = import('ocp.gm.weapons.2')
	
	_gm_hurt(@player, @w['melee-damage'], @attacker, 2)

	set_pvelocity(@player, array(@vec[0] * 2, @vec[1] * 0, @vec[2] * 2))
	
)

proc(_gm_shot_dir_2, @player, @attacker, @vec,

	play_sound(ploc(@player), array(sound:EXPLODE, pitch:1))

	@w = import('ocp.gm.weapons.2')
	
	_gm_hurt(@player, @w['shot-damage'], @attacker, 2)

	set_pvelocity(@player, array(@vec[0] * 3, @vec[1] * 1, @vec[2] * 3))

	@offset = _vec_add(ploc(@player), array(@vec[0], @vec[1] * -0.5, @vec[2]))
	@offset = array(@offset[0], @offset[1], @offset[2])
	@hit = _explode(@offset, 6, array(3, 1), array(@player), 4)
	foreach(@hit, @target, @percent,
		@dmg = ceil(@w['splash-damage'] * @percent)
		_gm_hurt(@target, @dmg, @attacker, 2)
	)
		
)

proc(_gm_shot_ind_2, @player, @loc, @vec,

	make_effect(@loc, 'STEP_SOUND:11')
	play_sound(@loc, array(sound:EXPLODE, pitch:1))
	
	@w = import('ocp.gm.weapons.2')
	
	@offset = _vec_add(@loc, array(@vec[0], @vec[1] * -0.5, @vec[2]))
	@offset = array(@offset[0], @offset[1], @offset[2])
	@hit = _explode(@offset, 6, array(3, 1), array(), 4)
	foreach(@hit, @target, @percent,
		@dmg = ceil(@w['splash-damage'] * @percent)
		_gm_hurt(@target, @dmg, @player, 2)
	)
	
	return()
	
)

#==[SHOTGUN]=====================================================================#

proc(_gm_fire_3, @player,

		if(!_gm_has_ammo(player(), 3) || !_gm_cooldown(player(), 3), die())

		@w = import('ocp.gm.weapons.3')

	#==[GUN FIRE]==#

		@bullets = import('ocp.gm.bullets')
		
		@vectors = array()
		
		@pi = to_radians(180)
		
		@i = 6
		@o = to_radians(36)
		
		@vectors[] = _forward(@player, sin(@pi * 1.0 + @o) * @i, cos(@pi * 1.0 + @o) * @i)
		@vectors[] = _forward(@player, sin(@pi * 1.4 + @o) * @i, cos(@pi * 1.4 + @o) * @i)
		@vectors[] = _forward(@player, sin(@pi * 1.8 + @o) * @i, cos(@pi * 1.8 + @o) * @i)
		@vectors[] = _forward(@player, sin(@pi * 2.2 + @o) * @i, cos(@pi * 2.2 + @o) * @i)
		@vectors[] = _forward(@player, sin(@pi * 2.6 + @o) * @i, cos(@pi * 2.6 + @o) * @i)
		
		@i = 3
		@o = to_radians(0)
		
		@vectors[] = _forward(@player, sin(@pi * 1.0 + @o) * @i, cos(@pi * 1.0 + @o) * @i)
		@vectors[] = _forward(@player, sin(@pi * 1.4 + @o) * @i, cos(@pi * 1.4 + @o) * @i)
		@vectors[] = _forward(@player, sin(@pi * 1.8 + @o) * @i, cos(@pi * 1.8 + @o) * @i)
		@vectors[] = _forward(@player, sin(@pi * 2.2 + @o) * @i, cos(@pi * 2.2 + @o) * @i)
		@vectors[] = _forward(@player, sin(@pi * 2.6 + @o) * @i, cos(@pi * 2.6 + @o) * @i)
		/*
		@i = 3
		@o = to_radians(54)
		
		@vectors[] = _forward(@player, sin(@pi * 1.0 + @o) * @i, cos(@pi * 1.0 + @o) * @i)
		@vectors[] = _forward(@player, sin(@pi * 1.4 + @o) * @i, cos(@pi * 1.4 + @o) * @i)
		@vectors[] = _forward(@player, sin(@pi * 1.8 + @o) * @i, cos(@pi * 1.8 + @o) * @i)
		@vectors[] = _forward(@player, sin(@pi * 2.2 + @o) * @i, cos(@pi * 2.2 + @o) * @i)
		@vectors[] = _forward(@player, sin(@pi * 2.6 + @o) * @i, cos(@pi * 2.6 + @o) * @i)
		
		@i = 3
		@o = to_radians(18)
		
		@vectors[] = _forward(@player, sin(@pi * 1.0 + @o) * @i, cos(@pi * 1.0 + @o) * @i)
		@vectors[] = _forward(@player, sin(@pi * 1.4 + @o) * @i, cos(@pi * 1.4 + @o) * @i)
		@vectors[] = _forward(@player, sin(@pi * 1.8 + @o) * @i, cos(@pi * 1.8 + @o) * @i)
		@vectors[] = _forward(@player, sin(@pi * 2.2 + @o) * @i, cos(@pi * 2.2 + @o) * @i)
		@vectors[] = _forward(@player, sin(@pi * 2.6 + @o) * @i, cos(@pi * 2.6 + @o) * @i)	
		*/
		
		execute(
			closure(
				foreach(@vectors, @vec,
					
					@id = shoot_projectile(@player, SNOWBALL)
					set_entity_velocity(@id, _vec_mult(@vec, 5))
					
					@bullets[@id] = 3
					
				)
					
				export('ocp.gm.bullets', @bullets)
			)
		)

	#==[GUN SOUND]==#
	
		play_sound(ploc(@player), array(sound:ZOMBIE_WOOD, pitch:0))
		
	#==[AMMO DEPLETION]==#
		
		_gm_take_ammo(@player, 3)	
)

proc(_gm_hit_3, @player, @attacker, @vec,

	@w = import('ocp.gm.weapons.3')
	
	_gm_hurt(@player, @w['melee-damage'], @attacker, 3)

	set_pvelocity(@player, array(@vec[0] * 2, @vec[1] * 0, @vec[2] * 2))
	
)

proc(_gm_shot_dir_3, @player, @attacker, @vec,

	@w = import('ocp.gm.weapons.3')
	
	_gm_hurt(@player, @w['shot-damage'], @attacker, 3)

	#set_pvelocity(@player, array(@vec[0] * 3, @vec[1] * 1, @vec[2] * 3))
	
)

proc(_gm_shot_ind_3, @player, @loc, 

	#make_effect(@loc, 'STEP_SOUND:44')
	
	return()
	
)

#==[PLASMAGUN]=====================================================================#

proc(_gm_fire_4, @player,

		if(!_gm_has_ammo(player(), 4) || !_gm_cooldown(player(), 4), die())

		@w = import('ocp.gm.weapons.4')

	#==[GUN FIRE]==#
		
		@vec = _forward(@player)

		@bullets = import('ocp.gm.bullets')
		
		@id = shoot_projectile(@player, SNOWBALL)
		set_entity_velocity(@id, _vec_mult(@vec, 5))
		
		@bullets[@id] = 4
		
		export('ocp.gm.bullets', @bullets)
		
	#==[GUN SOUND]==#
	
		play_sound(ploc(@player), array(sound:FALL_BIG, pitch:2))
		
	#==[AMMO DEPLETION]==#
		
		_gm_take_ammo(@player, 4)	
)

proc(_gm_hit_4, @player, @attacker, @vec,

	@w = import('ocp.gm.weapons.4')
	
	_gm_hurt(@player, @w['melee-damage'], @attacker, 4)

	set_pvelocity(@player, array(@vec[0] * 2, @vec[1] * 0, @vec[2] * 2))
	
)

proc(_gm_shot_dir_4, @player, @attacker, @vec,

	@w = import('ocp.gm.weapons.4')
	
	_gm_hurt(@player, @w['shot-damage'], @attacker, 4)

	set_pvelocity(@player, array(@vec[0] * 0.5, @vec[1] * 0.25, @vec[2] * 0.5))
	
)

proc(_gm_shot_ind_4, @player, @loc, @vec,

	make_effect(@loc, 'STEP_SOUND:133')
	
)

#==[IMPACTLAUNCHER]=====================================================================#

proc(_gm_fire_5, @player,

		if(!_gm_has_ammo(player(), 5) || !_gm_cooldown(player(), 5), die())

		@w = import('ocp.gm.weapons.5')

	#==[GUN FIRE]==#
		
		@vec = _forward(@player)

		@bullets = import('ocp.gm.bullets')
		
		@id = shoot_projectile(@player, SNOWBALL)
		set_entity_velocity(@id, _vec_mult(@vec, 1.1))
		
		@bullets[@id] = 5
		
		export('ocp.gm.bullets', @bullets)
		
	#==[GUN SOUND]==#
	
		play_sound(ploc(@player), array(sound:PISTON_RETRACT, pitch:0))
		
	#==[AMMO DEPLETION]==#
		
		_gm_take_ammo(@player, 5)	
)

proc(_gm_hit_5, @player, @attacker, @vec,

	@w = import('ocp.gm.weapons.5')
	
	_gm_hurt(@player, @w['melee-damage'], @attacker, 5)

	set_pvelocity(@player, array(@vec[0] * 2, @vec[1] * 0, @vec[2] * 2))
	
)

proc(_gm_shot_dir_5, @player, @attacker, @vec,

	play_sound(ploc(@player), array(sound:EXPLODE, pitch:1.5))

	@w = import('ocp.gm.weapons.5')
	
	_gm_hurt(@player, @w['shot-damage'], @attacker, 5)

	set_pvelocity(@player, array(@vec[0] * 0.5, @vec[1] * 0.25, @vec[2] * 0.5))

	@offset = _vec_add(ploc(@player), array(@vec[0], @vec[1] * -0.5, @vec[2]))
	@offset = array(@offset[0], @offset[1], @offset[2])
	@hit = _explode(@offset, 6, array(1, 0.5), array(@player), 4)
	foreach(@hit, @target, @percent,
		@dmg = ceil(@w['splash-damage'] * @percent)
		_gm_hurt(@target, @dmg, @attacker, 5)
	)
	
)

proc(_gm_shot_ind_5, @player, @loc, @vec,

	make_effect(@loc, 'STEP_SOUND:22')
	play_sound(@loc, array(sound:EXPLODE, pitch:1.5))
	
	@w = import('ocp.gm.weapons.5')
	
	@offset = _vec_add(@loc, array(@vec[0], @vec[1] * -0.5, @vec[2]))
	@offset = array(@offset[0], @offset[1], @offset[2])
	@hit = _explode(@offset, 6, array(1, 0.5), array(), 4)
	foreach(@hit, @target, @percent,
		@dmg = ceil(@w['splash-damage'] * @percent)
		_gm_hurt(@target, @dmg, @player, 5)
	)	
	
)

#==[MERCURY]=====================================================================#

proc(_gm_fire_6, @player,

		if(!_gm_has_ammo(player(), 6) || !_gm_cooldown(player(), 6), die())

		@w = import('ocp.gm.weapons.6')

	#==[GUN FIRE]==#
		
		@vec = _forward(@player)

		@bullets = import('ocp.gm.bullets')
		
		@id = shoot_projectile(@player, WITHER_SKULL)
		set_entity_velocity(@id, _vec_mult(@vec, 1.1))
		
		@bullets[@id] = 6
		
		export('ocp.gm.bullets', @bullets)
		
	#==[GUN SOUND]==#
	
		play_sound(ploc(@player), array(sound:WITHER_SHOOT, pitch:0))
		
	#==[AMMO DEPLETION]==#
		
		_gm_take_ammo(@player, 6)	
)

proc(_gm_hit_6, @player, @attacker, @vec,

	@w = import('ocp.gm.weapons.6')
	
	_gm_hurt(@player, @w['melee-damage'], @attacker, 6)

	set_pvelocity(@player, array(@vec[0] * 2, @vec[1] * 0, @vec[2] * 2))
	
)

proc(_gm_shot_dir_6, @player, @attacker, @vec,

	play_sound(ploc(@player), array(sound:EXPLODE, pitch:1))

	@w = import('ocp.gm.weapons.6')
	
	_gm_hurt(@player, @w['shot-damage'], @attacker, 6)

	set_pvelocity(@player, array(@vec[0] * 0.5, @vec[1] * 0.25, @vec[2] * 0.5))

	@offset = _vec_add(ploc(@player), array(@vec[0], @vec[1] * -0.5, @vec[2]))
	@offset = array(@offset[0], @offset[1], @offset[2])
	@hit = _explode(@offset, 5, array(3, 1), array(@player), 4)
	foreach(@hit, @target, @percent,
		@dmg = ceil(@w['splash-damage'] * @percent)
		_gm_hurt(@target, @dmg, @attacker, 6)
	)
	
)

proc(_gm_shot_ind_6, @player, @loc, @vec,

	make_effect(@loc, 'STEP_SOUND:119')
	play_sound(@loc, array(sound:EXPLODE, pitch:1))
	
	@w = import('ocp.gm.weapons.6')
	
	@offset = _vec_add(@loc, array(@vec[0], @vec[1] * -0.5, @vec[2]))
	@offset = array(@offset[0], @offset[1], @offset[2])
	@hit = _explode(@offset, 5, array(3, 1), array(), 4)
	foreach(@hit, @target, @percent,
		@dmg = ceil(@w['splash-damage'] * @percent)
		_gm_hurt(@target, @dmg, @player, 6)
	)
	
)

#==[DASH]=====================================================================#

proc(_gm_fire_7, @player,

		if(!_gm_has_ammo(player(), 7) || !_gm_cooldown(player(), 7), die())

		@w = import('ocp.gm.weapons.7')

	#==[GUN RECOIL]==#
		
		@vec = _forward(@player)
		if(split(':', get_block_at(ploc(@player)))[0] != 0,
			set_pvelocity(player(), array(0,1,0))
			set_timeout(100,
				closure(
					set_pvelocity(@player, array(@vec[0] * 1.5, @vec[1] * 0.8, @vec[2] * 1.5))
				)
			),
			set_pvelocity(@player, array(@vec[0] * 1.5, @vec[1] * 0.8, @vec[2] * 1.5))
		)
		
	#==[GUN SOUND]==#
	
		play_sound(ploc(@player), array(sound:BREATH, pitch:2))
		
	#==[AMMO DEPLETION]==#
		
		_gm_take_ammo(@player, 7)	
)

proc(_gm_hit_7, @player, @attacker, @vec,

	@w = import('ocp.gm.weapons.7')
	
	_gm_hurt(@player, @w['melee-damage'], @attacker, 5)

	set_pvelocity(@player, array(@vec[0] * 2, @vec[1] * 0, @vec[2] * 2))
	
)

proc(_gm_shot_dir_7, @player, @attacker, @vec,

	return()

	#@w = import('ocp.gm.weapons.5')
	
	#_gm_hurt(@player, @w['shot-damage'], @attacker, 5)

	#set_pvelocity(@player, array(@vec[0] * 0.5, @vec[1] * 0.25, @vec[2] * 0.5))
	
)

proc(_gm_shot_ind_7, @player, @loc,

	return()

	#make_effect(@loc, 'STEP_SOUND:133')
	
)
	



		

	
	
_gm_load()

bind(player_join, null, null, @event,

	modify_event(message, null)
	
	broadcast(player() . color(7) . ' connected.')

	@gamemode = import('ocp.gm.loaded.gamemode')
	@map = import('ocp.gm.loaded.map')

	set_ploc(array(0,0,0,@map['world']))

	_gm_stats_reset(player())
	export('ocp.gm.stats', @stats)
	
	@vanished = import('ocp.gm.player.vanish')
	foreach(@vanished, @vanish,
		try(
			raw_set_pvanish(@vanish, true, player()),
			array_remove_values(@vanished, @vanish)
			export('ocp.gm.player.vanish', @vanished)
		)
	)
	
	if(import('ocp.gm.game.playing'), 
		_gm_team_join(player())
		_gm_spectate(player()),

		_gm_spawn(player())
		_gm_check()
	)

	msg(colorize('&eType &f/rules &efor the rules of the current gamemode.'))
	msg(colorize('&eType &f/help &eto learn how to play this game.'))
	 
)

bind(player_quit, null, null, @event,

	modify_event(message, null)
	
	broadcast(player() . color(7) . ' disconnected.')

	_gm_status(player(), false)
	_gm_setshoot(player(), true)

	@stats = import('ocp.gm.player.stats')
	@score = import('ocp.gm.player.score')
	array_remove(@score, player())
	array_remove(@stats, player())
	export('ocp.gm.player.stats', @stats)
	export('ocp.gm.player.score', @score)
	
	@players = all_players()

	if(array_size(@players) <= 2 && import('ocp.gm.game.playing'), 
		_gm_game_end(true)
	)

)

bind(entity_damage, array(priority:highest), null, @event,

	modify_event(amount, 0)
	cancel()

	@bullets = import('ocp.gm.bullets')

	if(array_index_exists(@event, damager) && array_index_exists(@bullets, @event[damager]),
		@id = @bullets[@event[damager]]
		array_remove(@bullets, @event[damager])
		export('ocp.gm.bullets', @bullets),
		@id = pinfo(@attacker, 15)
	)

	switch(@event[cause],
		
		'ENTITY_ATTACK',
		
			@vec = _forward(@attacker)
			@attacker = @event[damager]
			
			if(!_gm_cooldown(@attacker, @id), die())
			
			switch(@id,
				0, _gm_hit_0(player(), @attacker, @vec),
				1, _gm_hit_1(player(), @attacker, @vec),
				2, _gm_hit_2(player(), @attacker, @vec),
				3, _gm_hit_3(player(), @attacker, @vec),
				4, _gm_hit_4(player(), @attacker, @vec),
				5, _gm_hit_5(player(), @attacker, @vec),
				6, _gm_hit_6(player(), @attacker, @vec),
				7, _gm_hit_7(player(), @attacker, @vec),
				8, _gm_hit_8(player(), @attacker, @vec)
			),
				
		'PROJECTILE',
		
			@attacker = @event[shooter]
			@vec = entity_velocity(@event[id])
			@vec = _vec_normalize(array(@vec[x], @vec[y], @vec[z]))
			
			switch(@id,
				0, _gm_shot_dir_0(player(), @attacker, @vec),
				1, _gm_shot_dir_1(player(), @attacker, @vec),
				2, _gm_shot_dir_2(player(), @attacker, @vec),
				3, _gm_shot_dir_3(player(), @attacker, @vec),
				4, _gm_shot_dir_4(player(), @attacker, @vec),
				5, _gm_shot_dir_5(player(), @attacker, @vec),
				6, _gm_shot_dir_6(player(), @attacker, @vec),
				7, _gm_shot_dir_7(player(), @attacker, @vec),
				8, _gm_shot_dir_8(player(), @attacker, @vec)
			),	
		
		'FIRE',
			set_ponfire(player(), false),
		'FIRE_TICK',
			set_ponfire(player(), false)
			_gm_hurt(player(), 1, player()),
			die()
		
	)
	
)

bind(projectile_hit, array(priority:monitor), null, @event,

	cancel()

	@attacker = get_player_from_entity_id(@event[shooter])
			
	try(entity_remove(@event[id]))		
	@vec = entity_velocity(@event[id])

	@bullets = import('ocp.gm.bullets')

	if(!array_index_exists(@bullets, @event[id]) , die(), @id = @bullets[@event[id]])

	@vec = _vec_normalize(array(@vec[x], @vec[y], @vec[z]))	
	@loc = @event[location]

	switch(@id,
		0, _gm_shot_ind_0(@attacker, @loc, @vec),
		1, _gm_shot_ind_1(@attacker, @loc, @vec),
		2, _gm_shot_ind_2(@attacker, @loc, @vec),
		3, _gm_shot_ind_3(@attacker, @loc, @vec),
		4, _gm_shot_ind_4(@attacker, @loc, @vec),
		5, _gm_shot_ind_5(@attacker, @loc, @vec),
		6, _gm_shot_ind_6(@attacker, @loc, @vec),
		7, _gm_shot_ind_7(@attacker, @loc, @vec),
		8, _gm_shot_ind_8(@attacker, @loc, @vec)
	)
	
	array_remove(@bullets, @event[id])
	export('ocp.gm.bullets', @bullets)

)

bind(player_interact, null, array(button: right), @event,

	if(pmode() == 'ADVENTURE' || pmode() == 'SURVIVAL', cancel(),  die())
	
	if(!_gm_canshoot(player()), die())

	switch(pinfo()[15],
		#0,	_gm_fire_0(player()),	#GUNBLADE
		1,	_gm_fire_1(player()),	#LIGHTNING BOLT
		2, 	_gm_fire_2(player()),	#FIREBALL
		3,	_gm_fire_3(player()),	#SHOTGUN
		4,	_gm_fire_4(player()),	#STREAM RIFLE
		5,	_gm_fire_5(player()),	#PLASMAGUN
		6,	_gm_fire_6(player()),	#IMPACT LAUNCHER
		7,	_gm_fire_7(player()),	#MERCURY
		#8,	_gm_fire_8(player()),	#DASH
	)
	
)

bind(player_interact_entity, null, array(button: right), @event,

	if(pmode() == 'ADVENTURE' || pmode() == 'SURVIVAL', cancel(),  die())
	
	if(!_gm_canshoot(player()), die())

	switch(pinfo()[15],
		#0,	_gm_fire_0(player()),	#GUNBLADE
		1,	_gm_fire_1(player()),	#LIGHTNING BOLT
		2, 	_gm_fire_2(player()),	#FIREBALL
		3,	_gm_fire_3(player()),	#SHOTGUN
		4,	_gm_fire_4(player()),	#STREAM RIFLE
		5,	_gm_fire_5(player()),	#PLASMAGUN
		6,	_gm_fire_6(player()),	#IMPACT LAUNCHER
		7,	_gm_fire_7(player()),	#MERCURY
		#8,	_gm_fire_8(player()),	#DASH
	)
	
)

bind(item_drop, null, null, @event, 
	cancel() 
	set_timeout(100, closure(set_pinv(pinv())))
)

bind(item_pickup, null, null, @event, 

	@item = @event[item]
	
	cancel()
	entity_remove(@event[id])
	
	foreach(range(0, 9), @id,
		
		@w = import('ocp.gm.weapons.' . @id)
		
		if(!is_array(@w), continue())
	
		@split = split(':', @w['ammo-item'])
		
		if(@split[0] == @item[type] && @split[1] == @item[data],
		
			_gm_give_ammo(player(), @id)
			set_timeout(500, closure(ptake_item(@player, @w['ammo-item'], 64)))
			die(),
			
			continue()
			
		)
		
	)

)

bind(pressure_plate_activated, null, null, @event,

	@map = import('ocp.gm.loaded.map')
	@loc = @event[location]
	
	cancel()
	set_block_at(@event[location], '70:1')

	foreach(@map[jumppads], @name, @array,
		if(@array[pos] == array(integer(@loc[0]), integer(@loc[1]), integer(@loc[2])),
			execute(
				closure(
					set_pvelocity(player(), array(0,1,0))
					set_timeout(100,
						closure(
							set_pvelocity(player(), @array[vec])
						)
					)
				)
			)
			play_sound(@loc, array(sound:BREATH))
			set_timeout(700, 
				closure(
					set_block_at(@event[location], '70:0')
				)
			)
			break()
		)
	)
		
)

bind(entity_enter_portal, null, null, @event,

	@map = import('ocp.gm.loaded.map')
	@loc = @event[location]
	
	cancel()
	
	foreach(@map[teleporters], @name, @array,
		if(_within_region(@loc, @array[p1], @array[p2]),
			@pos = @array[position]
			set_ploc(player(), array(@pos[0], @pos[1], @pos[2], pworld()))
			set_timeout(50,
				closure(
					pfacing(player(), @array[angles][0], @array[angles][1])
				)
			)
			play_sound(ploc(), array(sound: ZOMBIE_UNFECT, pitch: 2))
			break()			
		)
	)

)

#bind(inventory_open, null, null, @event, cancel() close_pinv(player()))

#==================================================================================================================#	

/*	
export('ocp.thrownitems', array())

bind(player_interact, null, null, @event,

	if(pinfo()[11],
		
		@items = import('ocp.thrownitems')

		@hand = pinv(player(), null)
		
		if(@hand != null,
		
			@inv = pinv()
			
			@inv[pinfo()[15]] = null
			
			set_pinv(@inv)
					
			@thrown = shoot_projectile(player(), SNOWBALL)
			
			@items[@thrown] = @hand
			
			export('ocp.thrownitems', @items)
			
		)
		
	)
	
)

bind(projectile_hit, null, null, @event,

	@items = import('ocp.thrownitems')
	
	@id = @event[id]
	
	if(array_index_exists(@items, @id),
	
		drop_item(@event['location'], @items[@id])
		
	)
	
)



bind(block_place, null, null, @event,

	#if(@event['oldblock'][type] == 9, cancel() die())
	#if(@event['oldblock'][type] == 8, cancel() die())
	#if(@event['against'][type] != 35, cancel() die())
	
	if(@event[type] == 35 && @event[data] == 5)
	{
		set_timeout(1000,
			closure(
			
				if(get_block_at(@event[X], @event[Y], @event[Z]) != '0:0',
				
					set_block_at(@event[X], @event[Y], @event[Z], '35:4')
					set_timeout(1000,
						closure(
						
							if(get_block_at(@event[X], @event[Y], @event[Z]) != '0:0',
							
								set_block_at(@event[X], @event[Y], @event[Z], '35:14')
								set_timeout(1000,
									closure(
									
										if(get_block_at(@event[X], @event[Y], @event[Z]) != '0:0',
										
											set_block_at(@event[X], @event[Y], @event[Z], '35:15')
											set_timeout(1000,
												closure(
													set_block_at(@event[X], @event[Y], @event[Z], '0')
												)
											)
										)
									)
								)
							)
						)
					)
				)
			)
		)
	}
)

bind(player_move, null, null, @event,

	if(player() != TheOctopod, set_pmode('SURVIVAL'))
	if(get_block_at(ploc()) == '35:6',
	
		@inv = pinv(player())
		foreach(array_keys(@inv), @slot,
			if(@inv[@slot] != null,
				if(@inv[@slot][type] == 35 && @inv[@slot][data] == 5 && @has_green != true,
					@has_green = true
					@inv[@slot][qty] = 16,
					if(@inv[@slot][type] == 35 && @inv[@slot][data] == 0,
						@inv[@slot] = @inv[@slot],
						@inv[@slot] = null
					)
				),
				if(@found != true, @empty = @slot)
				@found = true
			)
		)
		if(@has_green != true,
			@inv[@empty] = array(type:35, data:5, qty:16)
		)
		set_pinv(player(), @inv)
		
	)

)
*/

set_timeout(1000, 
	closure(
		_cmnd_register(array('/stats'), '', '',
			closure(
			
				@player = @arguments[1]
				
				@stats = import('ocp.gm.stats.player')
			
				_ocp_msg(@player, '&8+---------------------------------------------------+')
				_ocp_msg(@player, '&0`&8| +txt[60:"&fTeam":0]+txt[96:"&7Player":0]+txt[50:"&fKills":0]+txt[50:"&7Deaths":0]+txt[50:"&fScore":0]&8|')
				_ocp_msg(@player, '&8+---------------------------------------------------+')
				foreach(@stats, @target, @info,
					@k = @info[0]
					@d = @info[1]
					@s = @info[2]
					_ocp_msg(@player, '&0`&8| &f+txt[60:"&fWHITE":0]+txt[96:"&7'.@target.'":0]+txt[50:"&f'.@k.'":0]+txt[50:"&7'.@d.'":0]+txt[50:"&f'.@s.'":0]&8|')
				)
				_ocp_msg(@player, '+txt[318:"&8+---------------------------------------------------+":0]')
				
			)
		)

		_cmnd_register(array('/die', 'please kill me'), '', '',
			closure(
			
				@player = @arguments[1]

				_gm_hurt(@player, 999, @player)
				
			)
		)

		_cmnd_register(array('/help'), '', '',
			closure(
			
				@player = @arguments[1]
				
				tmsg(@player, colorize('&8+---------------------------------------------------+'))
				tmsg(@player, colorize('&8`&8|' . _adv_string_fill('&l= How to Play =&r', 316, 2) . '&8|'))
				tmsg(@player, colorize('&8+---------------------------------------------------+'))
				tmsg(@player, colorize('&8`&8|' . _adv_string_fill('&e&l[LEFT CLICK]&r to hit other players.', 331, 2) . '&8|'))
				tmsg(@player, colorize('&8`&8|' . _adv_string_fill('&e&l[RIGHT CLICK]&r to fire weapon / use ability.', 330, 2) . '&8|'))
				tmsg(@player, colorize('&8`&8|' . _adv_string_fill('&aAll weapons need to cooldown after use.', 322, 2) . '&8|'))
				tmsg(@player, colorize('&8`&8|' . _adv_string_fill('&aYou cannot use any weapon during the cooldown.', 322, 2) . '&8|'))
				tmsg(@player, colorize('&8`&8|' . _adv_string_fill('Different weapons work best in different situations.', 310, 2) . '&8|'))
				tmsg(@player, colorize('&8+---------------------------------------------------+'))
				
			)
		)

		_cmnd_register(array('/rules'), '', '',
			closure(
			
				@player = @arguments[1]
				
				_gm_show_objective(@player)
				
			)
		)
	)
)
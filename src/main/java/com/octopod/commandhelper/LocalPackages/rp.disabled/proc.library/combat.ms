
proc(_magic_use, @id, @combo,

	@mp = phunger()
	
	@regen_key = 'magic.regen.'.player()
	@regen = import(@regen_key.'')
	
	@known_pattern = true
	
	@timer_key = 'magic.combo.timer.'.player()
	@combo_key = 'magic.combo.'.player()
		
	clear_task(import(@timer_key.''))
		
	export(@combo_key.'', null)
	export(@timer_key.'', null)	
	
	if(@id === null, return(UNASSIGNED))

	switch(@id,
		0,
			@spell = color(6) . 'Fireball'
			@mp_cost = 6,
		1,
			@spell = color(a) . 'Heal'
			@mp_cost = 6,

	)
	
	if(!_stamina_use(player(), @mp_cost), return(NOMANA))

	msg(color(7) . 'You used: ' . @spell . color(7) . '!')
	
	switch(@id,
		0,
			@id = shoot_projectile(player(), 'SMALL_FIREBALL')
			set_interval(100,
				closure(
					if(!entity_exists(@id), clear_task() die())
					make_effect(entity_loc(@id), 'SMOKE')
				)
			),
		1,
			firework_effect(array(type: burst, colors: LIME, fade: GREEN, trail: false), _vec_add(ploc(), array(0,1,0)))
			@hp = pinfo()[5]
			@hp = min(20, @hp + 8)
			set_phealth(@hp)
	)

	return(true)
	
)

proc(_magic_push, @button,

	switch(@button,
		0,
			play_sound(ploc(), array(sound: NOTE_PIANO, pitch: 1)),
		1,
			play_sound(ploc(), array(sound: NOTE_PIANO, pitch: 1.25))
	)

	@timer_key = 'magic.combo.timer.'.player()
	@combo_key = 'magic.combo.'.player()

	@timer = import(@timer_key.'')
	@combo = import(@combo_key.'')
	
	if(@combo === null,
		@combo = array()
	)
	
	if(is_integer(@timer), clear_task(@timer))

	@combo[] = @button
	
	@timer = 
		set_timeout(500, 
			closure(
				play_sound(ploc(), array(sound:CLICK, pitch:2)) 
				msg('You\'ve lost your pattern.')
				export(@combo_key.'', null)
			)
		)
				
	export(@combo_key.'', @combo)
	export(@timer_key.'', @timer)
	
	if(array_size(@combo) < 3,

		return(null),

		return(@combo)
		
	)
	
)

proc(_hurt, @id, @dmg, @player,

	if(!entity_exists(@id), return(false))

	play_entity_effect(@id, HURT)
	play_sound(entity_loc(@id), array(sound:HURT_FLESH))
	make_effect(entity_loc(@id), 'STEP_SOUND:152')
	
	if(@dmg > 0,

		@max_hp = get_max_health(@id)
		@hp = (get_entity_health(@id) / 100 * @max_hp) - @dmg

		@perc = max(0, @hp / @max_hp)
		
		#==[ENTITY DEATH CODE]==============================================#
				
		if(@perc <= 0,

			queue_push(closure(_kill(@id, false, @player))),
			
			set_entity_health(@id, @perc * 100)
			
		)

	)

)

proc(_kill, @id, @silent, @player,

	if(!entity_exists(@id), return())

	if(entity_type(@id) == PLAYER,
	
		#===[PLAYER DEATH]=====================================#
	
		if(import('spawnprotect.'.player()) == true, return())

		play_sound(entity_loc(@id), array(sound:HURT, pitch:1))	
	
		@player = get_player_from_entity_id(@id)
		broadcast(@player . color(6) . ' has been slain.')
		@roomID = _player_getRoom(@player)
		
		if(array_size(_player_getRoomPlayers(@roomID)) == 1, 
			_mob_killAllInRoom(@roomID)
			_room_unlockRoom(@roomID)
		)
		
		_player_respawn(@player)
		
		export('spawnprotect.'.player(), true)
		set_timeout(1000, closure(export('spawnprotect.'.player(), null))),
		
		#===[ENTITY DEATH]=====================================#
		
		if(!@silent,
			play_sound(entity_loc(@id), array(sound:HURT, pitch:0))			
			play_entity_effect(@id, DEATH)
		)

		entity_remove(@id) 

		_mob_death(@id)
		
	)
	
)

proc(_stamina_use, @player, @amount,

	@food = phunger(@player)
	
	if(@food - @amount < 0, return(false))
	
	set_phunger(@food - @amount)
	
	@regen_key = 'stamina.regen.'.@player
	@regen = import(@regen_key.'')		
	
	clear_task(@regen)

	@regen = set_interval(500,
		closure(
			
			if(!ponline(@player), clear_task() die())
			@food = phunger(@player)
			if(@food == 20,
				export(@regen_key.'', null)
				clear_task(),
				if(!pinfo(@player, 19),
					set_phunger(@food + 1)
				)
			)
			
		)
	)
	
	export(@regen_key.'', @regen)
	
	return(true)

)
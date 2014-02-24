
proc(_sstats_reset, @player = player(),

	try(remove_scoreboard(@player))
	
)

proc(_sstats_update, @player = player(),

	try(create_scoreboard(@player))
	try(create_objective(STATS, DUMMY, @player))
	try(set_pscoreboard(@player, @player))
	
	set_objective_display(STATS, array(displayname: color(e) . 'Stats', slot: SIDEBAR), @player)
	
	set_pscore(STATS, color(9) . 'EXP: ', 1, @player)
	set_pscore(STATS, color(9) . 'EXP: ', 0, @player)
	set_pscore(STATS, color(9) . 'Players: ', 1, @player)
	set_pscore(STATS, color(9) . 'Players: ', 0, @player)
	
	try(set_pscore(STATS, color(9) . 'EXP: ', acc_balance(@player), @player))
	try(set_pscore(STATS, color(9) . 'Players: ', array_size(all_players()), @player))
	
)
	
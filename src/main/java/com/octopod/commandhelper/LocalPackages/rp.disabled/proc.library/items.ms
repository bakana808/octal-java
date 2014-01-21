
proc(_item_reg, @name = 'TEST', @item = '1', @closure = closure(),
	
	@items = import('items')
	
	if(!is_array(@items), @items = associative_array())
	
	@items[@name] = array(@item, @closure)
	
	export('items', @items)

)

proc(_item_use, @name = 'TEST', @player = player(),

	@items = import('items')
	
	if(!array_index_exists(@items, @name), return(false))
	
	@closure = @items[@name][1]

	execute(@player, @closure)
	tmsg(@player, color(7) . 'You have used: ' . color(f) . @name . '!')
	
	return(true)
	
)

proc(_item_getEmptySlot, @player = player(),

	@pinv = pinv(@player)
	
	foreach(range(1,8), @slot,
		if(@pinv[@slot] == null, return(@slot))
	)
	
	return(null)
	
)

proc(_item_give, @name = 'TEST', @player = player(),

	@items = import('items')
	
	if(!array_index_exists(@items, @name), return(false))
	
	@item_split = split(':', @items[@name][0]) if(!array_index_exists(@item_split, 1), @item_split[1] = 0)
	@item_array = array(type:@item_split[0], data:@item_split[1], meta:array(display: @name))
	
	@slot = _item_getEmptySlot(@player)

	@pinv = pinv(@player)
	@pinv[@slot] = @item_array
	set_pinv(@player, @pinv)
	
	tmsg(@player, color(7) . 'You have found: ' . color(f) . @name)
	
	return(true)
	
)

proc(_item_useFirstItem, @player = player(),

	@pinv = pinv(@player)
	
	if(!is_array(@pinv[1]), return(false))
	@item = @pinv[1][meta][display]
	@pinv[1] = null
	
	_item_use(@item, @player)
	
	foreach(range(2,8), @slot,
		@pinv[(@slot - 1)] = @pinv[@slot]
		@pinv[@slot] = null
	)
	
	set_pinv(@player, @pinv)

)

proc(_item_rotateItems, @player = player(), 

	@pinv = pinv(@player)
	
	@deck = 0
	
	foreach(range(1,8), @slot,
		if(@pinv[@slot] == null, break(), @deck = @slot)
	)
	
	if(@deck <= 1, return(false)) 
	
	@first = @pinv[1]
	
	foreach(range(2,(@deck + 1)), @slot,
		@pinv[(@slot - 1)] = @pinv[@slot]
		@pinv[@slot] = null
	)
	
	@pinv[@deck] = @first
	
	set_pinv(@player, @pinv)
	
)



proc(_displayitem, @loc, @item,

	@i = drop_item(@loc, @item)
	
	set_timeout(100, closure(set_entity_loc(@i, _vec_add(@loc, array(0,0.5,0)))))
	
	@items = import('displayitems')
	
	if(!is_array(@items), @items = array())
	
	@items[] = @i
	
	export('displayitems', @items)
	
)
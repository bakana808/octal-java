
bind(item_pickup, null, null, @event,

	@items = import('displayitems')
	
	if(@items == null, @items = array())
	
	if(array_contains(@items, @event[id]), cancel())
	
)
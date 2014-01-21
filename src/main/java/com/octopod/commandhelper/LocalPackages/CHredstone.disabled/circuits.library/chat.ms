name: AND Circuit
inputs:
outputs: @y
persist: @a
block:

@message = import('chr.chat.lastSaid')

broadcast(player())

if(@message == 'on', @y = 1)
if(@message == 'off', @y = 0)  
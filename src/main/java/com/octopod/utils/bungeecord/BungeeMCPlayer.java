package com.octopod.utils.bungeecord;

import net.md_5.bungee.api.connection.ProxiedPlayer;
import net.md_5.bungee.protocol.packet.Chat;

import com.octopod.utils.abstraction.MCPlayer;

public class BungeeMCPlayer extends MCPlayer{
	
	Object player = null;
	
	public BungeeMCPlayer(ProxiedPlayer player) {
		this.player = player;
	}

	@Override
	public void sendJsonMessage(String json) {
		((ProxiedPlayer)player).unsafe().sendPacket(new Chat(json));
	}

}

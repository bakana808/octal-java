package com.octopod.octal.minecraft.bungeecord;

import net.md_5.bungee.api.connection.ProxiedPlayer;
import net.md_5.bungee.protocol.packet.Chat;

import com.octopod.octal.minecraft.AbstractPlayer;

public class BungeePlayer extends AbstractPlayer{
	
	Object player = null;
	
	public BungeePlayer(ProxiedPlayer player) {
		this.player = player;
	}

	@Override
	public void sendJsonMessage(String json) {
		((ProxiedPlayer)player).unsafe().sendPacket(new Chat(json));
	}

}

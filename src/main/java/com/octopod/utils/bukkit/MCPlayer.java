package com.octopod.utils.bukkit;

import org.bukkit.entity.Player;

public class MCPlayer {
	
	 private Player player;
	 
	 public MCPlayer(Player p) {player = p;}
	 
	 public void sendMessageJSON(String json) {
		 PacketUtils.sendMessageJSON(player, json);
	 }

}

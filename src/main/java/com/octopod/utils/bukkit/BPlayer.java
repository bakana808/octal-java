package com.octopod.utils.bukkit;

import org.bukkit.entity.Player;

public class BPlayer {
	
	 private Player player;
	 
	 public BPlayer(Player p) {player = p;}
	 
	 public void sendMessageJSON(String json) {
		 BukkitPacketUtils.sendMessageJSON(player, json);
	 }

}

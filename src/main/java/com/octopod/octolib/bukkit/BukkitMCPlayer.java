package com.octopod.octolib.bukkit;

import net.minecraft.server.v1_7_R1.ChatSerializer;
import net.minecraft.server.v1_7_R1.PacketPlayOutChat;

import org.bukkit.craftbukkit.v1_7_R1.entity.CraftPlayer;
import org.bukkit.entity.Player;

import com.octopod.octolib.abstraction.MCPlayer;

public class BukkitMCPlayer extends MCPlayer{
	
	 private Object player;
	 
	 public BukkitMCPlayer(Player p) {player = p;}
	 
	 public void sendJsonMessage(String json) {
		PacketPlayOutChat packet = new PacketPlayOutChat(ChatSerializer.a(json));
		((CraftPlayer)player).getHandle().playerConnection.sendPacket(packet);	
	 }

}
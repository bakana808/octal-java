package com.octopod.octolib.minecraft.bukkit;

import net.minecraft.server.v1_7_R1.ChatSerializer;
import net.minecraft.server.v1_7_R1.PacketPlayOutChat;

import org.bukkit.craftbukkit.v1_7_R1.entity.CraftPlayer;

import com.octopod.octolib.minecraft.AbstractPlayer;

public class BukkitPlayer extends AbstractPlayer{
	
	 private Object player;
	 
	 public BukkitPlayer(Object p) {player = p;}
	 
	 public void sendJsonMessage(String json) {
		PacketPlayOutChat packet = new PacketPlayOutChat(ChatSerializer.a(json));
		((CraftPlayer)player).getHandle().playerConnection.sendPacket(packet);	
	 }

}
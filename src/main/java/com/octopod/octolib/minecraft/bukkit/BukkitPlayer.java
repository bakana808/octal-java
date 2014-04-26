package com.octopod.octolib.minecraft.bukkit;

import com.octopod.octolib.minecraft.AbstractPlayer;
import net.minecraft.server.v1_7_R3.ChatSerializer;
import net.minecraft.server.v1_7_R3.PacketPlayOutChat;
import org.bukkit.craftbukkit.v1_7_R3.entity.CraftPlayer;

public class BukkitPlayer extends AbstractPlayer{
	
	 private Object player;
	 
	 public BukkitPlayer(Object p) {player = p;}
	 
	 public void sendJsonMessage(String json) {
		PacketPlayOutChat packet = new PacketPlayOutChat(ChatSerializer.a(json));
		((CraftPlayer)player).getHandle().playerConnection.sendPacket(packet);
	 }

}
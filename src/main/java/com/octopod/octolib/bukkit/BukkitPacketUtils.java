package com.octopod.octolib.bukkit;

import net.minecraft.server.v1_7_R1.ChatSerializer;
import net.minecraft.server.v1_7_R1.PacketPlayOutChat;
import net.minecraft.server.v1_7_R1.PacketPlayOutNamedSoundEffect;
import net.minecraft.server.v1_7_R1.EntityPlayer;
import net.minecraft.server.v1_7_R1.Packet;

import org.bukkit.Bukkit;
import org.bukkit.Location;
import org.bukkit.craftbukkit.v1_7_R1.entity.CraftPlayer;
import org.bukkit.entity.Player;

public class BukkitPacketUtils {
	
	public static void playSound(Location loc, String sound) {playSound(loc, sound, 1.0f, 1.0f);}
	public static void playSound(Location loc, String sound, float volume, float pitch) {

		PacketPlayOutNamedSoundEffect packet = new PacketPlayOutNamedSoundEffect(
				sound, 
				loc.getBlockX(), loc.getBlockY(), loc.getBlockZ(), 
				volume, pitch
		);
		
		for(Player p: Bukkit.getOnlinePlayers())
			((CraftPlayer)p).getHandle().playerConnection.sendPacket(packet);
		
	}
	
	public static void sendMessageJSON(Player player, String string) {
		
		PacketPlayOutChat packet = new PacketPlayOutChat(ChatSerializer.a(string));
		
		((CraftPlayer)player).getHandle().playerConnection.sendPacket(packet);	
		
	}

	public static void sendPacket(Player player, Packet packet){
		EntityPlayer entityPlayer = ((CraftPlayer) player).getHandle();
		entityPlayer.playerConnection.sendPacket(packet);
	}

}

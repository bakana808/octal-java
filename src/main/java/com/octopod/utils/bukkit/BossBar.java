package com.octopod.utils.bukkit;

import net.minecraft.server.v1_7_R1.DataWatcher;
import net.minecraft.server.v1_7_R1.PacketPlayOutEntityDestroy;
import net.minecraft.server.v1_7_R1.PacketPlayOutSpawnEntityLiving;

import org.bukkit.Location;
import org.bukkit.entity.EntityType;
import org.bukkit.entity.Player;

import com.octopod.utils.reflection.ClassUtils;
import com.octopod.utils.reflection.ReflectionException;

public class BossBar {
	
	Player player;
	String text = "";
	int health = 300;
	boolean enabled = true;
	
	static int ENTITY_ID = 1234;	
	
	public BossBar(Player player) {this(player, "", 300);}
	public BossBar(Player player, String text, int health) {
		this.player = player; 
		PacketPlayOutSpawnEntityLiving packet = getMobPacket(text, health, player.getLocation());
		BukkitPacketUtils.sendPacket(player, packet);
	}
	
	public void setBoth(String text, int health) {
		PacketPlayOutSpawnEntityLiving packet = getMobPacket(text, health, player.getLocation());
		BukkitPacketUtils.sendPacket(player, packet);		
	}
	
	public void setText(String text) {
		PacketPlayOutSpawnEntityLiving packet = getMobPacket(text, health, player.getLocation());
		BukkitPacketUtils.sendPacket(player, packet);		
	}
	
	public void setHealth(int health) {
		PacketPlayOutSpawnEntityLiving packet = getMobPacket(text, health, player.getLocation());
		BukkitPacketUtils.sendPacket(player, packet);		
	}	
	
	public void destroy() {
		PacketPlayOutEntityDestroy packet = getDestroyEntityPacket();
		BukkitPacketUtils.sendPacket(player, packet);
		enabled = false;
	}
	
	public void respawn() {
		PacketPlayOutSpawnEntityLiving packet = getMobPacket(text, health, player.getLocation());
		BukkitPacketUtils.sendPacket(player, packet);
		enabled = true;
	}
	
	@SuppressWarnings("deprecation")
	public static PacketPlayOutSpawnEntityLiving getMobPacket(String text, int health, Location loc){
		
		PacketPlayOutSpawnEntityLiving packet = new PacketPlayOutSpawnEntityLiving();

		try {
			ClassUtils.setField(packet, "a", (int)ENTITY_ID);
			ClassUtils.setField(packet, "b", (byte)EntityType.WITHER.getTypeId());
			ClassUtils.setField(packet, "c", (int)Math.floor(loc.getBlockX() * 32.0D));
			ClassUtils.setField(packet, "d", (int)Math.floor(loc.getBlockY() * 32.0D));
			ClassUtils.setField(packet, "e", (int)Math.floor(loc.getBlockZ() * 32.0D));
			ClassUtils.setField(packet, "f", (byte)0);
			ClassUtils.setField(packet, "g", (byte)0);
			ClassUtils.setField(packet, "h", (byte)0);
			ClassUtils.setField(packet, "i", (byte)0);
			ClassUtils.setField(packet, "j", (byte)0);
			ClassUtils.setField(packet, "k", (byte)0);
			ClassUtils.setField(packet, "l", getWatcher(text, health));
		} catch (ReflectionException e) {}
		
		return packet;
		
	}
	
	private static PacketPlayOutEntityDestroy getDestroyEntityPacket(){
		PacketPlayOutEntityDestroy packet = new PacketPlayOutEntityDestroy();
		try {
			return ClassUtils.setField(packet, "a", new int[]{ENTITY_ID});
		} catch (ReflectionException e) {
			return null;
		}
	}

	private static DataWatcher getWatcher(String text, int health){
		DataWatcher watcher = new DataWatcher(null);
		
		watcher.a(0, (Byte) (byte) 0x20); //Flags, 0x20 = invisible
		watcher.a(6, (Float) (float) health);
		watcher.a(10, (String) text); //Entity name
		watcher.a(11, (Byte) (byte) 1); //Show name, 1 = show, 0 = don't show
		//watcher.a(16, (Integer) (int) health); //Wither health, 300 = full health
		
		return watcher;
	}
}

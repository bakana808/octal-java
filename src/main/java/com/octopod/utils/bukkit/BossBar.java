package com.octopod.utils.bukkit;

import net.minecraft.server.v1_7_R1.DataWatcher;
import net.minecraft.server.v1_7_R1.PacketPlayOutEntityDestroy;
import net.minecraft.server.v1_7_R1.PacketPlayOutSpawnEntityLiving;

import org.bukkit.Location;
import org.bukkit.entity.EntityType;
import org.bukkit.entity.Player;

import com.octopod.utils.reflection.ClassField;

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
		PacketUtils.sendPacket(player, packet);
	}
	
	public void setBoth(String text, int health) {
		PacketPlayOutSpawnEntityLiving packet = getMobPacket(text, health, player.getLocation());
		PacketUtils.sendPacket(player, packet);		
	}
	
	public void setText(String text) {
		PacketPlayOutSpawnEntityLiving packet = getMobPacket(text, health, player.getLocation());
		PacketUtils.sendPacket(player, packet);		
	}
	
	public void setHealth(int health) {
		PacketPlayOutSpawnEntityLiving packet = getMobPacket(text, health, player.getLocation());
		PacketUtils.sendPacket(player, packet);		
	}	
	
	public void destroy() {
		PacketPlayOutEntityDestroy packet = getDestroyEntityPacket();
		PacketUtils.sendPacket(player, packet);
		enabled = false;
	}
	
	public void respawn() {
		PacketPlayOutSpawnEntityLiving packet = getMobPacket(text, health, player.getLocation());
		PacketUtils.sendPacket(player, packet);
		enabled = true;
	}
	
	@SuppressWarnings("deprecation")
	public static PacketPlayOutSpawnEntityLiving getMobPacket(String text, int health, Location loc){
		
		PacketPlayOutSpawnEntityLiving mobPacket = new PacketPlayOutSpawnEntityLiving();
		ClassField clazz = new ClassField(mobPacket);
		
		clazz.setPublic("a", (int)ENTITY_ID);
		clazz.setPublic("b", (byte)EntityType.WITHER.getTypeId());
		clazz.setPublic("c", (int)Math.floor(loc.getBlockX() * 32.0D));
		clazz.setPublic("d", (int)Math.floor(loc.getBlockY() * 32.0D));
		clazz.setPublic("e", (int)Math.floor(loc.getBlockZ() * 32.0D));
		clazz.setPublic("f", (byte)0);
		clazz.setPublic("g", (byte)0);
		clazz.setPublic("h", (byte)0);
		clazz.setPublic("i", (byte)0);
		clazz.setPublic("j", (byte)0);
		clazz.setPublic("k", (byte)0);
		clazz.setPrivate("t", getWatcher(text, health));
		
		return (PacketPlayOutSpawnEntityLiving)clazz.getHandle();
		
	}
	
	private static PacketPlayOutEntityDestroy getDestroyEntityPacket(){
		PacketPlayOutEntityDestroy packet = new PacketPlayOutEntityDestroy();
		return (PacketPlayOutEntityDestroy)ClassField.setPublic(packet, "a", new int[]{ENTITY_ID});
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

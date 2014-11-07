package com.octopod.minecraft;

import com.octopod.util.Angle;
import com.octopod.util.Vector;
import com.octopod.util.minecraft.chat.Chat;
import net.minecraft.server.v1_7_R4.ChatSerializer;
import net.minecraft.server.v1_7_R4.PacketPlayOutChat;
import org.bukkit.Bukkit;
import org.bukkit.Effect;
import org.bukkit.EntityEffect;
import org.bukkit.Material;
import org.bukkit.craftbukkit.v1_7_R4.entity.CraftPlayer;
import org.bukkit.entity.Player;
import org.bukkit.inventory.ItemStack;
import org.bukkit.inventory.PlayerInventory;
import org.bukkit.inventory.meta.ItemMeta;

import java.util.List;


/**
 * @author Octopod - octopodsquad@gmail.com
 */
public class BukkitPlayer implements MinecraftPlayer
{
	protected Player player;

	public BukkitPlayer(Player player)
	{
		this.player = player;
	}

	public MinecraftPlayer getPlayer()
	{
		return this;
	}

	@Override
	public void dispatchCommand(String command)
	{
		Bukkit.getServer().dispatchCommand(player, command);
	}

	@Override
	public String getName()
	{
		return player.getName();
	}

	@Override
	public void sendMessage(String message)
	{
		player.sendMessage(Chat.colorize(message));
	}

	@Override
	public void sendJSONMessage(String json)
	{
		PacketPlayOutChat packet = new PacketPlayOutChat(ChatSerializer.a(json));
		((CraftPlayer) player).getHandle().playerConnection.sendPacket(packet);
	}

	@Override
	public boolean hasPermission(String permission)
	{
		return player.hasPermission(permission);
	}

	@Override
	public String getUUID()
	{
		return player.getUniqueId().toString();
	}

	@Override
	public void setWhitelisted(boolean whitelist)
	{
		player.setWhitelisted(whitelist);
	}

	@Override
	public boolean isWhitelisted()
	{
		return player.isWhitelisted();
	}

	@Override
	public void setBanned(boolean banned)
	{
		player.setBanned(banned);
	}

	@Override
	public boolean isBanned()
	{
		return player.isBanned();
	}

	@Override
	public Object getHandle()
	{
		return player;
	}

	@Override
	public Location getLocation()
	{
		org.bukkit.Location loc = player.getLocation();
		return new Location(loc.getX(), loc.getY(), loc.getZ(), new BukkitWorld(player.getWorld()));
	}

	@Override
	public Vector getPosition()
	{
		org.bukkit.Location loc = player.getLocation();
		return new Vector(loc.getX(), loc.getY(), loc.getZ());
	}

	@Override
	public Angle getAngle()
	{
		org.bukkit.Location loc = player.getLocation();
		return new Angle(loc.getPitch(), loc.getYaw());
	}

	@Override
	public MinecraftWorld getWorld()
	{
		return new BukkitWorld(player.getWorld());
	}

	@Override
	public Location getCursor()
	{
		org.bukkit.Location cursor = player.getTargetBlock(null, 10000).getLocation();
		return new Location(cursor.getX(), cursor.getY(), cursor.getZ(), new BukkitWorld(player.getWorld()));
	}

	@Override
	public Vector forward()
	{
		return getLocation().getAngle().toVector();
	}

	@Override
	public Vector forward(double offsetYaw, double offsetPitch)
	{
		return getLocation().getAngle().toVector(offsetYaw, offsetPitch);
	}

	@Override
	public int getEmptyHotbarSlot()
	{
		PlayerInventory inv = player.getInventory();
		for(int i = 0; i < 9; i++)
		{
			if(inv.getItem(i) == null) return i;
		}
		return -1;
	}

	@Override
	public int getSelectedSlot()
	{
		return player.getInventory().getHeldItemSlot();
	}

	@Override
	public void setSelectedSlot(int slot)
	{
		player.getInventory().setHeldItemSlot(slot);
	}

	@Override
	public void setExpBar(float shield)
	{
		player.setExp(shield);
	}

	@Override
	public void setExpLevel(int level)
	{
		player.setLevel(level);
	}

	@Override
	public void setMaxHealth(int health)
	{
		player.setMaxHealth(health);
	}

	@Override
	public void setHealth(double health)
	{
		player.setHealth(health);
	}

	@Override
	public double getMaxHealth()
	{
		return player.getMaxHealth();
	}

	@Override
	public double getHealth()
	{
		return player.getHealth();
	}

	@Override
	public void setWalkSpeed(float speed)
	{
		player.setWalkSpeed(speed);
	}

	@Override
	public void setHunger(int hunger)
	{
		player.setFoodLevel(hunger);
	}

	@Override
	public void setCanFly(boolean fly)
	{
		player.setAllowFlight(fly);
	}

	@Override
	public void setFly(boolean fly)
	{
		player.setFlying(fly);
	}

	@Override
	public void giveItem(int slot, int type, int data, String name, List<String> description)
	{
		ItemStack item = new ItemStack(type, 1, (short)data);
		ItemMeta meta = item.getItemMeta();
		meta.setDisplayName(name);
		if(description != null) meta.setLore(description);
		item.setItemMeta(meta);
		player.getInventory().setItem(slot, item);
	}

	@Override
	public void renameItem(int slot, String name)
	{
		ItemStack item = player.getInventory().getItem(slot);
		if(item != null) {
			ItemMeta meta = item.getItemMeta();
			meta.setDisplayName(name);
			item.setItemMeta(meta);
		}
	}

	@Override
	public void playEffectBlock(Vector pos, String block)
	{
		player.playEffect(new org.bukkit.Location(player.getWorld(), pos.X(), pos.Y(), pos.Z()), Effect.STEP_SOUND, Material.REDSTONE_BLOCK);
	}

	@Override
	public void playEffectHurt()
	{
		player.playEffect(EntityEffect.HURT);
	}

	@Override
	public Vector head()
	{
		return getLocation().getVector().add(0, 2.8, 0);
	}

	@Override
	public Vector eyes()
	{
		return getLocation().getVector().add(0, 2.62, 0);
	}
}

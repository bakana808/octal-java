package com.octopod.minecraft;

import com.octopod.util.minecraft.chat.Chat;
import net.minecraft.server.v1_7_R4.ChatSerializer;
import net.minecraft.server.v1_7_R4.PacketPlayOutChat;
import org.bukkit.craftbukkit.v1_7_R4.entity.CraftPlayer;
import org.bukkit.entity.Player;


/**
 * @author Octopod - octopodsquad@gmail.com
 */
public class BukkitPlayer implements ServerPlayer
{
	Player player;

	public BukkitPlayer(Player player)
	{
		this.player = player;
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
	public void sendJsonMessage(String json)
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
	public String getID()
	{
		return player.getUniqueId().toString();
	}
}

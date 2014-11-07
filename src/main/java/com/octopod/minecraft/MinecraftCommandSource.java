package com.octopod.minecraft;

import com.octopod.util.minecraft.chat.ChatReciever;import java.lang.String;

/**
 * @author Octopod - octopodsquad@gmail.com
 */
public interface MinecraftCommandSource extends ChatReciever
{
	public String getName();

	public void sendMessage(String message);

	public void dispatchCommand(String command);

	public boolean hasPermission(String permission);
}

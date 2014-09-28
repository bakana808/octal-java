package com.octopod.minecraft;

import com.octopod.util.minecraft.chat.ChatReciever;

/**
 * @author Octopod - octopodsquad@gmail.com
 */
public interface ServerCommandSource extends ChatReciever
{
	public String getName();

	public void sendMessage(String message);

	public boolean hasPermission(String permission);
}

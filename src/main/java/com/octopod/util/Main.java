package com.octopod.util;

import com.octopod.util.minecraft.chat.ChatBuilder;
import com.octopod.util.minecraft.chat.ChatColor;

public class Main
{
	public static void main(String args[])
	{
		ChatBuilder chat = new ChatBuilder().append("white").newline().append("red", ChatColor.RED).newline().append("blue", ChatColor.BLUE);

		System.out.println(chat.json());
	}
}
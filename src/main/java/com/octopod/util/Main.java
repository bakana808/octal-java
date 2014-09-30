package com.octopod.util;

import com.octopod.util.minecraft.chat.Chat;

public class Main
{
	public static void main(String args[])
	{
		System.out.println(Chat.cut("wrap wrap wrap wrap wrap", 50));
		System.out.println(Chat.cut("wrap wrap wrap wrap wrap", 50, true, 15));
	}
}
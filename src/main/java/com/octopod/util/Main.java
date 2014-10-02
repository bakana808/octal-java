package com.octopod.util;

import com.octopod.util.minecraft.chat.ChatAlignment;
import com.octopod.util.minecraft.chat.ChatElement;

public class Main
{
	public static void main(String args[])
	{
		System.out.println(new ChatElement("aaaa").block(48, ChatAlignment.LEFT));
	}
}
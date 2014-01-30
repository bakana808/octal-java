package com.octopod.octolib;

import java.io.File;
import java.io.IOException;
import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import com.octopod.bukgetapi.Bukget;
import com.octopod.bukgetapi.BukgetException;
import com.octopod.bukgetapi.BukgetPlugin;
import com.octopod.bukgetapi.BukgetPluginVersion;
import com.octopod.examples.AbstractClass;
import com.octopod.utils.common.FileUtil;

public class OctoLib {

	public static void main(String args[]) throws BukgetException {
		
		String slug = "commandhelper";
		
		System.out.println("Initiating Bukget...");
		Bukget bukget = Bukget.getInstance();
		System.out.println("Finding plugin...");
		BukgetPlugin plugin = bukget.getPlugin("commandhelper");
		System.out.println("Finished.");
		System.out.println("-------------------");
		for(BukgetPluginVersion version: plugin.getAllVersions()) {
			System.out.println("Version: " + version.getName());
			System.out.println("Name: " + version.getDownload());
		}
	}
	
}
package com.octopod.util.minecraft.command;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;

/**
 * @author Octopod - octopodsquad@gmail.com
 */
@Retention(RetentionPolicy.RUNTIME)
public @interface Default
{
	String value();
}

package com.octopod.util.minecraft.command;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;

/**
 * @author Octopod - octopodsquad@gmail.com
 */
@Retention(RetentionPolicy.RUNTIME)
public @interface Command
{
	/**
	 * An array of commands aliases that will refer to this commands.
	 * The first element is the main one.
	 */
	String[] aliases();

	/**
	 * The usage of the commands.
	 * <commands> will be replaced with the main alias.
	 */
	String usage() default "<commands>";

	String permission();

	String description() default "";

	int[] arg_sizes() default {};
}

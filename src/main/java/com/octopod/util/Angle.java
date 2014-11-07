package com.octopod.util;

/**
 * @author Octopod - octopodsquad@gmail.com
 */
public class Angle
{
	double pitch, yaw, roll;

	public Angle(double pitch, double yaw, double roll)
	{
		this.pitch = pitch;
		this.yaw = yaw;
		this.roll = roll;
	}

	public Angle(double pitch, double yaw)
	{
		this.pitch = pitch;
		this.yaw = yaw;
		this.roll = 0;
	}

	public Angle(double pitch)
	{
		this.pitch = pitch;
		this.yaw = 0;
		this.roll = 0;
	}

	public Angle()
	{
		this.pitch = 0;
		this.yaw = 0;
		this.roll = 0;
	}

	public double pitch()
	{
		return pitch;
	}

	public double yaw()
	{
		return yaw;
	}

	public double roll()
	{
		return roll;
	}

	public Vector toVector()
	{
		double pitch = Math.toRadians(this.pitch);
		double yaw = Math.toRadians(this.yaw);
		return new Vector(
			- Math.sin(yaw) * Math.cos(pitch) + Math.cos(yaw),
			- Math.sin(pitch),
			+ Math.cos(yaw) * Math.cos(pitch) + Math.sin(yaw)
		);
	}

	public Vector toVector(double offsetYaw, double offsetPitch)
	{
		offsetYaw = Math.toRadians(offsetYaw);
		double pitch = Math.toRadians(this.pitch + offsetPitch);
		double yaw = Math.toRadians(this.yaw);
		return new Vector(
			- Math.sin(yaw) * Math.cos(pitch) + Math.cos(yaw) * Math.sin(offsetYaw),
			- Math.sin(pitch),
			+ Math.cos(yaw) * Math.cos(pitch) + Math.sin(yaw) * Math.sin(offsetYaw)
		);
	}
}

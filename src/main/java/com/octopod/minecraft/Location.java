package com.octopod.minecraft;

import com.octopod.util.Angle;
import com.octopod.util.Vector;

/**
 * @author Octopod - octopodsquad@gmail.com
 */
public class Location
{
	final Vector vector;
	final MinecraftWorld world;
	final Angle angle;

	public Location(Vector vector, MinecraftWorld world)
	{
		this.vector = new Vector(vector);
		this.world = world;
		this.angle = new Angle();
	}

	public Location(Vector vector, Angle angle, MinecraftWorld world)
	{
		this.vector = new Vector(vector);
		this.world = world;
		this.angle = angle;
	}

	public Location(double x, double y, double z, double pitch, double yaw)
	{
		this.vector = new Vector(x, y, z);
		this.world = null;
		this.angle = new Angle(pitch, yaw);
	}

	public Location(double x, double y, double z)
	{
		this.vector = new Vector(x, y, z);
		this.world = null;
		this.angle = new Angle();
	}

	public Location(double x, double y, double z, double pitch, double yaw, MinecraftWorld world)
	{
		this.vector = new Vector(x, y, z);
		this.world = world;
		this.angle = new Angle(pitch, yaw);
	}

	public Location(double x, double y, double z, MinecraftWorld world)
	{
		this.vector = new Vector(x, y, z);
		this.world = world;
		this.angle = new Angle();
	}

	public MinecraftWorld getWorld() {return world;}

	public double getX() {return vector.X();}

	public double getY() {return vector.Y();}

	public double getZ() {return vector.Z();}

	public Vector getVector() {return vector;}

	public double getPitch() {return angle.pitch();}

	public double getYaw() {return angle.yaw();}

	public Angle getAngle() {return angle;}

	@Override
	public String toString()
	{
		return "[" + vector.X() + ", " + vector.Y() + ", " + vector.Z() + ", " + world.getName() + "]";
	}
}

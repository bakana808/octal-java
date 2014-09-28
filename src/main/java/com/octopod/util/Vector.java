package com.octopod.util;

/**
 * @author Octopod - octopodsquad@gmail.com
 */
public class Vector
{
	private double x, y, z;

	public Vector(double x, double y, double z)
	{
		this.x = x;
		this.y = y;
		this.z = z;
	}

	public Vector(Vector vec)
	{
		this(vec.X(), vec.Y(), vec.Z());
	}

	public double X() {return x;}
	public double Y() {return y;}
	public double Z() {return z;}

	/**
	 * Adds this vector and another vector
	 *
	 * @param x the x component
	 * @param y the y component
	 * @param z the z component
	 * @return a new vector
	 */
	public Vector add(double x, double y, double z)
	{
		return new Vector(this.x + x, this.y + y, this.z * z);
	}

	/**
	 * Adds this vector and another vector
	 *
	 * @param vec the other vector
	 * @return a new vector
	 */
	public Vector add(Vector vec)
	{
		return add(vec.x, vec.y, vec.z);
	}

	/**
	 * Multiplies this vector by another vector
	 *
	 * @param x the x component
	 * @param y the y component
	 * @param z the z component
	 * @return a new vector
	 */
	public Vector multiply(double x, double y, double z)
	{
		return new Vector(this.x * x, this.y * y, this.z * z);
	}

	/**
	 * Multiplies this vector by another vector
	 *
	 * @param vec the other vector
	 * @return a new vector
	 */
	public Vector multiply(Vector vec)
	{
		return multiply(vec.x, vec.y, vec.z);
	}

	/**
	 * Multiplies this vector by an amount
	 *
	 * @param x the number to multiply by
	 * @return a new vector
	 */
	public Vector multiply(double x)
	{
		return multiply(x, x, x);
	}

	public Vector divide(double x, double y, double z)
	{
		return new Vector(this.x / x, this.y / y, this.z / z);
	}

	public Vector divide(Vector vec)
	{
		return divide(vec.x, vec.y, vec.z);
	}

	public Vector divide(double x)
	{
		return divide(x, x, x);
	}

	public double dot(Vector vec)
	{
		return x * vec.x + y * vec.y + z * vec.z;
	}

	public Vector floor()
	{
		return new Vector(Math.floor(x), Math.floor(y), Math.floor(z));
	}

	/**
	 * Gets the magnitude of this vector
	 *
	 * @return the magnitude of this vector
	 */
	public double magnitude()
	{
		return Math.sqrt(x * x + y * y + z * z);
	}

	/**
	 * Converts this vector into a unit vector
	 *
	 * @return a new vector
	 */
	public Vector normalize()
	{
		return divide(magnitude());
	}

	/**
	 * Gets the distance between this vector and another vector
	 *
	 * @param vec the other vector
	 * @return the distance between the two vectors
	 */
	public double distance(Vector vec)
	{
		return Math.sqrt(
			Math.pow(x - vec.x, 2) +
			Math.pow(y - vec.y, 2) +
			Math.pow(z - vec.z, 2)
		);
	}

	@Override
	public boolean equals(Object obj)
	{
		if(!(obj instanceof Vector)) return false;
		Vector vec = (Vector)obj;
		return vec.x == x && vec.y == y && vec.z == z;
	}

	@Override
	public String toString()
	{
		return "[" + x + ", " + y + ", " + z + "]";
	}
}
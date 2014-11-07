import org.junit.Test;

import java.lang.reflect.Method;

/**
 * @author Octopod - octopodsquad@gmail.com
 */
public class MainTests
{
	public static class A
	{
		public void method() {}
	}

	public static class B extends A {}

	@Test
	public void main()
	{
		try
		{
			Method method = B.class.getMethod("method");
			System.out.println(method.getDeclaringClass().getName());
		}
		catch (NoSuchMethodException e) {}

	}
}

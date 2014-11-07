import com.octopod.util.event.Event;
import com.octopod.util.event.EventBus;
import com.octopod.util.event.EventSubscribe;
import org.junit.Test;

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

/**
 * @author Octopod - octopodsquad@gmail.com
 */
public class EventTests
{
	public static class TestEventA extends Event {}

	public static class TestEventB extends Event {}

	public static class TestEventHandler
	{
		@EventSubscribe
		public void onTestEventA(TestEventA event)
		{
			System.out.println("TestEventA handled");
		}

		@EventSubscribe
		public void onTestEventB(TestEventB event)
		{
			System.out.println("TestEventB handled");
		}
	}

	@Test
	public void testEventBusRegister()
	{
		EventBus eventBus = new EventBus();
		TestEventHandler handler = new TestEventHandler();

		eventBus.register(handler);

		assertTrue(eventBus.registered(handler));
	}

	@Test
	public void testEventBusUnregister()
	{
		EventBus eventBus = new EventBus();
		TestEventHandler handler = new TestEventHandler();

		eventBus.register(handler);
		eventBus.unregister(handler);

		assertFalse(eventBus.registered(handler));
	}

	@Test
	public void testEventBusPost()
	{
		EventBus eventBus = new EventBus();
		TestEventHandler handler = new TestEventHandler();

		eventBus.register(handler);
		eventBus.post(new TestEventA());
	}
}

import com.octopod.util.minecraft.chat.Chat;
import com.octopod.util.minecraft.chat.ChatColor;
import com.octopod.util.minecraft.chat.ChatElement;
import org.junit.Test;

import static org.junit.Assert.assertTrue;

/**
 * @author Octopod - octopodsquad@gmail.com
 */
public class ChatBuilderTests
{
	@Test
	public void testChatEquality()
	{
		ChatElement a = new ChatElement(ChatColor.RED);
		ChatElement b = new ChatElement().color(ChatColor.RED);

		assertTrue(a.toJSONString().equals(b.toJSONString()));
	}

	@Test
	public void testChatWidths()
	{
		String text;
		int width;

		//Simple Test
		text = "test";
		width = Chat.width(text);
		assertTrue("Incorrect width for \"" + text + "\": expecting 20, recieved " + width, width == 20);

		//Color Test
		text = Chat.colorize("&ctest");
		width = Chat.width(text);
		assertTrue("Incorrect width for \"" + text + "\": expecting 20, recieved " + width, width == 20);

		//Bold Rule Test: All characters after bold are 1 pixel wider
		text = Chat.colorize("&ltest");
		width = Chat.width(text);
		assertTrue("Incorrect width for \"" + text + "\": expecting 24, recieved " + width, width == 24);

		//Bold Cancel Test: Color codes cancel bold
		text = Chat.colorize("&l&ctest");
		width = Chat.width(text);
		assertTrue("Incorrect width for \"" + text + "\": expecting 20, recieved " + width, width == 20);

		//Bold Cancel Test 2: Format codes do not cancel bold
		text = Chat.colorize("&l&ntest");
		width = Chat.width(text);
		assertTrue("Incorrect width for \"" + text + "\": expecting 24, recieved " + width, width == 24);
	}

	@Test
	public void testChatEvents()
	{
		System.out.println(new ChatElement("test").tooltip("hover").toJSONString());
	}
}

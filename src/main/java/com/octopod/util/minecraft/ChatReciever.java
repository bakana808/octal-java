package com.octopod.util.minecraft;

public interface ChatReciever
{

	/**
	 * Sends a message to the player, in JSON format.
	 * For an example on what to put in this method,
	 * visit this link: https://gist.github.com/Dinnerbone/5631634
	 * @param json
	 */
	public void sendJsonMessage(String json);

}

ChatBuilder
======
A library relating to JSON-styled minecraft chat.
Also doubles as a chat aligner.

Make sure your implementation of a minecraft player implements the ChatReciever class
so they they can be sent messages by ChatBuilder.

Examples
------
Creating colored / formatted text:
```java
new ChatBuilder().append("bold red").color(ChatColor.RED).formats(ChatColor.BOLD).send(player);
```

Creating colored / formatted text (legacy):
```java
new ChatBuilder().append(Chat.colorize("&c&lbold red")).send(player);
```

Creating text with a tooltip:
```java
new ChatBuilder().append("text").tooltip("more text").send(player);
```

Creating text that runs a command:
```java
new ChatBuilder().append("[suicide]").run("/kill").send(player);
```

Creating text on multiple lines:
```java
new ChatBuilder().append("Line 1").newline().append("Line 2").send(player);
```

Creating aligned text (with a width of 100 and LEFT alignment):
```java
new ChatBuilder().append("Text").block(100, ChatAlignment.LEFT).send(player);
```
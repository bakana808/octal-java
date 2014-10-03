CommandHelper
======
Classes relating to the Minecraft plugin CommandHelper, created by LadyCailin.
[CommandHelper Builds](http://builds.enginehub.org/job/commandhelper)
[CommandHelper GitHub](https://github.com/sk89q/CommandHelper)

Obviously, CommandHelper and whatever API (like Bukkit) that loaded it must be loaded.

Examples
------
Evaluate code (as console):
```java
MethodScript.eval("broadcast('hello')");
```

Evaluate code (as player):
```java
MethodScript.eval("msg('hello')", new BukkitMCPlayer(player));
```

Compile code:
```java
CompiledMethodScript A = MethodScript.compile("broadcast('hello')");
//or
CompiledMethodScript B = new CompiledMethodScript("broadcast('hello')");
```

Set variable in CompiledMethodScript A (all variable names start with @):
```java
ms.setVariable("@a", new CInt(5, Target.UNKNOWN));
```

Set procedure in CompiledMethodScript(all procedure names start with _):
```java
Procedure proc = MethodScript.proc("_something", new ArrayList<IVariable>(), "broadcast('hello')");
ms.include(proc);
```

Evaluate code (from CompiledMethodScript):
```java
ms.execute();
//with player
ms.execute(new BukkitMCPlayer(player));
```

Setting a variable before executing CompiledMethodScript A:
```java
CompiledMethodScript A = new CompiledMethodScript("broadcast(@hello)");

A.setVar("@hello", new CString("hello", A.getTarget()));
```

Including procedures from CompiledMethodScript A in CompiledMethodScript B:
```java
CompiledMethodScript A = new CompiledMethodScript("proc _hello() {broadcast('hello')}");
CompiledMethodScript B = new CompiledMethodScript("_hello()");

//The script needs to be executed at least once to get the procedures
B.include(A.getProcedures());
```

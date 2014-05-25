package com.octopod.octal.commandhelper;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.lang.reflect.Method;

import com.laytonsmith.abstraction.MCCommandSender;
import com.laytonsmith.abstraction.MCPlayer;
import com.laytonsmith.commandhelper.CommandHelperFileLocations;
import com.laytonsmith.commandhelper.CommandHelperPlugin;
import com.laytonsmith.core.MethodScriptCompiler;
import com.laytonsmith.core.MethodScriptComplete;
import com.laytonsmith.core.ParseTree;
import com.laytonsmith.core.constructs.Construct;
import com.laytonsmith.core.constructs.IVariable;
import com.laytonsmith.core.constructs.IVariableList;
import com.laytonsmith.core.constructs.Target;
import com.laytonsmith.core.environments.CommandHelperEnvironment;
import com.laytonsmith.core.environments.Environment;
import com.laytonsmith.core.environments.Environment.EnvironmentImpl;
import com.laytonsmith.core.environments.GlobalEnv;
import com.laytonsmith.core.exceptions.ConfigCompileException;
import com.laytonsmith.database.SQLProfiles;

/**
 * @author Octopod
 *         Created on 5/24/14
 */
public class MethodScript {

    private Environment environment;
    private ParseTree compiled;

    public MethodScript(String script) throws ConfigCompileException {

        environment = createDefaultEnvironment();
        compiled = MethodScriptCompiler.compile(MethodScriptCompiler.lex(script, Target.UNKNOWN.file(), true));

    }

    public MethodScript(File file) throws IOException, FileNotFoundException, ConfigCompileException {

        final StringBuilder script = new StringBuilder();

        BufferedInputStream input = new BufferedInputStream(new FileInputStream(file));

        int n;
        while((n = input.read()) != -1) {
            script.append(n);
        }

        try{
            input.close();
        } catch (IOException e) {}

        environment = createDefaultEnvironment();
        compiled = MethodScriptCompiler.compile(MethodScriptCompiler.lex(script.toString(), file, true));

    }

    public void setEnvironment(Environment env) {
        environment = env;
    }

    public Environment getEnvironment() {
        return environment;
    }

    /**
     * Tells the environment who's running the code.
     * It would modify what certain functions return such as player().
     * @param executor The new executor.
     */
    public MethodScript setExecutor(MCCommandSender executor) {
        environment.getEnv(CommandHelperEnvironment.class).SetCommandSender(executor);
        return this;
    }

    public MethodScript setExecutor(MCPlayer player) {
        environment.getEnv(CommandHelperEnvironment.class).SetPlayer(player);
        return this;
    }

    /**
     * Sets a variable in the environment.
     * Unlike setVariableList(), it won't clear all the other variables.
     * @param varName The variable name. Should be prefixed by "@" most of the time.
     * @param con The Construct this variable should represent.
     */
    public MethodScript setVariable(String varName, Construct con) {
        IVariable var = new IVariable(varName, con, Target.UNKNOWN);
        IVariableList vars = getVariableList();
        vars.set(var);
        setVariableList(vars);
        return this;
    }

    /**
     * Gets a variable in the environment.
     * @param varName The variable name.
     */
    public Construct getVariable(String varName) {
        IVariableList vars = getVariableList();
        if(vars.keySet().contains(varName)) {
            return vars.get(varName, Target.UNKNOWN);
        } else {
            return null;
        }
    }

    /**
     * Sets the environment's variable list.
     * Using this may unintentionally clear all pre-existing variables,
     * so maybe you'd want to use setVariable() instead?
     * @param ivarlist The IVariableList to use as the new variable list.
     */
    public MethodScript setVariableList(IVariableList ivarList) {
        environment.getEnv(GlobalEnv.class).SetVarList(ivarList);
        return this;
    }

    /**
     * Gets the environment's variable list.
     * @return The IVariableList.
     */
    public IVariableList getVariableList() {
        return environment.getEnv(GlobalEnv.class).GetVarList();
    }

    public Construct executeAs(MCCommandSender executor) {
        setExecutor(executor);
        return execute();
    }

    public Construct execute() {
        return execute((MethodScriptComplete)null);
    }

    public Construct execute(MethodScriptComplete done) {
        return MethodScriptCompiler.execute(compiled, environment, done, null);
    }

    public Thread executeAsync() {
        return executeAsync(null);
    }

    public Thread executeAsync(final MethodScriptComplete done) {
        Thread thread = new Thread() {
            @Override
            public void run() {
                MethodScriptCompiler.execute(compiled, environment, done, null);
            }
        };
        thread.start();
        return thread;
    }

    @Deprecated
    public MethodScript injectEnvironmentImplmentation(EnvironmentImpl ienv) {
        try {
            Method m = environment.getClass().getDeclaredMethod("addEnv", EnvironmentImpl.class);
            m.setAccessible(true);
            m.invoke(environment, ienv);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return this;
    }

    /**
     * Gets CommandHelper's default environment.
     * @return Environment
     */
    public static Environment createDefaultEnvironment() {

        CommandHelperPlugin plugin = CommandHelperPlugin.self;
        GlobalEnv gEnv;
        try {
            gEnv = new GlobalEnv(
                    plugin.executionQueue,
                    plugin.profiler,
                    plugin.persistenceNetwork,
                    plugin.permissionsResolver,
                    CommandHelperFileLocations.getDefault().getConfigDirectory(),
                    new SQLProfiles(CommandHelperFileLocations.getDefault().getSQLProfilesFile())
            );
        } catch (SQLProfiles.InvalidSQLProfileException e) {
            return null;
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
        gEnv.SetDynamicScriptingMode(true);
        CommandHelperEnvironment cEnv = new CommandHelperEnvironment();

        return Environment.createEnvironment(gEnv, cEnv);
    }

}
package com.octopod.util;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.List;

import com.octopod.util.common.IOUtils;
import com.octopod.util.common.StringUtils;

public class ShellCommand {
	
	public static String execute(String command) throws RuntimeException {
		
		ShellCommand cmd = new ShellCommand(command);
		int exitCode;
		final StringBuilder output = new StringBuilder();
		final StringBuilder error = new StringBuilder();
		
		cmd.setOutputStream(new BufferedOutputStream(new OutputStream() {
			
			@Override
			public void write(int b) {
				output.append((char)b);
			}
			
		}));
		
		cmd.setErrorStream(new BufferedOutputStream(new OutputStream() {
			
			@Override
			public void write(int b) {
				error.append((char)b);
			}
			
		}));
		
		try {
			cmd.start();
			exitCode = cmd.waitFor();
		} catch (IOException | InterruptedException e) {
			throw new RuntimeException(e.getMessage());
		}
		
		if(exitCode != 0) {
			throw new RuntimeException(error.toString());
		}
		
		return output.toString();
		
	}
	
	Process process;
	
	String[] args;

	int exitCode = -1;
	
	File workingDir = null;
	
	InputStream input = System.in;
	OutputStream output = System.out;
	OutputStream error = System.err;
	
	Thread inputThread;
	Thread outputThread;
	Thread errorThread;
	
	public ShellCommand(String args) {
		this(StringUtils.parseArgs(args));
	}
	
	public ShellCommand(List<String> args) {
		this(args.toArray(new String[args.size()]));
	}
	
	public ShellCommand(String[] args) {
		this.args = args;
	}
	
	public void start() throws IOException {

		ProcessBuilder builder = new ProcessBuilder(args);
		builder.directory(workingDir);
		process = builder.start();
		
		outputThread = new Thread(new Runnable() {
			
			@Override
			public void run() {
				
				InputStream binput = new BufferedInputStream(process.getInputStream());
				copy(binput, output);
				
			}
			
		});
		outputThread.start();
		
		errorThread = new Thread(new Runnable() {
			
			@Override
			public void run() {
				
				InputStream binput = new BufferedInputStream(process.getErrorStream());
				copy(binput, error);

			}
			
		});
		errorThread.start();
		
		if(input != null) {
			inputThread = new Thread(new Runnable() {
				
				@Override
				public void run() {
					
					OutputStream boutput = new BufferedOutputStream(process.getOutputStream());
					copy(input, boutput);

				}
				
			});
			inputThread.start();
		}
		
	}
	
    public void setInputStream(InputStream input){
        if(process != null)
        	throw new RuntimeException("The process is already running!");
        this.input = input;
	}
	
	public void setOutputStream(OutputStream output){
        if(process != null)
        	throw new RuntimeException("The process is already running!");
        this.output = output;
	}
	
	public void setErrorStream(OutputStream error){
        if(process != null)
        	throw new RuntimeException("The process is already running!");
        this.error = error;
	}	

    public int waitFor() throws InterruptedException {
    	int ret = process.waitFor();
    	IOUtils.flushSilent(output);
    	IOUtils.flushSilent(error);
    	outputThread.join();
    	errorThread.join();
    	return ret;
    }
	
	private void copy(InputStream is, OutputStream os){
        try {
        	IOUtils.copy(is, os);
        } catch (IOException e) {}
        finally {
	        IOUtils.flushSilent(os);
	        IOUtils.closeSilent(is);
	        IOUtils.closeSilent(os);
        }
	}

}

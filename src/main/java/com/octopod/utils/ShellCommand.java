package com.octopod.utils;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.List;

import com.octopod.utils.common.StringUtils;

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
				try {
					copy(binput, output);
				} catch (IOException e) {
					e.printStackTrace();
				}
				
			}
			
		});
		outputThread.start();
		
		errorThread = new Thread(new Runnable() {
			
			@Override
			public void run() {
				InputStream binput = new BufferedInputStream(process.getErrorStream());
				try {
					copy(binput, error);
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
			
		});
		errorThread.start();
		
		if(input != null) {
			inputThread = new Thread(new Runnable() {
				
				@Override
				public void run() {
					OutputStream boutput = new BufferedOutputStream(process.getOutputStream());
					try {
						copy(input, boutput);
					} catch (IOException e) {
						e.printStackTrace();
					}
					
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
    	if(output != null) {
    		try {
    			output.flush();
    		} catch (IOException e) {}
    	}
    	if(error != null) {
    		try {
    			error.flush();
    		} catch (IOException e) {}
    	}
    	outputThread.join();
    	errorThread.join();
    	return ret;
    }
	
	private void copy(InputStream is, OutputStream os) throws IOException {
        int ret;
        try {
            while((ret = is.read()) != -1){
                if(os != null) {
                	os.write(ret);
                }
            }
            if(os != null) {
            	os.flush();
            }
        } catch (IOException e) {
        	throw e;
        }
        finally {
            if(os != null) {
            	os.close();
            }
            if(is != null) {
            	is.close();
            }
        }
	}

}

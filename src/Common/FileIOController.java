package Common;

import java.io.File;
import java.io.IOException;

import org.apache.commons.io.FileUtils;

public  class FileIOController {

	public static synchronized void moveProfile(String srcPath, String destinationPath, String fileName)
			throws IOException {
		
	    if (fileName == null || fileName.isEmpty()) return;

        File srcFile = new File(srcPath + "\\" + fileName);
        File destDir = new File(destinationPath);

        if (!destDir.exists()) {
            destDir.mkdirs();
        }

        File destFile = new File(destDir, fileName);
        if (destFile.exists()) {
            System.out.println("File already exists: " + destFile.getAbsolutePath());
        } 
        else {
            FileUtils.moveToDirectory(srcFile, destDir, true);
        }
	}
	
	public static synchronized void deleteFile(String path, String fileName) {
		
		if (fileName == null || fileName.isEmpty()) return;
		
		System.out.println("path : " + path);
		System.out.println("fileName : " + fileName);
		
		File file = new File(path + "\\" + fileName);
		
		file.delete();
	}
	
	public static synchronized void deleteDirectory(String path) {
		
		File directory = new File(path);
		
		deleteDirectory(directory);
	}
	
	private static synchronized void deleteDirectory(File directory) {
		
	    if (directory.isDirectory()) {
	        File[] files = directory.listFiles();
	        
	        if (files != null) {
	            for (File file : files) {
	                deleteDirectory(file);
	            }
	        }
	    }
	    
	    directory.delete();
	}
}

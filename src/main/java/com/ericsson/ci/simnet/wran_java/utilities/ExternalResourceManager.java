package com.ericsson.ci.simnet.wran_java.utilities;

import java.io.File;

/**
 * @author eagachi
 * 
 */
public class ExternalResourceManager {

	public static File getResourceFile(String fileName) {
		java.net.URL url;
		String filesPathAndName;
		File f = null;
		try {
			url = ExternalResourceManager.class.getResource("/" + fileName);
			filesPathAndName = url.getPath();
			f = new File(filesPathAndName);
		} catch (Exception e) {
			System.out.println("File not found : " + fileName);
			System.out.println(e.toString());
		}

		return f;

	}

}

package com.ericsson.ci.simnet.wran_java.utilities;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;

import org.junit.Test;

public class DOMParserTest {

	@Test
	public void testWritingToFile() {

		PrintWriter out = null;

		String str = "hello";
		String fileName = "RNC01RBS01";
		String RncName = "RNC01";

		try {

			File dir = new File(RncName);

			dir.mkdir();

			// Create a PrintWriter (overwrites file if it exists).
			out = new PrintWriter(new BufferedWriter(new FileWriter(dir + "/"
					+ fileName + ".mo")));

			// Loop through the collection of customers.
			out.print(str);

			System.out
					.printf("//===INFO: Successfully written text file %s.\n",
							fileName);

		} catch (IOException ex) {
			System.err.println(ex.getMessage());
		} finally {
			if (out != null) {
				out.close();
			}
		}
	}

}

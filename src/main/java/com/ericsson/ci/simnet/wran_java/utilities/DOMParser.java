package com.ericsson.ci.simnet.wran_java.utilities;

import java.io.File;
import java.io.IOException;
import java.util.List;

import org.jdom2.Attribute;
import org.jdom2.DataConversionException;
import org.jdom2.Document;
import org.jdom2.Element;
import org.jdom2.JDOMException;
import org.jdom2.input.SAXBuilder;

public class DOMParser {

	static SAXBuilder builder = new SAXBuilder();
	static File xmlFile;
	static Document doc;
	static Element root;

	public DOMParser() {
	}

	public DOMParser(String path) {
		xmlFile = new File(path);
		try {
			doc = builder.build(xmlFile);
			root = doc.getRootElement();

		} catch (IOException io) {
			System.out.println(io.getMessage());
		} catch (JDOMException jdomex) {
			System.out.println(jdomex.getMessage());
		}

	}
	
	
	public static void loadXML(String path) {
		ClassLoader classLoader = Thread.currentThread()
				.getContextClassLoader();
		java.net.URL url = classLoader.getResource(path);
		String filesPathAndName = url.getPath();
		System.out.println("path for config file=" + filesPathAndName);
		try {
			doc = builder.build(url);
			root = doc.getRootElement();

		} catch (IOException io) {
			System.out.println(io.getMessage());
		} catch (JDOMException jdomex) {
			System.out.println(jdomex.getMessage());
		}

	}

	public static void loadXML1(String path) {
		xmlFile = new File(path);
		try {
			doc = builder.build(xmlFile);
			root = doc.getRootElement();

		} catch (IOException io) {
			System.out.println(io.getMessage());
		} catch (JDOMException jdomex) {
			System.out.println(jdomex.getMessage());
		}
	}


	public static Element getRoot() {
		return root;
	}

	public static int getAttributeInt(String element) {
		List node = getChildFromRoot(element);
		int value = 0; // Default value is 0
		if (node.size() == 1) {
			Element e = (Element) node.get(0);
			value = Integer.parseInt(e.getText());
		}
		return value;

	}

	public static boolean getAttributeBoolean(String element) {
		List node = getChildFromRoot(element);
		boolean value = false; // Default value is 0
		if (node.size() == 1) {
			Element e = (Element) node.get(0);
			if(e.getText().equalsIgnoreCase("on") || e.getText().equalsIgnoreCase("true"))
			value = true;
		}
		return value;

	}

	public static int getAttributeIntFromElement(String param, String attr) {
		Element node = getElement(param);
		int value = 0; // Default value is 0
		if (node != null) {
			value = Integer.parseInt(node.getAttributeValue(attr));
		}
		return value;

	}

	public static List getChildFromRoot(String param) {
		List node = root.getChildren(param);
		if (node == null) {
			System.out.println("Wrong entry in config file.");
		}

		return node;

	}


	// Use to get immediate child of root
	public static Element getElement(String string) {
		// TODO Auto-generated method stub

		return root.getChild(string);
	}

	// To fetch int values from config file
	public static int getIntAttrWithRncNumber(String param, int rncNum,
			String attr) {
		String attrValue = getAttrWithRncNumber(param, rncNum, attr);
		return Integer.parseInt(attrValue);
	}

	// To fetch boolean values from config file
	public static boolean getBooleanAttrWithRncNumber(String param, int rncNum,
			String attr) {
		String attrValue = getAttrWithRncNumber(param, rncNum, attr);
		if (attrValue.equals("yes"))
			return true;

		return Boolean.parseBoolean(attrValue);
	}

	public static int getAttributeFromElment(Element e, String attr) {
		int value = 0;
		if (e.getAttributeValue(attr) != null) {
			value = Integer.parseInt(e.getAttributeValue(attr));
		}
		return value;
	}

	// Generic function to get the value in string.
	public static String getAttrWithRncNumber(String param, int rncNum,
			String attr) {
		Element dist = getElement(param);
		String attrValue = "";

		List values = dist.getChildren();

		for (int i = 0; i < values.size(); i++) {
			Element node = (Element) values.get(i);
			int rncStart = Integer.parseInt(node.getAttribute("startRnc")
					.getValue());
			int rncEnd = Integer.parseInt(node.getAttributeValue("endRnc"));
			if (rncNum >= rncStart && rncNum <= rncEnd) {
				attrValue = node.getAttributeValue(attr);
			}

		}
		return attrValue;
	}

	public static int getAttributeValue(Attribute attr) {
		int value = 0;
		try {
			value = attr.getIntValue();
		} catch (DataConversionException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return value;
	}

	public static double getAttributeDouble(String element) {
		// TODO Auto-generated method stub
		List node = getChildFromRoot(element);
		double value = 0; // Default value is 0
		if (node.size() == 1) {
			Element e = (Element) node.get(0);
			value = Double.parseDouble(e.getText());

		}
		return value;
	}
	
	
}

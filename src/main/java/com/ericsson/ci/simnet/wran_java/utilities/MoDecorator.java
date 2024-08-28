package com.ericsson.ci.simnet.wran_java.utilities;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

public class MoDecorator {

	public void createMo(Object mo) {
		Class<? extends Object> objClass = mo.getClass();

		for (Method m : objClass.getDeclaredMethods()) {
			try {
				if (m.getName().contains("get"))
					System.out.println(m.invoke(mo, null));
			} catch (IllegalAccessException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IllegalArgumentException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (InvocationTargetException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}

	}

}

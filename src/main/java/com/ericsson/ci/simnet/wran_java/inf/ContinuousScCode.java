package com.ericsson.ci.simnet.wran_java.inf;

public class ContinuousScCode implements CodeGenerator {

	private static ContinuousScCode instance = null;
	private short code = 0;

	private ContinuousScCode() {

	}

	public static ContinuousScCode getInstance() {
		if (instance == null) {
			synchronized (ContinuousScCode.class) {
				if (instance == null) {
					instance = new ContinuousScCode();
				}
			}
		}
		return instance;
	}

	@Override
	public int GenerateCode() {
		if (code > CodeGenerator.maxSC)
			return 0;
		else
			return code++;
	}

}

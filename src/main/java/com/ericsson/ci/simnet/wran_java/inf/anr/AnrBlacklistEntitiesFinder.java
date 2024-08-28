package com.ericsson.ci.simnet.wran_java.inf.anr;

import com.ericsson.ci.simnet.wran_java.mo.UtranCell;

public interface AnrBlacklistEntitiesFinder {

	public void assignEntitiesToAnrBlacklist(UtranCell cell, int NumOfEntities);
}

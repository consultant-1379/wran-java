package com.ericsson.ci.simnet.wran_java.pool;

import com.ericsson.ci.simnet.wran_java.mo.Rnc;
import com.ericsson.ci.simnet.wran_java.utilities.DOMParser;
import java.util.List;
import org.jdom2.Element;

public class PoolConfigData
{
  public String getMemberId(Rnc rnc)
  {
    List<Element> clusters = DOMParser.getElement("RNCINPOOL")
      .getChildren();
    String memberId = "";
    for (Element cluster : clusters)
    {
      String member = cluster.getAttributeValue("members");
      if (member.contains(""+rnc.getRncNum()))
      {
        String[] members = member.split(",");
        for (int i = 0; i < members.length; i++) {
        	System.out.print(String.valueOf(rnc.getRncNum()) + "  "+ members[i]);
         if (members[i].equals(String.valueOf(rnc.getRncNum())))
          {
        	  memberId =String.valueOf(i+1);
        	  break;
          }
        
        }
      }
     
    }
    return memberId;
  }
  
  public String getClusterId(Rnc rnc)
  {
    List<Element> clusters = DOMParser.getElement("RNCINPOOL")
      .getChildren();
    String clusterId = "";
    for (Element cluster : clusters)
    {
      String member = cluster.getAttributeValue("members");
      if (member.contains(""+rnc.getRncNum()))
      {
        clusterId = cluster.getAttributeValue("cluster");
        break;
      }
    }
    return clusterId;
  }
  
  public String[] getPoolMembersId(Rnc rnc)
  {
    String[] members = null;
    List<Element> clusters = DOMParser.getElement("RNCINPOOL")
      .getChildren();
    for (Element cluster : clusters)
    {
      String member = cluster.getAttributeValue("members");
      if (member.contains(""+rnc.getRncNum()))
      {
        members = member.split(",");
        break;
      }
    }
    return members;
  }
}


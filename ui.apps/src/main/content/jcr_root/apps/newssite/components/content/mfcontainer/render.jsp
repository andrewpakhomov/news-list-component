<%@page session="false"
          import="java.util.HashMap,
				  java.util.Iterator,
				  org.apache.sling.commons.json.JSONObject,
                  com.adobe.granite.ui.components.ds.DataSource,
				  org.apache.sling.api.resource.Resource,
                  org.apache.sling.api.wrappers.ValueMapDecorator,
 			      com.adobe.granite.ui.components.ComponentHelper,
                  com.adobe.granite.ui.components.ComponentHelper.Options,
                  com.adobe.granite.ui.components.Config,
				  com.adobe.granite.ui.components.Value,	
                  com.adobe.granite.ui.components.Field" %>
<%@ page import="org.slf4j.Logger" %>
<%@ page import="org.slf4j.LoggerFactory" %>
<%@include file="/libs/granite/ui/global.jsp" %>



<%!
    private final Logger mLog = LoggerFactory.getLogger(this.getClass());
%>

<fieldset>
<%
                      String name = cmp.getConfig().get("name", String.class);
 					mLog.error("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
                      try{

if (request.getAttribute(Value.FORM_VALUESS_ATTRIBUTE) != null){
	includeFilledValues(cmp, request);
}else{
	includeTemplate(cmp, request);
}
                  }catch (Exception ex){
                          mLog.error("exception im multifiled component rendering", ex);
                  }

%>
</fieldset>
<%!
private void includeTemplate( ComponentHelper cmp, HttpServletRequest request) throws Exception{
	DataSource ds = cmp.getItemDataSource();
	Iterator<Resource> it = ds.iterator();
	while (it.hasNext()){
		Resource res = it.next();
		include(res, cmp, request);        
	}


}

private void includeFilledValues( ComponentHelper cmp, HttpServletRequest request) throws Exception{
	DataSource ds = cmp.getItemDataSource();
	Iterator<Resource> it = ds.iterator();
	ValueMap vm = (ValueMap)request.getAttribute(Value.FORM_VALUESS_ATTRIBUTE);
	//Receiving component name property
	String name = cmp.getConfig().get("name", String.class);
    mLog.info("calling include filled values, name = " + name);
	String jsonForm = vm.get(name, String.class);
    mLog.info("jsonForm is  = " + jsonForm);
	JSONObject compositeFieldValue = new JSONObject(jsonForm);                   
	while (it.hasNext()){
   		Resource res = it.next();
   		ValueMap currentResourcePropeties = res.adaptTo(ValueMap.class);
   		String subPartValueName =currentResourcePropeties.get("name", String.class);
		mLog.info("Enetring cycle, subPartValueName is " + subPartValueName);
        	if (compositeFieldValue.has(subPartValueName)){
				String value = compositeFieldValue.getString(subPartValueName);
            	include(res, subPartValueName, value, cmp, request);
        	}

	}
}

private String getValueFromJsonPart(String subPart){
    return subPart.substring(subPart.indexOf(":"));
}

private void include(Resource field, ComponentHelper cmp, HttpServletRequest request) throws Exception {
    // include the field with no value set at all
    
    ValueMap existingVM = (ValueMap) request.getAttribute(Value.FORM_VALUESS_ATTRIBUTE);
    String existingPath = (String) request.getAttribute(Value.CONTENTPATH_ATTRIBUTE);

    request.removeAttribute(Value.FORM_VALUESS_ATTRIBUTE);
    request.removeAttribute(Value.CONTENTPATH_ATTRIBUTE);
    
    cmp.include(field, new Options().rootField(false));
    
    request.setAttribute(Value.FORM_VALUESS_ATTRIBUTE, existingVM);
    request.setAttribute(Value.CONTENTPATH_ATTRIBUTE, existingPath);
}

private void include(Resource field, String name, Object value, ComponentHelper cmp, HttpServletRequest request) throws Exception {
    ValueMap map = new ValueMapDecorator(new HashMap<String, Object>());
    map.put(name, value);
    
    ValueMap existing = (ValueMap) request.getAttribute(Value.FORM_VALUESS_ATTRIBUTE);
    request.setAttribute(Value.FORM_VALUESS_ATTRIBUTE, map);
    
    cmp.include(field, new Options().rootField(false));
    
    request.setAttribute(Value.FORM_VALUESS_ATTRIBUTE, existing);
}



%>

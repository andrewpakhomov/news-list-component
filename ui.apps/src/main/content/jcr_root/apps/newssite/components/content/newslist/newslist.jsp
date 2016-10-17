<%@page session="false" import="
                  org.apache.sling.api.resource.Resource,
                  org.apache.sling.api.resource.ResourceUtil,
                  org.apache.sling.api.resource.ValueMap,
                  org.apache.sling.api.resource.ResourceResolver,
                  org.apache.sling.api.resource.ResourceMetadata,
                  org.apache.sling.api.wrappers.ValueMapDecorator,
                  java.util.List,
                  java.util.Iterator,
                  java.util.ArrayList,
                  java.util.HashMap,
                  java.util.Locale,
                  com.adobe.granite.ui.components.ds.DataSource,
                  com.adobe.granite.ui.components.ds.EmptyDataSource,
                  com.adobe.granite.ui.components.ds.SimpleDataSource,
                  com.adobe.granite.ui.components.ds.ValueMapResource,
					com.epam.training.newssite.core.models.NewListDataSource,
                  com.day.cq.wcm.api.Page,
                  com.day.cq.wcm.api.PageManager"%>


<%
%><%@taglib prefix="cq" uri="http://www.day.com/taglibs/cq/1.0" %>
<%@include file="/libs/granite/ui/global.jsp" %>

<%@ page import="org.slf4j.Logger" %>
<%@ page import="org.slf4j.LoggerFactory" %>

<%!
    private final Logger mLog = LoggerFactory.getLogger(this.getClass());
%>


<%
mLog.info("trying to create custom datasource");
// set fallback
//request.setAttribute(DataSource.class.getName(), EmptyDataSource.instance());


//Create an ArrayList to hold data
//List<Resource> fakeResourceList = new ArrayList<Resource>();

//ValueMap vm = null; 


//Add 5 values to drop down! 
//for (int i=0; i<5; i++)
//{

    //allocate memory to the Map instance
//vm = new ValueMapDecorator(new HashMap<String, Object>());   


 // Specify the value and text values
//String Value = "value"+i ;
// String Text = "text"+i ; 

    //populate the map
//vm.put("text",Text);


//    fakeResourceList.add(new ValueMapResource(resourceResolver, resource.getPath(), "granite/ui/components/foundation/text", vm));
//}

mLog.info("Resource path:" + resource.getPath());
DataSource ds = slingRequest.adaptTo(NewListDataSource.class);
Iterator<Resource> it = ds.iterator();
int resourceCount = 0;
while(it.hasNext()){
    it.next();
	resourceCount++;
}

if (resourceCount > 1) {
    cmp.include(resource,"granite/ui/components/foundation/container", cmp.consumeTag());
}else{
	%>
<h2>Just a placeholder</h2>

<%
}
    %>


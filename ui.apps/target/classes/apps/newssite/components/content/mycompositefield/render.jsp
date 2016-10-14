<%@page session="false"
          import="java.util.HashMap,
				  java.util.Iterator,
                  com.adobe.granite.ui.components.ds.DataSource,
				  org.apache.sling.api.resource.Resource,
                  org.apache.sling.api.wrappers.ValueMapDecorator,
                  com.adobe.granite.ui.components.Config,
                  com.adobe.granite.ui.components.Field" %>

<%@include file="/libs/granite/ui/global.jsp" %>
<%
try {
DataSource ds = cmp.getItemDataSource();
Iterator<Resource> it = ds.iterator();
while (it.hasNext()){
   Resource res = it.next();
   cmp.include(res, cmp.consumeTag());
}
}
 finally {
    request.removeAttribute(Field.class.getName());
}
%>
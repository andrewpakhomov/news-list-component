/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.epam.training.newssite.core.models;

import com.adobe.granite.asset.api.Asset;
import com.adobe.granite.ui.components.ds.AbstractDataSource;
import com.adobe.granite.ui.components.ds.ValueMapResource;
import com.day.cq.dam.commons.util.DamUtil;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import javax.annotation.PostConstruct;
import javax.inject.Inject;
import javax.inject.Named;
import org.apache.sling.api.SlingHttpServletRequest;
import org.apache.sling.api.resource.Resource;
import org.apache.sling.api.resource.ResourceResolver;
import org.apache.sling.api.resource.ValueMap;
import org.apache.sling.api.wrappers.ValueMapDecorator;
import org.apache.sling.commons.json.JSONException;
import org.apache.sling.commons.json.JSONObject;
import org.apache.sling.models.annotations.Model;
import org.apache.sling.models.annotations.Optional;
import org.apache.sling.models.annotations.Via;
import org.osgi.service.log.LogService;

/**
 *
 * @author Andrey_Pakhomov
 */
@Model(adaptables = SlingHttpServletRequest.class)
public class NewListDataSource extends AbstractDataSource{
    
    private final String SLING_RESOURCE_TYPE = "/apps/newssite/components/content/newslistitem";

    private final List<Resource> news;
    
    @Inject
    @Named("news")
    @Via("resource")
    @Optional
    private String[] newsJsonRepresentation;
    
    @Inject
    private ResourceResolver resourceResolver;
    
    @Inject
    private Resource resource;
    
    private String resourcePath;
    
    @Inject
    private LogService logService;   

    public NewListDataSource() {
        this.news = new LinkedList<>();
    }

    @PostConstruct
    public void convertToNewsResourceList(){
        this.resourcePath = this.resource.getPath();
        if (this.newsJsonRepresentation == null){
            return;
        }
        try{
            for (String current : this.newsJsonRepresentation){
            
                JSONObject currentObj = new JSONObject(current);
                Map valueMap = this.convertJsonObjectToMap(currentObj);
                ValueMapResource vm = new ValueMapResource(resourceResolver,(String)valueMap.get("./path"), SLING_RESOURCE_TYPE, new ValueMapDecorator(valueMap));
                this.news.add(vm);
            }
        }catch(JSONException ex){
            this.logService.log(LogService.LOG_ERROR, "error converting object", ex);
        }
    }
    
    
    private Map<String, Object> convertJsonObjectToMap(JSONObject obj) throws JSONException{
        Iterator<String> keys = obj.keys();
        Map<String, Object> result = new HashMap<>();
        while(keys.hasNext()){
            String currentKey =keys.next();
            result.put(currentKey, obj.get(currentKey));
        }
        String newsPagePath = (String) result.get("./path");
        Resource newsPageResource =this.resourceResolver.getResource(newsPagePath);
        Resource pageContent = this.resourceResolver.getResource(newsPageResource, "jcr:content");
        if (pageContent != null){
            ValueMap pageProperties = pageContent.getValueMap();
            String title = pageProperties.get("jcr:title", String.class);
            title = (title != null) ? title : "Page title is not specified"; 
            String description = pageProperties.get("jcr:description", String.class);
            description = (description != null) ? description : "Page description is not specified";
            result.put("title", title);
            result.put("description", description);
            Date lastModifiedDate = pageProperties.get("cq:lastModified", Date.class);
            SimpleDateFormat format = new SimpleDateFormat("Y-M-d");
            result.put("lastModifiedDate", format.format(lastModifiedDate));
            //checking for thumbnail exisiting
            Resource pageThumbnail = this.resourceResolver.getResource(pageContent, "image");
            if (pageThumbnail != null){
                Asset asset = pageThumbnail.adaptTo(Asset.class);
                if (asset!=null){
                    String thumbnailName = DamUtil.getThumbnailName(200, 200);
                    Resource thumbnail = asset.getRendition(thumbnailName);
                    String thumbnailPath = thumbnail.getPath();
                    result.put("thumbnailUri", thumbnailPath);
                }
            }
            
        }
        return result;
    }
    
    
    @Override
    public Iterator<Resource> iterator() {
        return news.iterator();
    }
 
    
    
}

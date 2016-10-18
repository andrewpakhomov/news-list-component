/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.epam.training.newssite.core.models;

import com.adobe.granite.ui.components.ds.ValueMapResource;
import org.apache.sling.api.resource.ResourceResolver;
import org.apache.sling.api.resource.ValueMap;



public class NewsPageModel extends ValueMapResource{

    
    public NewsPageModel(ResourceResolver resourceResolver, String path, String resourceType, ValueMap vm) {
        super(resourceResolver, path, resourceType, vm);
    }

    
    
    
}

({
    doInit: function(component, event, helper) {
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value"); 
        helper.getAccountList(component, pageNumber, pageSize);
    },
    
    handleNext: function(component, event, helper) {
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value");         
        pageNumber++;
        helper.getAccountList(component, pageNumber, pageSize);
    },
    
    handlePrev: function(component, event, helper) {
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value");              
        pageNumber--;
        helper.getAccountList(component, pageNumber, pageSize);
    },
    
    onSelectChange: function(component, event, helper) {
        var page = 1
        var pageSize = component.find("pageSize").get("v.value");
        helper.getAccountList(component, page, pageSize);
    },
    
    handleClick:function(component, event, helper) {
        
        var device = $A.get("$Browser.formFactor");
        var recordID=event.target.id;
        alert(recordID)
        if(device=='DESKTOP'){
            window.open("/lightning/r/Account/" + recordID+ "/view","_self");
        }else{
            
            var navEvt = $A.get("e.force:navigateToSObject");
            navEvt.setParams({
                "recordId": event.target.id,
                
            });
            navEvt.fire();
        }
    },
    handleParentClick:function(component, event, helper){
        var device = $A.get("$Browser.formFactor");
        var recordID=event.target.id;
        //  alert(recordID)
        if(device=='DESKTOP'){
            window.open("/lightning/r/Account/" + recordID+ "/view","_self");
        }else{
            
            var navEvt = $A.get("e.force:navigateToSObject");
            navEvt.setParams({
                "recordId": event.target.id,
                
            });
            navEvt.fire();
        }
    }       
    
})
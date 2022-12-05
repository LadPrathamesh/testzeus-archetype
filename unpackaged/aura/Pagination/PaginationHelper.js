({
	getAccountList: function(component, pageNumber, pageSize) {
         var recordid=component.get("v.recordId");
        var action = component.get("c.getAccountData");
        
        action.setParams({
            "recordId":recordid,
            "pageNumber": pageNumber,
            "pageSize": pageSize
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            if (component.isValid() && state === "SUCCESS"){
                var resultData = result.getReturnValue();
                console.log('resultData'+resultData)
                component.set("v.AccountList", resultData.AccountList);
                component.set("v.PageNumber", resultData.pageNumber);
                component.set("v.TotalRecords", resultData.totalRecords);
                component.set("v.RecordStart", resultData.recordStart);
                component.set("v.RecordEnd", resultData.recordEnd);
                component.set("v.TotalPages", Math.ceil(resultData.totalRecords / pageSize));
                
                if(resultData.pageNumber==1 && resultData.AccountList.length==0 ){
                     component.set("v.hasPrevious",true);
                     component.set("v.hasNext",true);
                }else if(resultData.pageNumber==1 && resultData.AccountList.length>0 ){
                     component.set("v.hasPrevious",true);
                     component.set("v.hasNext",false);
                }else if(resultData.pageNumber > 1 && resultData.AccountList.length>0){                    
                    component.set("v.hasPrevious",false);
                    component.set("v.hasNext",false); 
                }else if( resultData.pageNumber > 1 && resultData.AccountList.length==0 ){                    
                     component.set("v.hasPrevious",false);
                     component.set("v.hasNext",true);
                }
                  
            }
        });
        $A.enqueueAction(action);
    }
})
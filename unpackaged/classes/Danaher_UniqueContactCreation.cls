/*
* @Developer-Sudhir Dhawan
* @Company-Nanostuffs Technologies Private Limited
* @Description-
* */

public class Danaher_UniqueContactCreation {
    public static List<Database.upsertResult> ContactCreation(List<OpCo_Related_Contact__c> lstRec){
        
        // Unique Emails Set        
        Set<String>unqEmails=new Set<String>();
        for(OpCo_Related_Contact__c ls:lstRec){
            unqEmails.add(ls.Email__c);
        }
        //Unique OpCo Related Contact
        List<OpCo_Related_Contact__c> lstOpCo=new List<OpCo_Related_Contact__c>();
        //List of Records to be upserted
        List<Contact> upsertRec=new List<Contact>();
        
        
        
        // All Related Records List
        List<OpCo_Related_Contact__c> lstAllOpCoRelated=[
            SELECT 
            Id,Name,Email__c,FirstName__c,LastName__c,Source_Account__c,Title__c,Industry__c,MailingPostalCode__c,MailingStreet__c,
            MailingCity__c,MailingState__c,MailingCountry__c,Source_Account__r.Account__c,Source__c,Phone__c,
            Email_Opt_Out__c,Contact_Role__c,Region__c,Status__c,Marketing_Vertical__c,Application_Interest_Segment__c,Product_Interest__c 
            FROM OpCo_Related_Contact__c 
            WHERE  Email__c IN :unqEmails 
            Order by OpCoLastModifiedDate__c DESC  ]; 
        system.debug(lstAllOpCoRelated);
        	
        // Iterate over unique Email Set and compare value of email with all Related List Contact and finding the first match add it into 
        // lstOpCo List and break the loop
        
        for(String con:unqEmails){
            for(OpCo_Related_Contact__c co:lstAllOpCoRelated){
                if(con==co.Email__c){
                    lstOpCo.add(co);
                    break;
                }
            }            
        }
    
        //Consolidate Field Method
        
        Danaher_UniqueContactCreation.Danaher_FieldUpdate(lstAllOpCoRelated,lstOpCo);
        
        // Iteration on Unique Related Contacts and creating the new Object from that Information available and adding into upsertRec List.
        
        for(OpCo_Related_Contact__c cont:lstOpCo){
            //Integer index=cont.Title__c.length()>128?128:cont.Title__c.length();
            Contact c=new Contact();
            List<String> fstLstNm=cont.Name.split(' ');
            if(cont.Title__c!=NULL)
            {
            if(cont.Title__c.length()>128)
            {
                    c.AccountId=cont.Source_Account__r.Account__c;
           			c.OpCo_Contact_ID__c=cont.Id;
            		c.LastName=cont.LastName__c;
                    c.FirstName=cont.FirstName__c;
            		c.Industry__c=cont.Industry__c;
            		c.Title=cont.Title__c.substring(0,128);
            		c.Email=cont.Email__c;
            		c.Source__c=cont.Source__c;
            		c.OpCo_Account__c=cont.Source_Account__c;
            		c.Phone=cont.Phone__c;
            		c.HasOptedOutOfEmail=cont.Email_Opt_Out__c;
            		c.Contact_Role__c=cont.Contact_Role__c;
            		c.Region__c=cont.Region__c;
            		c.Status__c=cont.Status__c;
            		c.Marketing_Vertical__c=cont.Marketing_Vertical__c;
            		c.Application_Interest_Segment__c=cont.Application_Interest_Segment__c;
            		c.Product_Interest__c=cont.Product_Interest__c;
            		c.MailingPostalCode=cont.MailingPostalCode__c;
            		c.MailingStreet=cont.MailingStreet__c;
            		c.MailingCity=cont.MailingCity__c;
            		c.MailingState=cont.MailingState__c;
            		c.MailingCountry=cont.MailingCountry__c;
                
            }
            else
            {
		   			 c.AccountId=cont.Source_Account__r.Account__c;
          			 c.OpCo_Contact_ID__c=cont.Id;
            	     c.LastName=cont.LastName__c;
                     c.FirstName=cont.FirstName__c;
            		 c.Industry__c=cont.Industry__c;
                     c.Title=cont.Title__c;
                     c.Email=cont.Email__c;
                     c.Source__c=cont.Source__c;
                     c.OpCo_Account__c=cont.Source_Account__c;
                     c.Phone=cont.Phone__c;
                     c.HasOptedOutOfEmail=cont.Email_Opt_Out__c;
                     c.Contact_Role__c=cont.Contact_Role__c;
                     c.Region__c=cont.Region__c;
                     c.Status__c=cont.Status__c;
                     c.Marketing_Vertical__c=cont.Marketing_Vertical__c;
                     c.Application_Interest_Segment__c=cont.Application_Interest_Segment__c;
                     c.Product_Interest__c=cont.Product_Interest__c;
                     c.MailingPostalCode=cont.MailingPostalCode__c;
                     c.MailingStreet=cont.MailingStreet__c;
            		 c.MailingCity=cont.MailingCity__c;
                     c.MailingState=cont.MailingState__c;
                     c.MailingCountry=cont.MailingCountry__c; 
               
            }
            }
            else
            {
            
            c.AccountId=cont.Source_Account__r.Account__c;
            c.OpCo_Contact_ID__c=cont.Id;
            c.LastName=cont.LastName__c;
            c.FirstName=cont.FirstName__c;
            c.Industry__c=cont.Industry__c;
            c.Title=cont.Title__c;
            c.Email=cont.Email__c;
            c.Source__c=cont.Source__c;
            c.OpCo_Account__c=cont.Source_Account__c;
            c.Phone=cont.Phone__c;
            c.HasOptedOutOfEmail=cont.Email_Opt_Out__c;
            c.Contact_Role__c=cont.Contact_Role__c;
            c.Region__c=cont.Region__c;
            c.Status__c=cont.Status__c;
            c.Marketing_Vertical__c=cont.Marketing_Vertical__c;
            c.Application_Interest_Segment__c=cont.Application_Interest_Segment__c;
            c.Product_Interest__c=cont.Product_Interest__c;
            c.MailingPostalCode=cont.MailingPostalCode__c;
            c.MailingStreet=cont.MailingStreet__c;
            c.MailingCity=cont.MailingCity__c;
            c.MailingState=cont.MailingState__c;
            c.MailingCountry=cont.MailingCountry__c; 
            }
            upsertRec.add(c);
            
        }
                 /*Upsertion of Records */
            system.debug(upsertRec);
            List<Database.upsertResult> result=new List<Database.UpsertResult>();
			result=Database.upsert(upsertRec,contact.Email,false); 
        	system.debug(result);
            return result;
    }
    public static Void Danaher_FieldUpdate(List<OpCo_Related_Contact__c>lstAllOpCoRelated,List<OpCo_Related_Contact__c>lstOpCo){
        // Mapping Master Records where object is contact 
        List<Mapping_Master__c> mappingRec=[
            SELECT 
            ID,Object__c,Source_Field__c,Source_OpCo__c,
            Source_Value__c,Destination_Field__c,Destination_Value__c
            FROM Mapping_Master__c 
            WHERE Object__c='Contact'];
        
        // Contact Role Picklist value for comparison 
        List<String>conRolePickListValues=new List<String>();
        Schema.DescribeFieldResult conRoleFieldLabel = Contact.Contact_Role__c.getDescribe();
        List<Schema.PicklistEntry> cR = conRoleFieldLabel.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : cR){
            conRolePickListValues.add(pickListVal.getLabel());
        } 
        // Status Picklist value for comparison 
        List<String>statusPickListValues=new List<String>();
        Schema.DescribeFieldResult statusFieldLabel = Contact.Status__c.getDescribe();
        List<Schema.PicklistEntry> st = statusFieldLabel.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : st){
            statusPickListValues.add(pickListVal.getLabel());
        } 
        // Application Interest Segment Picklist value for comparison 
        List<String>applIntSegPickListValues=new List<String>();
        Schema.DescribeFieldResult applIntSegFieldLabel = Contact.Application_Interest_Segment__c.getDescribe();
        List<Schema.PicklistEntry> apI = applIntSegFieldLabel.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : apI){
            applIntSegPickListValues.add(pickListVal.getLabel());
        } 
        // Marketing Vertical Picklist value for comparison 
        List<String>mrktVertPickListValues=new List<String>();
        Schema.DescribeFieldResult mrktVerticalFieldLabel = Contact.Marketing_Vertical__c.getDescribe();
        List<Schema.PicklistEntry> mV = mrktVerticalFieldLabel.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : mV){
            mrktVertPickListValues.add(pickListVal.getLabel());
        }
        //Product Interest Picklist values 
        List<String>prodIntPickListValues=new List<String>();
        Schema.DescribeFieldResult prodIntFieldLabel = Contact.Product_Interest__c.getDescribe();
        List<Schema.PicklistEntry> pI = prodIntFieldLabel.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : pI){
            prodIntPickListValues.add(pickListVal.getLabel());
        }
        
        // Code for Email Map as key and List of Records as value i.e OpCo_Related_Contact__c
        Map<String,List<OpCo_Related_Contact__c>> mapEmail=new Map<String,List<OpCo_Related_Contact__c>>();
        for(OpCo_Related_Contact__c op:lstAllOpCoRelated){
            if(mapEmail.containsKey(op.Email__c)){
                List<OpCo_Related_Contact__c> con=mapEmail.get(op.Email__c);
                con.add(op);
                mapEmail.put(op.Email__c,con);
            }
            else{
                List<OpCo_Related_Contact__c> lstOp=new List<OpCo_Related_Contact__c>();
                lstOp.add(op);
                mapEmail.put(op.Email__c,lstOp);
            }
        }
        
        
        //
        for(OpCo_Related_Contact__c opCon:lstOpCo){
            List<OpCo_Related_Contact__c> res=mapEmail.get(opCon.Email__c);
            // Contact Role Set of Unique Value and String of that values
            Set<String>conRole=new Set<String>();
            String cRole='';
            //
            Set<String>status=new Set<String>();
            String st_pickVal='';
            //
            Set<String>applIntSeg=new Set<String>();
            String apI_pickVal='';
            //
            Set<String>mrktVertical=new Set<String>();
            String mV_pickVal='';
            //
            Set<String>prodInterest=new Set<String>();
            String prod_Intst='';
            if(res.Size()>0){
                for(OpCo_Related_Contact__c child:res){
                for(Mapping_Master__c mapRes:mappingRec){
                    /* Status */
                    if(child.status__c!=NULL)
                    {
                      if(child.Status__c.contains(','))
                       {
                        List<String> value=child.Status__c.split(',');
                        child.Status__c=value[0];
                       }  
                    } 
                    
                    /*Application Interest Segment */
                    if(child.Application_Interest_Segment__c!=NULL)
                    {
                        if(child.Application_Interest_Segment__c.contains(','))
                        {
                            List<String> value=child.Application_Interest_Segment__c.split(',');
                            child.Application_Interest_Segment__c=value[0];
                        }
                    }
                    /* Contact Role */
                    if(child.Contact_Role__c!=NULL)
                    {
                        if(child.Contact_Role__c.contains(','))
                        {
                            List<String> value=child.Contact_Role__c.split(',');
                            child.Contact_Role__c=value[0];
                        }
                    }
                    /* Marketing Vertical  */
                    if(child.Marketing_Vertical__c!=NULL)
                    {
                        if(child.Marketing_Vertical__c.contains(','))
                        {
                            List<String> value=child.Marketing_Vertical__c.split(',');
                            child.Marketing_Vertical__c=value[0];
                        }
                    }
                    /*Product Interest*/
                    if(child.Product_Interest__c!=NULL)
                    {
                        if(child.Product_Interest__c.contains(','))
                        {
                            List<String> value=child.Product_Interest__c.split(',');
                            child.Product_Interest__c=value[0];
                        }
                    }
                    
                    
                    if(child.Contact_Role__c==mapRes.Source_Value__c && child.Source__c==mapRes.Source_OpCo__c && mapRes.Destination_Field__c=='Contact_Role__c' ){
                        child.Contact_Role__c=mapRes.Destination_Value__c;       
                    } 
                    if(child.Status__c==mapRes.Source_Value__c && child.Source__c==mapRes.Source_OpCo__c && mapRes.Destination_Field__c=='Status__c' ){
                        child.Status__c=mapRes.Destination_Value__c;       
                    }
                    
                    if(child.Application_Interest_Segment__c==mapRes.Source_Value__c && child.Source__c==mapRes.Source_OpCo__c && mapRes.Destination_Field__c=='Application_Interest_Segment__c' ){
                        child.Application_Interest_Segment__c=mapRes.Destination_Value__c;       
                    } 
                    if(child.Marketing_Vertical__c==mapRes.Source_Value__c && child.Source__c==mapRes.Source_OpCo__c && mapRes.Destination_Field__c=='Marketing_Vertical__c' ){
                        child.Marketing_Vertical__c=mapRes.Destination_Value__c;       
                    } 
                     if(child.Product_Interest__c==mapRes.Source_Value__c && child.Source__c==mapRes.Source_OpCo__c && mapRes.Destination_Field__c=='Product_Interest__c' ){
                        child.Product_Interest__c=mapRes.Destination_Value__c;       
                    } 
                }
                // Insertion of values 
                if(child.Contact_Role__c!=NULL)
                {
					conRole.add(child.Contact_Role__c);                    
                }
                if(child.Status__c!=NULL)
                 {
                     status.add(child.Status__c);
                 }
                
                if(child.Marketing_Vertical__c!=NULL)
                {
                    mrktVertical.add(child.Marketing_Vertical__c); 
                }
                if(child.Application_Interest_Segment__c!=NULL)
                {
                    applIntSeg.add(child.Application_Interest_Segment__c); 
                }
                if(child.Product_Interest__c!=NULL)
                 {
                    prodInterest.add(child.Product_Interest__c); 
                 }   
                //
                for(String conR:conRole){
                   
                    //Boolean result=;
                    if(!conRolePickListValues.contains(conR)){
                        conRole.remove(conR);
                        conRole.add('Undefined');
                    }
                    if(conR==null){
                        conRole.remove(conR);
                    }
                    
                }
                //
                for(String sta:status){
                    
                    //Boolean result=; 
                    //system.debug(result);
                    if(!statusPickListValues.contains(sta)){
                        status.remove(sta);
                        status.add('Undefined');
                    }
                    
                    if(sta==null){
                        status.remove(sta);
                    }
                   
                }
                //
                for(String mrktVer:mrktVertical){
                    if(!mrktVertPickListValues.contains(mrktVer)){
                        mrktVertical.remove(mrktVer);
                        mrktVertical.add('Undefined');
                    }
                    if(mrktVer==null){
                        mrktVertical.remove(mrktVer);
                    }
                    
                }
                //
                for(String applIn:applIntSeg){
                    
                    //Boolean result=applIntSegPickListValues.contains(applIn);
                    if(!applIntSegPickListValues.contains(applIn)){
                        applIntSeg.remove(applIn);
                        applIntSeg.add('Undefined');
                    }
                    
                    if(applIn==null){
                        applIntSeg.remove(applIn);
                    }
                   
                }
                    for(String prInt:prodInterest)
                    {
                        if(!prodIntPickListValues.contains(prInt)){
                        prodInterest.remove(prInt);
                        prodInterest.add('Undefined');
                    }
                    
                    if(prInt==null){
                        prodInterest.remove(prInt);
                    }
                    }
                
            }
            }
            
            //For Contact Role
            for(String str:conRole){
                cRole+=str+';';
            }
            if(cRole.length()>0)
            {
                cRole=cRole.substring(0,cRole.length()-1);
                opCon.Contact_Role__c=cRole; 
            }
           
            // For Status
            for(String str:status){
                st_pickVal+=str+';';
            }
            if(st_pickVal.length()>0)
            {
               st_pickVal=st_pickVal.substring(0,st_pickVal.length()-1);
               opCon.Status__c=st_pickVal; 
            }
            
            // For Application Int Segment
            for(String str:applIntSeg){
                apI_pickVal+=str+';';
            }
            if(apI_pickVal.length()>0)
            {
                apI_pickVal=apI_pickVal.substring(0,apI_pickVal.length()-1);
                opCon.Application_Interest_Segment__c=apI_pickVal;
            }
            
            // For Marketing Vertical 
           
            for(String str:mrktVertical){
                mV_pickVal+=str+';';
            }
            if(mV_pickVal.length()>0)
            {
            mV_pickVal=mV_pickVal.substring(0,mV_pickVal.length()-1);
            opCon.Marketing_Vertical__c=mV_pickVal; 
            }
            // prod_Intst
            for(String str:prodInterest)
            {
                 prod_Intst+=str+';';
            }
            if(prod_Intst.length()>0)
            {
            prod_Intst=prod_Intst.substring(0,prod_Intst.length()-1);
            opCon.Product_Interest__c=prod_Intst; 
            }
           
        }
        
    }
    
    
}
public class Danaher_AccUpdateBatchHandler {
    
    public static Void accUpdateHandler(List<opCo_Account__c> lstOpCoAcc){
        
        Set<id> accId = new set<id>();
        for(opCo_Account__c opco :lstOpCoAcc)   
        {
            accId.add(opco.Account__c) ;
            
        }
        
        Map<Id,Account> MapAcc=new Map<Id,Account>([select id,name,Type__c,Industry__c from Account where id in :accId]);
        
        
        /* Records of Mapping Master for Account Object */
        List<Mapping_Master__c> mappingRec=[
            SELECT 
            ID,Object__c,Source_Field__c,Source_OpCo__c,
            Source_Value__c,Destination_Field__c,Destination_Value__c
            FROM Mapping_Master__c 
            WHERE Object__c='Account' and Destination_Field__c in ('Industry_lsig__c','Type_lsig__c')];
        
        List<String>industryPickListValues=new List<String>();
        Schema.DescribeFieldResult industryFieldLabel = Account.Industry__c.getDescribe();
        List<Schema.PicklistEntry> ple = industryFieldLabel.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            industryPickListValues.add(pickListVal.getLabel());            
        }  
        
        List<String>typePickListValues=new List<String>();
        Schema.DescribeFieldResult typeFieldLabel = Account.Type__c.getDescribe();
        List<Schema.PicklistEntry> typ = typeFieldLabel.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : typ){
            typePickListValues.add(pickListVal.getLabel());
        }   
        
        for(opCo_Account__c opCoAcc:lstOpCoAcc){
            Set<String> tpye =new Set<String>();
            Set<String> industry =new Set<String>();
            // PickList String type value 
            String typePickVal=''; 
            // PickList String industry value
            String industryPickVal=''; 
            system.debug(opCoAcc);
            
            // Inner Loop for child records of specific account i.e PFizer as acc
            //   for(OpCo_Account__c opCoAcc:acc.OpCo_Accounts__r){
            List<String> Typevalue =new  List<String>();
            if(opCoAcc.Type__c!=NULL)
            {
                
                if(opCoAcc.Type__c.contains(','))
                {
                    Typevalue =opCoAcc.Type__c.split(',');
                }else{
                    Typevalue.add(opCoAcc.Type__c);
                }
                
                
                Map<string,string> AllMapMasterType = new  Map<string,string>();
                
                
                for(Mapping_Master__c mas:mappingRec){                    
                    if(opCoAcc.Source__c==mas.Source_OpCo__c){
                        AllMapMasterType.put(mas.Source_Value__c,mas.Destination_Value__c);
                    }
                }
                for(string Tvalue:Typevalue){
                    if(AllMapMasterType.containsKey(Tvalue)){   
                        tpye.add(AllMapMasterType.get(Tvalue));
                    }else{
                        tpye.add(AllMapMasterType.get(Tvalue)); 
                    }
                    
                }
                
                for(string Dvalue:tpye){
                    
                    if(!typePickListValues.contains(Dvalue)){
                        tpye.remove(Dvalue);
                        tpye.add('Undefined');
                    }
                    
                }
                
            }                
            
            
            
            
            
            
            List<String> Industryvalue =new  List<String>();           
            if(opCoAcc.Industry__c!=NULL)
            {
                if(opCoAcc.Industry__c.contains(','))
                {
                    Industryvalue =opCoAcc.Industry__c.split(',');
                }else{
                    Industryvalue.add(opCoAcc.Industry__c);
                }
                
                
                Map<string,string> AllMapMasterIndustry = new  Map<string,string>();
                
                
                for(Mapping_Master__c mas:mappingRec){                    
                    if(opCoAcc.Source__c==mas.Source_OpCo__c){
                        AllMapMasterIndustry.put(mas.Source_Value__c,mas.Destination_Value__c);
                    }
                }
                for(string Ivalue:Industryvalue){
                    if(AllMapMasterIndustry.containsKey(Ivalue)){   
                        industry.add(AllMapMasterIndustry.get(Ivalue));
                    }else{
                        industry.add(AllMapMasterIndustry.get(Ivalue)); 
                    }
                    
                }
                
                for(string Ivalue:industry){
                    
                    if(!industryPickListValues.contains(Ivalue)){
                        industry.remove(Ivalue);
                        industry.add('Undefined');
                    }                    
                }
            }
            
            system.debug('last industry'+industry);
            // Loop will create String i.e Prospect;Value; for type field 
            if(tpye.size()>0){
                for(String str:tpye){
                    typePickVal+=str+';';
                }
            }
            // Loop will create String i.e Prospect;Value; for industry field 
            if(industry.size()>0){
                for(String str:industry){
                    industryPickVal+=str+';';
                }
            }
            // String ; remove from last index 
            system.debug(typePickVal);
            system.debug(industryPickVal);
            
            if(typePickVal.length()>0){
                typePickVal=typePickVal.substring(0,typePickVal.length()-1); 
                string OldType='';
                //Assigning Multi Select Value to Account Object Type__c field
                if(MapAcc.get(opCoAcc.Account__c).Type__c != null )
                {
                    OldType=MapAcc.get(opCoAcc.Account__c).Type__c;
                    OldType+=';'+typePickVal;   
                    List<string> newTypeValues= OldType.split(';');
                    set<string> uniqType =new set<string>();
                    for(string val : newTypeValues){
                        uniqType.add(val); 
                    }
                    string newtyepickval ='';
                    if(uniqType.size()>0){
                        
                        for(String str:uniqType){
                            
                            newtyepickval+=str+';';
                        }
                        
                        if(newtyepickval.length()>0){
                            
                            newtyepickval=newtyepickval.substring(0,newtyepickval.length()-1);
                            MapAcc.get(opCoAcc.Account__c).Type__c=newtyepickval;                            
                        }                        
                    } 
                    
                }else{
                    MapAcc.get(opCoAcc.Account__c).Type__c=typePickVal;
                }
            }
            
            if(industryPickVal.length()>0){
                industryPickVal=industryPickVal.substring(0,industryPickVal.length()-1); 
                string OldIndustry='';
                // Assigning Multi Select Value to Account Object Industry__c field 
                
                if(MapAcc.get(opCoAcc.Account__c).Industry__c != null )
                {
                    OldIndustry=MapAcc.get(opCoAcc.Account__c).Industry__c;
                    OldIndustry+=';'+industryPickVal;     
                    List<string> newIndustryValues= OldIndustry.split(';');
                    set<string> uniqIndustry =new set<string>();
                    for(string val : newIndustryValues){
                        uniqIndustry.add(val); 
                    }
                    string newIndustrypickval ='';
                    if(uniqIndustry.size()>0){
                        
                        for(String str:uniqIndustry){
                            
                            newIndustrypickval+=str+';';
                        }
                        
                        if(newIndustrypickval.length()>0){
                            newIndustrypickval=newIndustrypickval.substring(0,newIndustrypickval.length()-1);
                            MapAcc.get(opCoAcc.Account__c).Type__c=newIndustrypickval;
                        } 
                        
                    } 
                    
                }else{
                    
                    MapAcc.get(opCoAcc.Account__c).Industry__c=industryPickVal;
                }
            }                   
            
        }
        system.debug(MapAcc.values());
        Database.update(MapAcc.values(),false);        
    }
}
public class Danaher_AccUpdate {
 public static Void handler(List<OpCo_Account__c> lstOpAcc)
	{
    	 Set<id> accId = new set<id>();
         for(opCo_Account__c opco :lstOpAcc)   
        	{
           		 accId.add(opco.Account__c) ;
        	}
            /*Account Records */
          List<Account> lstAcc=new List<Account>([select id,name,Type__c,Industry__c from Account where id in :accId]);
           /* Records of Mapping Master for Account Object */
         List<Mapping_Master__c> mappingRec=[
            SELECT 
            ID,Object__c,Source_Field__c,Source_OpCo__c,
            Source_Value__c,Destination_Field__c,Destination_Value__c
            FROM Mapping_Master__c 
            WHERE Object__c='Account' and Destination_Field__c in ('Type_lsig__c')];
        Map<String,String> mapMasMap=new Map<String,String>();
        for(Mapping_Master__c val:mappingRec)
        {
            mapMasMap.put(val.Source_Value__c+val.Source_OpCo__c,val.Destination_Value__c);
        }
        /*Industry Picklist Values */
         List<String>typePickListValues=new List<String>();
        Schema.DescribeFieldResult typeFieldLabel = Account.Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = typeFieldLabel.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            typePickListValues.add(pickListVal.getLabel());            
        }
              	/* Main Code Start*/
         for(opCo_Account__c opCoAcc:lstOpAcc)
         {
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
            }
            for(String str:Typevalue)
              {
                for(Mapping_Master__c mapRes:mappingRec)
                {
                    if(mapMasMap.containsKey(str+opCoAcc.Source__c))
                    {
                         String value=mapMasMap.get(str+opCoAcc.Source__c);
                         Integer ind=Typevalue.indexOf(str);
                        	if(ind!=-1)
                            {
                                Typevalue.set(ind, value);
                            }
                         
                    }
                }
              }
             
             /*Adding value to Set*/
             for(String str:Typevalue)
             {
                 tpye.add(str);
             }
             for(Account ac:lstAcc)
             {
                 if(ac.ID==opCoAcc.Account__c)
                 {
                     if(ac.Type__c!=NULL)
                     {
                         String value=ac.Type__c;
                         List<String> ls=value.split(';');
                         for(String str:ls)
                         {
                             Typevalue.add(str);
                         }
                         
                     }
                 }
             }
             for(String str:Typevalue)
             {
                 if(!typePickListValues.contains(str))
                    {
                        tpye.add('Undefined');
                    }  
                 else
                     {
                     tpye.add(str);
                     }

             }
             if(tpye.Size()>0)
             {
                 for(String str:tpye)
                 {
                   typePickVal+=str+';';
                 }
                 
             }
             if(typePickVal.length()>0)
             {
                 typePickVal=typePickVal.substring(0,typePickVal.length()-1);
             }
             for(Account ac:lstAcc)
             {
                 if(ac.ID==opCoAcc.Account__c)
                 {
                     ac.Type__c=typePickVal;
                 }
             }
             
	    }
        system.debug(lstAcc);
        update lstAcc;
   }
}
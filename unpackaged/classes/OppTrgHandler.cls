public class OppTrgHandler {
	public static Void updateTrigger (List<Opportunity> lstOpp)
    {
        /* Find all Lsig opCo RElated Contact IDS  For all contact roles in this trigger */
        Set<String>IDs=new Set<String>();
        for(Opportunity op:lstOpp)
        {
            IDs.add(op.Contact_Role_ID__c);    
        }
        
        List<opCo_Related_Contact__c> lstRelContacts=[SELECT ID,LSIG_Contact__c FROM opCO_Related_Contact__c Where Source_OpCo_Record_Id__c IN :IDs];
        
         /* Mapping Master Records where object is contact */
        List<Mapping_Master__c> mappingRec=[
            SELECT 
            ID,Object__c,Source_Field__c,Source_OpCo__c,
            Source_Value__c,Destination_Field__c,Destination_Value__c
            FROM Mapping_Master__c 
            WHERE Object__c='Opportunity'];
        
       							 /*Product Family */
        List<Mapping_Master__c> prodFamily=[
            SELECT ID,Destination_Value__c, Source_OpCo__c,Destination_Field__c,Object__c 
            From Mapping_Master__c
            Where Destination_Field__c ='Product_Family__c' and Object__c ='Opportunity'
        ];
        Map<String,String> prodFamilyMap=new Map<String,String>();
        for(Mapping_Master__c val:prodFamily)
        {
            prodFamilyMap.put(val.Destination_Value__c,val.Destination_Value__c);
        }
        
       								 /*Cancellation Lost Data  */
        List<Mapping_Master__c> canLostData=[
            SELECT ID,Destination_Value__c, Source_OpCo__c,Destination_Field__c,Object__c 
            From Mapping_Master__c
            Where Destination_Field__c ='Cancellation_Lost_Data__c' and Object__c ='Opportunity'
        ];
        Map<String,String> canLostDataMap=new Map<String,String>();
        for(Mapping_Master__c val:canLostData)
        {
            canLostDataMap.put(val.Destination_Value__c,val.Destination_Value__c);
        }
        
         // Status Role Picklist value for comparison 
        List<String>stagePickListValues=new List<String>();
        Schema.DescribeFieldResult stageFieldLabel = Opportunity.StageName.getDescribe();
        List<Schema.PicklistEntry> sN = stageFieldLabel.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : sN){
            stagePickListValues.add(pickListVal.getLabel());
        } 
        
          // Type Picklist value for comparison 
        List<String>typePickListValues=new List<String>();
        Schema.DescribeFieldResult typeFieldLabel = Opportunity.Type.getDescribe();
        List<Schema.PicklistEntry> tY = typeFieldLabel.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : tY)
        {
            typePickListValues.add(pickListVal.getLabel());
        }
        
         // Market Seg Picklist value for comparison 
        List<String>mktSegPickListValues=new List<String>();
        Schema.DescribeFieldResult mktSegFieldLabel = Opportunity.Market_Segment__c.getDescribe();
        List<Schema.PicklistEntry> mS = mktSegFieldLabel.getPicklistValues();
        for( Schema.PicklistEntry mktSeg : mS){
            mktSegPickListValues.add(mktSeg.getLabel());
        }
        
        											/*Main Code Starts Opportunity Loop*/
         for(Opportunity opp:lstOpp)
        {
            if(opp.Skip_Trigger__c == true || opp.Source_OpCo_Record_Id__c==null || opp.Source_OpCo_Record_Id__c=='')
                continue;
            
            Map<String,List<String>> mapValues=new Map<String,List<String>>();
            // Condition to be removed 
            if(opp.LSIG_Contact__c==null)
            {
                opp.LSIG_Contact__c=lstRelContacts[0].LSIG_Contact__c; 
                opp.OpCo_Related_Contact__c=lstRelContacts[0].ID;
            }
            
             if(opp.OpCo_Line_Of_Business__c!=null)
            {
                if(opp.OpCo_Line_Of_Business__c.contains(','))
                {
                    List<String> value=opp.OpCo_Line_Of_Business__c.split(',');
                    mapValues.put('OpCo_Line_Of_Business__c',value);
                } 
                else
                {
                    List<String> value=new List<String>();
                    value.add(opp.OpCo_Line_Of_Business__c);
                    mapValues.put('OpCo_Line_Of_Business__c',value);
                }
            }
            
              if(opp.opCo_Market_Segment__c!=null)
            {
                if(opp.opCo_Market_Segment__c.contains(','))
                {
                    List<String> value=opp.opCo_Market_Segment__c.split(',');
                    mapValues.put('opCo_Market_Segment__c',value);
                } 
                else
                {
                    List<String> value=new List<String>();
                    value.add(opp.opCo_Market_Segment__c);
                    mapValues.put('opCo_Market_Segment__c',value);
                }
            }
            
              if(opp.OpCo_Product_Family__c!=null)
            {
                if(opp.OpCo_Product_Family__c.contains(','))
                {
                    List<String> value=opp.OpCo_Product_Family__c.split(',');
                    mapValues.put('OpCo_Product_Family__c',value);
                } 
                else
                {
                    List<String> value=new List<String>();
                    value.add(opp.OpCo_Product_Family__c);
                    mapValues.put('OpCo_Product_Family__c',value);
                }
            }
            
              if(opp.OpCo_Competitor_Data__c!=null)
            {
                if(opp.OpCo_Product_Family__c.contains(','))
                {
                    List<String> value=opp.OpCo_Competitor_Data__c.split(',');
                    mapValues.put('OpCo_Competitor_Data__c',value);
                } 
                else
                {
                    List<String> value=new List<String>();
                    value.add(opp.OpCo_Competitor_Data__c);
                    mapValues.put('OpCo_Competitor_Data__c',value);
                }
            }
            
            system.debug(mapValues);
           		             /*    OpCO Line Business      */
                List<String> values=mapValues.get('OpCo_Line_Of_Business__c');
                for(String val:values)
                {
                   for(Mapping_Master__c mapRes:mappingRec)
            		{
                         if(val==mapRes.Source_Value__c && opp.Source__c==mapRes.Source_OpCo__c && mapRes.Destination_Field__c=='Line_of_Business__c' )
               			 {
                   				Integer index=values.indexOf(val);
                             	values.set(index,mapRes.Destination_Value__c); 
                		 }  
                    }
                }
                mapValues.put('OpCo_Line_Of_Business__c',values);
                         /* End of OpCo Line Business */
            			 /*OpCo_Product_Family__c */
             List<String> prFam=mapValues.get('OpCo_Product_Family__c');
                for(String val:prFam)
                {
                   for(Mapping_Master__c mapRes:mappingRec)
            		{
                         if(val==mapRes.Source_Value__c && opp.Source__c==mapRes.Source_OpCo__c && mapRes.Destination_Field__c=='Line_of_Business__c' )
               			 {
                   				Integer index=prFam.indexOf(val);
                             	prFam.set(index,mapRes.Destination_Value__c); 
                		 }  
                    }
                    if(!prodFamilyMap.containskey(val) )
                		{
                  		        Integer index=prFam.indexOf(val);
                             	prFam.set(index,'Undefined');      
                		}
                }
            mapValues.put('OpCo_Product_Family__c',prFam);
            /*End of OpCo_Product_Family__c*/
            	system.debug(mapValues);
           
            /*End of Opportunity For Loop */
        }
        
    }
    
}
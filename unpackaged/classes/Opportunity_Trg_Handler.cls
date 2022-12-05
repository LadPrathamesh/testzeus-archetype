public class Opportunity_Trg_Handler {
    public static List<Opportunity> UpdateTrgHandler(List<Opportunity> lstOpp){
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
        
        /*Competitor Data */
        List<Mapping_Master__c> compData=[
            SELECT ID,Destination_Value__c, Source_OpCo__c,Destination_Field__c,Object__c 
            From Mapping_Master__c
            Where Destination_Field__c ='Competitor_Data__c' and Object__c ='Opportunity'
        ];
        Map<String,String> compDataMap=new Map<String,String>();
        for(Mapping_Master__c val:compData)
        {
            compDataMap.put(val.Destination_Value__c,val.Destination_Value__c);
        }
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
        /*Cancellation/Lost Data  */
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
        for( Schema.PicklistEntry pickListVal : tY){
            typePickListValues.add(pickListVal.getLabel());
        } 
        // Market Seg Picklist value for comparison 
        List<String>mktSegPickListValues=new List<String>();
        Schema.DescribeFieldResult mktSegFieldLabel = Opportunity.Market_Segment__c.getDescribe();
        List<Schema.PicklistEntry> mS = mktSegFieldLabel.getPicklistValues();
        for( Schema.PicklistEntry mktSeg : mS){
            mktSegPickListValues.add(mktSeg.getLabel());
        }
               
        //
        Set<String> opCoAccount=new Set<String>();
        for(Opportunity op:lstOpp)
        {
            opCoAccount.add(op.id);
        }
        List<Opportunity> opAc=[SELECT ID,OpCo_Account__r.Account__c FROM Opportunity  WHERE ID In :opCoAccount AND OpCo_Account__c!=NULL ];
        system.debug(opAc);
        
        for(Opportunity opp:lstOpp)
        {
            if(opAc.Size()>0)
            {
              for(Opportunity oc:opAc)
                {
                    if(oc.Id==opp.Id)
                    {
                        opp.AccountId=oc.OpCo_Account__r.Account__c;
                    }
                }   
            }
             
            
            if(opp.Skip_Trigger__c == true || opp.Source_OpCo_Record_Id__c==null || opp.Source_OpCo_Record_Id__c=='')
                continue;
            
            // Condition to be removed 
             
            	
           
              
         
            
            if(opp.LSIG_Contact__c==null)
            {
                opp.LSIG_Contact__c=lstRelContacts[0].LSIG_Contact__c; 
                opp.OpCo_Related_Contact__c=lstRelContacts[0].ID;
            }
            
            
            opp.StageName=opp.OpCo_Stage__c;
            opp.Type=opp.OpCo_Type__c;
            if(opp.OpCo_Line_Of_Business__c!=null)
            {
                if(opp.OpCo_Line_Of_Business__c.contains(','))
                {
                    List<String> value=opp.OpCo_Line_Of_Business__c.split(',');
                    opp.Line_of_Business__c=value[0];
                } 
                else
                {
                    opp.Line_of_Business__c=opp.OpCo_Line_Of_Business__c;
                }
            }
            
            if(opp.opCo_Market_Segment__c!=null)  
            {
                if(opp.opCo_Market_Segment__c.contains(','))  
                {
                    List<String> value=opp.opCo_Market_Segment__c.split(',');
                    opp.Market_Segment__c=value[0];
                }
                else
                {
                    opp.Market_Segment__c=opp.OpCo_Market_Segment__c; 
                }
                
            }
            if(opp.OpCo_Product_Family__c!=null)
            {
                if(opp.OpCo_Product_Family__c.contains(',')&& opp.OpCo_Product_Family__c!=null)
                {
                    List<String> value=opp.OpCo_Product_Family__c.split(',');
                    opp.Product_Family__c=value[0];
                }
                else
                {
                    opp.Product_Family__c=opp.OpCo_Product_Family__c;
                }
            }
            
            if(opp.OpCo_Competitor_Data__c!=null)
            {
                if(opp.OpCo_Competitor_Data__c.contains(',')&& opp.OpCo_Competitor_Data__c!=null)
                {
                    List<String> value=opp.OpCo_Competitor_Data__c.split(',');
                    opp.Competitor_Data__c=value[0];
                }
                else
                {
                    opp.Competitor_Data__c=opp.OpCo_Competitor_Data__c;
                }
            }
            
            if(opp.OpCo_Cancellation_Lost_Data__c !=null)
            {
                if(opp.OpCo_Cancellation_Lost_Data__c.contains(',')&& opp.OpCo_Cancellation_Lost_Data__c!=null)
                {
                    List<String> value=opp.OpCo_Cancellation_Lost_Data__c.split(',');
                    opp.Cancellation_Lost_Data__c=value[0];
                }
                else
                {
                    opp.Cancellation_Lost_Data__c=opp.OpCo_Cancellation_Lost_Data__c;
                }
            }
            
            for(Mapping_Master__c mapRes:mappingRec)
            {
                if(opp.OpCo_Stage__c==mapRes.Source_Value__c && opp.Source__c==mapRes.Source_OpCo__c )
                {
                    opp.StageName=mapRes.Destination_Value__c;
                }  
                
                if(opp.OpCo_Type__c==mapRes.Source_Value__c && opp.Source__c==mapRes.Source_OpCo__c )
                {
                    opp.Type=mapRes.Destination_Value__c;
                }
                if(opp.OpCo_Line_Of_Business__c==mapRes.Source_Value__c && opp.Source__c==mapRes.Source_OpCo__c )
                {
                    opp.OpCo_Line_Of_Business__c=mapRes.Destination_Value__c;
                }
                if(opp.OpCo_Market_Segment__c==mapRes.Source_Value__c && opp.Source__c==mapRes.Source_OpCo__c )
                {
                    opp.Market_Segment__c=mapRes.Destination_Value__c;
                }
                if(opp.OpCo_Product_Family__c==mapRes.Source_Value__c && opp.Source__c==mapRes.Source_OpCo__c )
                {
                    opp.Product_Family__c=mapRes.Destination_Value__c;
                } 
                if(opp.OpCo_Competitor_Data__c==mapRes.Source_Value__c && opp.Source__c==mapRes.Source_OpCo__c )
                {
                    opp.Competitor_Data__c=mapRes.Destination_Value__c;
                }
                if(opp.OpCo_Cancellation_Lost_Data__c==mapRes.Source_Value__c && opp.Source__c==mapRes.Source_OpCo__c )
                {
                    opp.Cancellation_Lost_Data__c=mapRes.Destination_Value__c;
                } 
                
            }    
        }
        system.debug(lstOpp);
        //
        for(Opportunity opp:lstOpp)
        {
            if(opp.StageName==null)
            {
                opp.StageName=Null;
            }
            else
            {
                if(!stagePickListValues.contains(opp.StageName) )
                {
                    opp.StageName='Undefined';     
                }
            }
            
            /*Type*/
            if(opp.Type==null)
            {
                opp.Type=Null;
            }
            else
            {
                if(!typePickListValues.contains(opp.Type) )
                {
                    opp.Type='Undefined';     
                }
            }
            
            /*Market Segment */
            if(opp.OpCo_Market_Segment__c==null )
            {
                opp.Market_Segment__c=Null;
            }
            else
            {
                if(!mktSegPickListValues.contains(opp.Market_Segment__c) )
                    
                {
                    
                    opp.Market_Segment__c='Undefined';              
                }
            }
            /*Competitor Data*/
            if(opp.OpCo_Competitor_Data__c==null )
            {
                opp.Competitor_Data__c=Null;
            }
            else
            {
                if(!compDataMap.containskey(opp.Competitor_Data__c) )
                {
                    opp.Competitor_Data__c='Undefined';     
                }
            }
            /*Product Family*/
            if(opp.OpCo_Product_Family__c==null )
            {
                opp.Product_Family__c=Null;
            }
            else
            {
                if(!prodFamilyMap.containskey(opp.Product_Family__c) )
                {
                    opp.Product_Family__c='Undefined';     
                }
            }
            /**/
            if(opp.OpCo_Cancellation_Lost_Data__c==null )
            {
                opp.Cancellation_Lost_Data__c=Null;  
            }
            else
            {
                if(!canLostDataMap.containskey(opp.Cancellation_Lost_Data__c) )
                {
                    opp.Cancellation_Lost_Data__c='Undefined';     
                }
            }
            /**/
            if(opp.OpCo_Line_Of_Business__c==null)
            {
                opp.Line_of_Business__c=Null;
            }
           
            
        }
        //system.debug(lstOpp);
        return lstOpp;
        
        
    }
    
}
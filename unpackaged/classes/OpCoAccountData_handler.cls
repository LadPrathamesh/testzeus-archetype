public class OpCoAccountData_handler {
/*   public static List<OpCo_Account__c> trg_mappingmaster(List<OpCo_Account__c> lstRec){
        List<Mapping_Master__c> mappingRec=[SELECT ID,Object__c,Source_Field__c,Source_OpCo__c, Source_Value__c,
                                            Destination_Field__c,Destination_Value__c FROM Mapping_Master__c 
                                            WHERE Object__c='Account'];
          
      List<OpCo_Account__c> oac=new List<OpCo_Account__c>();
     system.debug(lstRec);
       for(OpCo_Account__c opadata:lstRec){
           
           for(Mapping_Master__c mas:mappingRec){
               if(opadata.Type__c==mas.Source_Value__c && mas.Source_Field__c=='Type' ){
                   opadata.Type__c=mas.Destination_Value__c;
    				
               }
                if(opadata.Industry__c==mas.Source_Value__c &&  mas.Source_Field__c=='Industry' ){
                   opadata.Industry__c=mas.Destination_Value__c;
    				
               }
               if(opadata.Market_Segment__c==mas.Source_Value__c && mas.Source_Field__c=='Market Segment'  ){
                   opadata.Market_Segment__c=mas.Destination_Value__c;
    				
               }
           }   
           oac.add(opadata);
       }
       system.debug(oac);
        return oac;        
    }*/
}
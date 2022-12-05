public class OpCoAccountFieldUpdate_Handler {

    public static List<OpCo_Account__c> OpCoAccountFieldHandler(List<OpCo_Account__c> lstOpCoAcc){
     List<Mapping_Master__c> mappingRec=[
     SELECT 
     ID,Object__c,Source_Field__c,Source_OpCo__c,
     Source_Value__c,Destination_Field__c,Destination_Value__c
     FROM Mapping_Master__c 
     WHERE Object__c='Account']; 
        
        for(OpCo_Account__c opAcc:lstOpCoAcc){
           
           for(Mapping_Master__c mas:mappingRec){
               if(opAcc.Type__c==mas.Source_Value__c  && mas.Source_Field__c=='Type'&& opAcc.Source__c==mas.Source_OpCo__c){
                   opAcc.Type__c=mas.Destination_Value__c;       
               }
               if(opAcc.Industry__c==mas.Source_Value__c  && mas.Source_Field__c=='Industry' && opAcc.Source__c==mas.Source_OpCo__c){
                   opAcc.Industry__c=mas.Destination_Value__c;               
               }
           }
            
           
       }
        return lstOpCoAcc;
    }
}
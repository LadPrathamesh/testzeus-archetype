/*
* @Developer-Sudhir Dhawan
* @Company-Nanostuffs Technologies Private Limited
* @Description-
* @TestClass-Danaher_ContactCreationBatchTest
*/
global class Danaher_ContactCreationBatch implements Database.Batchable<sObject>,Database.Stateful{
    global static List<Database.upsertResult> result=new List<Database.upsertResult>();
    global Database.QueryLocator start(Database.BatchableContext BC){
        //Query to get Records
        String lmt = BaseURL__c.getOrgDefaults().ContactBatchLimit__c;
        
        String qry='SELECT ID,Name,Email__c,Source_Account__r.Account__c FROM OpCo_Related_Contact__c Where Email__c !=\' \'  Order by OpCo_LastModifiedDate__c DESC ' +lmt+'';
        return Database.getQueryLocator(qry);
    }
    
    global void execute(Database.BatchableContext BC, List<OpCo_Related_Contact__c> lstOpRelContact){
        system.debug('@@@@');
        System.debug('lstOpRelContact:::'+lstOpRelContact);
        Danaher_ContactCreationBatch.result=Danaher_UniqueContactCreation.ContactCreation(lstOpRelContact);        
        
    }
    global void finish(Database.BatchableContext BC){
        Database.executeBatch(new Danaher_LSIGContactBatch(),100);
        Integer updated=0;
        Integer inserted=0;
        Integer checked=0;
        
        if(Danaher_ContactCreationBatch.result.Size()>0){
            system.debug('Danaher_ContactCreationBatch.result:::'+Danaher_ContactCreationBatch.result);
            for(Integer index = 0, size = Danaher_ContactCreationBatch.result.size(); index < size; index++) {
                if(Danaher_ContactCreationBatch.result[index].isSuccess()) {
                    checked++; 
                    if(Danaher_ContactCreationBatch.result[index].isCreated()) {
                        inserted++;
                    } else {
                        updated++;
                    }
                }
            }
            Sync__c syncObj=new Sync__c();
            syncObj.Object__c='Contact';
            syncObj.Records_Checked__c=checked;
            syncObj.Records_Inserted__c=inserted;
            syncObj.Records_Updated__c=updated;
            syncObj.Script_Name__c='Danaher_ContactCreationBatch';
            insert syncObj;
            //Batch to update LSIG Contact Field on OpCo Related Contact
            
        }
    }
}
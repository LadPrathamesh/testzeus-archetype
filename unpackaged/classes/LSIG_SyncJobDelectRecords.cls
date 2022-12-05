/* @Developer   - Dinesh Kanwate
 * @Company     - Nanostuffs Technologies Pvt Limited
 * @Description - Delete all sync job records except 'Today'
 * @TestClass - LSIG_SyncJobDelectRecordsTest
 */

public class LSIG_SyncJobDelectRecords implements Database.Batchable<sObject> {
   
    public Database.QueryLocator start(Database.BatchableContext BC){
          return Database.getQueryLocator([select Id,CreatedDate from Sync__c where CreatedDate = Today ]);
    }
     public void execute(Database.BatchableContext BC, List<Sync__c> syncLst){
         delete syncLst;
     }
    
    public void finish(Database.BatchableContext BC){
        
    }
}
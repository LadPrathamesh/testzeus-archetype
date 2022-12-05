@isTest
public class LSIG_SyncJobDelectRecordsTest {
    @isTest
    public static void SynchJobDeleteRecords(){
        Sync__c syncdata = new Sync__c();
        insert syncdata;
      
        
        Test.startTest();
        
        LSIG_SyncJobDelectRecords obj = new LSIG_SyncJobDelectRecords();
        DataBase.executeBatch(obj); 
        
        Test.stopTest();
    }
}
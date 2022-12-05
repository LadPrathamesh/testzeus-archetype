@isTest
    public class Danaher_ContactCreationBatchTest {
        @isTest
        public static void Danaher_ContactCreationBatch(){
            
            Account acc = new Account();
            acc.Name = 'test';
            insert acc;
            
            OpCo_Account__c OpCoAccData = new OpCo_Account__c();
            OpCoAccData.Account__c = acc.id;
            OpCoAccData.Skip_Trigger__c = true;
            insert OpCoAccData;
            
            date mydate = date.parse('12/27/2023');
            
            Opportunity oppdata = new Opportunity();
            oppdata.Name = 'test';
            oppdata.AccountId = acc.id;
            oppdata.Skip_Trigger__c=true;
            oppdata.StageName='Qualification';
            oppdata.CloseDate=mydate;
            insert oppdata;
            
            OpCo_Related_Contact__c OpCoData = new OpCo_Related_Contact__c();
            OpCoData.Email__c = 'test@gmail.com';
            OpCoData.Name = 'test';
            OpCoData.Source_Account__c = OpCoAccData.Id;
            OpCoData.Title__c = '123';
            insert OpCoData;
            
            Test.startTest();
            
            ContactBatchScheduler sh1 = new ContactBatchScheduler();
            String sch2 = '0 0 2 * * ?'; 
            system.schedule('Test Territory Check1', sch2, sh1);
            
            AccBatchScheduler sh3 = new AccBatchScheduler();
            String sch4 = '0 0 2 * * ?'; 
            system.schedule('Test Territory Check', sch4, sh3); 
            
             unsetSkipTrigger_Oppty sh4 = new unsetSkipTrigger_Oppty();
            String sch5 = '0 0 2 * * ?'; 
            system.schedule('Test Territory Check3', sch5, sh4);
            
                     unsetSkipTrigger_Contact sh7 = new unsetSkipTrigger_Contact();
            String sch6 = '0 0 2 * * ?'; 
            system.schedule('Test Territory Check4', sch6, sh7);   
            
            
            
            Danaher_LSIGContactBatch obj = new Danaher_LSIGContactBatch();
            DataBase.executeBatch(obj); 
            
            unsetSkipTrigger_Contact obj1 = new unsetSkipTrigger_Contact();
            DataBase.executeBatch(obj1);
            
            unsetSkipTrigger_Oppty obj2 = new unsetSkipTrigger_Oppty();
            DataBase.executeBatch(obj2);
            
            Test.stopTest();
        }
        
    }
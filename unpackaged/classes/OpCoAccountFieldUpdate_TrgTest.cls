@isTest
public class OpCoAccountFieldUpdate_TrgTest {
    @isTest
    public static void OpCoAccountFieldUpdate_Trg(){
        Account acc= new Account();
        acc.name = 'test';
        insert acc;
        
        date mydate = date.parse('12/27/2023');


        Opportunity oppdata = new Opportunity();
        oppdata.AccountId = acc.id;
        oppdata.Name = 'test1';
        oppdata.StageName = 'Qualification';
        oppdata.CloseDate = mydate;
        oppdata.OpCo_Stage__c='Type';
        insert oppdata;
        
        
        
        Mapping_Master__c mapMasterData = new Mapping_Master__c();
        mapMasterData.Object__c = 'Opportunity';
        mapMasterData.Source_Field__c = 'Type';
        mapMasterData.Source_OpCo__c = 'IDBS';
        mapMasterData.Source_Value__c='Type';
        mapMasterData.Destination_Value__c='Destination Value';
        mapMasterData.Destination_Field__c = 'Type';
        insert mapMasterData;
        
        OpCo_Account__c OpCo = new OpCo_Account__c();
        OpCo.Account__c = acc.Id;
        OpCo.Type__c = 'Type';
        OpCo.Source__c= 'IDBS';
        OpCo.Industry__c= 'Industry';
        insert OpCO;
        
       /* ID,Object__c,Source_Field__c,Source_OpCo__c,
     Source_Value__c,Destination_Field__c,Destination_Value__c */
            
        
            }
    
}
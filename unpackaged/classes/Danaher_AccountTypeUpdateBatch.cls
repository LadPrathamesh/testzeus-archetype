/*
* @Developer-Sudhir Dhawan
* @Company-Nanostuffs Technologies Private Limited
* @Description-
* @TestClass - Danaher_ContactCreationBatchTest
*/
global class Danaher_AccountTypeUpdateBatch implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        //Query to get Records
        system.debug('@@@Start');
        
        
        return Database.getQueryLocator([
            SELECT ID,Type__c,Industry__c,Source__c,Account__c  FROM opCo_Account__c where Account__c !=NULL
        ]);
    }
    
    //
    global Void execute (Database.BatchableContext BC, List<opCo_Account__c> lstOPCoAcc){
        // Method to update the Account with Industry__c,Type__c Field
        system.debug(lstOPCoAcc); 
        Danaher_AccUpdateBatchHandler.accUpdateHandler(lstOPCoAcc);
        
    }
    //
    global void finish(Database.BatchableContext BC){
        
    }
    
}
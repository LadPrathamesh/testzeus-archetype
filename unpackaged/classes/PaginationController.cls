public class PaginationController {
    
     @AuraEnabled
    public static AccountDataTableWrapper getAccountData(Id recordId,Integer pageNumber, Integer pageSize) {
         
        //Offset for SOQL
        Integer offset = (pageNumber - 1) * pageSize;
         
        //Total Records
        Integer totalRecords = [SELECT COUNT() FROM Account Where (ParentId = :recordId OR Parent.ParentId = :recordId OR Parent.Parent.ParentId = :recordId OR parent.parent.parent.parentId =: recordId OR parent.parent.parent.parent.parentId =: recordId OR Parent.parent.parent.parent.parent.parentId =: recordId)];
        Integer recordEnd = pageSize * pageNumber;
 
        //Instance of Contact DataTable Wrapper Class
        AccountDataTableWrapper objDT =  new AccountDataTableWrapper();  
        objDT.pageSize = pageSize;
        objDT.pageNumber = pageNumber;
        objDT.recordStart = offset + 1;
        objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
        objDT.totalRecords = totalRecords;
        objDT.AccountList = [SELECT Id, Name,ParentId, Parent.name,BillingPostalCode, BillingCity, BillingState, LastModifiedDate, AccountSource FROM Account Where (ParentId = :recordId OR Parent.ParentId = :recordId OR Parent.Parent.ParentId = :recordId OR parent.parent.parent.parentId =: recordId OR parent.parent.parent.parent.parentId =: recordId OR Parent.parent.parent.parent.parent.parentId =: recordId) ORDER BY Name LIMIT :pageSize OFFSET :offset];
        return objDT;
    }
     
    //Wrapper Class For Contact DataTable  
    public class AccountDataTableWrapper {
        @AuraEnabled
        public Integer pageSize {get;set;}
        @AuraEnabled
        public Integer pageNumber {get;set;}
        @AuraEnabled
        public Integer totalRecords {get;set;}
        @AuraEnabled
        public Integer recordStart {get;set;}
        @AuraEnabled
        public Integer recordEnd {get;set;}
        @AuraEnabled
        public List<Account> AccountList {get;set;}
    }

}
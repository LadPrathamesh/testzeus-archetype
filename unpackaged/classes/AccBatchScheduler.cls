global class AccBatchScheduler implements Schedulable{
	global void execute(SchedulableContext SC) {
        Danaher_AccountTypeUpdateBatch bth=new Danaher_AccountTypeUpdateBatch(); 
        Database.executeBatch(bth,100);
        String day = string.valueOf(system.now().day());
        String month = string.valueOf(system.now().month());
        String hour = string.valueOf(system.now().hour());
        String minute = string.valueOf(system.now().minute() + 10);
        String second = string.valueOf(system.now().second());
        String year = string.valueOf(system.now().year());
        
        String strJobName = 'Job-' + second + '_' + minute + '_' + hour + '_' + day + '_' + month + '_' + year;
        String strSchedule = '0 ' + minute + ' ' + hour + ' ' + day + ' ' + month + ' ?' + ' ' + year;
        
    } 
}
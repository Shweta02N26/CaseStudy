/*
 * This is schedular class for daily email sending notification batch class. 
 * This is written to allow scheduling of batch class via Scheduled Apex feature on daily basis.
 * Created By: Shweta Deshmukh
 * Schedualr for: SendDailyEmailsBatch
 */ 
global class SchduleDailyNotifications implements Schedulable {

   global void execute(SchedulableContext ctx) {
      SendDailyEmailsBatch sendDailyMailJob = new SendDailyEmailsBatch();
        database.executeBatch(sendDailyMailJob);
   }    
}
/*
* This class is scheduled to send email notification on daily basis once survey is sent.
* Created By: Shweta Deshmukh
* Created Date: 16/03/2019
* Test Class: SendDailyEmailsBatchTest
* % Coverage: 96%
*/
global class SendDailyEmailsBatch implements Database.Batchable<sObject>  {
    List<Contact> updateConList = new List<Contact>();
    // start method
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT ID, Language__c,
                                         FirstName, Email, Survey_Date__c
                                         FROM Contact 
                                         WHERE Survey_Date__c =: system.today() 
                                         and Email != null]);
    }
    
    // This method will send email notification and set survey date to null 
    global void execute(Database.BatchableContext BC, List<Contact> scope){
        
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        EmailTemplate et = [SELECT Id FROM EmailTemplate WHERE DeveloperName ='Survey_Notification'];
        for(Contact objCon : scope){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List<String> toAddresses = new List<String>();
            toAddresses.add(objCon.email);
            mail.setToAddresses(toAddresses);
            mail.setTargetObjectId(objCon.Id);
            mail.setTemplateId(et.Id);
            mail.setWhatId(objCon.Id);
            mail.setSaveAsActivity(false);
            objCon.Survey_Date__c = null;
            updateConList.add(objCon);
            mails.add(mail); 
            try{
                if(updateConList != null && !updateConList.isEmpty())
                {
                    update updateConList;
                }
            }
            catch(Exception e){
                system.debug('Update on contact record is failed due to::'+e.getMessage());
            }
        }
        
        try{
            if(mails != null && !mails.isEmpty())
                Messaging.SendEmailResult[] results = Messaging.sendEmail(mails);
        }Catch(Exception e)
        {
            system.debug('Failed to send notification because::'+e.getMessage());
        }
    }
    
    // finish method
    global void finish(Database.BatchableContext BC){        
    }
}
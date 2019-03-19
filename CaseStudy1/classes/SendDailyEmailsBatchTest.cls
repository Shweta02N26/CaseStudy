/*
 * This class is used to test the functionality of send email feature on contact object.
 * Test class for: SendDailyEmailsBatch
 * Created by: Shweta Deshmukh
 * % Coverage: 96%
 */
@isTest
public class SendDailyEmailsBatchTest {

    // Variable decalarations
    private static Account acc;
    private static Contact con;
    
    // Method used to set up data 
    @testSetup
    static void setUpData()
    {
        acc = new Account();
        acc.Name = 'N26 Customer';
        insert acc;
    }
    
    // This method will do positive scenarion testing
    static testMethod void testPositiveScenario()
    {
        Id accId = [Select Id from Account where name = 'N26 Customer'].id;
        con = [Select Id, firstname, language__c, Survey_Date__c from Contact where accountId =: accId];
        con.Survey_Date__c = System.today();
        con.Email = 'test@test.com';
        update con;
       
        // check survey date before batch execution
        system.assertEquals(System.today(), [Select survey_date__C from contact where email = 'test@test.com'].survey_date__c);
       
        // calling bacth class
        Test.startTest();
        SendDailyEmailsBatch objBacth = new SendDailyEmailsBatch();
        database.executeBatch(objBacth);
        Test.stopTest();
   
        // check survey date after batch execution
        system.assertEquals(null, [Select survey_date__C from contact where email = 'test@test.com'].survey_date__c);
    }
    
    // This method will do negative scenarion testing
    static testMethod void testNegativeScenario()
    {
        Id accId = [Select Id from Account where name = 'N26 Customer'].id;
        con = [Select Id, firstname, language__c, Survey_Date__c from Contact where accountId =: accId];
        con.Survey_Date__c = System.today() + 2;
        con.Email = 'test@test.com';
        update con;
        
        // check survey date before batch execution
        system.assertEquals(System.today()+2, [Select survey_date__C from contact where email = 'test@test.com'].survey_date__c);
       
        // calling batch class
        Test.startTest();
        SendDailyEmailsBatch objBacth = new SendDailyEmailsBatch();
        database.executeBatch(objBacth);
        Test.stopTest();
        
        // check survey date after batch execution
        system.assertEquals(System.today()+2, [Select survey_date__C from contact where email = 'test@test.com'].survey_date__c);
    }
    
    // This method is used to perform bulk testing
    static testMethod void testBulkScenario()
    {
        Id accId = [Select Id from Account where name = 'N26 Customer'].id;
        List<Contact> conList = new List<Contact>();
        Test.startTest();
        // Creating bulk contact records for testing
        for(integer i=0; i<=50; i++){
            con = new Contact();
            con.Email = 'test'+i+'@test.com';
            con.LastName = 'Testing'+ i;
            con.Survey_Date__c = System.today();
            con.Language__c = 'DE';
            con.AccountId = accId;
            conList.add(con);
        }
        insert conList;
        // calling batch class
        SendDailyEmailsBatch objBacth = new SendDailyEmailsBatch();
        database.executeBatch(objBacth);
        Test.stopTest();
    }
}
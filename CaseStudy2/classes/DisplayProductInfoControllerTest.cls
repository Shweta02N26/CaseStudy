/*
 * This class is used to test product information fetched based on contact present on case on case page layout.
 * Created By: Shweta Deshmukh
 * For a class: DisplayProductInfoController
 * % Coverage: 79%
 */ 
@isTest
public class DisplayProductInfoControllerTest {

    private static Contact con, con2;
    private static Case caseObj, caseObj2;
    private static List<Case> casesList;
    private static CountryIsoCodeMap__mdt map1;
    private static Product2 prod;
    private static List<PriceBookEntry> pbList;
    
    @testSetUp
    static void setUpData()
    {
        casesList = new List<Case>();
        
        map1 = [Select id, label, MasterLabel, ISOCode__c from CountryIsoCodeMap__mdt limit 1];
     
        //create another Product record
        Product2 prod1 = new Product2();
        prod1.Name = 'Metal';
        prod1.IsActive = True;
        insert prod1;
        
        Id pricebookId = Test.getStandardPricebookId();
                
        pbList = new List<PriceBookEntry>();
        //create PriceBookEntry records
        PriceBookEntry pbEntry1 = new PriceBookEntry();
        pbEntry1.UnitPrice = 0;
        pbEntry1.PriceBook2Id = pricebookId;
        pbEntry1.CurrencyIsoCode = 'EUR';
        pbEntry1.Product2Id = prod1.Id; 
        pbEntry1.IsActive = True;
        insert pbEntry1;
        
        // Create a custom price book
        Pricebook2 customPB = new Pricebook2(Name='Card Replacement Cost', 
                                             Description = 'Free',
                                             isActive=true);
        insert customPB;
        
        // Insert a price book entry with a custom price.
        PricebookEntry customPrice = new PricebookEntry(
            Pricebook2Id = customPB.Id, Product2Id = prod1.Id, CurrencyIsoCode = 'EUR',
            UnitPrice = 45.00, IsActive = true);
        insert customPrice;
        
        // create contact record
        con = new Contact();
        con.LastName = 'Test';
        con.Product__c = 'Metal';
        con.Home_Country__c = 'DE';
        insert con;
        
        con2 = new Contact();
        con2.LastName = 'Test2';
        con2.Product__c = 'Test';
        con2.Home_Country__c = 'DE';
        insert con2;
        // create case record and map assocaited contact with it
        caseObj = new Case();
        caseObj.Origin = 'Email';
        caseObj.ContactId = con.Id;
        caseObj.Subject = 'Get Prod Info';
        casesList.add(caseObj);
        
        // create case record with no contact on it to test negative scenario
        caseObj2 = new Case();
        caseObj2.Origin = 'Email';
        caseObj.ContactId = con2.Id;
        caseObj2.Subject = 'Get Prod Info2';
        casesList.add(caseObj2);
        
        insert casesList;
    }
    
    // To test positive scenario
    static testMethod void testPositiveScenario()
    {
        Test.startTest();
        Id caseId = [Select id from case where subject = 'Get Prod Info'].id;
        // call controller method to test functionality
        String countryName = DisplayProductInfoController.getCountry(caseId);
        String isoCode = DisplayProductInfoController.returnISOCode(countryName);
        pbList = DisplayProductInfoController.getProductDetails(caseId);
        Test.stopTest();
    }
    
    // To test negative scenario
    static testMethod void testNegativeScenario()
    {
        Test.startTest();
        Id caseId = [Select id from case where subject = 'Get Prod Info2'].id;
        // call controller method to test functionality
        pbList = DisplayProductInfoController.getProductDetails(caseId);
        system.assertEquals(0, pbList.size());
        Test.stopTest();
    }
}
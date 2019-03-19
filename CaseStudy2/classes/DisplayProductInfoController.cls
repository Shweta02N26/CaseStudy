/*
 * This class is used to fetch product information based on contact present on case on case page layout.
 * Created By: Shweta Deshmukh
 * Test class: DisplayProductInfoControllerTest
 * % Coverage: 79%
 */ 
public class DisplayProductInfoController {
   
    public static String countryName;
   
     // Get country name from contact record
       @AuraEnabled
       public static String getCountry(String recordId){
            Id contactId;
            if(String.isNotBlank(recordId))
              { 
                  contactId = [Select Id, ContactId 
                               From case
                               where Id =:recordId].ContactId;
              }
            
            // Get product name and home country details from contact record
            if(contactId != null){
               countryName = [Select Home_Country__c
                              From contact 
                              where id =: contactId].Home_Country__c;
            }
           
           return countryName;
       }
        
       // This method is used to fetch product details based on product and home country on contact.
        @AuraEnabled
        public static List<PricebookEntry> getProductDetails(String recordId){
            
            // To store product detail information such as factor affecting cost, cost, country
            List<PricebookEntry> infoList = new List<PricebookEntry>();
            String currencyIsoCode;
            // Map to store home country iso code and product name combination from contact record
            Map<String, String> prodCountryISOCodeMap = new Map<String, String>();
            
            // Get associated contact record id from case
            Id contactId;
            if(String.isNotBlank(recordId))
              { 
                  contactId = [Select Id, ContactId 
                               From case
                               where Id =:recordId].ContactId;
              }
            
            // Get product name and home country details from contact record
            if(contactId != null){
               for(Contact contactInfo : [Select id, Product__c, 
                                          Home_Country__c
                                          From contact 
                                          where id =: contactId])
                                        {
                                             countryName = contactInfo.Home_Country__c;
                                             currencyIsoCode = returnISOCode(countryName);
                                             prodCountryISOCodeMap.put(contactInfo.Product__c, currencyIsoCode);
                                        }
            }
            
            // Get product details
            if(prodCountryISOCodeMap != null && !prodCountryISOCodeMap.isEmpty()){
                for(PricebookEntry pbEntry : [SELECT Product2.Name, PriceBook2.Name, CurrencyISOCode, 
                                              UnitPrice, PriceBook2.Description from PricebookEntry 
                                              where Product2.Name In : prodCountryISOCodeMap.keySet()
 											 ])
                 {   
                      if(pbEntry.CurrencyISOCode == prodCountryISOCodeMap.get(pbEntry.Product2.Name)){
                         if(pbEntry.UnitPrice == -1)
                         {
                             pbEntry.PriceBook2.Description = 'Free';
                         }
                         else if(pbEntry.UnitPrice == -2)
                         {
                             pbEntry.PriceBook2.Description = 'N/a';
                         }
                         else
                         {
                             pbEntry.PriceBook2.Description = String.valueOf(pbEntry.UnitPrice);
                         }
                    	infoList.add(pbEntry);
                     }
                 }
            }
            return infoList;        
        }
    
       // Get iso code based on country on contact record
       public static string returnISOCode(String countryName)
       {
         String isoCode;
         return isoCode = [Select ISOCode__c from CountryIsoCodeMap__mdt where MasterLabel =:countryName].ISOCode__c;
       }
}
/**
* Data for testing online shop cosmetics.
*
* @author Irina Bogdanets
* @version 1.0
*/

@isTest
public class DataForProductTable {
    public static void createContact() {
        insert new Contact(
            email = 'irinabogdanets@gmail.com',
            firstName = 'Irina',
            lastName = 'Bogdanets'
        );
    }
    
    public static void createWarehouse() {
        insert new Warehouse__c(
            Name = 'Warehouse ' + String.valueOf(Date.today()) + ' ' +
                    String.valueOf(Date.today() + 5),
            Period_Start__c = Date.today(),
            Period_End__c = Date.today() + 5
        );
    }

    public static void createProduct() {
        insert new Product_Table__c(
            name = 'Lipstick',
            Added_Date__c = Date.today(),
            Unit_Price__c = 2,
            Units_Available__c = 10
        );
    }
    
}
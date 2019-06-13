@isTest
public class ContactCustomControllerTest {
    @testSetup
    public static void setup() {
        List<Contact> contactList = new List<Contact>();
        for (Integer i=0; i<20; i++) {
            Contact contact = new Contact(lastname = 'lastname'+i);
            contactList.add(contact);
        }
        insert contactList;
    }
    @isTest
    public static void checkController() {
        List<Contact> baseQuery = [SELECT Id, Name FROM Contact];
        System.assertEquals(20, baseQuery.size());
        
        Test.startTest();
        
        Test.setCurrentPage(Page.ContactCustomControllerPage);
        ApexPages.StandardSetController contactSetController = new ApexPages.StandardSetController(baseQuery);
        ContactCustomController ext = new ContactCustomController(contactSetController);
        SelectOption[] selOptions = ext.getPageSizeList();
        Integer numberPage = ext.pageNumber;
        ext.sorting();
        
        Test.stopTest();
        
        System.assertEquals('Name', ext.sortingColumn);
        System.assertEquals(5, selOptions.size());
        System.assertEquals(20, contactSetController.getPageSize());
        system.assertEquals(1, numberPage);
        System.assertEquals(2, ext.totalPages);
        System.assert(ext.getContacts() != null);
        System.assertEquals(' DESC NULLS LAST ', ext.sortingOrder);
    }    
}
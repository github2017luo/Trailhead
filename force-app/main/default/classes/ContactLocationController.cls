global class ContactLocationController {
    public List<Contact> contactList {get; set;}
    
    public ContactLocationController() {
        contactList = [SELECT Full_Name__c, MailingLatitude, MailingLongitude FROM Contact ORDER BY Full_Name__c];
    }
    
    @RemoteAction
    global static List<Contact> findAll() {
        return [SELECT Full_Name__c, MailingLatitude, MailingLongitude FROM Contact];
    }
}
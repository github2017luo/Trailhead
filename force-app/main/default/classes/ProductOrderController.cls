/**
* Online shop cosmetics.
*
* <P>Buying the selected product.
*
* @author Irina Bogdanets
* @version 1.0
*/

public class ProductOrderController {

    public String OrderNotCreated = Label.Order_not_created;
    public String NoPurchaseMade = Label.No_purchase_made;
    public String PurchaseMade = Label.Purchase_made;

    public Contact customer { get;set; }
    public Id productId { get;set; }
    public Product_Table__c product { get;set; }
    public Order_Table__c order { get;set; }

    public ProductOrderController() {
        customer = new Contact();
        order = new Order_Table__c();
        productId = ApexPages.currentPage().getParameters().get('id');
        product = [
            SELECT Id, Name, Unit_Price__c, Units_Available__c
            FROM Product_Table__c
            WHERE Id = :productId
            LIMIT 1
        ];
    }

    public void buyProduct() {
        findContact();
        createOrderTable();
        updateUnitAvailableInProductTable();
        clearForm();
    }

    public void findContact() {
        Contact contact;
        Boolean existingContact;
        try {
            contact = [
                SELECT Id, firstName, lastName, email
                FROM Contact
                WHERE email = :customer.Email
                LIMIT 1
            ];
        } catch (System.QueryException queryError) {
        }
        existingContact = (
            contact != null && (
                contact.FirstName!=customer.FirstName || contact.LastName!=customer.LastName
            )
        );
        if (contact == null) {
            insert customer;
        } else if (existingContact) {
            customer.Id = contact.Id;
            update customer;
        } else {
            customer = contact;
        }
    }

    public void createOrderTable() {
        order.Product__c = productId;
        order.Order_Amount__c = order.Units__c * product.Unit_Price__c;
        order.Contact__c = customer.Id;
        try {
            insert order;
        } catch(DmlException dmlError) {
            ApexPages.addmessage(
                new ApexPages.message(
                    ApexPages.severity.ERROR, OrderNotCreated
                )
            );
        }
    }

    public void updateUnitAvailableInProductTable() {
        Decimal currentUnitsAvailable = product.Units_Available__c;
        product.Units_Available__c -= order.Units__c;
        if (product.Units_Available__c < 0 ||
            currentUnitsAvailable - product.Units_Available__c == 0) {
                ApexPages.addMessage(
                    new ApexPages.Message(
                        ApexPages.Severity.ERROR, NoPurchaseMade
                    )
                );
            } else {
                update product;
                ApexPages.addMessage(
                    new ApexPages.Message(
                        ApexPages.Severity.CONFIRM, PurchaseMade
                    )
                );
            }
    }

    public void clearForm() {
        customer = new Contact();
        order = new Order_Table__c();
    }

}
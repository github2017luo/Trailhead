/**
* Online shop cosmetics.
*
* <P>Demonstrating products.
*
* @author Irina Bogdanets
* @version 1.0
*/

public class ProductTableController {
    public String Error_Server = Label.Error_Server;
    public Id productId {get; set;}

    public ApexPages.StandardSetController products {
        get {
                if (products == null) {
                    products = new ApexPages.StandardSetController(Database.getQueryLocator([
                        SELECT Id, Name, Image_url__c, Title__c, Product_Description__c, Unit_Price__c, Units_Available__c
                        FROM Product_Table__c
                        WHERE Units_Available__c > 0
                    ]));
                }
                return products;
        }
        set;
    }

    public List<Product_Table__c> getProductTables() {
        return (List<Product_Table__c>) products.getRecords();
    }

    public Pagereference goDetail() {
        PageReference requestPage = Page.ProductDetailPage;
        requestPage.getParameters().put('id', productId);
        requestPage.setRedirect(true);
        return requestPage;
    }

    public Pagereference goBuy() {
        PageReference requestPage = Page.ProductOrder;
        requestPage.getParameters().put('id', productId);
        requestPage.setRedirect(true);
        return requestPage;
    }

}
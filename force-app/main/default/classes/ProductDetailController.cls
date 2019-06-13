/**
* Online shop cosmetics.
*
* <P>Demonstrating product detail.
*
* @author Irina Bogdanets
* @version 1.0
*/

public class ProductDetailController {

    public Product_Table__c product;
    public ApexPages.StandardController controller;

    public ProductDetailController(ApexPages.StandardController stdController) {
        controller = stdController;
        product = (Product_Table__c) controller.getRecord();
    }

    public Pagereference goShopping() {
        PageReference requestPage = Page.ProductTableList;
        requestPage.setRedirect(true);
        return requestPage;
    }

    public Pagereference goBuy() {
        PageReference requestPage = Page.ProductOrder;
        requestPage.getParameters().put('id', product.Id);
        requestPage.setRedirect(true);
        return requestPage;
    }

}
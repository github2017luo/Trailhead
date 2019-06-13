/**
* Form showing contacts.
*
* <P> Use pagination.
* <P> Вynamic change in the number of records displayed.
* <P> Filtering records.
* <P> Global sorting by selected field.
*
* @author Bogdanets Irina
* @version 1.0
*/

public class ContactCustomController {
    
    private Integer DEFAULT_PAGE_SIZE = 10;
    private String DEFAULT_BASE_QUERY = 'SELECT Id, Name, Title, Account.Name, Phone, Email, MobilePhone, Owner.Name ' +
        'FROM Contact ';
    
    public String sortingColumn {
        get {
            if (sortingColumn == null || sortingColumn == '') {
                sortingColumn = 'Name';
            }
            return sortingColumn;
        }
        set;
    }
    public String sortingOrder =  ' ASC NULLS LAST ';
    public String baseQuery = DEFAULT_BASE_QUERY + 'ORDER BY ' + sortingColumn + sortingOrder;
    String searchText;
    public String getSearchText() {
        return searchText;
    }
    
    public void setSearchText(String s) {
        searchText = s;
    }
    
    // Вynamic change in the number of records displayed.
    public list<SelectOption> getPageSizeList() {
        list<SelectOption>  options = new list<SelectOption>();
        options.add(new selectOption('5','5'));
        options.add(new selectOption('10','10'));
        options.add(new selectOption('20','20'));
        options.add(new selectOption('50','50'));
        options.add(new selectOption('100','100'));
        return options;
    }
    public Integer pageSize {
        get; set {
            if (value != null) {
                this.pageSize = value;
            }
        }
    }
    public Integer pageNumber {
        get {
            this.pageNumber = ContactSetController.getPageNumber();
            return this.pageNumber;
        }
        set {
            ContactSetController.setPageNumber(value);
        }
    }
    public Integer totalPages {
        get {
            if (ContactSetController.getResultSize() <= DEFAULT_PAGE_SIZE) {
                this.totalPages = 1;
            }
            if (Math.Mod ( ContactSetController.getResultSize(),ContactSetController.getPageSize() ) == 0) {
                this.totalPages = ( contactSetController.getResultSize()/contactSetController.getPageSize() );
            } else {
                this.totalPages = ( contactSetController.getResultSize()/contactSetController.getPageSize() )+1;
            }
            return totalpages;
        }
        set;
    }
    public ContactCustomController(ApexPages.StandardSetController controller) {}
    
    public ApexPages.StandardSetController contactSetController {
        get {
            if(contactSetController == null) {
                contactSetController = new ApexPages.StandardSetController(Database.getQueryLocator(baseQuery));
                if (this.pageSize == null) {
                    pageSize = DEFAULT_PAGE_SIZE;
                }
            }
            contactSetController.setPageSize(pageSize);
            return contactSetController;
        } set;
    }
    public List<Contact> getContacts()
    {
        return (List<Contact>)contactSetController.getRecords();
    }
    
    // Global sorting by selected field.
    public void sorting() {
        sortingOrder = (sortingOrder == ' ASC NULLS LAST ') ? ' DESC NULLS LAST ' : ' ASC NULLS LAST ';
        baseQuery = DEFAULT_BASE_QUERY + 'ORDER BY ' + sortingColumn + sortingOrder;
        contactSetController = new ApexPages.StandardSetController(Database.getQueryLocator(baseQuery));
    }
    
    public void doSearch() { 
        if (searchText==null || searchText=='') {
            contactSetController = new ApexPages.StandardSetController(Database.getQueryLocator(baseQuery));
        } else {
            List<Contact> contactList = (List<Contact>)[FIND :searchText IN ALL FIELDS RETURNING Contact(Name, Title, Account.Name, Phone, Email, MobilePhone, Owner.Name)][0];
            contactSetController =  new ApexPages.StandardSetController(contactList);
        }  
    }
}
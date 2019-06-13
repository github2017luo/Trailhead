public class ContactsListController {
    public String sortingColumn = 'Name';
    public String sortingOrder = ' ASC ';
    public String column = sortingColumn;
    
    public String AccFilterId {get; set;}
    
    public String query = 'SELECT Id, Name, Title, Account.Name, Phone, Email, MobilePhone, Owner.Name ' +
        'FROM Contact ' + 'ORDER BY ' + sortingColumn + sortingOrder;
    
    public ApexPages.StandardSetController setList {
        get {
            if (setList == null) {
                setList = new ApexPages.StandardSetController(Database.query(query));
            }
            if (this.PageSize == null) {
                PageSize = 10; 
            } 
            setList.setPageSize(PageSize);
            return setList;
            
        } set;
    }
    
    public SelectOption[] getAccountExistingViews(){
        return setList.getListViewOptions();
    }
    
    public List<Contact> getContact() {
        return (List<Contact>) setList.getRecords();
    }
    // ---------- start sort ------------

    public void sortByName() {
        sortingColumn = 'Name';
        sortingOrder();
    }
    public void sortByTitle() {
        sortingColumn = 'Title';
        sortingOrder();
    }
    public void sortByAccountName() {
        sortingColumn = 'Account.Name';
        sortingOrder();
    }
    public void sortByPhone() {
        sortingColumn = 'Phone';
        sortingOrder();
    }
    public void sortByEmail() {
        sortingColumn = 'Email';
        sortingOrder();
    }
    public void sortByMobilePhone() {
        sortingColumn = 'MobilePhone';
        sortingOrder();
    }
    public void sortByOwnerName() {
        sortingColumn = 'Owner.Name';
        sortingOrder();
    }
    
    public void sortingOrder() {
        if (sortingColumn == column) {
            sortingOrder = (sortingOrder == ' ASC ') ? ' DESC ' : ' ASC ';
        } else {
            sortingOrder = ' ASC ';
            column = sortingColumn;
        }
        // получаем наш запрос с нужной нам сортировкой, аминь!
        query = 'SELECT Id, Name, Title, Account.Name, Phone, Email, MobilePhone, Owner.Name ' +
            'FROM Contact ' +
            'ORDER BY ' + sortingColumn + sortingOrder;
        
        // после сортировки ОБЯЗАТЕЛЬНО создается новый экземпляр контроллера с новыми значениями
        setList = new ApexPages.StandardSetController(Database.query(query));
    }
    
    // ---------- finish sort ------------
    // конец сортировки --------------------------------------
    
    // Пагинация начинается здесь ---------------------------------
    // Вначале делаем выпадающий список - количество записей на странице
    public list<SelectOption> getPageSizeList(){ // выпадающий список на странице
        list<SelectOption>  options = new list<SelectOption>();
        options.add(new selectOption('5','5'));
        options.add(new selectOption('10','10'));
        options.add(new selectOption('25','25'));
        options.add(new selectOption('50','50'));
        options.add(new selectOption('100','100'));
        return options;
    }
    
    public Integer PageSize {
        get; set { // Выбираем количество записей на странице
            if(value != null) this.PageSize = value;
        }
    }
    public Integer PageNumber {
        get { // получаем текущий номер страницы
            this.PageNumber = setList.getPageNumber();
            return this.PageNumber;
        }
        set { // это чтобы перейти к введенному номеру страницы
            setList.setPageNumber(value); //
        }
    }
    public Integer TotalPages { // Считаем количество страниц
        // это я скопировал у других, кто знает как это упростить пишите. это работает
        get {
            if (setList.getResultSize() <= 10)
                this.TotalPages = 1;
            if (Math.Mod ( setList.getResultSize(),setList.getPageSize() ) == 0)
                this.TotalPages = ( setList.getResultSize()/setList.getPageSize() );
            else this.TotalPages = ( setList.getResultSize()/setList.getPageSize() )+1;
            return totalpages;
        }
        set;
    }
    
    // Конец пагинации
    
    //---------------------- filter --------------------------
    
    public String filter {
        get; set {
            if (value == 'All Contacts') {
                setList = new ApexPages.StandardSetController(Database.query(query));
            }
            if (value == 'New Last Week') {
                filterByNewLastWeekContacts();
            }
            if (value == 'New Last Week') {
                filterByNewLastWeekContacts();
            }
            if (value == 'New This Week') {
                filterByNewThisWeekContacts();
            }
        }
    }
    
    public list<SelectOption> getListViewFilter(){ // выпадающий список на странице
        list<SelectOption>  filterList = new list<SelectOption>();
        filterList.add(new selectOption('All Contacts','All Contacts'));
        filterList.add(new selectOption('New Last Week','New Last Week'));
        filterList.add(new selectOption('New This Week','New This Week'));
        return filterList;
    }
    
    public void filterByAllContacts() {
        query = 'SELECT Id, Name, Title, Account.Name, Phone, Email, MobilePhone, Owner.Name ' +
        'FROM Contact ' + 'ORDER BY Name';
        setList = new ApexPages.StandardSetController(Database.query(query));
    }
    public void filterByMyContacts() {
        Id owner = UserInfo.getUserId();
        system.debug('id'+owner);
         query = 'SELECT Id, Name, Title, Account.Name, Phone, Email, MobilePhone, Owner.Name ' +
            'FROM Contact ' + 'WHERE OwnerId = ' + '\'' + owner + '\'';
        system.debug('query'+query);

        setList = new ApexPages.StandardSetController(Database.query(query));   
            system.debug('setlist'+setlist);
    }
    public void filterByNewLastWeekContacts() {
        String datee2 = String.valueOf(Date.today().toStartofWeek());
        String datee1 = String.valueOf(Date.today().toStartofWeek().addDays(-7));
        query = 'SELECT Id, Name, Title, Account.Name, Phone, Email, MobilePhone, Owner.Name ' +
            'FROM Contact ' + 'WHERE DAY_ONLY(CreatedDate) >= ' + datee1 + ' and DAY_ONLY(CreatedDate) <= ' + datee2 +
            ' ORDER BY Name';

        setList = new ApexPages.StandardSetController(Database.query(query));
    }
    public void filterByNewThisWeekContacts() {
        String datee = String.valueOf(Date.today().toStartofWeek());
        query = 'SELECT Id, Name, Title, Account.Name, Phone, Email, MobilePhone, Owner.Name ' +
            'FROM Contact ' + 'WHERE DAY_ONLY(CreatedDate) >= ' + datee +
            ' ORDER BY Name';

        setList = new ApexPages.StandardSetController(Database.query(query));
    }
}
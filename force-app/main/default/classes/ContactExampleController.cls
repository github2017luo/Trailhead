public class ContactExampleController {
	public String sortingColumn = 'Name'; // первичный столбец
public String sortingOrder = ' ASC '; // первичная сортировка
public String column = sortingColumn; // первичное значение нового столбца
 
public String query = 'SELECT Id, Name, Email, AccountId, OwnerId, CreatedById, CreatedDate ' +
                      'FROM Contact ' +
                      'ORDER BY ' + sortingColumn + sortingOrder;
 

// Сортировка начинается здесь ---------------------------------------
// вначале пишем методы которые будут вызываться командой со стринички
public void sortByName() {
	sortingColumn = 'Name';
	sortingOrder();
}
public void sortByEmail() {
	sortingColumn = 'Email';
	sortingOrder();
}
public void sortByAccountId() {
	sortingColumn = 'AccountId';
	sortingOrder();
}
public void sortByOwnerId() {
	sortingColumn = 'OwnerId';
	sortingOrder();
}
public void sortByCreatedById() {
	sortingColumn = 'CreatedById';
	sortingOrder();
}
public void sortByCreatedDate() {
	sortingColumn = 'CreatedDate';
	sortingOrder();
}
 
// проверяем- новый столбец или тот же
// если столбец новый сортировка - ASC и обновляется запрос.
public void sortingOrder() {
	if (sortingColumn == column) {
		sortingOrder = (sortingOrder == ' ASC ') ? ' DESC ' : ' ASC ';
	} else {
		sortingOrder = ' ASC ';
		column = sortingColumn;
	}
	// получаем наш запрос с нужной нам сортировкой, аминь!
	query = 'SELECT Id, Name, Email, AccountId, OwnerId, CreatedById, CreatedDate ' +
	        'FROM Contact ' +
	        'ORDER BY ' + sortingColumn + sortingOrder;
 
	// после сортировки ОБЯЗАТЕЛЬНО создается новый экземпляр контроллера с новыми значениями
	setList = new ApexPages.StandardSetController(Database.query(query));
}
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
public ApexPages.StandardSetController setList {
	get {
		if (setList == null) { // проверка на наличие экземпляра контроллера
			setList = new ApexPages.StandardSetController(Database.query(query));
		}
		if (this.PageSize == null) PageSize = 10; // дефаултное значение записей/стр, попробуй 7 или 8 =)
		setList.setPageSize(PageSize); // количество записей/страница
		return setList;
	} set;
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
public List<Contact> getContact() {
	return (List<Contact>) setList.getRecords();
}
// Конец пагинации
}
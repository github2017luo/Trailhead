public class ProductTableTriggerHandler {
    public static List<Date> checkProductList(List<Product_Table__c> products) {
        List<Date> dates = new List<Date>();
        for (Product_Table__c product : products) {
            if (product.Added_Date__c == null) {
                product.Added_Date__c = Date.today();
            }
            dates.add(product.Added_Date__c);
        }
        dates.sort();
        return dates;
    }
    public static List<Warehouse__c> findRightWarehouse(List<Date> dates) {
        Date maxDate = dates.get(dates.size() - 1);
        Date minDate = dates.get(0);
        List<Warehouse__c> warehouses = [SELECT Id, Period_Start__c, Period_End__c 
                                         FROM Warehouse__c WHERE Period_Start__c <=: maxDate 
                                         AND Period_End__c >=: minDate];
        return warehouses;
    }
    public static void updateRecords(List<Product_Table__c> productTableList) {
        OrgConfiguration__c periodTerm = OrgConfiguration__c.getInstance();
        Map<Product_Table__c, Warehouse__c> productWithWarehouse = new Map<Product_Table__c, Warehouse__c>();
        List<Product_Table__c> productTableNotWarehouseIdList = new List<Product_Table__c>();
        List<Warehouse__c> newWarehouseToInsertList = new List<Warehouse__c>();
        
        List<Date> dateList = checkProductList(productTableList);
		List<Warehouse__c> warehouseList = findRightWarehouse(dateList);
        
        for (Product_Table__c productTable : productTableList) {
            Boolean warehouseFlag = true;
            for (Warehouse__c warehouse : warehouseList) {
                if (productTable.Added_Date__c >= warehouse.Period_Start__c && 
                    productTable.Added_Date__c <= warehouse.Period_End__c) {
                        productTable.Warehouse__c = warehouse.Id;
                        warehouseFlag = false;
                        break;
                    }
            }
            if (warehouseFlag) {
                Warehouse__c warehouse = new Warehouse__c(
                    Name = 'Warehouse ' + String.valueOf(productTable.Added_Date__c) + ' ' + 
                    String.valueOf(productTable.Added_Date__c + Integer.valueOf(periodTerm.Period_Term__c)),
                    Period_Start__c = productTable.Added_Date__c,
                    Period_End__c = productTable.Added_Date__c + Integer.valueOf(periodTerm.Period_Term__c)
                );
                warehouseList.add(warehouse);
                newWarehouseToInsertList.add(warehouse);
                productWithWarehouse.put(productTable, warehouse);
            }
        }
        try {
            insert newWarehouseToInsertList;
        } catch (DmlException dmlError) {
            dmlError.getMessage();
        }
        for (Product_Table__c productTable : productWithWarehouse.keySet()) {
            productTable.Warehouse__c = productWithWarehouse.get(productTable).Id;
        }    
    }
}
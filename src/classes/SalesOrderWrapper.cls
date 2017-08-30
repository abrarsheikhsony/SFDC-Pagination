/*----------------------------------------------------------------------
Name: 		SalesOrderWrapper.cls
Purpose: 	A wrapper class of a custom object "SalesOrder__c"
------------------------------History----------------------------------
Version 	Author 		Date 				Detail Description 
-------		-------		-------------- 		------------------
1.0 		Abrar 		30-August-2017		Initial Development	
----------------------------------------------------------------------*/
public with sharing class SalesOrderWrapper implements Comparable{

    // Fields (Attributes) of SalesOrder__c Wrapper
    public Boolean isSelected {get; set;}
    public SalesOrder__c salesOrderRecord {get; set;}

    public SalesOrderWrapper(){           
        // Initialize the values
        isSelected = false;
        salesOrderRecord = new SalesOrder__c();
    }

	// Sort SalesOrder__c records	
    public Integer compareTo(Object compareTo){
        SalesOrderWrapper salesOrderWrapperRecord = (SalesOrderWrapper) compareTo;
        String salesOrderFieldToSort = (salesOrderRecord == null) ? null : salesOrderRecord.Name;
        String salesOrderWrapperToSort = (salesOrderWrapperRecord == null || salesOrderWrapperRecord.salesOrderRecord == null) ? null : salesOrderWrapperRecord.salesOrderRecord.Name;
        return salesOrderFieldToSort.compareTo(salesOrderWrapperToSort);
    }

}
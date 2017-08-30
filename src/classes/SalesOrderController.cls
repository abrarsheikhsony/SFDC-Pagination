/*----------------------------------------------------------------------
Name: 		SalesOrderController.cls
Purpose: 	A controller class of a custom object "SalesOrder__c" and a Visualforce page "SalesOrderPagination".
            (1) This page shows "SalesOrder__c" records associated to an Account record using a Field Set fields and Dynamic query.
            (2) The page will have a functionality to select one "or" more "SalesOrder__c" records to perform Update/Delete operation.
            (3) In order to achieve above functionality the page uses a wrapper class "SalesOrderWrapper".
            (4) The page has Pagination functionality with buttons "First", "Previous", "Next", "Last".
            (5) A page show maximum 25 records at a time. You can change this setting in "PaginationUtility" class by using a custom setting etc.
            (6) The page tracks the Selected/UnSelected SalesOrder__c record(s) with Pagination.

            >>> ApexPages.StandardSetController features:
            (1) Uses "StandardSetController" built-in pagination functionality in list controllers to prevent list views from displaying unbounded data.
            (2) Unbounded data might cause longer load times, hit governor limits, and become unusable as the data set grows.
            (3) By default, a list controller returns 20 records on the page, but developers often configure list views to display up to 100 records at a time.
            (4) To control the number of records each page displays, uses a "setPageSize" property of ApexPages.StandardSetController.
------------------------------History----------------------------------
Version 	Author 		Date 				Detail Description 
-------		-------		-------------- 		------------------
1.0 		Abrar 		30-August-2017		Initial Development	
----------------------------------------------------------------------*/
public with sharing class SalesOrderController extends PaginationUtility{

	@TestVisible private Account accountRecord;

    @TestVisible private List<SalesOrder__c> lstSalesOrdersToProcess;

    // Map to keep tracking of Selected/UnSelected SalesOrder__c : Id > SalesOrderWrapper
    @TestVisible private Map<Id, SalesOrderWrapper> mapSelectedDeselectedSalesOrders;

    // Contains list of SalesOrder__c Wrapper records
    public List<SalesOrderWrapper> lstSalesOrderWrapper{
        get{
            if(lstSalesOrderWrapper == null){
                lstSalesOrderWrapper = new List<SalesOrderWrapper>();
            }
            return lstSalesOrderWrapper;
        }
        set;
    }

	public SalesOrderController(ApexPages.StandardController stdController){
		accountRecord = (Account)stdController.getRecord();
		lstSalesOrdersToProcess = new List<SalesOrder__c>();
		mapSelectedDeselectedSalesOrders = new Map<Id, SalesOrderWrapper>();

		showSalesOrders();
	}

	/*----------------------------------------------------------------------
	Purpose: 	(1) Query SalesOrder__c records associated to an Account record.
                (2) Use "ApexPages.StandardSetController" built-in pagination functionality to show those record(s).
                (3) Track Selected and Unselected SalesOrder__c records
	Parameters: None
	Returns:	None
	------------------------------History----------------------------------
	Version 	Author 		Date 				Detail Description 
	-------		-------		-------------- 		------------------
	1.0 		Abrar 		30-August-2017		Initial Development
	----------------------------------------------------------------------*/
    @TestVisible
    private void showSalesOrders(){
        try{
			lstSalesOrdersToProcess = querySalesOrders();

			paginationStandardSetController = new ApexPages.StandardSetController(lstSalesOrdersToProcess);
			paginationStandardSetController.setPageSize(recordsPerPage);            

			// Keep Track of Selected and Unselected SalesOrders
			trackSelectedDeselectedSalesOrders();

            getSalesOrders();
        }        
        catch(System.Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
        }                 
    }

	/*----------------------------------------------------------------------
	Purpose:    (1) Use "ApexPages.StandardSetController" built-in pagination functionality to show those record(s).
                (2) Track Selected and Unselected SalesOrder__c records
	Parameters: None
	Returns:	None
	------------------------------History----------------------------------
	Version 	Author 		Date 				Detail Description 
	-------		-------		-------------- 		------------------
	1.0 		Abrar 		30-August-2017		Initial Development
	----------------------------------------------------------------------*/
    public List<SalesOrderWrapper> getSalesOrders(){
        lstSalesOrderWrapper = new List<SalesOrderWrapper>();
        
        // Keep Track of Selected and Unselected SalesOrders
        trackSelectedDeselectedSalesOrders();
                
        try{            
            if(lstSalesOrdersToProcess.size() > 0){
                lstSalesOrdersToProcess = (List<SalesOrder__c>)paginationStandardSetController.getRecords();                
                
                // Process SalesOrder__c records
                for(SalesOrder__c salesOrderRecord : lstSalesOrdersToProcess){
                    // Populate wrapper class of SalesOrder__c records
                    SalesOrderWrapper salesOrderWrapper = new SalesOrderWrapper();
                    salesOrderWrapper.salesOrderRecord = salesOrderRecord;                    

                    // Track of Selected and Unselected SalesOrder__c
                    if(mapSelectedDeselectedSalesOrders.containsKey(salesOrderRecord.Id)){
                        SalesOrderWrapper updatedSalesOrderWrapper = mapSelectedDeselectedSalesOrders.get(salesOrderRecord.Id);
                        salesOrderWrapper.isSelected = updatedSalesOrderWrapper.isSelected;
                    }
                    else{
                        salesOrderWrapper.isSelected = false;
                    }
                    
                    lstSalesOrderWrapper.add(salesOrderWrapper);
                }

                // Sort wrapper class list. This uses the compareTo method within the wrapper class
                lstSalesOrderWrapper.sort();
            }
        }        
        catch(System.Exception ex){
            ApexPages.addMessages(ex); 
        }

        return lstSalesOrderWrapper;
    }

    /*----------------------------------------------------------------------
    Purpose:    The "First" button functionality of ApexPages.StandardSetController
    Parameters: None
    Returns:    None
    ------------------------------History----------------------------------
    Version     Author      Date                Detail Description 
    -------     -------     --------------      ------------------
    1.0         Abrar       30-August-2017      Initial Development
    ----------------------------------------------------------------------*/
    public override void first() {
        if(lstSalesOrderWrapper.size() > 0){
            trackSelectedDeselectedSalesOrders();
        }    
        paginationStandardSetController.first();         
    }

    /*----------------------------------------------------------------------
    Purpose:    The "Previous" button functionality of ApexPages.StandardSetController
    Parameters: None
    Returns:    None
    ------------------------------History----------------------------------
    Version     Author      Date                Detail Description 
    -------     -------     --------------      ------------------
    1.0         Abrar       30-August-2017      Initial Development
    ----------------------------------------------------------------------*/
    public override void previous() {
        if(lstSalesOrderWrapper.size() > 0){
            trackSelectedDeselectedSalesOrders();
        }
        paginationStandardSetController.previous();
    }

    /*----------------------------------------------------------------------
    Purpose:    The "Next" button functionality of ApexPages.StandardSetController
    Parameters: None
    Returns:    None
    ------------------------------History----------------------------------
    Version     Author      Date                Detail Description 
    -------     -------     --------------      ------------------
    1.0         Abrar       30-August-2017      Initial Development
    ----------------------------------------------------------------------*/
    public override void next() {
        if(lstSalesOrderWrapper.size() > 0){
            trackSelectedDeselectedSalesOrders();
        }
        paginationStandardSetController.next();
    }

    /*----------------------------------------------------------------------
    Purpose:    The "Last" button functionality of ApexPages.StandardSetController
    Parameters: None
    Returns:    None
    ------------------------------History----------------------------------
    Version     Author      Date                Detail Description 
    -------     -------     --------------      ------------------
    1.0         Abrar       30-August-2017      Initial Development
    ----------------------------------------------------------------------*/
    public override void last() {
        if(lstSalesOrderWrapper.size() > 0){
            trackSelectedDeselectedSalesOrders();
        }
        paginationStandardSetController.last();
    }

    /*----------------------------------------------------------------------
    Purpose:    Perform Update/Delete operation on Selected SalesOrder__c records
    Parameters: None
    Returns:    None
    ------------------------------History----------------------------------
    Version     Author      Date                Detail Description 
    -------     -------     --------------      ------------------
    1.0         Abrar       30-August-2017      Initial Development
    ----------------------------------------------------------------------*/
    public PageReference updateSalesOrders(){
        SalesOrderWrapper updatedSalesOrderWrapper = new SalesOrderWrapper();
        List<SalesOrder__c> lstSalesOrdersToUpdate = new List<SalesOrder__c>();        

        trackSelectedDeselectedSalesOrders();

        for(Id salesOrderId : mapSelectedDeselectedSalesOrders.keySet()){
            updatedSalesOrderWrapper = mapSelectedDeselectedSalesOrders.get(salesOrderId);
            // Get ONLY selected SalesOrder__c records
            if( updatedSalesOrderWrapper.isSelected ){
                // Do processing (e.g. map fields etc.)
                SalesOrder__c salesOrderToUpdate = new SalesOrder__c(Id = salesOrderId);
                    salesOrderToUpdate.SalesQuantity__c = 50;
                    salesOrderToUpdate.SalesAmount__c = 50;
                lstSalesOrdersToUpdate.add(salesOrderToUpdate);
            }
        }

        // Perform DML (Insert/Update/Delete) here on selected SalesOrder__c records
        update lstSalesOrdersToUpdate;

        // Re-load the list of SalesOrder__c
        for(SalesOrderWrapper salesOrderWrapper : lstSalesOrderWrapper){
            if(salesOrderWrapper.isSelected){
                salesOrderWrapper.isSelected = false;
            }
        }
        showSalesOrders();

        /* Redirect the user to the detail page of Account
        PageReference detailPage = new PageReference('/'+accountRecord.Id);
        detailPage.setRedirect(true);
        return detailPage;
        */
        return null;
    }

	/*----------------------------------------------------------------------
	Purpose: 	Track Selected/De-selected SalesOrder__c records
	Parameters: None
	Returns:	None
	------------------------------History----------------------------------
	Version 	Author 		Date 				Detail Description 
	-------		-------		-------------- 		------------------
	1.0 		Abrar 		30-August-2017		Initial Development
	----------------------------------------------------------------------*/
    @TestVisible
    private void trackSelectedDeselectedSalesOrders(){
        for(SalesOrderWrapper salesOrderWrapper : lstSalesOrderWrapper){
            mapSelectedDeselectedSalesOrders.put(salesOrderWrapper.salesOrderRecord.Id, salesOrderWrapper);
        }
    }

	/*----------------------------------------------------------------------
	Purpose: 	Query SalesOrder__c records using a Field Set fields and Dynamic query
	Parameters: None
	Returns:	None
	------------------------------History----------------------------------
	Version 	Author 		Date 				Detail Description 
	-------		-------		-------------- 		------------------
	1.0 		Abrar 		30-August-2017		Initial Development
	----------------------------------------------------------------------*/
    @TestVisible
    private List<SalesOrder__c> querySalesOrders(){
    	String accountRecordId = accountRecord.Id;
        String soql = '';
        List<SalesOrder__c> lstSalesOrders = new List<SalesOrder__c>();

        try{
			soql = 'SELECT ';

			for(Schema.FieldSetMember field : SObjectType.SalesOrder__c.FieldSets.SalesOrderPaginationFieldSet.getFields()) {
				soql += field.getFieldPath() + ', ';
			}

            soql += 'Id FROM SalesOrder__c WHERE Customer__c = :accountRecordId Order By Name';                
            lstSalesOrders = Database.query(soql);
        }
        catch(System.Exception ex){
            
        }
        return lstSalesOrders;
    }

}
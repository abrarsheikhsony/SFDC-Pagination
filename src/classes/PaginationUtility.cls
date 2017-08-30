/*----------------------------------------------------------------------
Name: 		PaginationUtility.cls
Purpose: 	A utility class using StandardSetController built-in Pagination functionality
------------------------------History----------------------------------
Version 	Author 		Date 				Detail Description 
-------		-------		-------------- 		------------------
1.0 		Abrar 		30-August-2017		Initial Development	
----------------------------------------------------------------------*/
public with sharing virtual class PaginationUtility{

	// Total number of records to show on page
	public Integer totalNumberOfRecords{
		get{
			totalNumberOfRecords = 0;
			return recordsPerPage;
		}
		set;
	}

    // Number of Records to show on per page
    public Integer recordsPerPage{
        get {
			recordsPerPage = ApplicationConstant.RECORDS_PER_PAGE;
			/* Note: If you want to store this constant in a custom setting
            //get from custom setting and default to 25 if not in setting
            Application_Setting__c applicationCustomSetting = Application_Setting__c.getInstance();
            if(applicationCustomSetting <> null){
                // Get from Custom Setting
                if(applicationCustomSetting.Records_Per_Page__c <> null){
                    recordsPerPage = Integer.ValueOf(applicationCustomSetting.Records_Per_Page__c);
                }
                // Get from ApplicationConstant class if it is not available in custom setting
                else{
                	recordsPerPage = ApplicationConstant.RECORDS_PER_PAGE;
                }
            }
            */
            return recordsPerPage;
        }
        private set;
    }
    
    // Constructor without parameters
    public PaginationUtility(){
    }

    // Standard Set Controller for pagination
    public ApexPages.StandardSetController paginationStandardSetController {get; set;}

    // Check whether there are more records after the current page set.
    public Boolean hasNext{
        get {
            if(paginationStandardSetController !=null)
                return paginationStandardSetController.getHasNext();
            else
                return false;
        }
        set;
    }

    // Check whether there are more records before the current page set.
    public Boolean hasPrevious{
        get {
            if(paginationStandardSetController !=null)
                return paginationStandardSetController.getHasPrevious();
            else
                return false;
        }
        set;
    }

    // Returns the page number of the current page set.
    public Integer pageNumber{
        get {
            if(paginationStandardSetController !=null)
                return paginationStandardSetController.getPageNumber();
            else
                return 0;
        }
        set;
    }
    
    // Returns the total number of records in the set.
    public Integer totalRows{
        get{
            if(paginationStandardSetController !=null)
                return paginationStandardSetController.getResultSize();
            else 
                return 0;
        }
        set;
    }

    // Returns the number of records included in each page set.
    public integer pageSize{
        get{
            if(paginationStandardSetController !=null)
                return paginationStandardSetController.getPageSize();
            else 
                return 1;
        }
        set;
    }
         
    // total pages in the result set
    public integer totalPages{        
        get{
            if(paginationStandardSetController !=null){
                Decimal pgSizes = decimal.valueOf(totalRows) / decimal.valueOf(recordsPerPage);
                return Integer.ValueOf(pgSizes.round(System.RoundingMode.Ceiling));
            }
            else 
                return 1;
        }
        set;
    }

    // Returns the first page of records.
    public virtual void first(){
        paginationStandardSetController.first();         
    }

    // Returns the last page of records.
    public virtual void last(){
        paginationStandardSetController.last();
    }

    // Returns the previous page of records.
    public virtual void previous(){
        paginationStandardSetController.previous();
    }

    // Returns the next page of records.
    public virtual void next(){
        paginationStandardSetController.next();
    }

    // Returns the next page of records.
    public List<SObject> getRecords(){
        return paginationStandardSetController.getRecords();        
    }

}
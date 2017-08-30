# Visualforce Pagination using StandardSetController

There are 2 main approaches of using Pagination in Visualforce world.
1. StandardSetController Built-In Pagination
2. SOQL OFFSET Pagination

Please read in detail about each of these here in <a href="https://developer.salesforce.com/docs/atlas.en-us.salesforce_visualforce_best_practices.meta/salesforce_visualforce_best_practices/vfbp_intro.htm">Visualforce Performance: Best Practices guide.</a>

Here you will find the most common and standard built-in pagination approach<a href="https://developer.salesforce.com/docs/atlas.en-us.pages.meta/pages/apex_pages_standardsetcontroller.htm"> "StandardSetController" </a>

A controller class of a custom object "SalesOrder__c" and a Visualforce page "SalesOrderPagination".
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


<img src="supportedimages/Image1.png" />
<img src="supportedimages/Image2.png" />
<img src="supportedimages/Image3.png" />
<img src="supportedimages/Image4.png" />
<img src="supportedimages/Image5.png" />

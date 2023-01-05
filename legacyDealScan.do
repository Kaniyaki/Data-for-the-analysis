clear all 
cd "C:\Users\konra\Dropbox\Project Module\Code"


global firmData "C:\Users\konra\Dropbox\Thesis\Firm level data"

global dealScanData "$firmData\DealScan2021\original data"
global dealScanLenderLinkPath "$firmData\DealsScanLenderLink"
global dealScanBorrowerLinkPath "$firmData\DealScan\DealScan DataSeb\Roberts DealScan - Computstat link"


*-------------------------------------
* 1/ match borrowers to compustat
*-------------------------------------

* Michael Roberts Dealscan-Compustat Link
import excel "$dealScanBorrowerLinkPath/ds_cs_link_April_2018_post.xlsx", clear sheet("link_data") firstrow

/*
* demonstration why one should not match on boid 
gen nobs = 1 
collapse (sum) nobs , by(bcoid gvkey )
duplicates tag bcoid , gen(dup)
* end 
*/

keep facid gvkey
rename facid facilityid
save temp/roberts_link, replace
			
* DealScan Package 			
use "$dealScanData/package" , replace 
keep packageid borrowercompanyid dealactivedate dealamount

* DealScan Facility 
merge 1:m packageid using  "$dealScanData/facility", keepusing(maturity facilityid facilityamt loantype facility*date borrowercompanyid)
drop if _merge !=3
drop _merge 

* add borrower info 
gen companyid = borrowercompanyid  
merge m:1 companyid using "$dealScanData/company", keepusing(country state primarysiccode)
drop if _merge ==2
drop _merge 

* explain data
* Aggregate lending: what about "collapse (sum) dealamount" ?

* Add link 
merge m:1 facilityid using temp/roberts_link

* DONE: connection from DealScan to Compustat firms for each matched facility/deal
* why so many unmatched? 



*-------------------------------------
* 2/ match lenders to parent BHC
*-------------------------------------

* linktable provided by Michael Schwert 
import	excel "$dealScanLenderLinkPath/DealScan_Lender_Link.xlsx", sheet("Compustat") clear firstrow
drop if lcoid == .
todate  comp_start	, gen(start_ultpar) pattern(yyyymmdd) format(%d)
todate  comp_end	, gen(end_ultpar) 	pattern(yyyymmdd) format(%d)
replace		end_ultpar = mdy(12,31,2015) if year(end_ultpar) >= 2014 // assumption: 2014 links are valid until end of 2015
keep lcoid gvkey start_ultpar end_ultpar
ren	lcoid lenderid // = lenderid in Dealscan
save temp/bankcrosswalk, replace
	
	
	
* DealScan Package 			
use "$dealScanData/package" , replace 
keep packageid borrowercompanyid dealactivedate dealamount

* DealScan Facility 
merge 1:m packageid using  "$dealScanData/facility", keepusing(maturity facilityid facilityamt loantype facility*date borrowercompanyid)
drop if _merge !=3
drop _merge 

* Lender Shares 
merge 1:m facilityid using "$dealScanData/lendershares", keepusing(lenderrole leadarrangercredit lender companyid bankallocation)
rename companyid lenderid 
drop if _merge ==1
drop _merge 

* explain data
* Aggregate lending: what about "collapse (sum) facilityamt"?

* Sometimes we want to know how much all banks lent, sometimes we want to know the "key" bank

* Who is the most important lender? Several ways to try to find out
* Here is one: 
bys facilityid: gen totobs = _N 
gen leader = (totobs ==1)
replace	lenderrole = trim(lenderrole) 
replace leader = 1 if inlist(lenderrole,"Lead arranger","Joint arranger","Co-lead arranger","Co-arranger","Arranger","Admin agent","Agent")
replace leader = 1 if inlist(lenderrole,"Bookrunner","Coordinating arranger","Lead bank","Lead manager","Mandated Lead arranger","Mandated arranger")
keep if leader == 1		

bys facilityid: gen totleaders = _N 
tab totleaders // tricky...


* several ways to proceed depending on what we want to do.

merge 1:m lenderid using temp/bankcrosswalk
drop _merge 

merge m:1 lenderid using temp/bankcrosswalk

* d* it

joinby lenderid using temp/bankcrosswalk, unmatched(master)
tab _merge 

* now the hard work starts: something along those lines 
gen facstart_y = year(facilitystartdate)
gen	start_y = year(start_ultpar)
gen end_y	= year(end_ultpar)
gen	goodlink = (facstart_y >= start_y) & (facstart_y <= end_y)



*-------------------------------------
* 3/ over maturity 
*-------------------------------------

use "$dealScanData/facility", replace 
keep facilityid packageid facilitystartdate facilityenddate

keep if facilitystartdate!=. & facilityenddate!=. 
keep if facilityid < 100 // save energy  
expand 2
sort facilityid 
* look at dataset 
by facilityid: gen nobs = _n 
gen year_start = year(facilitystartdate)
gen year_end = year(facilityenddate)
gen date = year_start if nobs ==1
replace date = year_end if nobs ==2
drop if year_end==year_start & nobs ==2
xtset facilityid date 

keep facilityid packageid date 
tsfill

* and done!




# Data-for-the-analysis

There are two data sets which need to be merged: Compustat and
Dealscan.
Compustat contains information on US companies in terms
of their assets, liabilities, cash, etc.
Dealscan contains information about US banks and loans they provided
to companies. 
They do not have any common column to do the merge, so one has to 
use 2 linking tables:
1. WRDS_to_LoanConnector_IDs
2. Chava_and_Roberts_table

Steps:
1. Generate "Facility_ID" column in Dealscan data: by merging
WRDS_to_LoanConnector_IDs and Dealscan on "Tranche_ID" and
"Deal_ID" keep in mind that these colums are named "LPC Deal_ID"
and "LPC_Tranche_ID" in Dealscan).
2. Merge new Dealscan data (initial Dealscan containing
"Facility_ID" column) and Chava_and_Roberts_table: merge them on
Facility_ID in order to get "gvkey" column in Dealscan.
3. Now Dealscan and Compustat have a column in common - "gvkey". Merge them on this column. 
4. Done.
# Financial Covenants

## Background on the study
During the Great Recession, central banks realized that they had to act swiftly in order to try to stabilize the
economy.
As a result, new spending programs, created by Fed, were implemented: Primary Dealer Credit Facility, Commercial
Paper Funding Facility, Money Market, Mutual Funds Facility, Term Asset-Backed Securities Term Facility. 
They were targeted at providing more liquidity and were mainly helping banks navigate through tough times. 
When a new crisis came (covid-19), it did not have an as severe impact on credit supply as the Recession did,
partially because of its very nature. But more importantly, after the Recession, the Fed and government realized they
have to impose additional regulations (Dodd-Frank Act, Basel III, etc). Thus, most banks entered the pandemic with
stronger balance sheets and more lending capacity than in 07/08, which in turn prevented the severe reduction in loan
supply.

Based on experience from 07/08, the Fed was able to act more quickly. Programs first introduced in 07/08 were
again implemented. However, 3 new programs were created (for the purpose of further explanation, I roughly say three
as there are additional subgroups of them) as the previous ones were not sufficient to get things back in order. 
These programs were directed at companies, which was the first time the Fed did something like this. Two of these
programs went through banks, and one entailed the Fed's direct market participation. These are:
1. Primary Corporate Credit Facilities, Secondary Corporate Credit Facilities, etc. - purchase of corporate bonds,
where the Fed participates in both primary and secondary markets, thus enabling large firms to access market financing
(this was also enabled for state bonds, municipality bonds). This entailed the Fed's direct market participation.
2. Paycheck Protection Program Liquidity Facility - provision of PPP loans to companies that have less than 500
employees, and which can prove that they were affected by covid; loans were forgiven. This program was implemented
through banks.
3. Main Street Lending Facility - provision of loans for companies that had more than 500 employees (implying that
they were not candidates for PPP), but were too small to issue equity; here fed purchased 95% of the loan from banks;
was not forgiven. Just like the previous one, this program was also implemented through banks.

### Some specifics of programs
**PPP Program**:
A total of $800 bn of loans was issued, where almost all applications were approved. In total 743 banks participated.
The turnout was great (94% of eligible firms took part). However, after the implementation, research revealed that
only 23%-24% of loan funds actually went to employees, and the rest went to owners, shareholders, and suppliers. Due
to the lack of targeting, there was no differentiation among firms according to their needs. A large fraction of loans
went to companies that would have remained viable and retained their employees even without this loan. The requirement
was to maintain the number of employees and wage levels close to pre-crisis levels (Cho et al., 2022).

**MS Program**:
A total of $17.5 bn of loans was issued, with a duration of 5 years. There was a certain eligibility criterion imposed
on companies (they had to be in sound condition before covid-19) which stumbled upon media disapproval as not a lot of
companies were eligible. Lenders' benefit entailed risk sharing (banks took upon 5% of the risk), and benefits from
fees (both original fee on the full principal and annual servicing fee). The program did not have a turnout as
expected. A total of 316 banks sold their loans to the Fed (out of 643 registered for the program), and 327 did not
actively participate. After digging into the literature, I found research done with both lenders and borrowers that
tried to identify their reason for not taking a part in this program. As for the banks, the most reported reason was
that banks met borrower needs without an MS program.
The second reason was that PPP was sufficient to meet the borrower's needs. On the other hand, borrowers reported
certification and covenants as the number one reason for discouraging participation (Minoiu et al., 2021).

### Research question
We know that banks were not in such a bad condition as in the Great Recession. The Fed wanted to incentivize
banks to lend through risk sharing, but 643 banks registered (316 actually took part) out of 5242 banks, which
indicates low demand. 
The research question would be: *Did banks that participated in MS program impose stricter financial covenants than
non-participating ones?*

## Data
There are two data sets: Compustat and Dealscan (both publicly available) which help us study the covenants. 
Compustat contains quarterly data on US companies and their financial, market, and statistical information. Dealscan contains information on all US banks, their loans, and loan requirements. Dealscan data contains information on
financial covenants contained in loan contracts between banks and companies, which are the main subject of the study.

The goal is to match Dealscan and Compustat data, which in the beginning do not have any common variable to merge on.

However, there are two tables (both publicly available) which can help sort this out. They are: *WRDS to LoanConnector
ID* and *Chava & Roberts table*
 
Steps needed for the merging:
1. *WRDS to LoanConnector ID* - this table has 2 collumns which are also in Dealscan. Additionally, it has
"Facility_ID" column which we need in out Dealscan data (useful for additional merging later on).
So, we should merge *WRDS to LoanConnector ID* and *Dealscan* on "Tranche_ID" and "Deal_ID". 
Result: Dealscan data with additional column - Facility_ID.
2. *Chava & Roberts table* - this table contains "Facility_ID" (which now we also have in our Dealscan data), and we
merge it with *Dealscan* on "Facility_ID" to generate "gvkey" column. 
Result: Dealscan with "Facility_ID" and "gvkey".
3. Now, our 2 initial data frames have something in commom: both Dealscan and Compustat have "gvkey" column.
We merge them on this column. 

Now our data is ready for the analysis. 

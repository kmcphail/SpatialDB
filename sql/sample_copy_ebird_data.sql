-- This is a sample of the command structure to copy the TXT file downloaded from
--	eBird to the database. This assumes you ahve donloaded the .tar file to the same
--	system as the database and are using the command in PSQL

-- Use these commands to extract the text file from the tarball:
   -- tar xvf ebd_COUNTRYCODE_relMONTH-YEAR.tar
   -- gunzip ebd_COUNTRYCODE_relMONTH-YEAR.txt.gz


COPY "ebd"."ebird"  -- 'ebd' is our schema and 'ebird' is our table
    FROM E'/home/icfadmin/ebd_US/ebd_US_relFeb-2017.txt' -- include the path and file name
    HEADER -- indicate if there is a heard row
    CSV  -- even though it's a tab delimited, we specify CSV
    QUOTE E'\5' -- since single and double quotes can be used in text, 
    			--	we use a stange character as quotes to avoid mistakes
    DELIMITER E'\t' -- specify the tab (\t) as the DELIMITER
;

**Nashville Housing Data Cleansing in SQL**

The steps below are taken to clean the Nashville housing data in preparation for analysis:
1. Change the format of the "SaleDate" field ("convert")
2. Populate missing property addresses ("isnull" with self-join)
3. Split property and owner addresses so that street address, city and state have their own field ("substring," "charindex," "parsename," and "replace")
4. Standardize the "SoldAsVacant" field ("update" and "case")
5. Remove duplicates ("row_number" and "partition by")
6. Remove unneeded columns ("drop")

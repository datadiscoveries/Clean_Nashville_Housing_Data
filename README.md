**Nashville Housing Data Cleansing in SQL**

The script cleans data in the Excel file "Nashville Housing Data" in preparation for analysis in the following ways:
1. Changes the format of the "SaleDate" field ("convert")
2. Populates missing property addresses ("isnull" with self-join)
3. Splits property and owner addresses so that street address, city and state have their own field ("substring," "charindex," "parsename," and "replace")
4. Standardizes the "SoldAsVacant" field ("update" and "case")
5. Removes duplicates ("row_number" and "partition by")
6. Removes unneededfields ("drop")

**Nashville Housing Data Cleaning Project in SQL**

The SQL script "NashvilleHousing" cleans the data in the Excel file "Nashville Housing Data" in preparation for analysis. It does the following:
1. Changes the format of the "SaleDate" field ("convert" function)
2. Populates missing property addresses ("isnull" function with a self-join)
3. Splits out property and owner addresses so that street address, city and state are each in their own field ("substring," "charindex," "parsename," and "replace" functions)
4. Standardizes the "SoldAsVacant" field ("update" function with "case" command)
5. Removes duplicates ("row_number" function with "partition by" command)
6. Removes unused fields ("drop" command)

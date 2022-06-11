
--VIEW DATA
use Nashville

select * from Housing
order by UniqueID



-------------------------------------------------------------------------------------------------------------------------------------------------------------------------



--CHANGE SaleDate COLUMN FORMAT TO "DATE"
select SaleDate from Housing

--convert to date
select SaleDate, convert (date, SaleDate)
from Housing

update Housing
set SaleDate = convert (date, SaleDate)

--update date table with new converted sales date column
alter table Housing
add SaleDateConverted date

update Housing
set SaleDateConverted = convert (date, SaleDate)

--check that SaleDate format has been converted correctly
select SaleDateConverted from Housing



-------------------------------------------------------------------------------------------------------------------------------------------------------------------------



--POPULATE MISSING PROPERTY ADDRESS (if two records have the same ParcelID but one does not have an address, then populate the missing address from the other)

--use a self-join to create a column with the PropertyAddress for records where it is missing, taken from a duplicate ParcelID that has the address 
SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from Housing a
join Housing b on a.ParcelID = b.ParcelID and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null

--populate missing PropertyAddress 
update a
set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
from Housing a
join Housing b on a.ParcelID = b.ParcelID and a.UniqueID <> b.UniqueID



-------------------------------------------------------------------------------------------------------------------------------------------------------------------------



--SPLIT ADDRESS COLUMNS (address, city, state)

--using SUBSTRING, view *PropertyAddress* split into 2 separate columns: Street_Address and City
select
substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Property_Street_Address,
substring(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, len(PropertyAddress)) as Property_City
from Housing

--add these 2 new columns to the table 
alter table Housing
add Property_Street_Address Nvarchar(255)

update Housing
set Property_Street_Address = substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

alter table Housing
add Property_City Nvarchar(255)

update Housing
set Property_City = substring(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, len(PropertyAddress))

--check that the 2 new columns have been added correctly
select * from Housing

--using PARSENAME, view *OwnerAddress* split into 3 separate columnn: Street_Address, City & State
select
parsename(replace(OwnerAddress, ',', '.'), 3),
parsename(replace(OwnerAddress, ',', '.'), 2),
parsename(replace(OwnerAddress, ',', '.'), 1)
from Housing

--add these 3 new columns to the table 
alter table Housing
add OwnerSplitAddress Nvarchar(255)

update Housing
set OwnerSplitAddress = parsename(replace(OwnerAddress, ',', '.'), 3)

alter table Housing
add OwnerSplitCity Nvarchar(255)

update Housing
set OwnerSplitCity = parsename(replace(OwnerAddress, ',', '.'), 2)

alter table Housing
add OwnerSplitState Nvarchar(255)

update Housing
set OwnerSplitState = parsename(replace(OwnerAddress, ',', '.'), 1)

--check that the 3 new columns have been added correctly
select * from Housing


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------



--"SoldAsVacant" FIELD HAS INCONSISTENT RESPONSES (Yes, No, Y, N). CHANGE ALL Y & N TO Yes & No

--create column where Y & N are changed to Yes & No
select SoldAsVacant,
case when SoldAsVacant = 'Y' then 'Yes'
	 when SoldAsVacant = 'N' then 'No'
	 end
from Housing
where SoldAsVacant = 'Y' or SoldAsVacant = 'N'

--update the SoldAsVacant column
update Housing
set SoldAsVacant =
case when SoldAsVacant = 'Y' then 'Yes'
	 when SoldAsVacant = 'N' then 'No'
	 end

--confirm there are no more Y's and N's
select distinct(SoldAsVacant), Count(SoldAsVacant)
from Housing
group by SoldAsVacant
order by 2



-------------------------------------------------------------------------------------------------------------------------------------------------------------------------



--REMOVE DUPLICATES

--find duplicates (this creates a column "row_num" and assigns a value of 2+ for each duplicate record)
with RowNumCTE as (
select *,
	row_number() over (
	partition by ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
	order by uniqueID) row_num
from Housing)
select *
from RowNumCTE
where row_num > 1
order by PropertyAddress

--delete duplicates
with RowNumCTE as (
select *,
	row_number() over (
	partition by ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
	order by uniqueID) row_num
from Housing)
DELETE
from RowNumCTE
where row_num > 1



-------------------------------------------------------------------------------------------------------------------------------------------------------------------------



--DELETE UNUSED COLUMNS
alter table Housing
drop column OwnerAddress, TaxDistrict, PropertyAddress

alter table Housing
drop column SaleDate

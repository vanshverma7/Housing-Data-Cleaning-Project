-- Displaying all columns from the dataset.

select * from NashvilleHousing

------------------------------------------------------------------------------
-- Standardizing the format of the date

alter table NashvilleHousing add updated_date date -- creating a new column

begin transaction
	update NashvilleHousing 
	set updated_date = CAST(SaleDate as date)
commit --To save the changes 
-- rollback -> To undo the changes if something goes wrong

------------------------------------------------------------------------------
-- Populating the property address information

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress) updated from NashvilleHousing a
join NashvilleHousing b 
on a.ParcelID = b.ParcelID and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null 
--(Defining the structure where property address needs to be updated in the above querry)

begin transaction
update a
	set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
	from NashvilleHousing a
	join NashvilleHousing b 
	on a.ParcelID = b.ParcelID and a.[UniqueID ] <> b.[UniqueID ]
	where a.PropertyAddress is null
commit
--(updating the property address in the above querry)

------------------------------------------------------------------------------

--Splitting the Property address into separate columns (Address, City, State)

--(Identifying the address and city)
select PropertyAddress, 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) State
from NashvilleHousing

--(Creating a new column "Address")
alter table NashvilleHousing
add Address varchar(100)

--(Updating values in the newly created column "Address")
update NashvilleHousing
set Address = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1)

--(Creating a new column "City")
alter table NashvilleHousing
add City varchar(100)

--(Updating values in the newly created column "City")
update NashvilleHousing
set City = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))

------------------------------------------------------------------------------
--Splitting the owner address into separate columns (Address, City, State)

select OwnerAddress, 
PARSENAME(replace(OwnerAddress, ',', '.'), 3) Owner_Address, --(PARSENAME is used for seperating dot-separated object names. Starts from the end of the string)
PARSENAME(replace(OwnerAddress, ',', '.'), 2) Owner_City,    --(EG: "Hello.World" --> PARSENAME('Hello.World', 1). Result --> World
PARSENAME(replace(OwnerAddress, ',', '.'), 1) Owner_State    --(EG: "Hello.World" --> PARSENAME('Hello.World', 2). Result --> Hello)
from NashvilleHousing                                        -- Run the example using """Select parsename('Hello.World', 1)"""

alter table NashvilleHousing -- CREATING NEW COLUMN "Owner_Address"
add Owner_Address varchar(100)

update NashvilleHousing
set Owner_Address = PARSENAME(replace(OwnerAddress, ',', '.'), 3) -- UPDATING "Owner_Address"

alter table NashvilleHousing -- CREATING NEW COLUMN "Owner_City"
add Owner_city varchar(100)

update NashvilleHousing
set Owner_City = PARSENAME(replace(OwnerAddress, ',', '.'), 2) -- UPDATING "Owner_City"

alter table NashvilleHousing -- CREATING NEW COLUMN "Owner_State"
add Owner_State varchar(50)

update NashvilleHousing
set Owner_State = PARSENAME(replace(OwnerAddress, ',', '.'), 1) -- UPDATING "Owner_State"

------------------------------------------------------------------------------
-- Change Y and N to Yes and No in "Sold as Vacant" field

-- OPTION 1 -> Creating new column using CASE expressions
select SoldAsVacant,
case
	when SoldAsVacant = 'N' then 'No'
	when SoldAsVacant = 'Y' then 'Yes'
	else SoldAsVacant
end New_col
from NashvilleHousing

---	---	---	---

-- OPTION 2 -> Updating the existing column (METHOD 1)
select SoldAsVacant, COUNT(SoldAsVacant) from NashvilleHousing
group by SoldAsVacant --> Calculating the number of distinct elements in the column

begin transaction -- Updating "N" to "No"
	update NashvilleHousing
	Set SoldAsVacant = 'No'
	where SoldAsVacant = 'N'
--rollback (Verifying if the query is affecting the correct number of rows)
commit

begin transaction -- Updating "Y" to "Yes"
	update NashvilleHousing
	Set SoldAsVacant = 'Yes'
	where SoldAsVacant = 'Y'
--rollback (Verifying if the query is affecting the correct number of rows)
commit

-- OPTION 2 -> Updating the existing column (METHOD 2 -> Updating using CASE expressions)

update NashvilleHousing
set SoldAsVacant = case
						when SoldAsVacant = 'N' then 'No'
						when SoldAsVacant = 'Y' then 'Yes'
						else SoldAsVacant
				   end

------------------------------------------------------------------------------

-- Eliminating duplicate rows

with cte as (
select *,
ROW_NUMBER() over (partition by ParcelID, LandUse, PropertyAddress, SaleDate,
SalePrice, LegalReference, SoldAsVacant order by UniqueID) cnt
from NashvilleHousing )

delete from cte
where cnt > 1

------------------------------------------------------------------------------

-- Deleting unnecessary columns

select * from NashvilleHousing

alter table NashvilleHousing
drop column PropertyAddress, SaleDate, OwnerAddress

-- PLEASE NOTE : Please note that the DELETE and DROP commands should be executed on views or duplicate tables.
-- It is not advisable to use these commands on the primary database.

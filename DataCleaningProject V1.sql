/*

Data cleaning Project

*/

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing

----------------------------------------------------------------
----Changing Dates format

SELECT SaleDate, CONVERT(Date, SaleDate)
FROM PortfolioProject.dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate= CONVERT(Date, SaleDate)

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

SELECT SaleDateConverted, CONVERT(Date, SaleDate)
FROM PortfolioProject.dbo.NashvilleHousing


--------------------------------------------------------------------
---Populate Property address data

SELECT PropertyAddress
FROM PortfolioProject.dbo.NashvilleHousing
WHERE PropertyAddress IS NULL

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing
WHERE PropertyAddress IS NULL


----------------------------------------------------------------
---Looking at everything with order by

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing
---WHERE PropertyAddress IS NULL
ORDER BY ParcelID 

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	 ON a.ParcelID = b.ParcelID
	 AND a.[UniqueID ] <> b.[UniqueID ]

---------------------------------------------------------
---Populating the columns with Null data.

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
FROM PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	 ON a.ParcelID = b.ParcelID
	 AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL


----Uing ISNULL command to populate the table
SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	 ON a.ParcelID = b.ParcelID
	 AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL


--------------------------------------------------------
---Updating the table to reflect the changes

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	 ON a.ParcelID = b.ParcelID
	 AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL



------------------------------------------------------------------------------
---Breaking out Address into individual columns (Address, city, State)

---This has a deliminator (,)
SELECT PropertyAddress
FROM PortfolioProject.dbo.NashvilleHousing


----This will leave a commma at the end of every address
SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)) AS Address
FROM PortfolioProject.dbo.NashvilleHousing

---Using the CHARINDEX to identify the number
SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)) AS Address,
	CHARINDEX(',', PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing

---To remove the comma at the end, add a '-1' to the command written
SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address
FROM PortfolioProject.dbo.NashvilleHousing


----Another one
SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address,
	SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) AS Address
FROM PortfolioProject.dbo.NashvilleHousing

---Creating New columns in the table to add the new columns.

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress NVARCHAR(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) 

ALTER TABLE NashvilleHousing
ADD PropertySplitcity NVARCHAR(255);

UPDATE NashvilleHousing
SET PropertySplitcity =SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))


---You can view the added columns at the end of the table
SELECT *
FROM PortfolioProject.dbo.NashvilleHousing


SELECT OwnerAddress
FROM PortfolioProject.dbo.NashvilleHousing


---using PARSENAME ON DELIMINATORS

---PARSENAME is only useful with periods
SELECT 
PARSENAME (ownerAddress, 1)
FROM PortfolioProject.dbo.NashvilleHousing

--to make it work
SELECT 
PARSENAME (REPLACE(ownerAddress, ',', '.'), 1)
FROM PortfolioProject.dbo.NashvilleHousing


---Adding other things (PARSENAME works backwards)
SELECT 
PARSENAME (REPLACE(ownerAddress, ',', '.'), 1),
PARSENAME (REPLACE(ownerAddress, ',', '.'), 2),
PARSENAME (REPLACE(ownerAddress, ',', '.'), 3)
FROM PortfolioProject.dbo.NashvilleHousing


----To make it go from the front
SELECT 
PARSENAME (REPLACE(ownerAddress, ',', '.'), 3),
PARSENAME (REPLACE(ownerAddress, ',', '.'), 2),
PARSENAME (REPLACE(ownerAddress, ',', '.'), 1)
FROM PortfolioProject.dbo.NashvilleHousing


---Nowing adding columns and values to the table (Table Update)

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress NVARCHAR(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME (REPLACE(ownerAddress, ',', '.'), 3)

ALTER TABLE NashvilleHousing
ADD OwnerSplitcity NVARCHAR(255);

UPDATE NashvilleHousing
SET OwnerSplitcity = PARSENAME (REPLACE(ownerAddress, ',', '.'), 2) 

ALTER TABLE NashvilleHousing
ADD OwnerSplitState NVARCHAR(255);

UPDATE NashvilleHousing
SET OwnerSplitState =PARSENAME (REPLACE(ownerAddress, ',', '.'), 1)

---Viewing the whole table again
SELECT *
FROM PortfolioProject.dbo.NashvilleHousing


------------------------------------------------------------------------------------
----CHANGE Y AND N TO YES AND NO IN 'SOLD AS VACANT' FIELD

SELECT DISTINCT(SoldAsVacant)
FROM PortfolioProject.dbo.NashvilleHousing

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM PortfolioProject.dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant,
	CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		 WHEN SoldAsVacant = 'N' THEN 'No'
		 ELSE SoldAsVacant
		 END
FROM PortfolioProject.dbo.NashvilleHousing

---Updating the table

UPDATE NashvilleHousing
SET SoldAsVacant = 	CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		 WHEN SoldAsVacant = 'N' THEN 'No'
		 ELSE SoldAsVacant
		 END


---REMOVE DUPLICATES

WITH RowNumCTE AS (
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

FROM PortfolioProject.dbo.NashvilleHousing
--ORDER BY ParcelID
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress

---TO DELETE
WITH RowNumCTE AS (
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

FROM PortfolioProject.dbo.NashvilleHousing
--ORDER BY ParcelID
)
DELETE ---just replace SELECT with DELETE
FROM RowNumCTE
WHERE row_num > 1
----ORDER BY PropertyAddress


----------------------------------------------------------------
---DELETE unused columns


SELECT *
FROM PortfolioProject.dbo.NashvilleHousing


---This will delete the selected cells.

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN SaleDate



----------------------------------------------
/*
ACTIONS TAKEN TO CLEAN THE DATA

1. Using CONVERT, I standardize the date format
2. Then Populated the PropertyAddress column
3. The broke the values into individual/Separated columns using substring, PARSENAME, charindex and replace
4. Change Y and N to YES and No using Key statements.
5. Removed duplicates using Row_NUM, CTE and windows of PARTITION_BY.
6. Then deleted few usless columns using ALTER and DROP.

*/
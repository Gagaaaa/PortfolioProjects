--CLEANING DATA IN SQL QUERIES

Select *
From PortfolioProject..NashvilleHousing

--STANDARDIZE SALES FORMAT

Select saleDateConverted, CONVERT(Date,SaleDate)
From PortfolioProject..NashvilleHousing

Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

--POPULATE PROPERTY ADDRESS DATA

Select *
From PortfolioProject..NashvilleHousing
--where PropertyAddress is null
order by ParcelID



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject..NashvilleHousing  a
JOIN PortfolioProject..NashvilleHousing  b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

--UPDATING A COLUMN TO REMOVE NULLS
Update a
SET propertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject..NashvilleHousing  a
JOIN PortfolioProject..NashvilleHousing  b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null



--SPLIT ADDRESS TO INDIVIDUAL COLUMNS, ADDRESS, CITY, STATE

Select PropertyAddress
From PortfolioProject..NashvilleHousing
--where PropertyAddress is null
--order by ParcelID

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress)) as Address

From PortfolioProject..NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress NvarChar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity NvarChar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress))

Select *
From PortfolioProject..NashvilleHousing



--SPLIT THE ADDRESS THREE WAYS

Select OwnerAddress
From PortfolioProject..NashvilleHousing



Select
Parsename(REPLACE(OwnerAddress, ',', '.'), 3)  Street
, Parsename(REPLACE(OwnerAddress, ',', '.'), 2)  City
, Parsename(REPLACE(OwnerAddress, ',', '.'), 1)  State
From PortfolioProject..NashvilleHousing



ALTER TABLE NashvilleHousing
Add OwnerSplitAddress NvarChar(255);

Update NashvilleHousing
SET OwnerSplitAddress = Parsename(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity NvarChar(255);

Update NashvilleHousing
SET OwnerSplitCity = Parsename(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState NvarChar(255);

Update NashvilleHousing
SET OwnerSplitState = Parsename(REPLACE(OwnerAddress, ',', '.'), 1)


Select *
From PortfolioProject..NashvilleHousing





--CHANGE Y AND N TO YES AND NO IN "SOLD VACANT" FIELD

Select SoldAsVacant
From PortfolioProject..NashvilleHousing


Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
From PortfolioProject..NashvilleHousing
Group by SoldAsVacant
order by 2


Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From PortfolioProject..NashvilleHousing


Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END





--REMOVE DUPLICATES


--FIND DUPLICATES WITH CTE

WITH RowNumCTE AS (
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY
					UniqueID
					)  row_num

From PortfolioProject..NashvilleHousing
--Order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress

Select *
From PortfolioProject..NashvilleHousing





--DELETE UNUSED COLUMNS


Select *
From PortfolioProject..NashvilleHousing

ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN SaleDate
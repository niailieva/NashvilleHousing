select * 
from NashvilleHousing.dbo.housing

select SaleDate, CONVERT(date, SaleDate)
from NashvilleHousing.dbo.housing

alter table NashvilleHousing.dbo.housing
add  SaleDateConverted Date;

update NashvilleHousing.dbo.housing
set SaleDateConverted = convert(date, SaleDate)

select SaleDateConverted
from NashvilleHousing.dbo.housing



select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing.dbo.housing a 
join NashvilleHousing.dbo.housing b 
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing.dbo.housing a 
join NashvilleHousing.dbo.housing b 
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null



select PropertyAddress
from NashvilleHousing.dbo.housing
--where PropertyAddress is null
--order by ParcelID

select 
substring(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1) as Address,
substring(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, len(PropertyAddress)) as Address
from NashvilleHousing.dbo.housing

alter table NashvilleHousing.dbo.housing
add PropertySplitAddress nvarchar(255);

update NashvilleHousing.dbo.housing
set PropertySplitAddress = substring(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1)

alter table NashvilleHousing.dbo.housing
add PropertySplitCity nvarchar(255);

update NashvilleHousing.dbo.housing
set PropertySplitCity = substring(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, len(PropertyAddress))

select * 
from NashvilleHousing.dbo.housing




select OwnerAddress
from NashvilleHousing.dbo.housing

select 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
from NashvilleHousing.dbo.housing

alter table NashvilleHousing.dbo.housing
add OwnerSplitAddress nvarchar(255);

update NashvilleHousing.dbo.housing
set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

alter table NashvilleHousing.dbo.housing
add OwnerSplitCity nvarchar(255);

update NashvilleHousing.dbo.housing
set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

alter table NashvilleHousing.dbo.housing
add OwnerSplitState nvarchar(255);

update NashvilleHousing.dbo.housing
set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

select * 
from NashvilleHousing.dbo.housing



select distinct(SoldAsVacant), count(SoldAsVacant)
from NashvilleHousing.dbo.housing
group by SoldAsVacant
order by 2

select SoldAsVacant
, case when SoldAsVacant = 'Y' then 'Yes'
       when SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant
	   end
from NashvilleHousing.dbo.housing

update NashvilleHousing.dbo.housing
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
       when SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant
	   end



with RowNumCTE as (
select *,
ROW_NUMBER() over(
partition by ParcelID, 
             PropertyAddress, 
			 SalePrice, 
			 SaleDate, 
			 LegalReference
order by UniqueID) row_num
from NashvilleHousing.dbo.housing)

select *  
from RowNumCTE
where row_num > 1
order by PropertyAddress

alter table NashvilleHousing.dbo.housing
drop column OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

select * 
from NashvilleHousing.dbo.housing

alter table NashvilleHousing.dbo.housing
drop column SaleDate

select * 
from NashvilleHousing.dbo.housing


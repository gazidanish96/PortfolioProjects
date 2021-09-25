/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
  FROM [PortfolioProject].[dbo].[NashvilleHousing]

  select * from PortfolioProject..NashvilleHousing

  select SaleDate, convert(date,SaleDate) from NashvilleHousing


update NashvilleHousing
set SaleDate=convert(date,SaleDate)

alter table NashvilleHousing
add SaleDateConverted Date;

update NashvilleHousing
set SaleDateConverted=convert(date,SaleDate)

select SaleDateConverted from NashvilleHousing

select propertyaddress from NashvilleHousing
where propertyaddress is null

select * from PortfolioProject..NashvilleHousing
where PropertyAddress is null

select * from NashvilleHousing
order by ParcelID

select* from NashvilleHousing a
join NashvilleHousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]


select a.ParcelID,b.ParcelID,a.PropertyAddress,b.PropertyAddress
from NashvilleHousing a
join NashvilleHousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

select a.ParcelID,b.ParcelID,a.PropertyAddress,b.PropertyAddress, 
	isnull(a.PropertyAddress,b.PropertyAddress) as NullNewAddress
from NashvilleHousing a
join NashvilleHousing b
	on a.ParcelID=b.ParcelID
	and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress=isnull(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
Join PortfolioProject..NashvilleHousing b
	on a.ParcelID=b.ParcelID
	and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

select PropertyAddress from NashvilleHousing

select 
substring(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)) as Address,
charindex(',',PropertyAddress)
from NashvilleHousing

select 
substring(PropertyAddress, 1, (CHARINDEX(',',PropertyAddress)-1)) as Address
from PortfolioProject..NashvilleHousing

select 
substring(PropertyAddress , charindex(',',PropertyAddress)+1 , len(PropertyAddress)) as Address
from PortfolioProject..NashvilleHousing

alter table NashvilleHousing 
add PropertySplitAddress nvarchar(255);
update NashvilleHousing
set PropertySplitAddress=substring(PropertyAddress,1,Charindex(',',PropertyAddress)-1)

alter table NashvilleHousing
add PropertySplitCity nvarchar (255)
update NashvilleHousing
set PropertySplitCity=substring(PropertyAddress,charindex(',',PropertyAddress)+1,len(PropertyAddress))

select * from PortfolioProject.dbo.NashvilleHousing

select owneraddress from PortfolioProject.dbo.NashvilleHousing

select parsename(replace(OwnerAddress,',','.'),1) as StateName
,parsename(replace(OwnerAddress,',','.'),2) as CityName
,parsename(replace(OwnerAddress,',','.'),3) as AddressField
From PortfolioProject.dbo.NashvilleHousing


select parsename(replace(OwnerAddress,',','.'),3) as AddressField
,parsename(replace(OwnerAddress,',','.'),2) as CityName
,parsename(replace(OwnerAddress,',','.'),1) as StateName
From PortfolioProject.dbo.NashvilleHousing


alter table PortfolioProject.dbo.NashvilleHousing 
add OwnerSplitAddress nvarchar(255);
update PortfolioProject.dbo.NashvilleHousing 
set OwnerSplitAddress=parsename(replace(OwnerAddress,',','.'),3)


alter table PortfolioProject.dbo.NashvilleHousing 
add OwnerSplitCity nvarchar (255)
update PortfolioProject.dbo.NashvilleHousing 
set OwnerSplitCity=parsename(replace(OwnerAddress,',','.'),2)


alter table PortfolioProject.dbo.NashvilleHousing 
add OwnerSplitState nvarchar (255)
update PortfolioProject.dbo.NashvilleHousing 
set OwnerSplitState=parsename(replace(OwnerAddress,',','.'),1)

select * from PortfolioProject.dbo.NashvilleHousing

select distinct(SoldAsVacant),count(SoldAsVacant)
from PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2


Select SoldAsVacant,
Case when SoldAsVacant= 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
Else SoldAsVacant
END
from PortfolioProject.dbo.NashvilleHousing

Update PortfolioProject.dbo.NashvilleHousing 
SET SoldAsVacant = Case when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
End 


with RownumCTE as(
select * ,
	ROW_NUMBER() over(
	Partition by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 Order by
					UniqueID
					) row_num
FROM PortfolioProject.dbo.NashvilleHousing
--Order by ParcelID
)
delete
from RownumCTE
where row_num > 1
--Order by PropertyAddress


select *
FROM PortfolioProject.dbo.NashvilleHousing

alter table PortfolioProject.dbo.NashvilleHousing
drop column OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

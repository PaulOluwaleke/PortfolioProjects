/*

Cleaning Data in SQL queries

*/

select *
from PortfolioProject..NashvilleHousing

--------------------------------------------------------------------------------------------------------

-- Standardize Date Format

select SaleDate, CONVERT(Date,SaleDate)
from PortfolioProject..NashvilleHousing


update NashvilleHousing
set SaleDate = CONVERT(Date,SaleDate)

-- If this does not work

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date;

update NashvilleHousing
set SaleDateConverted = CONVERT(Date,SaleDate)

select SaleDateConverted, CONVERT(Date,SaleDate)
from PortfolioProject..NashvilleHousing

-- Populate Property Address date

select *
from PortfolioProject..NashvilleHousing
--where PropertyAddress is null
order by ParcelID


SELECT a.PropertyAddress, a.ParcelID, b.PropertyAddress, b.ParcelID, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
     on a.ParcelID = b.ParcelID
	 AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
     on a.ParcelID = b.ParcelID
	 AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

-- can also write it as a string

update a
set PropertyAddress = ISNULL(a.PropertyAddress, 'No Address')
FROM PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
     on a.ParcelID = b.ParcelID
	 AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


--------------------------------------------------------------------------------------------------------
-- Breaking out Address into Individual columns (Address, City, States)


select PropertyAddress
from PortfolioProject..NashvilleHousing
--where PropertyAddress is null
--order by ParcelID

select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address

FROM PortfolioProject..NashvilleHousing





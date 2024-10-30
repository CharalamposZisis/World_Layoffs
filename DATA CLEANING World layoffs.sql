-- DATA CLEANING 

SELECT distinct industry,company,location
FROM layoffs
ORDER by industry ; 


-- 1. Remove Duplicates 
-- 2. Standardize Data
-- 3. Null values or blank values
-- 4. Remone any Columns 

CREATE TABLE layoffs_staging 
LIKE layoffs;

INSERT layoffs_staging
SELECT *
FROM layoffs;


-- 1.Remove Duplicates


SELECT *
FROM layoffs_staging 
;

SELECT company, industry, total_laid_off,`date`,
		ROW_NUMBER() OVER (
			PARTITION BY company, industry, total_laid_off,`date`) AS row_num
	FROM 
		layoffs_staging;
        
        
        
        
WITH duplicate_cte AS
(
SELECT * ,
ROW_NUMBER () OVER(
PARTITION BY company,location, 
industry, total_laid_off,`date`, stage, country, funds_raised) AS row_num
FROM layoffs_staging
)
DELETE 
FROM duplicate_cte
WHERE row_num >1;


CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` text,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised` text,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,location, 
industry, total_laid_off,`date`, stage, country, funds_raised) AS row_num
FROM layoffs_staging;

DELETE
FROM layoffs_staging2
WHERE row_num > 1;

SELECT *
FROM layoffs_staging2;


-- We don 't need anymore the row_num col
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;
-- 

-- Standardizing Data

-- I  noticed the Travel has multiple different variations. We need to standardize that - let's say all to Travel

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Tra%';

SELECT DISTINCT industry
FROM layoffs_staging2
order by 1;

UPDATE layoffs_staging2
SET industry = 'Travel'
WHERE industry LIKE 'Tra%';


-- we should set the blanks to nulls since those are typically easier to work with
SELECT *
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET 
    percentage_laid_off = NULL
    WHERE percentage_laid_off = '';
    
    
-- Delete Useless data we can't really use
DELETE FROM layoffs_staging2
WHERE location IS NULL
AND industry IS NULL;


SELECT *
from layoffs_staging2;
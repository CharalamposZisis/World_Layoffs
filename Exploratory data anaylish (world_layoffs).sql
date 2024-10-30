-- Exploratory Data Analysis

-- https://www.kaggle.com/datasets/swaptr/layoffs-2022

SELECT *
FROM layoffs_staging2;

--

-- I AM LOOKING AT PERCENTAGE TO SEE HOW BIG ARE THESE LAYOFFS 

SELECT MAX(percentage_laid_off),  MIN(percentage_laid_off)
FROM layoffs_staging2;

-- which companies had 1 so 100% of the staff laid off
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off=1;


-- if we order by funcs_raised_millions we can see how big some of these companies were
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1 
ORDER BY funds_raised DESC;

-- Companies with the biggest single Layoff
SELECT company, total_laid_off
FROM layoffs_staging2
ORDER BY 2 DESC
LIMIT 5;
-- THE ABOVE IS FOR A SINGLE DAY

-- Companies with the most Total Layoffs (THE FIRST 10)
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC
LIMIT 10;

-- Locations with the most Total Layoffs (THE FIRST 10)
SELECT location, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY location
ORDER BY 2 DESC
LIMIT 10;

-- This it Total Laid offs in the dataset

SELECT sum(total_laid_off), country
FROM layoffs_staging2
GROUP by COUNTRY
ORDER BY 2 DESC;

SELECT sum(total_laid_off), company
FROM layoffs_staging2
GROUP by company
ORDER BY 1 ASC;


SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

 
 -- Rank the first five companies per year with total laid offs 
WITH Company_Year (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), sum(total_laid_off)
FROM layoffs_staging2
GROUP by company, YEAR(`date`)
), Company_Year_Ranking AS
(SELECT*,
DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL)
SELECT*
FROM Company_Year_Ranking
WHERE RANKING <=5 ;


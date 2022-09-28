--Q1 A
SELECT npi, nppes_provider_last_org_name AS last_name, nppes_provider_first_name AS first_name, total_claim_count AS claims, specialty_description, drug_name
FROM prescription
INNER JOIN prescriber USING (npi) 
ORDER BY total_claim_count DESC
LIMIT 1;

--Q2 A
--Family practice 9,752,347
SELECT specialty_description, SUM(total_claim_count) AS claims
FROM prescriber
INNER JOIN prescription USING (npi)
GROUP BY specialty_description
ORDER BY claims DESC;

--Q2 B come back to this
SELECT DISTINCT specialty_description, total_claim_count AS claims, drug_name
FROM prescriber
INNER JOIN prescription USING (npi)
INNER JOIN drug USING (drug_name)
WHERE opioid_drug_flag = 'Y'
ORDER BY specialty_description DESC;

--Q3
--A perfenidone 2,829,174.3
SELECT generic_name, SUM(total_drug_cost)
FROM drug
INNER JOIN prescription USING (drug_name)
GROUP BY generic_name
ORDER BY total_drug_cost DESC
LIMIT 1;

--B 
SELECT generic_name, ROUND(SUM(total_drug_cost)/SUM(total_day_supply),2) AS day_cost 
FROM drug
INNER JOIN prescription USING (drug_name)
GROUP BY generic_name
ORDER BY day_cost DESC;

--4 A
SELECT drug_name,
CASE WHEN opioid_drug_flag = 'Y' THEN 'opioid'
WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
ELSE 'neither' END as drug_type
FROM drug;

--4B add count-- not sure how to do this
SELECT drug_type, SUM(total_drug_cost::money) AS sum_drug_cost
FROM prescription
INNER JOIN (SELECT drug_name,
	CASE WHEN opioid_drug_flag = 'Y' THEN 'opioid'
	WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
	ELSE 'neither' END as drug_type FROM drug) AS dt
USING (drug_name)	
GROUP BY dt.drug_type
ORDER BY sum_drug_cost DESC;

---5 A. How many CBSAs are in Tennessee? 33

SELECT COUNT(*)
FROM cbsa
WHERE cbsaname LIKE '%TN'

--5 B Which cbsa has the largest combined population? Report the CBSA name and total population.
-- Nashville-Davidson-Mur-Frank- 1,830,410
SELECT cbsaname, SUM(population) AS pop_total
FROM cbsa 
FULL JOIN population USING (fipscounty)
FULL JOIN fips_county ON cbsa.fipscounty = fips_county.county
WHERE population IS NOT NULL
AND cbsa IS NOT NULL
GROUP BY cbsaname
ORDER BY pop_total DESC;

-- Which has the smallest? Morristown, TN 116,352
SELECT cbsaname, SUM(population) AS pop_total
FROM cbsa
FULL JOIN population USING (fipscounty)
FULL JOIN fips_county ON cbsa.fipscounty = fips_county.county
WHERE population IS NOT NULL
AND cbsa IS NOT NULL
GROUP BY cbsaname
ORDER BY pop_total ASC;

--5 C.  What is the largest (in terms of population) county name and population which is not included in a CBSA?

SELECT county, population, cbsaname
FROM population
LEFT JOIN cbsa USING(fipscounty)
LEFT JOIN fips_county USING(fipscounty)
WHERE cbsaname IS NULL
ORDER BY population DESC




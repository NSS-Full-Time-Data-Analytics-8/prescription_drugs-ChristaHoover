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
--A perfenidone 2829174.3
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
SELECT drug_name 
CASE WHEN opioid_drug_flag = 'Y' THEN 'opioid'
WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
ELSE 'neither' END as drug_type
FROM drug










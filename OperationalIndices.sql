--Operational Indices for HES
describe view PRD_BI.LOS.RPT_TPO_CONTRACT_DATA_V

--- TPO ONLY ---------------------------------------------------
-- Contract Velue Tab -> total_epc_contracted_amt
Select 
CASE
      WHEN "Installer Partner" = 'Freedom Forever' THEN 'Freedom Forever'
      WHEN "Installer Partner" = 'AXIA SOLAR CORP.' THEN 'AXIA SOLAR CORP.'
      ELSE 'Others'
    END AS installer_partner,
    COUNT(DISTINCT "App ID" ),COALESCE(SUM("EPC Payment (Contracted Amount)"),0) AS "EPC Amount" 
    FROM PRD_BI.LOS.RPT_TPO_CONTRACT_DATA_V
  where "Current Status" NOT IN (
    'CREDIT DECLINED',
    'M3 COMPLETED',
    'M3 COMPLETED- TRANSFER',
    'M3 COMPLETED- TRANSFERRED',
    'PROJECT CANCELLED',
    'SIGNED CONTRACT CANCELLED')
    AND
    "Active Status" = 'ACTIVE'
GROUP BY installer_partner


-- Cancellation
-- RATIONALE: From ALL Contracts Signed between 18 and 6 month ago, how many of them were "CANCELLED"

--, Cancellation_YTD AS(
SELECT 
COUNT(CASE WHEN "Current Status"  IN('PROJECT CANCELLED') THEN 1 END) AS YTD_num_cancelled
, COUNT(*) AS YTD_Total_volume 
, YTD_num_cancelled/YTD_Total_volume as YTD_Cancellation_rate
, max("Original Contract Signed Date"), MIN("Original Contract Signed Date")
FROM PRD_BI.LOS.RPT_TPO_CONTRACT_DATA_V
WHERE "Original Contract Signed Date" <= LAST_DAY(DATEADD('month',-6, CURRENT_DATE()))
AND "Original Contract Signed Date" > LAST_DAY(DATEADD('month',-18, CURRENT_DATE()))

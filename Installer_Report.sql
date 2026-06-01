--describe view PRD_BI.LOS.rpt_executive_v

---QUERY 1/2
SELECT PARTNER_NAME
--, table_name,APPLICATION_ID, CURRENT_STATUS, original_contract_signed_date, notice_to_proceed_timestamp, ready_for_m3_timestamp, m3_completed_timestamp
, sum(
CASE WHEN table_name = 'TPO' AND notice_to_proceed_timestamp IS NULL AND READY_FOR_M3_TIMESTAMP IS NULL AND DATEDIFF(DAY,ORIGINAL_CONTRACT_SIGNED_DATE,CURRENT_DATE())>30 THEN 1
        WHEN notice_to_proceed_timestamp IS NOT NULL AND ready_for_m3_timestamp IS NULL AND DATEDIFF(DAY, notice_to_proceed_timestamp,CURRENT_DATE())>45 THEN 1
        WHEN ready_for_m3_timestamp IS NOT NULL AND m3_completed_timestamp IS NULL AND DATEDIFF(DAY,ready_for_m3_timestamp,CURRENT_DATE())>45 THEN 1
        ELSE 0
END ) OOB_COUNT
, SUM(CASE WHEN m3_completed_timestamp IS NULL THEN 1 ELSE 0 END) AS noPTO_PROJECT_COUNT
, COUNT( APPLICATION_ID) PROJECT_COUNT
, case when noPTO_PROJECT_COUNT = 0 then 0 ELSE  OOB_COUNT/noPTO_PROJECT_COUNT END AS OBB_PERCENT
/*, DATEDIFF(DAY,ORIGINAL_CONTRACT_SIGNED_DATE,CURRENT_DATE()) cs
, DATEDIFF(DAY, notice_to_proceed_timestamp,CURRENT_DATE()) ntp
,DATEDIFF(DAY,ready_for_m3_timestamp,CURRENT_DATE()) RM3
*/
, SUM(CASE WHEN ORIGINAL_CONTRACT_SIGNED_DATE IS NOT NULL AND date_trunc(month,original_contract_signed_date) = date_trunc(month,dateadd('mm',-1,current_date() ))
THEN 1 end ) as num_Contract_Submitted
--, SUM(CASE WHEN m2_submitted_timestamp IS NOT NULL  AND DATEDIFF(DAY, m2_submitted_timestamp ,CURRENT_DATE())>=30 THEN 1 END) as num_m2_Submitted
, SUM(CASE WHEN m2_submitted_timestamp IS NOT NULL  AND date_trunc(month,m2_submitted_timestamp) = date_trunc(month,dateadd('mm',-1,current_date() )) THEN 1 END) as num_m2_Submitted
, SUM(CASE WHEN m3_submitted_timestamp IS NOT NULL  AND date_trunc(month,m3_submitted_timestamp) = date_trunc(month,dateadd('mm',-1,current_date() )) THEN 1 END) as num_m3_Submitted

, SUM(CASE WHEN READY_FOR_M2_TIMESTAMP IS NOT NULL AND date_trunc(month,READY_FOR_M2_TIMESTAMP) = date_trunc(month,dateadd('mm',-1,current_date() )) THEN 1 end ) as num_Contract_Approved
, SUM(CASE WHEN ready_for_m3_timestamp IS NOT NULL  AND date_trunc(month,READY_FOR_M3_TIMESTAMP) = date_trunc(month,dateadd('mm',-1,current_date() )) THEN 1 END) as num_m2_Approved
, SUM(CASE WHEN m3_completed_timestamp IS NOT NULL  AND date_trunc(month,m3_completed_timestamp) = date_trunc(month,dateadd('mm',-1,current_date() )) THEN 1 END) as num_m3_Approved

--1month ago:
, SUM(CASE WHEN READY_FOR_M2_TIMESTAMP IS NOT NULL AND date_trunc(month,READY_FOR_M2_TIMESTAMP) = date_trunc(month,dateadd('mm',-2,current_date() )) THEN 1 end ) as num_Contract_Approved_1
, SUM(CASE WHEN ready_for_m3_timestamp IS NOT NULL  AND date_trunc(month,READY_FOR_M3_TIMESTAMP) = date_trunc(month,dateadd('mm',-2,current_date() )) THEN 1 END) as num_m2_Approved_1
, SUM(CASE WHEN m3_completed_timestamp IS NOT NULL  AND date_trunc(month,m3_completed_timestamp) = date_trunc(month,dateadd('mm',-2,current_date() )) THEN 1 END) as num_m3_Approved_1

--2month ago:
, SUM(CASE WHEN READY_FOR_M2_TIMESTAMP IS NOT NULL AND date_trunc(month,READY_FOR_M2_TIMESTAMP) = date_trunc(month,dateadd('mm',-3,current_date() )) THEN 1 end ) as num_Contract_Approved_2
, SUM(CASE WHEN ready_for_m3_timestamp IS NOT NULL  AND date_trunc(month,READY_FOR_M3_TIMESTAMP) = date_trunc(month,dateadd('mm',-3,current_date() )) THEN 1 END) as num_m2_Approved_2
, SUM(CASE WHEN m3_completed_timestamp IS NOT NULL  AND date_trunc(month,m3_completed_timestamp) = date_trunc(month,dateadd('mm',-3,current_date() )) THEN 1 END) as num_m3_Approved_2
---3month ago
, SUM(CASE WHEN READY_FOR_M2_TIMESTAMP IS NOT NULL AND date_trunc(month,READY_FOR_M2_TIMESTAMP) = date_trunc(month,dateadd('mm',-4,current_date() )) THEN 1 end ) as num_Contract_Approved_3
, SUM(CASE WHEN ready_for_m3_timestamp IS NOT NULL  AND date_trunc(month,READY_FOR_M3_TIMESTAMP) = date_trunc(month,dateadd('mm',-4,current_date() )) THEN 1 END) as num_m2_Approved_3
, SUM(CASE WHEN m3_completed_timestamp IS NOT NULL  AND date_trunc(month,m3_completed_timestamp) = date_trunc(month,dateadd('mm',-4,current_date() )) THEN 1 END) as num_m3_Approved_3


--Aging ntp
,SUM( CASE WHEN TABLE_NAME LIKE 'TPO' AND NOTICE_TO_PROCEED_TIMESTAMP IS NOT NULL AND READY_FOR_M2_TIMESTAMP IS NULL AND DATEDIFF('DAY',NOTICE_TO_PROCEED_TIMESTAMP , CURRENT_DATE())<90   THEN 1 END)  NTP_0_89
,SUM( CASE WHEN TABLE_NAME LIKE 'TPO' AND NOTICE_TO_PROCEED_TIMESTAMP IS NOT NULL AND READY_FOR_M2_TIMESTAMP IS NULL AND DATEDIFF('DAY',NOTICE_TO_PROCEED_TIMESTAMP , CURRENT_DATE())<120  AND DATEDIFF('DAY',NOTICE_TO_PROCEED_TIMESTAMP , CURRENT_DATE())>=90 THEN 1 END)  NTP_90_119
,SUM( CASE WHEN TABLE_NAME LIKE 'TPO' AND NOTICE_TO_PROCEED_TIMESTAMP IS NOT NULL AND READY_FOR_M2_TIMESTAMP IS NULL AND DATEDIFF('DAY',NOTICE_TO_PROCEED_TIMESTAMP , CURRENT_DATE())<150  AND DATEDIFF('DAY',NOTICE_TO_PROCEED_TIMESTAMP , CURRENT_DATE())>=120 THEN 1 END)  NTP_120_149
,SUM( CASE WHEN TABLE_NAME LIKE 'TPO' AND NOTICE_TO_PROCEED_TIMESTAMP IS NOT NULL AND READY_FOR_M2_TIMESTAMP IS NULL AND DATEDIFF('DAY',NOTICE_TO_PROCEED_TIMESTAMP , CURRENT_DATE())<180  AND DATEDIFF('DAY',NOTICE_TO_PROCEED_TIMESTAMP , CURRENT_DATE())>=150 THEN 1 END)  NTP_150_179
,SUM( CASE WHEN TABLE_NAME LIKE 'TPO' AND NOTICE_TO_PROCEED_TIMESTAMP IS NOT NULL AND READY_FOR_M2_TIMESTAMP IS NULL AND DATEDIFF('DAY',NOTICE_TO_PROCEED_TIMESTAMP , CURRENT_DATE())>=180 THEN 1 END)  NTP_181

--Aging M2
,SUM( CASE WHEN ready_for_m2_timestamp IS NOT NULL AND READY_FOR_M3_TIMESTAMP IS NULL AND DATEDIFF('DAY',ready_for_m2_timestamp , CURRENT_DATE())<90   THEN 1 END)  M2_0_89
,SUM( CASE WHEN  ready_for_m2_timestamp IS NOT NULL AND READY_FOR_M3_TIMESTAMP IS NULL AND DATEDIFF('DAY',ready_for_m2_timestamp , CURRENT_DATE())<120  AND DATEDIFF('DAY',ready_for_m2_timestamp , CURRENT_DATE())>=90 THEN 1 END)  M2_90_119
,SUM( CASE WHEN  ready_for_m2_timestamp IS NOT NULL AND READY_FOR_M3_TIMESTAMP IS NULL AND DATEDIFF('DAY',ready_for_m2_timestamp , CURRENT_DATE())<150  AND DATEDIFF('DAY',ready_for_m2_timestamp , CURRENT_DATE())>=120 THEN 1 END)  M2_120_149
,SUM( CASE WHEN  ready_for_m2_timestamp IS NOT NULL AND READY_FOR_M3_TIMESTAMP IS NULL AND DATEDIFF('DAY',ready_for_m2_timestamp , CURRENT_DATE())<180  AND DATEDIFF('DAY',ready_for_m2_timestamp , CURRENT_DATE())>=150 THEN 1 END)  M2_150_179
,SUM( CASE WHEN ready_for_m2_timestamp IS NOT NULL AND READY_FOR_M3_TIMESTAMP IS NULL AND DATEDIFF('DAY',ready_for_m2_timestamp , CURRENT_DATE())>=180 THEN 1 END)  M2_181

--Aging M3
,SUM( CASE WHEN ready_for_m3_timestamp IS NOT NULL AND M3_COMPLETED_TIMESTAMP IS NULL AND DATEDIFF('DAY',ready_for_m3_timestamp , CURRENT_DATE())<90   THEN 1 END)  M3_0_89
,SUM( CASE WHEN  ready_for_m3_timestamp IS NOT NULL AND M3_COMPLETED_TIMESTAMP  IS NULL AND DATEDIFF('DAY',ready_for_m3_timestamp , CURRENT_DATE())<120  AND DATEDIFF('DAY',ready_for_m3_timestamp , CURRENT_DATE())>=90 THEN 1 END)  M3_90_119
,SUM( CASE WHEN  ready_for_m3_timestamp IS NOT NULL AND M3_COMPLETED_TIMESTAMP  IS NULL AND DATEDIFF('DAY',ready_for_m3_timestamp , CURRENT_DATE())<150  AND DATEDIFF('DAY',ready_for_m3_timestamp , CURRENT_DATE())>=120 THEN 1 END)  M3_120_149
,SUM( CASE WHEN  ready_for_m3_timestamp IS NOT NULL AND M3_COMPLETED_TIMESTAMP  IS NULL AND DATEDIFF('DAY',ready_for_m3_timestamp , CURRENT_DATE())<180  AND DATEDIFF('DAY',ready_for_m3_timestamp , CURRENT_DATE())>=150 THEN 1 END)  M3_150_179
,SUM( CASE WHEN ready_for_m3_timestamp IS NOT NULL AND M3_COMPLETED_TIMESTAMP  IS NULL AND DATEDIFF('DAY',ready_for_m3_timestamp , CURRENT_DATE())>=180 THEN 1 END)  M3_181


, SUM( CASE WHEN YEAR(NOTICE_TO_PROCEED_TIMESTAMP)*100+MONTH(NOTICE_TO_PROCEED_TIMESTAMP) = year(DATEADD('DAY',-1,DATE_TRUNC('MONTH',current_date())))*100+month(DATEADD('DAY',-1,DATE_TRUNC('MONTH',current_date()))) then 1 else 0
END ) AS month_NTP

,  AVG((LOAN_AMOUNT/(SYSTEM_SIZE*1000))) as ppw
, AVG( CASE WHEN PROJECT_TYPE = 'SolarSystem' THEN (LOAN_AMOUNT/(SYSTEM_SIZE*1000))/6.5
WHEN PROJECT_TYPE = 'SolarSystemBatteryStorage' THEN (LOAN_AMOUNT/(SYSTEM_SIZE*1000))/10
WHEN PROJECT_TYPE = 'SolarSystemReroofing' THEN (LOAN_AMOUNT/(SYSTEM_SIZE*1000))/12
WHEN PROJECT_TYPE = 'SolarSystemGroundMount' THEN (LOAN_AMOUNT/(SYSTEM_SIZE*1000))/12
WHEN PROJECT_TYPE = 'SolarSystemBatteryStorageReroofing' THEN (LOAN_AMOUNT/(SYSTEM_SIZE*1000))/15
WHEN PROJECT_TYPE = 'SolarSystemBatteryStorageReroofingge' THEN (LOAN_AMOUNT/(SYSTEM_SIZE*1000))/15
WHEN PROJECT_TYPE = 'SolarSystemBatteryStorageGroundMount' THEN (LOAN_AMOUNT/(SYSTEM_SIZE*1000))/15
END) ppw_by_cap
, CURRENT_DATE() AS YEAR_MONTH
FROM PRD_BI.LOS.rpt_executive_v
WHERE 

contract_active = 'TRUE'AND CURRENT_STATUS NOT IN('PROJECT CANCELLED','SIGNED CONTRACT CANCELLED','CREDIT DECLINED','INACTIVE PROJECT') 
AND CONTRACT_SIGNED_DATE IS NOT NULL
and CONTRACT_status in ('NEW - ENTERED','CONTRACT SIGNED')

GROUP BY PARTNER_NAME



/**************************************************/
---QUERY 2/2
---- ALL_DATA BY APPLICATION_ID
/*
SELECT PARTNER_NAME
, table_name,APPLICATION_ID, CURRENT_STATUS, original_contract_signed_date, ready_for_m2_timestamp, notice_to_proceed_timestamp, ready_for_notice_to_proceed_timestamp, ready_for_m3_timestamp, m3_completed_timestamp
, 
CASE WHEN table_name = 'TPO' AND notice_to_proceed_timestamp IS NULL AND READY_FOR_M3_TIMESTAMP IS NULL AND DATEDIFF(DAY,ORIGINAL_CONTRACT_SIGNED_DATE,CURRENT_DATE())>30 THEN 1
        WHEN notice_to_proceed_timestamp IS NOT NULL AND ready_for_m3_timestamp IS NULL AND DATEDIFF(DAY, notice_to_proceed_timestamp,CURRENT_DATE())>45 THEN 1
        WHEN ready_for_m3_timestamp IS NOT NULL AND m3_completed_timestamp IS NULL AND DATEDIFF(DAY,ready_for_m3_timestamp,CURRENT_DATE())>45 THEN 1
        ELSE 0
END  OOB_COUNT
, CASE WHEN m3_completed_timestamp IS NULL THEN 1 ELSE 0 END AS noPTO_PROJECT_COUNT
, APPLICATION_ID
, case when noPTO_PROJECT_COUNT = 0 then 0 ELSE  OOB_COUNT/noPTO_PROJECT_COUNT END AS OBB_PERCENT
, CASE WHEN ORIGINAL_CONTRACT_SIGNED_DATE IS NOT NULL AND date_trunc(month,original_contract_signed_date) = date_trunc(month,dateadd('mm',-1,current_date() ))
THEN 1 end  as num_Contract_Submitted
, CASE WHEN m2_submitted_timestamp IS NOT NULL  AND DATEDIFF(DAY, m2_submitted_timestamp ,CURRENT_DATE())>=30 THEN 1 END as num_m2_Submitted
, CASE WHEN m3_submitted_timestamp IS NOT NULL  AND DATEDIFF(DAY, m3_submitted_timestamp ,CURRENT_DATE())>=30 THEN 1 END as num_m3_Submitted

, CASE WHEN table_name = 'TPO' AND notice_to_proceed_timestamp IS NOT NULL AND DATEDIFF(DAY, notice_to_proceed_timestamp,CURRENT_DATE())>=30 THEN 1 end  as num_NTP_Approved
, CASE WHEN ready_for_m3_timestamp IS NOT NULL  AND DATEDIFF(DAY, ready_for_m3_timestamp ,CURRENT_DATE())>=30 THEN 1 END as num_m2_Approved
, CASE WHEN m3_completed_timestamp IS NOT NULL  AND DATEDIFF(DAY, m3_completed_timestamp ,CURRENT_DATE())>=30 THEN 1 END as num_m3_Approved

, CASE WHEN YEAR(NOTICE_TO_PROCEED_TIMESTAMP)*100+MONTH(NOTICE_TO_PROCEED_TIMESTAMP) = year(DATEADD('DAY',-1,DATE_TRUNC('MONTH',current_date())))*100+month(DATEADD('DAY',-1,DATE_TRUNC('MONTH',current_date()))) then 1 else 0
END  AS month_NTP

--AGING
,CASE WHEN TABLE_NAME LIKE 'TPO' AND NOTICE_TO_PROCEED_TIMESTAMP IS NOT NULL AND READY_FOR_M2_TIMESTAMP IS NULL THEN DATEDIFF('DAY',NOTICE_TO_PROCEED_TIMESTAMP , CURRENT_DATE() )END AS NTP_AGING
CASE WHEN ready_for_m2_timestamp IS NOT NULL AND READY_FOR_M3_TIMESTAMP IS NULL THEN DATEDIFF('DAY',ready_for_m2_timestamp , CURRENT_DATE()) END M2_AGING
CASE WHEN ready_for_m3_timestamp IS NOT NULL AND M3_COMPLETED_TIMESTAMP IS NULL THEN DATEDIFF('DAY',ready_for_m3_timestamp , CURRENT_DATE()) END M3_AGING

,  LOAN_AMOUNT/(SYSTEM_SIZE*1000) as ppw
, CASE WHEN PROJECT_TYPE = 'SolarSystem' THEN (LOAN_AMOUNT/(SYSTEM_SIZE*1000))/6.5
WHEN PROJECT_TYPE = 'SolarSystemBatteryStorage' THEN (LOAN_AMOUNT/(SYSTEM_SIZE*1000))/10
WHEN PROJECT_TYPE = 'SolarSystemReroofing' THEN (LOAN_AMOUNT/(SYSTEM_SIZE*1000))/12
WHEN PROJECT_TYPE = 'SolarSystemGroundMount' THEN (LOAN_AMOUNT/(SYSTEM_SIZE*1000))/12
WHEN PROJECT_TYPE = 'SolarSystemBatteryStorageReroofing' THEN (LOAN_AMOUNT/(SYSTEM_SIZE*1000))/15
WHEN PROJECT_TYPE = 'SolarSystemBatteryStorageReroofingge' THEN (LOAN_AMOUNT/(SYSTEM_SIZE*1000))/15
WHEN PROJECT_TYPE = 'SolarSystemBatteryStorageGroundMount' THEN (LOAN_AMOUNT/(SYSTEM_SIZE*1000))/15
END ppw_by_cap
, CURRENT_DATE() AS YEAR_MONTH
,date_trunc(month,original_contract_signed_date)
FROM PRD_BI.LOS.rpt_executive_v
WHERE 

contract_active = 'TRUE'AND CURRENT_STATUS NOT IN('PROJECT CANCELLED','SIGNED CONTRACT CANCELLED','CREDIT DECLINED','INACTIVE PROJECT') 
AND CONTRACT_SIGNED_DATE IS NOT NULL
and CONTRACT_status in ('NEW - ENTERED','CONTRACT SIGNED')

---------------
select distinct m2_rejection_reasons FROM PRD_BI.LOS.rpt_executive_v

-----------------------------
*/
/***********COMPLAINTS********************/

SELECT sum(task_id),contract_id_orig, who_id_name,partner_name, current_status, is_closed, category,  COMPLAINT_DETAILS, SFDC_CREATED_DATE ,sfdc_created_by, current_date() as today
FROM PRD_BI.LOS.RPT_TASKS_V ---distinct(current_status)
where REC_TYPE = 'Complaint' --AND contract_id_orig = 'CTRTPO-2407246422'
--AND who_id_name = 'Gale Ruffino'
AND current_status not in ('Completed','Confirmation Completed')

SELECT t.task_id,t.contract_id_orig, t.who_id_name, t.partner_name, t.current_status as complaint_status, e.current_status, E.CONTRACT_STATUS, e.CONTRACT_SIGNED_DATE, e.M3_COMPLETED_TIMESTAMP, e.ready_for_M3_timestamp, e.ready_for_m2_timestamp, e.notice_to_proceed_timestamp, 
case WHEN e.M3_COMPLETED_TIMESTAMP IS not null then 'PTO'
    WHEN e.ready_for_M3_timestamp IS NOT NULL OR e.ready_for_m2_timestamp IS NOT NULL  THEN 'M2/M3'
ELSE 'NTP'
END as complaint_type
,t.is_closed, t.category,  t.COMPLAINT_DETAILS, t.SFDC_CREATED_DATE ,t.sfdc_created_by
,CURRENT_DATE() AS today
FROM PRD_BI.LOS.RPT_TASKS_V t left join PRD_BI.LOS.RPT_EXECUTIVE_V e 
on t.contract_id_orig = e.contract_id
and t.partner_name = e.PARTNER_NAME
where t.REC_TYPE = 'Complaint' --AND contract_id_orig = 'CTRTPO-2407246422'
--AND who_id_name = 'Gale Ruffino'
AND t.current_status not in ('Completed','Confirmation Completed')
AND  e.CONTRACT_SIGNED_DATE IS NOT NULL
AND e.CURRENT_STATUS NOT IN('PROJECT CANCELLED','SIGNED CONTRACT CANCELLED','CREDIT DECLINED','INACTIVE PROJECT')

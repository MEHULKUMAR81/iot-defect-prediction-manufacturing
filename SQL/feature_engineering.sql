/* ============================================================
   SQL CHECKS FOR MASTER CYCLE TABLE
   Goal:
   Understand defect distribution, cycle time impact,
   robot load behavior, and stopper/bottleneck patterns.
   ============================================================ */


/* ------------------------------------------------------------
   1. Defect distribution
   Question:
   Which defect type occurs most often?
   NULL defect_label means no defect / good cycle.
   ------------------------------------------------------------ */

SELECT 
    defect_label,
    COUNT(*) AS total_cycles,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM master_time_table),
        2
    ) AS defect_pct
FROM master_time_table
GROUP BY defect_label
ORDER BY total_cycles DESC;


/* ------------------------------------------------------------
   2. Cycle time comparison
   Question:
   Do defective cycles take longer than good cycles?
   defect_flag = 0 means good cycle
   defect_flag = 1 means defective cycle
   ------------------------------------------------------------ */

SELECT 
    defect_flag,
    AVG(cycle_time_sec) AS avg_cycle_time_sec,
    MIN(cycle_time_sec) AS min_cycle_time_sec,
    MAX(cycle_time_sec) AS max_cycle_time_sec
FROM master_time_table
GROUP BY defect_flag;


/* ------------------------------------------------------------
   3. Robot gripper load comparison
   Question:
   Do robot gripping/load values change during defective cycles?
   This helps identify which robot signal is most associated
   with missing-part defects.
   ------------------------------------------------------------ */

SELECT 
    defect_flag,
    AVG(avg_r01_load) AS avg_R1_load,
    AVG(avg_r02_load) AS avg_R2_load,
    AVG(avg_r03_load) AS avg_R3_load,
    AVG(avg_r04_load) AS avg_R4_load
FROM master_time_table
GROUP BY defect_flag;


/* ------------------------------------------------------------
   4. Stopper activity / bottleneck comparison
   Question:
   Are defective cycles linked with longer stopper engagement?
   Higher stopper active count means the tray/station was held
   for more sensor observations during the cycle.
   ------------------------------------------------------------ */

SELECT
    defect_flag,
    AVG(stopper1_active_count) AS avg_stopper1_active_count,
    AVG(stopper2_active_count) AS avg_stopper2_active_count,
    AVG(stopper3_active_count) AS avg_stopper3_active_count,
    AVG(stopper4_active_count) AS avg_stopper4_active_count,
    AVG(stopper5_active_count) AS avg_stopper5_active_count
FROM master_time_table
GROUP BY defect_flag;

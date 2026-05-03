Create table master_time_table (
WITH master_time_table AS (
    SELECT 
        c.time_stamp,
        c.Q_VFD1_Temp, c.Q_VFD2_Temp, c.Q_VFD3_Temp, c.Q_VFD4_Temp,
        c.Stopper1_status, c.Stopper2_status, c.Stopper3_status,
        c.Stopper4_status, c.Stopper5_status,

        cm.Q_Cell_CycleCount AS cycle_id,
        cm.I_MHS_GreenRocketTray,

        R1.I_R01_Gripper_Load, R1.I_R01_Gripper_Pot,
        R2.I_R02_Gripper_Load, R2.I_R02_Gripper_Pot,
        R3.I_R03_Gripper_Load, R3.I_R03_Gripper_Pot,
        R4.I_R04_Gripper_Load, R4.I_R04_Gripper_Pot,

        COALESCE(c.Descp, cm.Descp, r1.Descp, r2.Descp, r3.Descp, r4.Descp) AS defect_label

    FROM conveyor_clean c
    LEFT JOIN cyclemanagement cm ON c.time_stamp = cm.time_stamp
    LEFT JOIN robot1 R1 ON c.time_stamp = R1.time_stamp
    LEFT JOIN robot2 R2 ON c.time_stamp = R2.time_stamp
    LEFT JOIN robot3 R3 ON c.time_stamp = R3.time_stamp
    LEFT JOIN robot4 R4 ON c.time_stamp = R4.time_stamp
),

prev_cycle AS (
    SELECT 
        *,
        LAG(cycle_id) OVER (ORDER BY time_stamp) AS previous_cycle_id
    FROM master_time_table
    WHERE cycle_id IS NOT NULL
),

new_id AS (
    SELECT 
        *,
        CASE 
            WHEN previous_cycle_id IS NULL THEN 1
            WHEN cycle_id < previous_cycle_id THEN 1
            ELSE 0
        END AS new_id
    FROM prev_cycle
),

run_table AS (
    SELECT 
        *,
        SUM(new_id) OVER (ORDER BY time_stamp) AS run_id
    FROM new_id
)

SELECT
    run_id,
    cycle_id,

    MIN(time_stamp) AS cycle_start_time,
    MAX(time_stamp) AS cycle_end_time,
    TIMESTAMPDIFF(SECOND, MIN(time_stamp), MAX(time_stamp)) AS cycle_time_sec,

    AVG(Q_VFD1_Temp) AS avg_vfd1_temp,
    AVG(Q_VFD2_Temp) AS avg_vfd2_temp,
    AVG(Q_VFD3_Temp) AS avg_vfd3_temp,
    AVG(Q_VFD4_Temp) AS avg_vfd4_temp,

    AVG(I_R01_Gripper_Load) AS avg_r01_load,
    MIN(I_R01_Gripper_Load) AS min_r01_load,
    MAX(I_R01_Gripper_Load) AS max_r01_load,

    AVG(I_R02_Gripper_Load) AS avg_r02_load,
    MIN(I_R02_Gripper_Load) AS min_r02_load,
    MAX(I_R02_Gripper_Load) AS max_r02_load,

    AVG(I_R03_Gripper_Load) AS avg_r03_load,
    MIN(I_R03_Gripper_Load) AS min_r03_load,
    MAX(I_R03_Gripper_Load) AS max_r03_load,

    AVG(I_R04_Gripper_Load) AS avg_r04_load,
    MIN(I_R04_Gripper_Load) AS min_r04_load,
    MAX(I_R04_Gripper_Load) AS max_r04_load,

    SUM(Stopper1_status) AS stopper1_active_count,
    SUM(Stopper2_status) AS stopper2_active_count,
    SUM(Stopper3_status) AS stopper3_active_count,
    SUM(Stopper4_status) AS stopper4_active_count,
    SUM(Stopper5_status) AS stopper5_active_count,

    MAX(defect_label) AS defect_label,
    CASE 
        WHEN MAX(defect_label) IS NULL THEN 0
        ELSE 1
    END AS defect_flag

FROM run_table
GROUP BY run_id, cycle_id
ORDER BY run_id, cycle_id)

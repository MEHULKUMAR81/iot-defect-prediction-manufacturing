DROP TABLE IF EXISTS conveyor;

CREATE TABLE conveyor (
    time_stamp DATETIME(3),
    Q_VFD1_Temp DOUBLE,
    Q_VFD2_Temp DOUBLE,
    Q_VFD3_Temp DOUBLE,
    Q_VFD4_Temp DOUBLE,
    Stopper1_status BOOLEAN,
    Stopper2_status BOOLEAN,
    Stopper3_status BOOLEAN,
    Stopper4_status BOOLEAN,
    Stopper5_status BOOLEAN,
    Descp VARCHAR(50)
);


LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 9.6/Uploads/industrial line/Conveyor_Signals.csv"
INTO TABLE conveyor
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(@time_stamp, @Q_VFD1_Temp, @Q_VFD2_Temp, @Q_VFD3_Temp, @Q_VFD4_Temp,
 @Stopper1_status, @Stopper2_status, @Stopper3_status, @Stopper4_status, @Stopper5_status, @Descp)
SET
time_stamp = STR_TO_DATE(REPLACE(REPLACE(@time_stamp,'T',' '),'Z',''), '%Y-%m-%d %H:%i:%s.%f'),
Q_VFD1_Temp = NULLIF(TRIM(@Q_VFD1_Temp),''),
Q_VFD2_Temp = NULLIF(TRIM(@Q_VFD2_Temp),''),
Q_VFD3_Temp = NULLIF(TRIM(@Q_VFD3_Temp),''),
Q_VFD4_Temp = NULLIF(TRIM(@Q_VFD4_Temp),''),
Stopper1_status = CASE WHEN UPPER(TRIM(@Stopper1_status))='TRUE' THEN 1 ELSE 0 END,
Stopper2_status = CASE WHEN UPPER(TRIM(@Stopper2_status))='TRUE' THEN 1 ELSE 0 END,
Stopper3_status = CASE WHEN UPPER(TRIM(@Stopper3_status))='TRUE' THEN 1 ELSE 0 END,
Stopper4_status = CASE WHEN UPPER(TRIM(@Stopper4_status))='TRUE' THEN 1 ELSE 0 END,
Stopper5_status = CASE WHEN UPPER(TRIM(@Stopper5_status))='TRUE' THEN 1 ELSE 0 END,
Descp = NULLIF(TRIM(@Descp),'');
=========================================================================================================================================================

DROP TABLE IF EXISTS conveyor_clean;

CREATE TABLE conveyor_clean AS
SELECT
    time_stamp,
    MAX(Q_VFD1_Temp) AS Q_VFD1_Temp,
    MAX(Q_VFD2_Temp) AS Q_VFD2_Temp,
    MAX(Q_VFD3_Temp) AS Q_VFD3_Temp,
    MAX(Q_VFD4_Temp) AS Q_VFD4_Temp,
    COALESCE(MAX(Stopper1_status),0) AS Stopper1_status,
    COALESCE(MAX(Stopper2_status),0) AS Stopper2_status,
    COALESCE(MAX(Stopper3_status),0) AS Stopper3_status,
    COALESCE(MAX(Stopper4_status),0) AS Stopper4_status,
    COALESCE(MAX(Stopper5_status),0) AS Stopper5_status,
    MAX(Descp) AS Descp
FROM conveyor
GROUP BY time_stamp;


=====================================================================================================================================================
DROP TABLE IF EXISTS Robot1;

CREATE TABLE robot1 (
    time_stamp DATETIME(3),
 I_R01_Gripper_Load DOUBLE,
   I_R01_Gripper_Pot DOUBLE,
    M_R01_BJointAngle_Degree DOUBLE,
  M_R01_LJointAngle_Degree DOUBLE,
  M_R01_RJointAngle_Degree double,
  M_R01_SJointAngle_Degree Double,
  M_R01_TJointAngle_Degree Double,
  M_R01_UJointAngle_Degree double,
  Descp   varchar(50)
);

============================================================================================================================================

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 9.6/Uploads/industrial line/R01_Data.csv"
INTO TABLE Robot1
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    @time_stamp,
    @I_R01_Gripper_Load,
    @I_R01_Gripper_Pot,
    @M_R01_BJointAngle_Degree,
    @M_R01_LJointAngle_Degree,
    @M_R01_RJointAngle_Degree,
    @M_R01_SJointAngle_Degree,
    @M_R01_TJointAngle_Degree,
    @M_R01_UJointAngle_Degree,
    @Descp
)
SET
    time_stamp = STR_TO_DATE(
        REPLACE(REPLACE(@time_stamp,'T',' '),'Z',''),
        '%Y-%m-%d %H:%i:%s.%f'
    ),
    I_R01_Gripper_Load = NULLIF(TRIM(@I_R01_Gripper_Load),''),
    I_R01_Gripper_Pot = NULLIF(TRIM(@I_R01_Gripper_Pot),''),
    M_R01_BJointAngle_Degree = NULLIF(TRIM(@M_R01_BJointAngle_Degree),''),
    M_R01_LJointAngle_Degree = NULLIF(TRIM(@M_R01_LJointAngle_Degree),''),
    M_R01_RJointAngle_Degree = NULLIF(TRIM(@M_R01_RJointAngle_Degree),''),
    M_R01_SJointAngle_Degree = NULLIF(TRIM(@M_R01_SJointAngle_Degree),''),
    M_R01_TJointAngle_Degree = NULLIF(TRIM(@M_R01_TJointAngle_Degree),''),
    M_R01_UJointAngle_Degree = NULLIF(TRIM(@M_R01_UJointAngle_Degree),''),
    Descp = NULLIF(TRIM(@Descp),'');

==================================
DROP TABLE IF EXISTS Robot2;

CREATE TABLE Robot2 (
    time_stamp DATETIME(3),
    I_R02_Gripper_Load DOUBLE,
    I_R02_Gripper_Pot DOUBLE,
    M_R02_BJointAngle_Degree DOUBLE,
    M_R02_LJointAngle_Degree DOUBLE,
    M_R02_RJointAngle_Degree DOUBLE,
    M_R02_SJointAngle_Degree DOUBLE,
    M_R02_TJointAngle_Degree DOUBLE,
    M_R02_UJointAngle_Degree DOUBLE,
    Descp VARCHAR(100)
);

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 9.6/Uploads/industrial line/R02_Data.csv"
INTO TABLE Robot2
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    @time_stamp,
    @I_R02_Gripper_Load,
    @I_R02_Gripper_Pot,
    @M_R02_BJointAngle_Degree,
    @M_R02_LJointAngle_Degree,
    @M_R02_RJointAngle_Degree,
    @M_R02_SJointAngle_Degree,
    @M_R02_TJointAngle_Degree,
    @M_R02_UJointAngle_Degree,
    @Descp
)
SET
    time_stamp = STR_TO_DATE(
        REPLACE(REPLACE(@time_stamp,'T',' '),'Z',''),
        '%Y-%m-%d %H:%i:%s.%f'
    ),
    I_R02_Gripper_Load = NULLIF(TRIM(@I_R02_Gripper_Load),''),
    I_R02_Gripper_Pot = NULLIF(TRIM(@I_R02_Gripper_Pot),''),
    M_R02_BJointAngle_Degree = NULLIF(TRIM(@M_R02_BJointAngle_Degree),''),
    M_R02_LJointAngle_Degree = NULLIF(TRIM(@M_R02_LJointAngle_Degree),''),
    M_R02_RJointAngle_Degree = NULLIF(TRIM(@M_R02_RJointAngle_Degree),''),
    M_R02_SJointAngle_Degree = NULLIF(TRIM(@M_R02_SJointAngle_Degree),''),
    M_R02_TJointAngle_Degree = NULLIF(TRIM(@M_R02_TJointAngle_Degree),''),
    M_R02_UJointAngle_Degree = NULLIF(TRIM(@M_R02_UJointAngle_Degree),''),
    Descp = NULLIF(TRIM(@Descp),'');
    
    ====================================================================================
DROP TABLE IF EXISTS Robot3;

CREATE TABLE Robot3 (
    time_stamp DATETIME(3),
    I_R03_Gripper_Load DOUBLE,
    I_R03_Gripper_Pot DOUBLE,
    M_R03_BJointAngle_Degree DOUBLE,
    M_R03_LJointAngle_Degree DOUBLE,
    M_R03_RJointAngle_Degree DOUBLE,
    M_R03_SJointAngle_Degree DOUBLE,
    M_R03_TJointAngle_Degree DOUBLE,
    M_R03_UJointAngle_Degree DOUBLE,
    Descp VARCHAR(100)
);

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 9.6/Uploads/industrial line/R03_Data.csv"
INTO TABLE Robot3
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    @time_stamp,
    @I_R03_Gripper_Load,
    @I_R03_Gripper_Pot,
    @M_R03_BJointAngle_Degree,
    @M_R03_LJointAngle_Degree,
    @M_R03_RJointAngle_Degree,
    @M_R03_SJointAngle_Degree,
    @M_R03_TJointAngle_Degree,
    @M_R03_UJointAngle_Degree,
    @Descp
)
SET
    time_stamp = STR_TO_DATE(
        REPLACE(REPLACE(@time_stamp,'T',' '),'Z',''),
        '%Y-%m-%d %H:%i:%s.%f'
    ),
    I_R03_Gripper_Load = NULLIF(TRIM(@I_R03_Gripper_Load),''),
    I_R03_Gripper_Pot = NULLIF(TRIM(@I_R03_Gripper_Pot),''),
    M_R03_BJointAngle_Degree = NULLIF(TRIM(@M_R03_BJointAngle_Degree),''),
    M_R03_LJointAngle_Degree = NULLIF(TRIM(@M_R03_LJointAngle_Degree),''),
    M_R03_RJointAngle_Degree = NULLIF(TRIM(@M_R03_RJointAngle_Degree),''),
    M_R03_SJointAngle_Degree = NULLIF(TRIM(@M_R03_SJointAngle_Degree),''),
    M_R03_TJointAngle_Degree = NULLIF(TRIM(@M_R03_TJointAngle_Degree),''),
    M_R03_UJointAngle_Degree = NULLIF(TRIM(@M_R03_UJointAngle_Degree),''),
    Descp = NULLIF(TRIM(@Descp),'');
    ====================================================================================
    
    
    
    DROP TABLE IF EXISTS Robot4;

CREATE TABLE Robot4 (
    time_stamp DATETIME(3),
    I_R04_Gripper_Load DOUBLE,
    I_R04_Gripper_Pot DOUBLE,
    M_R04_BJointAngle_Degree DOUBLE,
    M_R04_LJointAngle_Degree DOUBLE,
    M_R04_RJointAngle_Degree DOUBLE,
    M_R04_SJointAngle_Degree DOUBLE,
    M_R04_TJointAngle_Degree DOUBLE,
    M_R04_UJointAngle_Degree DOUBLE,
    Descp VARCHAR(100)
);

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 9.6/Uploads/industrial line/R04_Data.csv"
INTO TABLE Robot4
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    @time_stamp,
    @I_R04_Gripper_Load,
    @I_R04_Gripper_Pot,
    @M_R04_BJointAngle_Degree,
    @M_R04_LJointAngle_Degree,
    @M_R04_RJointAngle_Degree,
    @M_R04_SJointAngle_Degree,
    @M_R04_TJointAngle_Degree,
    @M_R04_UJointAngle_Degree,
    @Descp
)
SET
    time_stamp = STR_TO_DATE(
        REPLACE(REPLACE(@time_stamp,'T',' '),'Z',''),
        '%Y-%m-%d %H:%i:%s.%f'
    ),
    I_R04_Gripper_Load = NULLIF(TRIM(@I_R04_Gripper_Load),''),
    I_R04_Gripper_Pot = NULLIF(TRIM(@I_R04_Gripper_Pot),''),
    M_R04_BJointAngle_Degree = NULLIF(TRIM(@M_R04_BJointAngle_Degree),''),
    M_R04_LJointAngle_Degree = NULLIF(TRIM(@M_R04_LJointAngle_Degree),''),
    M_R04_RJointAngle_Degree = NULLIF(TRIM(@M_R04_RJointAngle_Degree),''),
    M_R04_SJointAngle_Degree = NULLIF(TRIM(@M_R04_SJointAngle_Degree),''),
    M_R04_TJointAngle_Degree = NULLIF(TRIM(@M_R04_TJointAngle_Degree),''),
    M_R04_UJointAngle_Degree = NULLIF(TRIM(@M_R04_UJointAngle_Degree),''),
    Descp = NULLIF(TRIM(@Descp),'');
    ========================================================================================================================
    
    DROP TABLE IF EXISTS CycleManagement;

CREATE TABLE CycleManagement (
    time_stamp DATETIME(3),
    Q_Cell_CycleCount INT,
    I_MHS_GreenRocketTray BOOLEAN,
    Descp VARCHAR(100)
);

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 9.6/Uploads/industrial line/FFCell_CycleManagement.csv"
INTO TABLE CycleManagement
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    @time_stamp,
    @Q_Cell_CycleCount,
    @I_MHS_GreenRocketTray,
    @Descp
)
SET
    time_stamp = STR_TO_DATE(
        REPLACE(REPLACE(@time_stamp,'T',' '),'Z',''),
        '%Y-%m-%d %H:%i:%s.%f'
    ),
    Q_Cell_CycleCount = NULLIF(TRIM(@Q_Cell_CycleCount),''),
    I_MHS_GreenRocketTray = CASE
        WHEN UPPER(TRIM(@I_MHS_GreenRocketTray)) = 'TRUE' THEN 1
        WHEN UPPER(TRIM(@I_MHS_GreenRocketTray)) = 'FALSE' THEN 0
        ELSE NULL
    END,
    Descp = NULLIF(TRIM(@Descp),'');
    
    =========================================================================================================
    
    
    DROP TABLE IF EXISTS SafetyManagement;

CREATE TABLE SafetyManagement (
    time_stamp DATETIME(3),
    I_CabinetEStop BOOLEAN,
    I_SafetyDoor1 BOOLEAN,
    I_SafetyDoor2 BOOLEAN,
    I_HMI_EStop BOOLEAN,
    Descp VARCHAR(100)
);
LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 9.6/Uploads/industrial line/FFCell_SafetyManagement.csv"
INTO TABLE SafetyManagement
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    @time_stamp,
    @I_CabinetEStop,
    @I_SafetyDoor1,
    @I_SafetyDoor2,
    @I_HMI_EStop,
    @Descp
)
SET
    time_stamp = STR_TO_DATE(
        REPLACE(REPLACE(@time_stamp,'T',' '),'Z',''),
        '%Y-%m-%d %H:%i:%s.%f'
    ),

    I_CabinetEStop = CASE
        WHEN UPPER(TRIM(@I_CabinetEStop))='TRUE' THEN 1
        WHEN UPPER(TRIM(@I_CabinetEStop))='FALSE' THEN 0
        ELSE NULL
    END,

    I_SafetyDoor1 = CASE
        WHEN UPPER(TRIM(@I_SafetyDoor1))='TRUE' THEN 1
        WHEN UPPER(TRIM(@I_SafetyDoor1))='FALSE' THEN 0
        ELSE NULL
    END,

    I_SafetyDoor2 = CASE
        WHEN UPPER(TRIM(@I_SafetyDoor2))='TRUE' THEN 1
        WHEN UPPER(TRIM(@I_SafetyDoor2))='FALSE' THEN 0
        ELSE NULL
    END,

    I_HMI_EStop = CASE
        WHEN UPPER(TRIM(@I_HMI_EStop))='TRUE' THEN 1
        WHEN UPPER(TRIM(@I_HMI_EStop))='FALSE' THEN 0
        ELSE NULL
    END,

    Descp = NULLIF(TRIM(@Descp),'');

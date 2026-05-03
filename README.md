# IoT Defect Prediction for Smart Manufacturing Assembly Line

## Project Overview

Built an end-to-end predictive quality analytics pipeline using industrial IoT sensor data from a robotic manufacturing assembly line to identify defect drivers, monitor process bottlenecks, and predict defective assemblies before final inspection.

The project uses multi-source sensor streams from:

* 4 robotic arms (gripper load + potentiometer signals + joint angles)
* Conveyor VFD temperature signals
* Stopper station activity signals
* Cycle management logs
* Material handling station signals
* Defect annotations

The objective was to move beyond descriptive dashboards and build a predictive maintenance / quality monitoring workflow that can support **real-time defect prevention, process optimization, and throughput improvement** on automated shop floors.

---

# Manufacturing Setup

Dataset was collected from the **Future Factories Testbed – University of South Carolina**, which simulates an industrial robotic assembly line.

Assembly workflow:

* **R01** picks tray from material handling station
* Conveyor transfers tray to **R02**
* **R02** assembles rocket body components
* Conveyor transfers tray to **R03**
* **R03** assembles base + nose cone
* Conveyor transfers tray to **R04**
* **R04** disassembles product and returns tray
* Process repeats continuously

The dataset includes intentionally injected defects where components were manually removed to simulate real manufacturing anomalies such as:

* NoNose
* NoBody2 + NoNose
* NoBody1 + NoBody2 + NoNose

The dataset contains:

* ~30 hours of production runtime
* ~166,000 raw sensor records
* 325 completed production cycles
* Multiple labeled defect events



---

# Business Problem

Traditional quality inspection identifies defects only after product completion.

This creates:

* Rework costs
* Scrap generation
* Production delays
* Low equipment utilization
* Reactive maintenance behavior

This project builds a **predictive quality framework** that flags high-risk production cycles before defective assemblies move downstream.

---

# Technical Architecture

```text
Raw Sensor Logs
→ SQL Data Ingestion
→ Data Cleaning
→ Cycle Reconstruction
→ Feature Engineering
→ Exploratory Analysis
→ Machine Learning Classification
→ Defect Prediction
→ Process Optimization Recommendations
```

---

# SQL Pipeline

Raw CSV files were ingested into MySQL from multiple assets:

* Conveyor signals
* Robot 1
* Robot 2
* Robot 3
* Robot 4
* Cycle management
* Safety management

---

## Data Cleaning & Transformation

Built SQL scripts to standardize fragmented manufacturing logs:

### Timestamp standardization

```sql
STR_TO_DATE()
```

Converted raw machine timestamps into structured datetime format.

---

## Missing value handling

```sql
NULLIF()
```

Removed blank sensor readings.

---

## Boolean conversion

```sql
CASE WHEN
```

Converted TRUE/FALSE machine signals into binary operational states.

---

## Multi-table integration

```sql
LEFT JOIN
```

Merged robot, conveyor, and cycle logs into a unified production dataset.

---

## Cycle reconstruction

Used:

* `LAG()`
* Window functions
* CTEs
* Running sums

to rebuild complete manufacturing cycles because cycle IDs reset during interruptions.

---

## Feature Engineering

Generated cycle-level KPIs:

* Cycle time
* Average conveyor temperature
* Robot load distributions
* Stopper congestion counts
* Defect labels
* Defect flags

---

# Python Analytics

Libraries used:

### Pandas

Data manipulation and feature engineering

### NumPy

Numerical transformations and anomaly cleaning

### Matplotlib / Seaborn

Operational trend visualization

Used for:

* Defect distribution analysis
* Boxplots
* Cycle variability analysis
* Robot load comparisons
* Bottleneck identification

---

# Key Process Insights

### Robot 3 was the largest defect contributor

Feature importance analysis showed:

* `avg_r03_load → 35.1%`

Low gripper load frequently correlated with incomplete assembly.

---

### Robot 1 showed secondary impact

* `avg_r01_load → 26.5%`

Indicates inconsistent tray handling/material transfer.

---

### Stopper 2 created conveyor bottlenecks

High stopper activation frequency indicated downstream congestion.

---

### Defect categories were concentrated in missing component failures

Most common:

* NoNose
* NoBody2 + NoNose
* NoBody1 + NoBody2 + NoNose

---

# Machine Learning Model

Built a **Random Forest Classification model** for predictive defect detection.

Why Random Forest:

* Handles nonlinear manufacturing relationships
* Robust to noisy sensor data
* Performs well for predictive maintenance classification problems
* Provides feature importance interpretability for root cause analysis

Model inputs:

* Cycle time
* Robot loads
* Conveyor temperatures
* Stopper congestion metrics

Output:

* Defective cycle
* Non-defective cycle

---

# Model Performance

### Accuracy: **98%**

### Defect Recall: **100%**

### Precision: **97%**

The model successfully identified nearly all defective assemblies while minimizing false alarms.

---

# Predictive Maintenance / Shop Floor Impact

This framework enables:

* Early defect detection
* Reduced scrap
* Lower rework costs
* Improved throughput
* Reduced manual inspection dependency
* Better robotic asset utilization
* Data-driven preventive maintenance decisions

Example operational rule:

If:

* Robot 3 load drops below threshold
* Stopper 2 congestion rises
* Cycle time increases

→ Trigger maintenance alert before defective product moves downstream.

---

# Repository Structure

```text
sql/
    create_tables.sql
    data_ingestion.sql
    data_cleaning.sql
    master_cycle_aggregation.sql

notebooks/
    defect_prediction_analysis.ipynb

data/
    processed datasets

README.md
```

---

# Dataset Credit

Harik, R., El Kalach, F., Samaha, J., Clark, D., Sander, D., Samaha, P., Burns, L., Yousif, I., Gadow, V., Tarekegne, T., & Saha, N. (2024). *Analog and Multi-modal Manufacturing Datasets Acquired on the Future Factories Platform*. Department of Mechanical Engineering, University of South Carolina.

Dataset source: Future Factories Lab, University of South Carolina. 

---



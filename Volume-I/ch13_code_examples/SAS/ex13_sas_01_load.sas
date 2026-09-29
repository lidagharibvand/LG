/* ex13_sas_01_load.sas
   Loading data and descriptives. Section 13.6.1. */

/* Read the CSV into a SAS dataset called trial */
PROC IMPORT DATAFILE = "data/processed/trial_hypertension.csv"
    OUT = trial DBMS = CSV REPLACE;
    GETNAMES = YES;
RUN;

/* Descriptives by treatment arm */
PROC MEANS DATA = trial N MEAN STD MIN MAX;
    CLASS arm;
    VAR age sbp_baseline sbp_12wk;
RUN;

PROC FREQ DATA = trial;
    TABLES arm sex bp_target_met;
RUN;

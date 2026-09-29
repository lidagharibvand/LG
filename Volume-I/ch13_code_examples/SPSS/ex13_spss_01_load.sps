* ex13_spss_01_load.sps.
* Loading data and descriptives. Section 13.7.1.

GET DATA
  /TYPE = TXT
  /FILE = "data/processed/trial_hypertension.csv"
  /DELIMITERS = ","
  /FIRSTCASE = 2
  /VARIABLES = id F8.0 arm A12 age F5.1 sex A1
               sbp_baseline F5.1 sbp_12wk F5.1 bp_target_met F1.0.
EXECUTE.

* Descriptives by treatment arm.
MEANS TABLES = age sbp_baseline sbp_12wk BY arm
  /CELLS = MEAN COUNT STDDEV.

* ex13_spss_03_chisq.sps.
* Chi-square test. Section 13.7.3.

CROSSTABS
  /TABLES = arm BY bp_target_met
  /STATISTICS = CHISQ RISK
  /CELLS = COUNT ROW COLUMN TOTAL.

/* ex13_sas_03_chisq.sas
   Chi-square test. Section 13.6.3. */

PROC FREQ DATA = trial;
    TABLES arm * bp_target_met / CHISQ RELRISK;
RUN;

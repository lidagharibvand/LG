/* ex13_sas_02_ttest.sas
   Two-sample t-test. Section 13.6.2. */

/* Compute the change score */
DATA trial;
    SET trial;
    sbp_change = sbp_12wk - sbp_baseline;
RUN;

/* Welch's two-sample t-test on the change score */
PROC TTEST DATA = trial;
    CLASS arm;
    VAR sbp_change;
RUN;

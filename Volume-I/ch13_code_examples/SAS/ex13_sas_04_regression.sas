/* ex13_sas_04_regression.sas
   Linear regression with adjustment. Section 13.6.4. */

PROC GLM DATA = trial;
    CLASS arm sex;
    MODEL sbp_12wk = arm sbp_baseline age sex / SOLUTION CLPARM;
    LSMEANS arm / DIFF CL;
RUN;
QUIT;

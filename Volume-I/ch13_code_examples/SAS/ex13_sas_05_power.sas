/* ex13_sas_05_power.sas
   Sample-size for a 5 mmHg difference, SD 12, 80% power. Section 13.6.5.
   NTOTAL = . asks PROC POWER to solve for the total sample size. */

PROC POWER;
    TWOSAMPLEMEANS
        MEANDIFF = 5
        STDDEV   = 12
        ALPHA    = 0.05
        POWER    = 0.80
        NTOTAL   = .;
RUN;

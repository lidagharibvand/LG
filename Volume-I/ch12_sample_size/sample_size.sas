/* sample_size.sas  Section 12.6 of Modern Biostatistics, Volume I. */

/* 1. One-sample: solve for n                          n = 199 */
proc power;
   onesamplemeans test = t
      nullmean = 0   mean = 5   stddev = 25
      alpha = 0.05   sides = 2  power  = 0.80
      ntotal = .;
run;

/* 2. Same design, n fixed: solve for power        power = 0.761 */
proc power;
   onesamplemeans test = t
      nullmean = 0   mean = 5   stddev = 25
      alpha = 0.05   sides = 2  ntotal = 180
      power = .;
run;

/* 3. Two groups, unequal variances.                            */
/*    TEST = DIFF wants ONE common sd, so supply the            */
/*    root-mean-square, computed rather than typed.             */
data _null_;
   sd_ave = sqrt((15**2 + 18**2) / 2);     /* 16.56804 */
   call symputx('SDAVE', sd_ave);
run;

proc power;                                /* 45 per group */
   twosamplemeans test = diff
      meandiff = 10  stddev = &SDAVE
      alpha = 0.05   sides = 2  power = 0.80
      npergroup = .;
run;

/* 3b. The same question asked properly. GROUPSTDDEVS takes the */
/*     two standard deviations as they are, and is valid ONLY   */
/*     with TEST = DIFF_SATT. R cannot do this at all.          */
proc power;                                /* also 45 per group */
   twosamplemeans test = diff_satt
      meandiff = 10  groupstddevs = (15 18)
      alpha = 0.05   sides = 2  power = 0.80
      npergroup = .;
run;

/* 4. Two groups, common sd = 17                 47 per group */
proc power;
   twosamplemeans test = diff
      meandiff = 10  stddev = 17
      alpha = 0.05   sides = 2  power = 0.80
      npergroup = .;
run;

/* 5. Paired. PROC POWER takes the two standard deviations and  */
/*    the correlation directly and collapses them itself, so    */
/*    there is no hand arithmetic to get wrong.      29 pairs   */
proc power;
   pairedmeans test = diff
      meandiff = 20  pairedstddevs = (40 32)  corr = 0.5
      alpha = 0.05   sides = 2  power = 0.80
      npairs = .;
run;

/* 6. Most PROC POWER options take a LIST, and the procedure    */
/*    crosses every list and prints one row per combination.    */
/*    One statement replaces the loop R needs.                  */
proc power;
   pairedmeans test = diff
      meandiff = 20  pairedstddevs = (40 32)
      corr = 0.0 0.3 0.5 0.7 0.9
      alpha = 0.05   sides = 2  power = 0.80
      npairs = .;
run;

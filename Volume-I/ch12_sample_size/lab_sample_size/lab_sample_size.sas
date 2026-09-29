/* =========================================================================
   lab_sample_size.sas

   Modern Biostatistics for the Health Sciences, Volume I
   Chapter 11, Section 11.6 -- Sample Size and Power in Software

   The SAS counterpart of lab_sample_size.R. Every calculation uses
   PROC POWER, which solves the same noncentral-t equation as R's
   power.t.test, so the answers are identical.

   Two SAS conventions to know before you read further:

     * A missing value (a lone period) marks the quantity you want SOLVED.
       NTOTAL = . means "tell me the sample size"; POWER = . means "tell me
       the power". Exactly one quantity per statement may be missing.

     * PROC POWER reports sample sizes already rounded UP to a whole
       participant. R reports the fractional root and leaves the rounding
       to you. This is the only reason the two ever appear to disagree.

   Submit the whole file in one session.
   Tested against SAS/STAT 14.1 and later; PROC POWER has been in SAS/STAT
   since version 9.1.
   ========================================================================= */

ods graphics off;          /* we want the tables, not the power curves */
title;

/* -------------------------------------------------------------------------
   1. One-sample t test -- solving for n

      Detect a 5-unit shift from the null value, sd = 25,
      two-sided alpha = 0.05, power = 0.80.

      MEAN and NULLMEAN differ by 5, which is how PROC POWER is told the
      effect size; there is no MEANDIFF option on ONESAMPLEMEANS.

      Expected: N Total = 199
   ------------------------------------------------------------------------- */
title1 "1. One-sample t test: solving for n";
proc power;
   onesamplemeans
      test     = t
      nullmean = 0
      mean     = 5
      stddev   = 25
      alpha    = 0.05
      sides    = 2
      power    = 0.80
      ntotal   = .;
run;

/* -------------------------------------------------------------------------
   2. One-sample t test -- solving for power at n = 180

      Same design, recruitment capped at 180. Swap which quantity is
      missing: supply NTOTAL, leave POWER = .

      Expected: Power = 0.761
   ------------------------------------------------------------------------- */
title1 "2. One-sample t test: solving for power at n = 180";
proc power;
   onesamplemeans
      test     = t
      nullmean = 0
      mean     = 5
      stddev   = 25
      alpha    = 0.05
      sides    = 2
      ntotal   = 180
      power    = .;
run;

/* -------------------------------------------------------------------------
   3. Two independent groups -- unequal variances

      sd1 = 15, sd2 = 18. TEST = DIFF assumes a single common standard
      deviation, so we supply the root-mean-square of the two:

          sd_ave = sqrt((15**2 + 18**2) / 2) = 16.56804

      This is the same substitution the R script makes, and it gives the
      same answer. Compute it in a DATA step rather than typing a rounded
      constant, so the number in the log is the number PROC POWER used.

      Expected: sd_ave = 16.56804, N per Group = 45 (90 total)
   ------------------------------------------------------------------------- */
title1 "3. Two-sample t test: unequal variances, pooled via root-mean-square";

data _null_;
   sd1 = 15;
   sd2 = 18;
   sd_ave = sqrt((sd1**2 + sd2**2) / 2);
   put "sd_ave = " sd_ave 10.5;
   call symputx('SDAVE', sd_ave);
run;

proc power;
   twosamplemeans
      test       = diff
      meandiff   = 10
      stddev     = &SDAVE
      alpha      = 0.05
      sides      = 2
      power      = 0.80
      npergroup  = .;
run;

/* -------------------------------------------------------------------------
   3b. The same question asked properly: Satterthwaite

      SAS does not need the root-mean-square trick. TEST = DIFF_SATT takes
      the two group standard deviations directly through GROUPSTDDEVS and
      runs the unequal-variance (Welch) test. GROUPSTDDEVS is valid ONLY
      with TEST = DIFF_SATT; it is rejected with TEST = DIFF.

      This is the calculation R's power.t.test cannot do at all, and it is
      the honest answer when the variances really are expected to differ.

      Expected: N per Group = 45 -- the same as 3, because the
      Satterthwaite degrees of freedom cost is tiny at this sample size
      (44.10 against 44.07 before rounding).
   ------------------------------------------------------------------------- */
title1 "3b. Two-sample t test: Satterthwaite, unequal variances stated directly";
proc power;
   twosamplemeans
      test          = diff_satt
      meandiff      = 10
      groupstddevs  = (15 18)
      alpha         = 0.05
      sides         = 2
      power         = 0.80
      npergroup     = .;
run;

/* -------------------------------------------------------------------------
   4. Two independent groups -- equal variances, sd = 17

      Expected: N per Group = 47 (94 total)
   ------------------------------------------------------------------------- */
title1 "4. Two-sample t test: equal variances, sd = 17";
proc power;
   twosamplemeans
      test       = diff
      meandiff   = 10
      stddev     = 17
      alpha      = 0.05
      sides      = 2
      power      = 0.80
      npergroup  = .;
run;

/* -------------------------------------------------------------------------
   5. Paired t test

      Here PROC POWER is genuinely better than power.t.test. R makes you
      collapse the two standard deviations and the correlation into a
      single sd of the differences by hand:

          sd_paired = sqrt(sd1**2 + sd2**2 - 2*rho*sd1*sd2) = 36.66061

      PROC POWER takes all three as they come: PAIREDSTDDEVS = (40 32)
      and CORR = 0.5. It does the collapsing internally, using the same
      formula, so nothing can be fat-fingered.

      Expected: N Pairs = 29
   ------------------------------------------------------------------------- */
title1 "5. Paired t test: standard deviations and correlation supplied directly";
proc power;
   pairedmeans
      test           = diff
      meandiff       = 20
      pairedstddevs  = (40 32)
      corr           = 0.5
      alpha          = 0.05
      sides          = 2
      power          = 0.80
      npairs         = .;
run;

/* -------------------------------------------------------------------------
   6. Sensitivity of the paired design to rho

      A SAS option that takes a single value will usually take a LIST, and
      PROC POWER then crosses every list and prints one row per
      combination. One statement replaces the loop the R script needs.

      Expected:  rho   0.0   0.3   0.5   0.7   0.9
                 pairs  54    39    29    19     9
   ------------------------------------------------------------------------- */
title1 "6. Paired design: how the answer moves with the assumed correlation";
proc power;
   pairedmeans
      test           = diff
      meandiff       = 20
      pairedstddevs  = (40 32)
      corr           = 0.0 0.3 0.5 0.7 0.9
      alpha          = 0.05
      sides          = 2
      power          = 0.80
      npairs         = .;
run;

title;

/* -------------------------------------------------------------------------
   The five answers, for checking against the other four languages:

       1. one-sample                    199 participants
       2. power at n = 180              0.761
       3. two-sample, sd_ave 16.568      45 per group
       4. two-sample, sd = 17            47 per group
       5. paired, rho = 0.5              29 pairs

   If your SAS session prints something else, check three things first:
   SIDES = 2 (one-sided tests give smaller numbers), ALPHA = 0.05, and
   whether you gave NPERGROUP or NTOTAL -- TWOSAMPLEMEANS will solve for
   either, and 90 total is the same answer as 45 per group.
   ------------------------------------------------------------------------- */

* =========================================================================
  lab_sample_size.sps

  Modern Biostatistics for the Health Sciences, Volume I
  Chapter 11, Section 11.6 -- Sample Size and Power in Software

  The SPSS counterpart of lab_sample_size.R.

  SPSS gained a native POWER command in version 27, and it solves the same
  noncentral-t equation as R and SAS. Part A below uses it. If you are on
  an older release, or your licence does not include the module, Part B
  reproduces all five answers with nothing but COMPUTE statements and the
  IDF/CDF functions that have been in SPSS for decades.

  Three things to know about the POWER command:

    * The quantity you OMIT is the quantity it solves for. Give POWER= and
      it returns a sample size; give N= and it returns power. Do not give
      both.

    * TEST = NONDIRECTIONAL means two-tailed. This is not the default in
      every dialog, and a one-tailed test quietly returns a smaller number.

    * MEAN= is the mean under the alternative and NULL= the value tested
      against; their difference is the effect size. On the RELATED
      (paired) form, MEAN= is the mean DIFFERENCE and SD= is the standard
      deviation OF THE DIFFERENCES, not of either measurement.

  Open this file in the syntax editor and run it top to bottom.
  ========================================================================= .

* =========================================================================
  PART A -- the POWER command (SPSS 27 and later)
  ========================================================================= .

* -------------------------------------------------------------------------
  1. One-sample t test: solving for n
     delta = 5 (MEAN 5 against NULL 0), sd = 25, alpha = .05, power = .80
     Expected: N = 199
  ------------------------------------------------------------------------- .
POWER MEANS ONESAMPLE
  /PARAMETERS TEST=NONDIRECTIONAL SIGNIFICANCE=0.05 POWER=0.80
              MEAN=5 NULL=0 SD=25.

* -------------------------------------------------------------------------
  2. One-sample t test: solving for power at n = 180
     Supply N, omit POWER.
     Expected: Power = .761
  ------------------------------------------------------------------------- .
POWER MEANS ONESAMPLE
  /PARAMETERS TEST=NONDIRECTIONAL SIGNIFICANCE=0.05 N=180
              MEAN=5 NULL=0 SD=25.

* -------------------------------------------------------------------------
  3. Two independent groups, unequal variances

     SPSS takes the two group standard deviations directly: SD=15 17 gives
     one per group, and NRATIO=1 asks for equal group sizes. MEAN=0 10
     gives the two group means, so the difference is 10.

     With equal group sizes, pooling two standard deviations of 15 and 18
     is arithmetically the same as supplying the single root-mean-square
     value 16.56804 that the R script computes by hand -- which is why
     SPSS, SAS, and R all land on the same number here.

     Expected: N = 45 per group, 90 total
  ------------------------------------------------------------------------- .
POWER MEANS INDEPENDENT
  /PARAMETERS TEST=NONDIRECTIONAL SIGNIFICANCE=0.05 POWER=0.80
              NRATIO=1 MEAN=0 10 SD=15 18.

* -------------------------------------------------------------------------
  4. Two independent groups, equal variances, sd = 17
     Expected: N = 47 per group, 94 total
  ------------------------------------------------------------------------- .
POWER MEANS INDEPENDENT
  /PARAMETERS TEST=NONDIRECTIONAL SIGNIFICANCE=0.05 POWER=0.80
              NRATIO=1 MEAN=0 10 SD=17 17.

* -------------------------------------------------------------------------
  5. Paired t test

     The RELATED form wants the standard deviation of the DIFFERENCES, so
     the collapsing step has to be done first, exactly as in R:

         sd_paired = SQRT(40**2 + 32**2 - 2 * .5 * 40 * 32) = 36.66061

     Part B computes it rather than trusting the rounded constant.
     Expected: N = 29 pairs
  ------------------------------------------------------------------------- .
POWER MEANS RELATED
  /PARAMETERS TEST=NONDIRECTIONAL SIGNIFICANCE=0.05 POWER=0.80
              MEAN=20 SD=36.66061.

* =========================================================================
  PART B -- the same five answers with COMPUTE only (any SPSS version)

  No POWER command, no module licence. This costs a little accuracy and
  buys a lot of transparency: every step is visible, and the arithmetic is
  the same arithmetic the Excel workbook in this folder performs.

  The approximation replaces the noncentral t with a central t shifted by
  the noncentrality parameter. It is accurate to about a thousandth of a
  unit of power, and in all five of these designs it rounds to exactly the
  same whole number of participants as the exact calculation. It is NOT
  exact in general; when the answer matters, use Part A, SAS, R, or Python.

  Two SPSS functions do the work:
      IDF.T(p, df)       the t value with left-tail area p
      CDF.T(t, df)       the left-tail area below t
  ========================================================================= .

NEW FILE.
INPUT PROGRAM.
  LOOP #i = 1 TO 1.
    COMPUTE dummy = 1.
    END CASE.
  END LOOP.
  END FILE.
END INPUT PROGRAM.
EXECUTE.

* --- shared inputs ------------------------------------------------------- .
COMPUTE alpha  = 0.05.
COMPUTE target = 0.80.

* --- 1. one-sample n, by iterative refinement ----------------------------- .
* Start from the normal approximation, then refine four times. The degrees
  of freedom depend on n and n depends on the degrees of freedom, so the
  calculation has to chase its own tail. Four passes is always enough;
  the value stops moving after the second .
COMPUTE delta = 5.
COMPUTE sd    = 25.
COMPUTE n1 = (IDF.NORMAL(1 - alpha/2, 0, 1) + IDF.NORMAL(target, 0, 1))**2
             * sd**2 / delta**2.
LOOP #k = 1 TO 4.
  COMPUTE df = MAX(RND(n1) - 1, 1).
  COMPUTE n1 = (IDF.T(1 - alpha/2, df) + IDF.T(target, df))**2
               * sd**2 / delta**2.
END LOOP.
COMPUTE n1_enroll = TRUNC(n1) + (MOD(n1,1) > 0).
FORMATS n1 (F10.4) n1_enroll (F6.0).

* --- 2. power at n = 180 -------------------------------------------------- .
COMPUTE n_have = 180.
COMPUTE ncp    = delta / (sd / SQRT(n_have)).
COMPUTE crit   = IDF.T(1 - alpha/2, n_have - 1).
COMPUTE power180 = 1 - CDF.T(crit - ncp, n_have - 1).
FORMATS power180 (F8.4).

* --- 3. two-sample, unequal variances ------------------------------------- .
COMPUTE sd1    = 15.
COMPUTE sd2    = 18.
COMPUTE sd_ave = SQRT((sd1**2 + sd2**2) / 2).
COMPUTE delta2 = 10.
COMPUTE n3 = 2 * (IDF.NORMAL(1 - alpha/2, 0, 1) + IDF.NORMAL(target, 0, 1))**2
             * sd_ave**2 / delta2**2.
LOOP #k = 1 TO 4.
  COMPUTE df = MAX(2 * (RND(n3) - 1), 1).
  COMPUTE n3 = 2 * (IDF.T(1 - alpha/2, df) + IDF.T(target, df))**2
               * sd_ave**2 / delta2**2.
END LOOP.
COMPUTE n3_group = TRUNC(n3) + (MOD(n3,1) > 0).
FORMATS sd_ave n3 (F10.5) n3_group (F6.0).

* --- 4. two-sample, equal variances --------------------------------------- .
COMPUTE sd_eq = 17.
COMPUTE n4 = 2 * (IDF.NORMAL(1 - alpha/2, 0, 1) + IDF.NORMAL(target, 0, 1))**2
             * sd_eq**2 / delta2**2.
LOOP #k = 1 TO 4.
  COMPUTE df = MAX(2 * (RND(n4) - 1), 1).
  COMPUTE n4 = 2 * (IDF.T(1 - alpha/2, df) + IDF.T(target, df))**2
               * sd_eq**2 / delta2**2.
END LOOP.
COMPUTE n4_group = TRUNC(n4) + (MOD(n4,1) > 0).
FORMATS n4 (F10.5) n4_group (F6.0).

* --- 5. paired ------------------------------------------------------------ .
COMPUTE rho    = 0.5.
COMPUTE psd1   = 40.
COMPUTE psd2   = 32.
COMPUTE sd_pair = SQRT(psd1**2 + psd2**2 - 2 * rho * psd1 * psd2).
COMPUTE delta5 = 20.
COMPUTE n5 = (IDF.NORMAL(1 - alpha/2, 0, 1) + IDF.NORMAL(target, 0, 1))**2
             * sd_pair**2 / delta5**2.
LOOP #k = 1 TO 6.
  COMPUTE df = MAX(RND(n5) - 1, 1).
  COMPUTE n5 = (IDF.T(1 - alpha/2, df) + IDF.T(target, df))**2
               * sd_pair**2 / delta5**2.
END LOOP.
COMPUTE n5_pairs = TRUNC(n5) + (MOD(n5,1) > 0).
FORMATS sd_pair n5 (F10.5) n5_pairs (F6.0).

EXECUTE.

* --- report --------------------------------------------------------------- .
VARIABLE LABELS
  n1        'Ex 1  one-sample n (exact root)'
 /n1_enroll 'Ex 1  participants to enroll'
 /power180  'Ex 2  power at n = 180'
 /sd_ave    'Ex 3  root-mean-square sd'
 /n3_group  'Ex 3  per group'
 /n4_group  'Ex 4  per group'
 /sd_pair   'Ex 5  sd of differences'
 /n5_pairs  'Ex 5  pairs'.

LIST VARIABLES = n1 n1_enroll power180 sd_ave n3_group n4_group
                 sd_pair n5_pairs.

* =========================================================================
  Expected from Part B, and how it compares with the exact answer:

      n1          198.1800   (exact 198.1513)  -> 199 either way
      n1_enroll   199
      power180      0.7607   (exact   0.7608)
      sd_ave       16.56804  (exact, no approximation involved)
      n3_group     45        (this block 44.0856, exact root 44.0716)
      n4_group     47        (this block 46.3670, exact root 46.3467)
      sd_pair      36.66061  (exact, no approximation involved)
      n5_pairs     29        (this block 28.3936, exact root 28.3529)

  The approximation never changes the number you would enrol. That is the
  useful lesson: the third decimal place of a power calculation is not
  where the risk in a study design lives. The assumed effect size is.
  ========================================================================= .

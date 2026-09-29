* sample_size.sps  Section 12.6 of Modern Biostatistics, Volume I..

* 1. One-sample: omit N, so it solves for N.              N = 199 .
POWER MEANS ONESAMPLE
  /PARAMETERS TEST=NONDIRECTIONAL SIGNIFICANCE=0.05 POWER=0.80
              MEAN=5 NULL=0 SD=25.

* 2. Same design with N supplied, so it solves for power.
*    Power = .761 .
POWER MEANS ONESAMPLE
  /PARAMETERS TEST=NONDIRECTIONAL SIGNIFICANCE=0.05 N=180
              MEAN=5 NULL=0 SD=25.

* 3. Two groups. SD takes one value PER GROUP, and MEAN takes
*    the two group means, so the difference is 10.
*    NRATIO=1 asks for equal group sizes.        45 per group .
POWER MEANS INDEPENDENT
  /PARAMETERS TEST=NONDIRECTIONAL SIGNIFICANCE=0.05 POWER=0.80
              NRATIO=1 MEAN=0 10 SD=15 18.

* 4. The same with one common standard deviation. 47 per group .
POWER MEANS INDEPENDENT
  /PARAMETERS TEST=NONDIRECTIONAL SIGNIFICANCE=0.05 POWER=0.80
              NRATIO=1 MEAN=0 10 SD=17 17.

* 5. Paired. RELATED wants the SD of the DIFFERENCES, so the
*    collapsing must be done first, exactly as in R:
*        SQRT(40**2 + 32**2 - 2*0.5*40*32) = 36.66061
*                                                  29 pairs .
POWER MEANS RELATED
  /PARAMETERS TEST=NONDIRECTIONAL SIGNIFICANCE=0.05 POWER=0.80
              MEAN=20 SD=36.66061.

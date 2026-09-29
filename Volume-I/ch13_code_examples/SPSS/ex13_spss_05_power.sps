* ex13_spss_05_power.sps.
* Sample-size for a 5 mmHg difference, SD 12, 80% power. Section 13.7.5.
* Requires SPSS Statistics 28 or later. On 27 or earlier, compute in
* G*Power and record the result here.

POWER TTEST INDEPENDENT
  /PARAMETERS TEST = TWOSIDED MEANDIFF = 5 ESPOOLEDSD = 12 NRATIO = 1
  /TEST DIRECTION = TWOSIDED
  /CRITERIA ALPHA = 0.05 POWER = 0.80.

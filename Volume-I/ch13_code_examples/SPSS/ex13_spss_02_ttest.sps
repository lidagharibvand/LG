* ex13_spss_02_ttest.sps.
* Two-sample t-test. Section 13.7.2.

* Create the change score.
COMPUTE sbp_change = sbp_12wk - sbp_baseline.
EXECUTE.

* Independent-samples t-test on the change score.
T-TEST GROUPS = arm("app" "usual")
  /VARIABLES = sbp_change
  /CRITERIA = CI(0.95).

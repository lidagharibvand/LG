* ex13_spss_04_regression.sps.
* Linear regression with adjustment. Section 13.7.4.

* Code arm and sex as numeric for regression.
RECODE arm ("app" = 1) ("usual" = 0) INTO arm_num.
RECODE sex ("F" = 1) ("M" = 0) INTO sex_num.
EXECUTE.

REGRESSION
  /STATISTICS COEFF CI(95) R ANOVA
  /DEPENDENT sbp_12wk
  /METHOD = ENTER arm_num sbp_baseline age sex_num.

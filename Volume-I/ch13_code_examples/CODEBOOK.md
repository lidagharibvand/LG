# Codebook: trial_hypertension.csv

The working dataset for the code examples of Chapter 13. It is synthetic.
It exists so that every listing in Sections 13.5 through 13.7 runs as
printed.

| Variable | Type | Description | Allowed values |
|---|---|---|---|
| id | integer | Anonymous participant identifier | 1 to 480 |
| arm | string | Treatment assignment | app, usual |
| age | numeric | Age in years at randomization | 18.0 to 89.0 |
| sex | string | Recorded sex | F, M |
| sbp_baseline | numeric | Systolic BP at randomization, mmHg | 120.0 to 200.0 |
| sbp_12wk | numeric | Systolic BP at 12 weeks, mmHg | 90.0 to 200.0 |
| bp_target_met | integer | Systolic BP below 140 at 12 weeks | 0, 1 |

Missingness: sbp_12wk is missing for participants lost to follow-up.
Nothing else is missing.

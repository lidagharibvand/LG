# ch13_code_examples

Materials accompanying Chapter 13, Companion Resources and Reproducible Code.

## Run these from the chapter folder, not from R/

The six listings read `data/processed/trial_hypertension.csv`, a path relative
to **this** folder. That is the chapter's own lesson about project-relative
paths, so the listings are printed that way on purpose.

Open `ch13.Rproj` and the working directory is set for you. From a terminal:

```
cd ch13_code_examples
Rscript R/ex13_r_01_load.R
```

Running a script from inside `R/` fails with `does not exist in current
working directory`, which is the error the chapter warns about.

## The listings

| File | What it does |
| --- | --- |
| `R/ex13_r_01_load.R` | Reads the trial dataset and inspects its structure |
| `R/ex13_r_02_describe.R` | Descriptive statistics and a boxplot of change in systolic BP by arm |
| `R/ex13_r_03_ttest.R` | Two-sample t-test on the primary outcome |
| `R/ex13_r_04_chisq.R` | Tests whether more app users met the BP target |
| `R/ex13_r_05_regression.R` | Adjusted analysis of the primary outcome |
| `R/ex13_r_06_power.R` | Sample-size planning for a two-arm trial |

The SAS and SPSS folders hold the same analyses in those languages.

The chapter's exercises also use `../datasets/repo90.csv`, described in
Appendix G.

## Verified

All six R listings were run before release and complete without error when
started from this folder.

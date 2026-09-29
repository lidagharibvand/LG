# D.6 TRIPOD+AI, CONSORT-AI, and SPIRIT-AI, Studies Involving AI Tools

From Appendix D of *Modern Biostatistics for the Health Sciences, Volume I*.

Use when a study develops, validates, or tests a prediction model or an AI-enabled intervention; TRIPOD and TRIPOD+AI are maintained at tripod-statement.org, CONSORT-AI and SPIRIT-AI by their own steering groups, and all are indexed by the EQUATOR Network, download the one matching your study type before writing, since the summary below covers only the shared domains.

The study type is identified: model development, internal validation, external validation, clinical utility, or randomized trial.

The clinical problem, the intended users, and the point in the care pathway where the tool would act are described.

Data sources, eligibility, setting, and dates are reported separately for development and for validation cohorts.

The predicted outcome is defined, with how and when it was determined and whether the assessor was blinded to predictions.

All predictors are defined, with how and when each was measured and how missing values were handled.

The model type, architecture, version, and hyperparameters are reported in enough detail to permit reproduction.

How the model was trained and tuned, and how any class imbalance or resampling was handled, is described.

Performance is reported with both discrimination and calibration, not accuracy alone, and with confidence intervals.

Performance is reported separately within every subgroup where a disparity would matter clinically.

Any human-AI interaction is described: what the user sees, at what point, and how disagreement is resolved.

Error cases, known failure modes, and the plan for post-deployment monitoring are described.

Code, a model card or weights, and de-identified evaluation data are shared, or the reason they are not is stated.

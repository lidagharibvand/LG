# Datasets

The named datasets the exercises in *Modern Biostatistics for the Health Sciences, Volume I* use. Appendix G of the book
describes each one column by column; that description is reproduced
below so the file and its documentation travel together.

`generate_datasets.py` rebuilds every file from a fixed seed, so the
construction can be read rather than taken on trust.

| File | Dataset | Status |
| --- | --- | --- |
| `clinic200.csv` | CLINIC200 | in this folder |
| `codes48.csv` | CODES48 | in this folder |
| `cohort600.csv` | COHORT600 | in this folder |
| `survey300.csv` | SURVEY300 | in this folder |
| `screen2000.csv` | SCREEN2000 | in this folder |
| `irb150.csv` | IRB150 | in this folder |
| `submit200.csv` | SUBMIT200 | in this folder |
| `trial240.csv` | TRIAL240 | in this folder |
| `talks80.csv` | TALKS80 | in this folder |
| `repo90.csv` | REPO90 | in this folder |
| `ehr20k.csv` | EHR20K | in this folder |

## What each one contains

### G.1 CLINIC200

Two hundred adult patients on the panel of a community primary-care clinic, one row per patient. Built so that every level of measurement is represented and so that holding a patient-portal account is associated with age, insurance and satisfaction.

Shape. 200 rows and 14 columns, introduced in Chapter 1.

Column

Type

Values

id

numeric

min 1, max 200, mean 100.500, median 100.5

age

numeric

min 21, max 92, mean 56.570, median 56

sex

text

Female: 114, Male: 86

zip

numeric

min 92324, max 92411, mean 92357.085, median 92354

insurance

text

Commercial: 98, Medicare: 55, Medicaid: 34, Uninsured: 13

portal

text

Yes: 120, No: 80

visits_12mo

numeric

min 0, max 6, mean 1.920, median 2

a1c

numeric

min 4.6, max 10.3, mean 6.511, median 6.5

sbp

numeric

min 88, max 161, mean 123.160, median 122

temp_f

numeric

min 96.5, max 99.7, mean 98.255, median 98.3

pain

text

No pain: 78, Mild: 67, Moderate: 36, Severe: 19

satisfaction

numeric

min 2, max 5, mean 4.035, median 4

responded

text

No: 142, Yes: 58

followup

text

Yes: 117, No: 83


### G.2 CODES48

Forty-eight excerpts drawn from twelve interviews, each assigned one of six codes independently by two coders, with a separate binary judgment of whether the excerpt shows an unmet need. Built so that raw agreement and Cohen’s kappa disagree sharply on the rare judgment.

Shape. 48 rows and 7 columns, introduced in Chapter 2.

Column

Type

Values

excerpt

numeric

min 1, max 48, mean 24.500, median 24.5

interview

numeric

min 1, max 12, mean 6.500, median 6.5

coder_A

text

Communication: 19, Access: 16, Cost: 5, Trust: 3, Transport: 3, Time: 2

coder_B

text

Communication: 19, Access: 14, Trust: 5, Cost: 4, Transport: 3, Time: 3

agree

text

Yes: 42, No: 6

unmet_need_A

text

No: 44, Yes: 4

unmet_need_B

text

No: 44, Yes: 4


### G.3 COHORT600

Six hundred adults followed for two years, with a baseline cardiovascular risk score, whether they joined a worksite wellness program, and whether they were hospitalized. Built so that the crude association is strong and almost entirely produced by who chose to join.

Shape. 600 rows and 7 columns, introduced in Chapter 3.

Column

Type

Values

id

numeric

min 1, max 600, mean 300.500, median 300.5

age

numeric

min 23, max 90, mean 57.832, median 58

sex

text

Female: 315, Male: 285

risk_score

numeric

min 10, max 95, mean 50.077, median 50

smoker

text

No: 406, Yes: 194

program

text

Yes: 314, No: 286

hospitalized

text

No: 349, Yes: 251


### G.4 SURVEY300

Three hundred responses to a clinic experience survey, with ten Likert items of which two are reverse-worded, a randomly assigned wording of item q1, completion times, straightliners, and missing income data.

Shape. 300 rows and 15 columns, introduced in Chapter 5.

Column

Type

Values

id

numeric

min 1, max 300, mean 150.500, median 150.5

version

text

A: 151, B: 149

seconds

numeric

min 30, max 825, mean 265.623, median 231

q1

numeric

min 1, max 5, mean 3.723, median 4

q2

numeric

min 1, max 5, mean 3.647, median 4

q3

numeric

min 1, max 5, mean 3.580, median 4

q4

numeric

min 1, max 5, mean 2.497, median 2

q5

numeric

min 1, max 5, mean 3.650, median 4

q6

numeric

min 1, max 5, mean 3.690, median 4

q7

numeric

min 1, max 5, mean 3.557, median 4

q8

numeric

min 1, max 5, mean 3.573, median 4

q9

numeric

min 1, max 5, mean 2.547, median 2.5

q10

numeric

min 1, max 5, mean 3.650, median 4

income_band

text

25-50k: 77, 50-100k: 75, <25k: 63, >100k: 36, 49 missing

straightlined

text

No: 266, Yes: 34


### G.5 SCREEN2000

Two thousand people screened with a new test, each with true disease status and test result. Built so that a test with excellent sensitivity and specificity has a positive predictive value near 25 percent.

Shape. 2,000 rows and 3 columns, introduced in Chapter 6.

Column

Type

Values

id

numeric

min 1, max 2000, mean 1000.500, median 1000.5

disease

text

No: 1955, Yes: 45

test

text

Negative: 1830, Positive: 170


### G.6 IRB150

One hundred and fifty protocols submitted to a university IRB, with the review level requested and assigned, days to approval, revisions, the reading grade of the consent form, and any vulnerable population.

Shape. 150 rows and 7 columns, introduced in Chapter 8.

Column

Type

Values

protocol

numeric

min 1, max 150, mean 75.500, median 75.5

requested_level

text

Expedited: 65, Exempt: 53, Full board: 32

assigned_level

text

Expedited: 60, Full board: 49, Exempt: 41

days_to_approval

numeric

min 4, max 94, mean 32.893, median 27.5

revisions

numeric

min 0, max 4, mean 1.413, median 1

consent_reading_grade

numeric

min 9.2, max 19.4, mean 14.237, median 14.35

vulnerable_population

text

None: 103, Children: 19, Cognitive impairment: 12, Pregnant: 11, Prisoners: 5


### G.7 SUBMIT200

Two hundred manuscript submissions from one department over three years, with journal tier, registration, reporting checklist, desk rejection, days to first decision, revision rounds, and outcome.

Shape. 200 rows and 8 columns, introduced in Chapter 9.

Column

Type

Values

ms

numeric

min 1, max 200, mean 100.500, median 100.5

journal_tier

text

Mid: 90, Specialty: 68, High: 42

registered

text

No: 115, Yes: 85

checklist_attached

text

Yes: 103, No: 97

desk_reject

text

No: 147, Yes: 53

days_to_first_decision

numeric

min 2, max 180, mean 79.935, median 84.5

revision_rounds

numeric

min 0, max 3, mean 1.085, median 1

outcome

text

Rejected: 128, Accepted: 72


### G.8 TRIAL240

A two-arm randomized trial of a diabetes self-management program, 240 participants across three sites, with baseline and 24-week HbA1c. The week24_a1c column is blank for the 67 who withdrew from study visits; week24_a1c_all adds the values later retrieved from routine records, so both the per-protocol and the intention-to-treat analyses can be run.

Shape. 240 rows and 7 columns, introduced in Chapter 10.

Column

Type

Values

id

numeric

min 1, max 240, mean 120.500, median 120.5

arm

text

Control: 120, Intervention: 120

site

text

Site A: 103, Site B: 83, Site C: 54

baseline_a1c

numeric

min 6, max 11.2, mean 8.391, median 8.3

week24_a1c

numeric

min 5, max 11.3, mean 7.806, median 7.8, 67 missing

completed

text

Yes: 173, No: 67

week24_a1c_all

numeric

min 5, max 12.2, mean 8.064, median 8


### G.9 TALKS80

Eighty fifteen-minute conference talks scored by an audience panel, with slide count, minutes over time, audience comprehension, the speaker’s own estimate of the same thing, and questions asked.

Shape. 80 rows and 6 columns, introduced in Chapter 11.

Column

Type

Values

talk

numeric

min 1, max 80, mean 40.500, median 40.5

slides

numeric

min 8, max 60, mean 33.475, median 32

minutes_over

numeric

min -6, max 18.8, mean 4.062, median 2.25

audience_comprehension

numeric

min 3.8, max 9.6, mean 6.804, median 6.7

speaker_self_rating

numeric

min 4.5, max 10, mean 8.107, median 8.25

questions_asked

numeric

min 0, max 8, mean 4.025, median 4


### G.10 REPO90

An audit of ninety published papers and the code each claimed to share, following the claim through to whether the published numbers could be reproduced.

Shape. 90 rows and 8 columns, introduced in Chapter 13.

Column

Type

Values

paper

numeric

min 1, max 90, mean 45.500, median 45.5

claims_code_available

text

Yes: 76, No: 14

link_resolves

text

Yes: 58, No: 32

code_runs

text

No: 66, Yes: 24

seed_set

text

No: 78, Yes: 12

numbers_reproduce

text

No: 82, Yes: 8

readme_present

text

No: 52, Yes: 38

data_availability

text

On request: 32, Open: 30, None: 28


### G.11 EHR20K

An extract of hospital encounters carrying the defects a real extract carries: duplicate rows, sentinel values, absent readings stored as zero, a set of weights recorded in pounds, negative stays, and missing data.

Shape. 20,214 rows and 6 columns, introduced in Chapter 14.

Column

Type

Values

encounter

numeric

min 1, max 20000, mean 9999.270, median 9997.5

age

numeric

min 0, max 999, mean 54.120, median 52

sbp

numeric

min 0, max 196, mean 127.636, median 128

weight_kg

numeric

min 35, max 274.475, mean 80.550, median 80.3, 1864 missing

los_days

numeric

min -1, max 13, mean 3.108, median 3

dept

text

ED: 6866, Medicine: 6092, Surgery: 3639, Pediatrics: 1810, Obstetrics: 1807


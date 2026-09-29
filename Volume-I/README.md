# Volume I — Modern Biostatistics for the Health Sciences

Companion materials for *Modern Biostatistics for the Health Sciences, Volume I: Health Research Methods and Study Design*, by Lida Gharibvand, PhD.

The interactive companion, with the code running in the browser, the quizzes
and the AI prompt library, is at <https://lgera.com/vol1/>.

## What is here

| Folder | What it holds |
| --- | --- |
| `ch01_introduction` … `ch14_big_data` | One folder per chapter, named as the book prints it |
| `datasets/` | The 11 named datasets, with Appendix G's description of each |
| `checklists/` | The 9 reporting and design checklists from Appendix D |
| `ai-prompts/` | The research-methods prompt library from Appendix C |
| `capstone/` | The 10 capstone project briefs |
| `figures/` | Figures released for reuse |

## The chapter folder names are load-bearing

Section 13.2 and Chapter 12 both print paths into this repository, so the
folder names cannot change without making a printed page wrong. If a future
edition inserts a chapter, tag this repository for the edition rather than
renumbering the folders, and let a reader check out the tag that matches
their printing.

## One naming inconsistency, flagged rather than fixed

Chapter 12 names the R program `ex12_r_01_power.R` where it names its four
siblings `lab_sample_size.sas`, `lab_sample_size.sps`, `lab_sample_size.py`
and `lab_sample_size.xlsx`. Both names are shipped, with identical content,
so either printed reference resolves. The next edition should settle on one.

## Datasets

Two files carry deliberate defects and are meant to be cleaned rather than
used as they arrive: `codes48.csv` and `ehr20k.csv`. The rest are ready to
read. None of them contains real participant data.

## Running the code

The R scripts need base R and nothing else unless their own header says
otherwise. The chapter 13 listings read
`ch13_code_examples/data/processed/trial_hypertension.csv`, which is
committed so that the listings run exactly as printed.

## Licence

See `LICENSE`. The datasets are synthetic and may be reused freely for
teaching; please cite the book.

# AI prompt library for research methods

Appendix C of *Modern Biostatistics for the Health Sciences, Volume I*.

Each prompt is written to make an assistant explain, question or
check rather than hand over a finished thing. Every one of them
still needs its answer verified against a source you trust.

**Never paste identifiable participant data, protected health
information or confidential research material into a
general-purpose AI system.**

The prompts below are organized by research task rather than by chapter, because that is how you will reach for them. Each one expects you to supply your own study details where square brackets appear. None of them will defend a design decision for you; every one of them assumes you will verify what comes back against a primary source before it enters a protocol or a manuscript.

## C.1 Framing a Research Question

Prompts for turning a vague idea into a question a study can actually answer, and for testing whether that question is worth the resources it would consume.

PICO reconstruction. I am planning a study of [your topic] in [your population]. Restate my idea as a PICO question, naming the population, the intervention or exposure, the comparator, and the outcome separately. Where I have not specified an element, say so explicitly rather than inventing one, and list everything you had to leave blank.

FINER critique. Here is my draft research question: [paste question]. Critique it against each of the five FINER criteria (feasible, interesting, novel, ethical, relevant) and for each one, tell me what evidence I would have to gather myself in order to decide. Do not tell me whether the question is novel; tell me how to check.

Narrowing a broad topic. My topic is [broad topic] and my setting is [your clinic, school, or health system]. Propose six narrower questions at different levels of ambition, from a single-site descriptive study to a multi-site trial. For each one, name the design it would require and the resource that would be hardest for me to obtain.

Outcome definition audit. My primary outcome is [your outcome]. Ask me the questions a methods reviewer would ask in order to pin this outcome down: how it is measured, by whom, at what time point, with which instrument, and how missing values are handled. Produce the questions only, do not answer any of them for me.

Testing the comparison. My study compares [group A] with [group B]. List every way these two groups could differ apart from the exposure I care about. Mark which of those differences I could measure and adjust for, and which I could only address by changing the design itself. I will verify each one against my own setting.

Literature framing, verified separately. Summarize how researchers have typically framed the question of [your topic] and which study designs they have used. Then list the specific search terms and databases I should use to confirm your summary myself. Do not supply citations. I will find and read the primary sources before citing anything.

## C.2 Choosing a Study Design

Prompts that lay out the design options open to a question and make the tradeoffs explicit, while leaving the choice with the investigator who has to defend it.

Design options with tradeoffs. My question is [your PICO question]. Lay out three study designs that could address it, for example a cross-sectional survey, a retrospective cohort, and a randomized trial. For each, state what it could establish, what it could not, and its principal threat to validity. Do not recommend one.

Argue both sides of randomization. I am considering an observational design for [your question]. Argue as forcefully as you can that a randomized trial would be feasible and ethical here, then argue the opposite. I will decide which argument survives contact with my setting, and I will record my reasoning in writing.

Cohort versus case-control. My outcome is [your outcome] and my exposure is [your exposure], with an approximate outcome frequency of [rate]. Explain when a cohort design and when a case-control design would be the more efficient choice given those numbers. Ask me for any figure you need rather than assuming one.

Quasi-experimental fallbacks. Randomization is not possible in my setting because [your constraint]. Describe the quasi-experimental designs that could still support a defensible causal claim here, and for each one name the assumption that must hold and the specific check I could run to see whether it does.

Unit of assignment. My intervention is delivered at the level of [clinic, ward, classroom, or individual]. Explain the consequences of randomizing at that level rather than at the individual level, including contamination between arms, intra-cluster correlation, and what the resulting design effect would do to my required sample size.

Design flaw hunt. Here is my draft design paragraph: [paste paragraph]. Play a skeptical reviewer. List every ambiguity, unstated assumption, and missing detail you find, phrased as a question rather than a correction. Rank them by how much each one would weaken the study if I left it unresolved.

Matching the design to the claim. I want my paper to be able to claim [your intended claim]. Work backward: state what design, comparison, and timing would be required to support that exact sentence, and then say plainly what weaker claim my current design of [your design] would actually license instead.

## C.3 Qualitative Design and Coding

Prompts for the five traditions of qualitative inquiry, for building a codebook, and for keeping participant voice intact when a model summarizes fluently.

Choosing a tradition. I want to understand [your phenomenon] among [your participants]. Compare narrative, phenomenology, grounded theory, ethnography, and case study as approaches to this question, naming the unit of analysis and the kind of claim each one supports. Do not pick a tradition for me.

Interview guide draft. Draft a semi-structured interview guide of eight open questions with probes, on the topic of [your topic], for [your participants]. Flag any question that is leading, double-barreled, or presupposes an experience the participant may not have had. I will pilot the guide before fielding it.

First-pass codes with evidence. Here is one de-identified transcript excerpt: [paste excerpt]. Propose an initial set of open codes, and for each code quote the exact span of text that supports it. I will verify that every quoted span really appears in my transcript before I adopt any code.

Codebook definitions. Here are my draft code names: [paste codes]. For each, write a one-sentence definition, an inclusion rule, an exclusion rule, and a boundary case that distinguishes it from the nearest neighboring code. I will refine these against the data and with my second coder.

Diagnosing coder disagreement. My second coder and I disagree on these excerpts: [paste excerpts and both codings]. For each one, describe what a coder would have had to believe about my definition in order to reach each coding. Do not adjudicate, help me see where the definition is ambiguous.

Reasoning about saturation. I have completed [number] interviews in a [tradition] study of [your topic]. Explain what saturation means within this tradition, what evidence would show that I have reached it, and what evidence would show that I have not. The judgment about my own data remains mine.

Auditing a summary against transcripts. Here is a thematic summary I drafted: [paste summary]. For each theme, tell me what I would need to find in the transcripts to support it, and identify any place where the summary flattens disagreement, smooths over a contradiction, or loses a minority perspective.

## C.4 Survey and Instrument Development

Prompts for drafting items, testing them for clarity, and planning the validation work that makes a new instrument usable by someone other than its author.

Item variants for review. Draft six variants of a survey item measuring [your construct] for [your population], at a sixth-to-eighth-grade reading level. For each variant, note the response scale and its level of measurement. Every variant will go to expert review and cognitive testing before any of it is fielded.

Wording problems. Here are my draft items: [paste items]. Flag every item that is double-barreled, leading, ambiguous, or that assumes access or experience the respondent may lack, and every item that uses clinical jargon. Suggest a repair for each, and say which repairs change what the item measures.

Response scale fit. My construct is [your construct] and my analysis plan is [your plan]. Explain which response formats (binary, ordinal Likert, visual analog, count) fit that construct, and what each one would permit and forbid at the analysis stage given its level of measurement.

Cognitive interview probes. For this item, [paste item], write the probes a cognitive interviewer would use to learn how respondents understand the key terms, how they retrieve the information, and how they map their answer onto the scale. I will run the interviews with real respondents from my population.

Validation plan outline. I am developing a new instrument to measure [your construct] in [your population]. Outline the sequence of validation work (content validity, face validity, pilot testing, reliability, construct validity, and where relevant criterion validity and measurement invariance) and say what a shortfall at each step would mean.

Translation review. Here is an item in English and its [target language] translation: [paste both]. Identify concepts that may not carry across, idioms that will not translate, and response options that imply a different scale. Flag them for a bilingual expert panel, your reading does not substitute for theirs.

Data-integrity defenses. My survey will be fielded online to [your population], with [incentive, if any]. List the defenses I should build in against automated, duplicate, or fraudulent responses (attention checks, completion-time thresholds, device checks, manual review of open text) and the respondent burden each one adds.

## C.5 Bias, Validity, and Reliability Review

Prompts that turn a design or a draft into a named list of threats, with a concrete check attached to every one of them.

Named-bias inventory. Here is my methods paragraph: [paste paragraph]. Identify which of the biases named in this volume could plausibly operate here (selection, recall, misclassification, social desirability, attrition, regression to the mean, Hawthorne, interviewer, diffusion of treatment) and for each, say what in my design would let it in.

Direction of bias. In my study, [describe a specific measurement or selection problem]. Reason through whether this would bias my estimate toward the null or away from it, and state the assumptions your reasoning depends on, so that I can check whether those assumptions hold in my data.

Internal versus external validity. My study enrolls [your sampling frame] at [your setting]. List the features of this design that strengthen internal validity, the features that limit generalization, and the specific populations to whom my result would not transfer. I will write the limitations paragraph myself.

Reliability plan. My instrument is [describe the instrument] and my raters are [describe the raters]. Explain which reliability coefficients apply here (internal consistency, test-retest, inter-rater, intra-rater) how each is computed, and what value would be considered inadequate in my field, with the reason.

Interpreting alpha honestly. My Cronbach alpha for a [number]-item scale is [value] in a sample of [n]. Explain what this does and does not tell me, including why a high alpha can reflect redundant items and why alpha rises with the number of items. Do not tell me the scale is validated.

Subgroup performance plan. I am evaluating a predictive model for [your use case]. List the subgroups in which performance should be reported separately, the fairness metrics that could apply, and the tradeoffs among them. The choice of metric is a judgment I have to defend, so give me the arguments rather than a verdict.

Confounders, mediators, colliders. My exposure is [your exposure] and my outcome is [your outcome] in [your population]. List plausible confounders and, separately, variables that would act as mediators or colliders. Explain why adjusting for each type has a different consequence. I will confirm every candidate against subject-matter knowledge.

## C.6 Ethics, Consent, and IRB Preparation

Prompts for assembling an IRB submission and for writing consent language a participant can actually use, never for deciding what a board will approve.

Review pathway reasoning. Here is my study: [your procedures, population, and data]. Explain how exempt, expedited, and full-board review differ, and which features of my study would push it toward each. The determination belongs to the IRB, not to me and not to you, so tell me what to ask them.

Plain-language consent draft. Draft a Key Information summary for a consent form describing [your study], at an eighth-grade reading level, covering purpose, duration, procedures, foreseeable risks, benefits, alternatives, confidentiality, and the right to withdraw. My institutional template and required language take precedence over anything you write.

Readability repair. Here is a paragraph from my consent form: [paste paragraph]. Rewrite it at a lower reading level without removing any required element, then list every term you simplified and what you replaced it with, so I can confirm that the meaning did not shift.

Risk enumeration. My procedures are [list procedures], in [your population]. Enumerate the foreseeable physical, psychological, social, legal, and economic risks, and for each one the mitigation an IRB would expect to see described in the protocol. I will assess which of them actually apply in my setting.

Vulnerable-population safeguards. My study will enroll [describe population, for example children, prisoners, or people with cognitive impairment]. Explain the additional safeguards that apply, including assent, parental permission, independent advocacy, and limits on compensation, and state what the protocol must say about each of them.

Data-flow description. My study will send [describe the data] to [describe the tool or service] for [describe the purpose]. Write the data-flow paragraph an IRB would want to see, naming what leaves the institution, in what form, under what agreement, and who retains it. I will confirm every fact with information security.

Amendment triggers. Here is my approved protocol summary: [paste summary]. Here is a change I am considering: [describe the change]. Explain which kinds of change normally require an approved amendment before implementation and which are typically administrative, then draft the questions I should put to my IRB coordinator.

## C.7 Sample-Size Planning

Prompts for drafting and auditing a sample-size justification, on the standing condition that every number is re-run in dedicated software before it reaches a protocol.

Justification paragraph draft. Draft a sample-size justification for: primary outcome [outcome], analysis [test], assumed effect [effect], variability [standard deviation or baseline rate], alpha [value], power [value], allocation [ratio], expected dropout [percent]. Cover all five required elements. I will re-run the calculation in dedicated software before this paragraph enters a protocol.

Power code with an independent check. Write R code using the pwr package to compute the sample size for [describe the comparison and the assumptions]. Then write a second, independent block (a simulation, or a different package) that should return the same answer, so that I can compare the two results rather than trusting either one.

Where the effect size comes from. My assumed effect size is [value] for [your outcome]. List the legitimate sources for such an assumption (prior trials, pilot data, a minimum clinically important difference) and the questions I should ask of each source. Do not supply a value or a citation; the assumption is mine to defend.

Sensitivity table. Build a sensitivity table of required sample size across effect sizes of [three values] and standard deviations of [three values], at alpha [value] and power [value], for a [design]. Show the formula behind the table so that I can verify each cell independently in software.

Inflation factors, step by step. My analyzable target is [n] participants. Walk through every inflation that applies to my study: dropout of [percent], survey non-response of [percent], clustering with average cluster size [m] and intra-cluster correlation [value], and any multiplicity adjustment. Show each step separately so I can check the arithmetic.

Auditing another protocol. Here is a sample-size paragraph from a protocol I am reviewing: [paste paragraph]. List what is missing, what is internally inconsistent, and where the stated analysis does not match the formula the numbers imply. Phrase each finding as a question for the authors rather than as a correction.

Design and formula mismatch. My design is [crossover, cluster-randomized, paired, non-inferiority, or other]. Explain why a standard two-sample parallel-group formula would be wrong here and what the correct approach requires. Models frequently misapply formulas to these designs, so I will confirm the method in a primary statistical reference.

## C.8 Manuscript Drafting and Revision

Prompts for turning results into prose, stress-testing a draft, and answering reviewers, with verification built into the wording of each request.

Methods notes into prose. Convert these methods notes into a Methods section in the past tense and an impersonal voice: [paste notes]. Add nothing I did not write. If a detail a reader would need is missing, list it as a gap at the end instead of filling it in yourself.

Introduction structure check. Here is my draft Introduction: [paste draft]. Check whether it does the three jobs in order (establishes what is known, names the gap, states the question and the aim) and mark every sentence that belongs in the Discussion instead of here.

Results without interpretation. Here is my results text: [paste text]. Flag every sentence that interprets rather than reports, every effect reported without a confidence interval, and every number that appears in the text but not in a table. I will reconcile each flagged item against my output files.

Discussion in five paragraphs. Here is my Discussion: [paste draft]. Map it against the five-paragraph structure (principal finding, comparison with prior work, explanation or mechanism, limitations, conclusion and implications) and tell me which paragraph is doing two jobs at once and which one is missing entirely.

Overclaiming hunt. Here are my abstract and conclusion: [paste text]. My design is [your design]. Flag every sentence whose claim is stronger than that design supports, particularly causal language in an observational study, and propose alternative wording that matches the evidence I actually have.

Citation verification list. Here is a paragraph of my draft: [paste paragraph]. For each factual claim, tell me what kind of source would support it and what specifically I should check in that source. Do not generate references; models fabricate plausible citations, and I will locate and read every source myself.

Reviewer response draft. Here is a reviewer comment: [paste comment]. Here is what I did about it: [describe the change]. Draft a point-by-point response that states the change, gives the page and line, and stays courteous where I disagree. I will confirm every line reference against the revised file.

AI-use disclosure statement. I used [tool and version] on [dates] to [describe the task] while preparing this manuscript. Draft the disclosure statement that journals now expect, naming the tool, the purpose, and confirming that the human authors verified all content and take full responsibility for it.

## C.9 Presentations and Posters

Prompts for drafting a talk or a poster, on the understanding that the model writes the words and the investigator decides which result is the headline.

Talk outline from an abstract. Here is my abstract: [paste abstract]. Propose a ten-slide outline for a fifteen-minute talk, with a sentence title for each slide and a note on how long it should take. Say which slide you think carries the headline, and I will decide whether you are right.

Sentence titles. Here are my slide headings: [paste headings]. Rewrite each one as a full sentence that states the point of the slide rather than naming its topic. Offer three candidates per slide so that I can choose the one that matches what the data show.

Speaker notes from results. Turn this results paragraph into spoken-language speaker notes for a single slide: [paste paragraph]. Keep it under ninety seconds when read aloud, and do not add any number, comparison, or interpretation that is not already present in the paragraph I gave you.

Figure critique. Here is a description of my figure: [describe the axes, marks, colors, and annotation]. Identify clutter, unclear axes, unlabeled units, and likely problems for readers with color-vision deficiency. Then tell me what to confirm with an actual accessibility simulator rather than by your judgment alone.

Poster layout. My poster is [dimensions], for [conference and audience], reporting [your study]. Propose a column layout, a reading order, and a rough word budget per section, prioritizing the single message a passerby should be able to take away from three feet without stopping.

Anticipating hard questions. Here is my talk outline and my principal limitation: [paste both]. Write the ten hardest questions a skeptical audience could ask, ranked by difficulty. Do not draft my answers. I will prepare those myself and rehearse them aloud in front of colleagues.

## C.10 Reproducibility and Code

Prompts for drafting analysis code, documentation, and project structure, where every line is read before it is run and every result is checked against a known answer.

Analysis script draft. Write R code that reads [describe your file and columns] and performs [describe the analysis]. Comment every line. List separately any assumption you made about my data (variable names, types, coding of missing values) that I did not state, so that I can verify each one against my codebook.

Known-answer test. For the analysis [describe the analysis], write a short script that runs it on a small simulated or built-in dataset whose correct answer can be checked by hand or against a textbook example. I will confirm the test result before running any of this code on my real data.

Line-by-line explanation. Explain this script line by line, in plain language: [paste code]. Wherever a line makes a choice (a join type, a filter, a default argument, a method for handling missing values) say what the alternatives were and what would change if a different choice were the correct one.

Translation with verification. Translate this R script into SAS: [paste code]. Note every place where the default behavior of the two languages differs, especially in missing-value handling and factor coding. I will run both versions on the same dataset and compare the output before trusting the translation.

Codebook draft. Here is the header row and five de-identified rows of my dataset: [paste rows]. Draft a codebook table with variable name, type, description, units, and allowed values. Mark every field you inferred rather than read, so that I can correct it against the data-collection instrument.

README draft. My project analyzes [describe the study] using [software and version]. Draft a README that answers what the project is, how to install what is needed to run it, how to reproduce the main results script by script and in what order, and whom to contact under what license.

Missing-data plan. My dataset has [describe the pattern and amount of missingness] in [variables]. Explain the three missingness mechanisms, which analyses each one would justify, and what I would need to show in order to argue for one. Draft the reporting paragraph; the mechanism assumption is mine to defend.

## C.11 Judging What a Model Gives Back

Each chapter of this volume closes with four AI Practice drills. There is no answer key for them, because the assessable work is your critique rather than the model’s output. Use the questions below as the rubric.

A rubric for AI Practice

Did the model supply an assumption that I did not? A good answer names each supplied assumption explicitly (the population, the comparator, the outcome definition, the time horizon, the level of measurement) and says which of them you would have chosen differently. A bad answer accepts the output whole because it reads fluently and arrives organized.

Did I verify every factual claim against a primary source? A good answer points to the source you actually opened and read for each claim, and notes wherever the summary you were given differed from what the source said. A bad answer treats the confidence of the output, or its agreement with what you already believed, as the verification.

Did I catch the fabricated citation? A good answer reports that you searched for every reference by title, author, and year, and identifies which ones did not exist or did not say what was attributed to them. A bad answer is any paragraph of yours that carries a reference you have not located and read in full.

Did protected and unpublished data stay out of the tool? A good answer confirms that only de-identified or synthetic material was entered, in an institutionally approved tool, with the data flow documented. A bad answer contains any identifiable record, unblinded interim result, or unpublished pilot dataset that was pasted into a public chatbot for convenience.

Is the analytic judgment still mine? A good answer shows that the design, the effect-size assumption, the choice of primary outcome, and the interpretation were decided by you and can be defended without reference to the model. A bad answer offers the model as the reason a parameter was set where it was set.

Did I test the code, or only read it approvingly? A good answer records the known-answer test or the independent second implementation you ran, and the comparison between the two results. A bad answer is a script that ran without error, which is evidence that the syntax was valid and evidence of nothing else.

Could another researcher repeat what I did with the model? A good answer records the tool name and version, the exact prompt, the date, and the output, because model behavior changes over time even when the name does not. A bad answer is a step in your workflow that nobody, including you, could reconstruct six months from now.

Would I disclose this use, and in what words? A good answer drafts the disclosure Chapter 13 recommends: the tool and version, the date, the specific task, and a statement that the human authors verified the content and take responsibility for it. A bad answer is any use you would prefer not to describe in the methods.

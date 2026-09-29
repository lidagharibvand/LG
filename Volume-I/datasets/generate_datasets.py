"""The named datasets for Appendix G. Each one is synthetic, describes no real
person, and is built so that its chapter's Chapter Problem behaves the way the
chapter needs it to."""
import numpy as np, pandas as pd, json
R = lambda s: np.random.default_rng(s)
OUT = {}

# ---------------------------------------------------- Ch2  CODES48 ----------
rng = R(202); n = 48
codes = ['Access', 'Communication', 'Cost', 'Trust', 'Transport', 'Time']
p = [.34, .28, .14, .10, .08, .06]                 # deliberately unbalanced
a = rng.choice(codes, n, p=p)
b = a.copy()
flip = rng.random(n) < 0.21                        # coder B disagrees on ~21%
b[flip] = rng.choice(codes, flip.sum(), p=p)
disagree = a != b
# a second, binary judgement: does the excerpt show an UNMET NEED?
truth = rng.random(n) < 0.14
fA = np.where(truth, rng.random(n) < 0.72, rng.random(n) < 0.05)
fB = np.where(truth, rng.random(n) < 0.68, rng.random(n) < 0.06)
codes48 = pd.DataFrame({'excerpt': np.arange(1, n+1),
                        'interview': np.repeat(np.arange(1, 13), 4),
                        'coder_A': a, 'coder_B': b,
                        'agree': np.where(disagree, 'No', 'Yes'),
                        'unmet_need_A': np.where(fA, 'Yes', 'No'),
                        'unmet_need_B': np.where(fB, 'Yes', 'No')})
codes48.to_csv('data/codes48.csv', index=False)
po = (~disagree).mean()
pe = sum((a == c).mean() * (b == c).mean() for c in codes)
kappa = (po - pe) / (1 - pe)
po2 = (fA == fB).mean()
pe2 = fA.mean()*fB.mean() + (1-fA.mean())*(1-fB.mean())
k2 = (po2 - pe2) / (1 - pe2)
OUT['CODES48_binary'] = {'both_yes': int((fA & fB).sum()), 'A_only': int((fA & ~fB).sum()),
                         'B_only': int((~fA & fB).sum()), 'both_no': int((~fA & ~fB).sum()),
                         'raw_agreement': round(100*po2, 1), 'pe': round(pe2, 4),
                         'kappa': round(k2, 3),
                         'A_yes': int(fA.sum()), 'B_yes': int(fB.sum())}
OUT['CODES48'] = {'n': n, 'raw_agreement': round(100*po, 1), 'pe': round(pe, 4),
                  'kappa': round(kappa, 3),
                  'A_counts': pd.Series(a).value_counts().to_dict(),
                  'B_counts': pd.Series(b).value_counts().to_dict(),
                  'new_codes_by_interview': [int(len(set(a[:4*k]))) for k in range(1, 13)]}

# ---------------------------------------------------- Ch3  COHORT600 --------
rng = R(303); n = 600
risk = np.clip(rng.normal(50, 14, n), 10, 95).round(0).astype(int)   # baseline risk score
# healthier people are likelier to join the wellness program
pj = 1/(1+np.exp(-(-0.055*(risk-50) + 0.1)))
prog = np.where(rng.random(n) < pj, 'Yes', 'No')
# the OUTCOME depends only on risk, not on the program at all
ph = 1/(1+np.exp(-(-3.1 + 0.055*risk)))
hosp = np.where(rng.random(n) < ph, 'Yes', 'No')
age = np.clip(rng.normal(30 + 0.55*risk, 9, n), 18, 90).round(0).astype(int)
sex = rng.choice(['Female','Male'], n, p=[.53,.47])
smoke = np.where(rng.random(n) < 1/(1+np.exp(-(-2.6+0.035*risk))), 'Yes','No')
cohort = pd.DataFrame({'id':np.arange(1,n+1),'age':age,'sex':sex,'risk_score':risk,
                       'smoker':smoke,'program':prog,'hospitalized':hosp})
cohort.to_csv('data/cohort600.csv', index=False)
band = pd.cut(cohort.risk_score, [0,40,60,100], labels=['low','medium','high'])
cohort['band'] = band
crude = cohort.groupby('program', observed=True).hospitalized.apply(lambda s:(s=='Yes').mean())
strat = {str(b): {str(k): [int((g.hospitalized=='Yes').sum()), int(len(g))]
                  for k,g in cohort[cohort.band==b].groupby('program', observed=True)}
         for b in ['low','medium','high']}
OUT['COHORT600'] = {'n': n,
   'program_yes': int((prog=='Yes').sum()), 'program_no': int((prog=='No').sum()),
   'crude_hosp_pct': {k: round(100*v,1) for k,v in crude.items()},
   'by_band': strat,
   'mean_risk_by_program': {k: round(v,1) for k,v in cohort.groupby('program', observed=True).risk_score.mean().items()},
   'hosp_total': int((hosp=='Yes').sum())}

# ---------------------------------------------------- Ch4  SURVEY300 --------
rng = R(404); n = 300
version = rng.choice(['A','B'], n)          # two wordings of item 1
latent = rng.normal(0, 1, n)
def likert(mu, sd=0.9):
    return np.clip(np.round(rng.normal(mu, sd)), 1, 5).astype(int)
items = {}
for i in range(1, 11):
    items[f'q{i}'] = likert(3.7 + 0.55*latent)
# item 1 is the one whose wording differs; version B is loaded toward agreement
items['q1'] = np.clip(np.round(3.5 + 0.55*latent + np.where(version=='B',0.62,0) + rng.normal(0,0.9,n)),1,5).astype(int)
# items 4 and 9 are reverse-worded
items['q4'] = 6 - items['q4']; items['q9'] = 6 - items['q9']
S = pd.DataFrame(items)
# straightliners: identical answer to every item
straight = rng.random(n) < 0.13
for idx in np.where(straight)[0]:
    v = rng.integers(3,6)
    S.iloc[idx] = v
secs = np.clip(rng.lognormal(np.log(260),0.5,n),35,2400).round(0).astype(int)
secs[straight] = np.clip(rng.lognormal(np.log(58),0.35,straight.sum()),25,180).round(0).astype(int)
S.insert(0,'seconds',secs); S.insert(0,'version',version); S.insert(0,'id',np.arange(1,n+1))
# item-level missingness, heavier on the income question
S['income_band'] = rng.choice(['<25k','25-50k','50-100k','>100k'], n, p=[.22,.3,.3,.18])
S.loc[rng.random(n) < 0.17, 'income_band'] = np.nan
S['straightlined'] = np.where(straight,'Yes','No')
S.to_csv('data/survey300.csv', index=False)
top2 = lambda v: round(100*(v>=4).mean(),1)
OUT['SURVEY300'] = {'n': n,
  'version_counts': pd.Series(version).value_counts().to_dict(),
  'q1_top2_A': top2(S.q1[version=='A']), 'q1_top2_B': top2(S.q1[version=='B']),
  'q1_top2_all': top2(S.q1),
  'straightliners': int(straight.sum()),
  'median_seconds_all': int(S.seconds.median()),
  'median_seconds_straight': int(S.seconds[straight].median()),
  'median_seconds_other': int(S.seconds[~straight].median()),
  'income_missing': int(S.income_band.isna().sum())}

# ---------------------------------------------------- Ch5  SCREEN2000 -------
rng = R(505); N = 2000
prev = 0.02
dis = rng.random(N) < prev
sens, spec = 0.92, 0.94
pos = np.where(dis, rng.random(N) < sens, rng.random(N) < (1-spec))
screen = pd.DataFrame({'id':np.arange(1,N+1),
                       'disease':np.where(dis,'Yes','No'),
                       'test':np.where(pos,'Positive','Negative')})
screen.to_csv('data/screen2000.csv', index=False)
TP=int((dis&pos).sum()); FN=int((dis&~pos).sum()); FP=int((~dis&pos).sum()); TN=int((~dis&~pos).sum())
OUT['SCREEN2000']={'N':N,'TP':TP,'FN':FN,'FP':FP,'TN':TN,
  'disease_total':TP+FN,'test_pos_total':TP+FP,
  'sensitivity':round(100*TP/(TP+FN),1),'specificity':round(100*TN/(TN+FP),1),
  'PPV':round(100*TP/(TP+FP),1),'NPV':round(100*TN/(TN+FN),1),
  'prevalence':round(100*(TP+FN)/N,2)}

# ---------------------------------------------------- Ch6  IRB150 -----------
rng = R(606); n = 150
requested = rng.choice(['Exempt','Expedited','Full board'], n, p=[.38,.42,.20])
bump = rng.random(n) < 0.29
assigned = requested.copy()
order = {'Exempt':'Expedited','Expedited':'Full board','Full board':'Full board'}
assigned[bump] = [order[r] for r in requested[bump]]
days = np.where(assigned=='Exempt', rng.integers(4,19,n),
        np.where(assigned=='Expedited', rng.integers(11,41,n), rng.integers(28,96,n)))
revisions = np.where(assigned=='Full board', rng.integers(1,5,n), rng.integers(0,3,n))
grade = np.clip(rng.normal(14.2,1.9,n),8.1,19.4).round(1)
vuln = rng.choice(['None','Children','Prisoners','Cognitive impairment','Pregnant'],
                  n, p=[.66,.14,.04,.09,.07])
irb = pd.DataFrame({'protocol':np.arange(1,n+1),'requested_level':requested,
                    'assigned_level':assigned,'days_to_approval':days,
                    'revisions':revisions,'consent_reading_grade':grade,
                    'vulnerable_population':vuln})
irb.to_csv('data/irb150.csv', index=False)
OUT['IRB150']={'n':n,'requested':pd.Series(requested).value_counts().to_dict(),
  'assigned':pd.Series(assigned).value_counts().to_dict(),
  'escalated':int(bump.sum()),
  'median_days':{k:int(v) for k,v in irb.groupby('assigned_level').days_to_approval.median().items()},
  'grade_mean':round(float(grade.mean()),1),'grade_min':float(grade.min()),'grade_max':float(grade.max()),
  'at_or_below_8':int((grade<=8.0).sum()),'above_12':int((grade>12).sum()),
  'vulnerable':pd.Series(vuln).value_counts().to_dict()}

# ---------------------------------------------------- Ch7  SUBMIT200 --------
rng = R(707); n = 200
reg = rng.choice(['Yes','No'], n, p=[.44,.56])
chk = np.where(reg=='Yes', rng.choice(['Yes','No'],n,p=[.72,.28]), rng.choice(['Yes','No'],n,p=[.31,.69]))
lin = -1.15 + 0.85*(chk=='Yes') + 0.35*(reg=='Yes')
acc = np.where(rng.random(n) < 1/(1+np.exp(-lin)), 'Accepted','Rejected')
desk = np.where((acc=='Rejected') & (rng.random(n)<0.42), 'Yes','No')
days = np.where(desk=='Yes', rng.integers(2,13,n), rng.integers(28,181,n))
tier = rng.choice(['High','Mid','Specialty'], n, p=[.22,.45,.33])
rounds = np.where(acc=='Accepted', rng.integers(1,4,n), rng.integers(0,3,n))
sub = pd.DataFrame({'ms':np.arange(1,n+1),'journal_tier':tier,'registered':reg,
                    'checklist_attached':chk,'desk_reject':desk,
                    'days_to_first_decision':days,'revision_rounds':rounds,
                    'outcome':acc})
sub.to_csv('data/submit200.csv', index=False)
OUT['SUBMIT200']={'n':n,'accepted':int((acc=='Accepted').sum()),
  'acc_by_checklist':{k:[int((g.outcome=='Accepted').sum()),int(len(g))] for k,g in sub.groupby('checklist_attached')},
  'acc_by_registered':{k:[int((g.outcome=='Accepted').sum()),int(len(g))] for k,g in sub.groupby('registered')},
  'desk_rejects':int((desk=='Yes').sum()),
  'median_days_desk':int(sub[sub.desk_reject=='Yes'].days_to_first_decision.median()),
  'median_days_review':int(sub[sub.desk_reject=='No'].days_to_first_decision.median()),
  'tier':pd.Series(tier).value_counts().to_dict()}

# ---------------------------------------------------- Ch8/10 TRIAL240 -------
rng = R(808); n = 240
arm = np.array(['Intervention']*120 + ['Control']*120); rng.shuffle(arm)
site = rng.choice(['Site A','Site B','Site C'], n, p=[.42,.33,.25])
base = np.clip(rng.normal(8.4,1.1,n),6.0,12.5).round(1)          # baseline HbA1c
true_eff = -0.42
wk24 = base + np.where(arm=='Intervention', true_eff, 0) + rng.normal(-0.15,0.72,n)
wk24 = np.round(np.clip(wk24,5.0,13.0),1)
# dropout is differential AND related to poor response
pdrop = 1/(1+np.exp(-(-2.9 + 0.8*(arm=='Intervention') + 2.6*((wk24-base) > -0.1))))
drop = rng.random(n) < pdrop
trial = pd.DataFrame({'id':np.arange(1,n+1),'arm':arm,'site':site,
                      'baseline_a1c':base,'week24_a1c':np.where(drop,np.nan,wk24),
                      'completed':np.where(drop,'No','Yes')})
trial.to_csv('data/trial240.csv', index=False)
chg_all = wk24 - base
pp = trial.dropna(subset=['week24_a1c'])
pp_chg = pp.week24_a1c - pp.baseline_a1c
OUT['TRIAL240']={'n':n,'per_arm':120,
  'completed':int((~drop).sum()),'dropped':int(drop.sum()),
  'dropped_by_arm':{k:int(v) for k,v in pd.Series(drop).groupby(arm).sum().items()},
  'ITT_mean_change':{a: round(float(chg_all[arm==a].mean()),3) for a in ['Intervention','Control']},
  'ITT_diff': round(float(chg_all[arm=='Intervention'].mean()-chg_all[arm=='Control'].mean()),3),
  'PP_mean_change':{a: round(float(pp_chg[pp.arm==a].mean()),3) for a in ['Intervention','Control']},
  'PP_diff': round(float(pp_chg[pp.arm=='Intervention'].mean()-pp_chg[pp.arm=='Control'].mean()),3),
  'baseline_mean':round(float(base.mean()),2),'baseline_sd':round(float(base.std(ddof=1)),3),
  'change_sd':round(float(pp_chg.std(ddof=1)),3),
  'site':pd.Series(site).value_counts().to_dict()}

# ---------------------------------------------------- Ch9  TALKS80 ----------
rng = R(909); n = 80
slides = rng.integers(8, 61, n)
overrun = np.round(np.clip(0.42*(slides-24) + rng.normal(0,2.4,n), -6, 22),1)
comp = np.round(np.clip(8.6 - 0.055*slides + rng.normal(0,0.85,n), 1, 10),1)
selfr = np.round(np.clip(comp + rng.normal(1.35,0.8,n), 1, 10),1)
qs = rng.integers(0, 9, n)
talks = pd.DataFrame({'talk':np.arange(1,n+1),'slides':slides,
                      'minutes_over':overrun,'audience_comprehension':comp,
                      'speaker_self_rating':selfr,'questions_asked':qs})
talks.to_csv('data/talks80.csv', index=False)
OUT['TALKS80']={'n':n,'slides_min':int(slides.min()),'slides_max':int(slides.max()),
  'slides_mean':round(float(slides.mean()),2),'slides_median':float(np.median(slides)),
  'corr_slides_comp':round(float(np.corrcoef(slides,comp)[0,1]),3),
  'corr_slides_over':round(float(np.corrcoef(slides,overrun)[0,1]),3),
  'mean_comp':round(float(comp.mean()),2),'mean_self':round(float(selfr.mean()),2),
  'self_minus_comp':round(float((selfr-comp).mean()),2),
  'over_time_count':int((overrun>0).sum())}

# ---------------------------------------------------- Ch11 REPO90 -----------
rng = R(1111); n = 90
claims = rng.choice(['Yes','No'], n, p=[.79,.21])
link_ok = np.where(claims=='Yes', rng.choice(['Yes','No'],n,p=[.76,.24]), 'No')
runs = np.where(link_ok=='Yes', rng.choice(['Yes','No'],n,p=[.45,.55]), 'No')
seed = np.where(runs=='Yes', rng.choice(['Yes','No'],n,p=[.52,.48]), 'No')
reproduces = np.where((runs=='Yes') & (seed=='Yes'), rng.choice(['Yes','No'],n,p=[.78,.22]), 'No')
readme = np.where(link_ok=='Yes', rng.choice(['Yes','No'],n,p=[.62,.38]),'No')
data_av = rng.choice(['Open','On request','None'], n, p=[.27,.38,.35])
repo = pd.DataFrame({'paper':np.arange(1,n+1),'claims_code_available':claims,
                     'link_resolves':link_ok,'code_runs':runs,'seed_set':seed,
                     'numbers_reproduce':reproduces,'readme_present':readme,
                     'data_availability':data_av})
repo.to_csv('data/repo90.csv', index=False)
OUT['REPO90']={'n':n,'claims':int((claims=='Yes').sum()),'link_ok':int((link_ok=='Yes').sum()),
  'runs':int((runs=='Yes').sum()),'seed':int((seed=='Yes').sum()),
  'reproduce':int((reproduces=='Yes').sum()),'readme':int((readme=='Yes').sum()),
  'data':pd.Series(data_av).value_counts().to_dict()}

# ---------------------------------------------------- Ch12 EHR20K -----------
rng = R(1212); N = 20000
enc = pd.DataFrame({'encounter':np.arange(1,N+1)})
enc['age'] = np.clip(rng.normal(52,19,N),0,104).round(0).astype(int)
enc['sbp'] = np.clip(rng.normal(128,18,N),70,220).round(0).astype(int)
enc['weight_kg'] = np.round(np.clip(rng.normal(80,19,N),35,210),1)
enc['los_days'] = rng.poisson(3.1,N)
enc['dept'] = rng.choice(['ED','Medicine','Surgery','Obstetrics','Paediatrics'],N,p=[.34,.3,.18,.09,.09])
# planted defects
bad_age = rng.choice(N, 46, replace=False);  enc.loc[bad_age,'age'] = 999
bad_sbp = rng.choice(N, 31, replace=False);  enc.loc[bad_sbp,'sbp'] = 0
bad_wt  = rng.choice(N, 58, replace=False);  enc.loc[bad_wt,'weight_kg'] = enc.loc[bad_wt,'weight_kg']*2.20462  # pounds
neg_los = rng.choice(N, 12, replace=False);  enc.loc[neg_los,'los_days'] = -1
miss_wt = rng.choice(N, 1840, replace=False); enc.loc[miss_wt,'weight_kg'] = np.nan
dup = enc.sample(214, random_state=3)
enc = pd.concat([enc, dup], ignore_index=True)
enc.to_csv('data/ehr20k.csv', index=False)
OUT['EHR20K']={'rows':int(len(enc)),'unique_encounters':int(enc.encounter.nunique()),
  'duplicate_rows':int(len(enc)-enc.encounter.nunique()),
  'age_999':int((enc.age==999).sum()),'sbp_zero':int((enc.sbp==0).sum()),
  'los_negative':int((enc.los_days<0).sum()),
  'weight_missing':int(enc.weight_kg.isna().sum()),
  'weight_missing_pct':round(100*enc.weight_kg.isna().mean(),2),
  'weight_over_150':int((enc.weight_kg>150).sum()),
  'dept':enc.dept.value_counts().to_dict()}

json.dump(OUT, open('data/FACTS.json','w'), indent=1, default=str)
for k,v in OUT.items(): print(k, json.dumps(v, default=str)[:300])

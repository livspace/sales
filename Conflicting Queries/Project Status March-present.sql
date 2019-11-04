--http://reports.livspace.com/question/2056

Select 

prs.project_id as PID,
date(prs.project_created_at) as Lead_creation_month,
prs.primary_designer as ID_DP,
prs.primary_cm as BM,
prs.project_status Status,
prs.inactivation_reason as DISQUALIFICATION_REASON,
prs.project_stage,
lbp.last_note


from flat_tables.flat_projects prs
left join launchpad_backend.projects lbp
on prs.project_id=lbp.id

where (prs.project_created_at>='2019-03-01'::date)

and is_test_project=0

order by 2

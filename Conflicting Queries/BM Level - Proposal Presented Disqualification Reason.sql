--http://reports.livspace.com/question/1858

select 

fprs.primary_cm,
to_char(prs.created_at,'YYYY-MM') as month,
sum(case when ps.weight>=110 then 1 else 0 end) as Total_Effective,

sum(case when prs.status = 'INACTIVE' then 1 else 0 end) as Disqualified,
(sum(case when prs.status = 'INACTIVE' then 1.0 else 0 end)/nullif(sum(case when ps.weight>=110 then 1.0 else 0 end),0)*100) as Disqualified_percent,

(sum(case when prs.inactivation_reason = 'posted_by_mistake' then 1.0 else 0 end)/nullif(sum(case when prs.status = 'INACTIVE' then 1.0 else 0 end),0)*100) as Posted_By_Mistake_percent,

(sum(case when lower(prs.inactivation_reason) = 'rnr' then 1.0 else 0 end)/nullif(sum(case when prs.status = 'INACTIVE' then 1.0 else 0 end),0)*100) as RNR_percent,

(sum(case when prs.inactivation_reason = 'budget' then 1.0 else 0 end)/nullif(sum(case when prs.status = 'INACTIVE' then 1.0 else 0 end),0)*100) as budget_percent,

(sum(case when prs.inactivation_reason = 'client_doesnot_want_to_work_with_us' then 1.0 else 0 end)/nullif(sum(case when prs.status = 'INACTIVE' then 1.0 else 0 end),0)*100) as client_does_not_want_percent,

(sum(case when prs.inactivation_reason = 'change_of_plan' then 1.0 else 0 end)/nullif(sum(case when prs.status = 'INACTIVE' then 1.0 else 0 end),0)*100) as change_of_plan


from launchpad_backend.projects prs  

join launchpad_backend.project_stages ps on ps.id=prs.stage_id
join launchpad_backend.cities ct on ct.id=prs.city_id
left join (select project_id,primary_cm from flat_tables.flat_projects group by project_id,primary_cm) fprs on fprs.project_id=prs.id
 

where ct.name like '%chennai%'

and prs.created_at > to_date('01 Sep 2018','DD Mon YYYY')

and ps.weight>=110 

and ps.weight>=270 

group by 1,2

having sum(case when ps.weight>=110 then 1 else 0 end)>5

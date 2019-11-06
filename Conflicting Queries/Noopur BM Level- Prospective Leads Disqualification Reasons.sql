--http://reports.livspace.com/question/1869

select 

fprs.primary_cm,
to_char(prs.created_at,'YYYY-MM') as month,
sum(case when ps.weight>=110 then 1 else 0 end) as Total_Effective,

sum(case when prs.status = 'INACTIVE' then 1 else 0 end) as Disqualified,
(sum(case when prs.status = 'INACTIVE' then 1.0 else 0 end)/sum(case when ps.weight>=110 then 1.0 else 0 end))*100 as Disqualified_Percent,

sum(case when prs.inactivation_reason = 'posted_by_mistake' then 1 else 0 end) as Mistake,
(sum(case when prs.inactivation_reason = 'posted_by_mistake' then 1.0 else 0 end)/sum(case when prs.status = 'INACTIVE' then 1.0 else 0 end)*100) as Mistake_Percent,

sum(case when lower(prs.inactivation_reason) = 'rnr' then 1 else 0 end) as RNR,
(sum(case when lower(prs.inactivation_reason) = 'rnr' then 1.0 else 0 end)/sum(case when prs.status = 'INACTIVE' then 1.0 else 0 end)*100) as RNR_percent

from launchpad_backend.projects prs  

join launchpad_backend.project_stages ps on ps.id=prs.stage_id
join launchpad_backend.cities ct on ct.id=prs.city_id
left join (select project_id,primary_cm from flat_tables.flat_projects group by project_id,primary_cm) fprs on fprs.project_id=prs.id

where fprs.primary_cm in ('Mischelle Lobo','Dhara Mukhi','Sonia Saraf','Charvie Mehta','Sooraj Moolchandani', 'Namita Gawde')

and prs.created_at > to_date('01 Mar 2019','DD Mon YYYY')

and ps.weight>=110 

and ps.weight<250 

group by 1,2

having sum(case when ps.weight>=110 then 1 else 0 end)>5

order by fprs.primary_cm

--http://reports.livspace.com/question/2417

select
prs.project_id,
prs.project_created_at,
prs.primary_cm,
prs.primary_gm,
prs.primary_designer,
prs.project_city,
prs.project_property_category,
prs.project_property_name,
prs.project_property_type,
prs.estimated_value,
prs.brief_scope,
lpb.budget_max,
lpb.budget_min,
lpb.inactivation_reason,
listagg(lc.display_name,',') as sub,
max(case when pvs.new_value='INACTIVE' and pvs.old_value='ACTIVE' then (pvs.event_date) end) as "Inactivation Date"

from 
flat_tables.flat_projects prs
join launchpad_backend.projects lpb on prs.project_id=lpb.id
left join launchpad_backend.lsf_responses lr on lr.context_id=lpb.id
left join launchpad_backend.lsf_components lc on lr.option_id=lc.id
left join flat_tables.flat_project_events pvs on prs.project_id=pvs.project_id 

where prs.primary_cm in ('Nidhi Agarwal','Anjuli Gupta','Abhishek Sharma','Palak Jolly','Rinkesh Bafna','Gautam Gupta','Sri Harsha Ks','Mohammed Azharuddin','Tarun Garg','Prateek Bharadwaj','Himanshi Sharma','Abhishek Sharma','Heli Kumar','Chandana  Ainwale','Annu  Bala','Natasha Sharon Shah','Natasha .','Satish Prasad  Sahu','Mohammad Takki','Shuchi',
'Nitin Bhatia') and pvs.new_value='INACTIVE' and pvs.event_date>='2019-09-15'::date

group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14

order by 1

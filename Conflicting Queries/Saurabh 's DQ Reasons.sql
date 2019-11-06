--http://reports.livspace.com/question/2418

select
prs.project_id,
prs.project_stage,
to_char(prs.project_created_at,'YYYY-MM-DD'),
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
(case when (lower(prs.inactivation_reason) like '%post%' or lower(prs.inactivation_reason) like '%rnr%')  then lc.display_name 

when lower(prs.inactivation_reason) like '%doesn%' and lower(lc.display_name) not like '%doesn%'  then lc.display_name

end) as sub,
max(case when pvs.new_value='INACTIVE' and pvs.old_value='ACTIVE' then to_char(pvs.event_date,'YYYY-MM-DD') end) as "Inactivation Date"

from 
flat_tables.flat_projects prs
join launchpad_backend.projects lpb on prs.project_id=lpb.id
left join launchpad_backend.lsf_responses lr on lr.context_id=lpb.id
left join launchpad_backend.lsf_components lc on lr.option_id=lc.id
left join flat_tables.flat_project_events pvs on prs.project_id=pvs.project_id 

where prs.primary_cm in ('Nidhi Agarwal','Anjuli Gupta','Abhishek Sharma','Palak Jolly','Rinkesh Bafna','Gautam Gupta','Sri Harsha Ks','Mohammed Azharuddin','Tarun Garg','Prateek Bharadwaj','Himanshi Sharma','Abhishek Sharma','Heli Kumar','Chandana  Ainwale','Annu  Bala','Natasha Sharon Shah','Natasha .','Satish Prasad  Sahu','Mohammad Takki','Shuchi',
'Nitin Bhatia') and pvs.new_value='INACTIVE' and prs.project_created_at>='2019-07-01'::date 

and lr.descriptive_response is null 
and lower(prs.inactivation_reason) is not null and 
((lower(prs.inactivation_reason)  like '%post%' and lc.lsf_type_id=8) or 
(lower(prs.inactivation_reason)  like '%rnr%' and lc.lsf_type_id=4) or 
(lower(prs.inactivation_reason)  like '%doesnot%' and lc.lsf_type_id=8 and lc.parent_component_id=239) or
(lower(prs.inactivation_reason) not like '%post%' and lower(prs.inactivation_reason)  not like '%rnr%' and lower(prs.inactivation_reason) not like '%doesn%')
)

group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16

order by 1

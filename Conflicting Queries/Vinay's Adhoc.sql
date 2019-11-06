--http://reports.livspace.com/question/2468?created_date_end=2019-10-01&created_date_start=2019-10-15&Bm_name=Ankita%20Sharan

select ou.project_id as "Canvas Id",
ou.stage,ou.primary_cm as "BM",
ou.primary_reason as "Primary Reason",
ou.sub as "Sub Reason",
ou.customer_display_name,
ou.customer_phone,
ou.stage


from (select
fprs.project_id,
fprs.customer_display_name,
fprs.customer_phone,
fprs.primary_cm,
fprs.project_created_at,
s.display_name as stage,

prs.inactivation_reason as primary_reason,
(case when (lower(prs.inactivation_reason) like '%post%' or lower(prs.inactivation_reason) like '%rnr%')  then lc.display_name 

when lower(prs.inactivation_reason) like '%doesn%' and lower(lc.display_name) not like '%doesn%'  then lc.display_name

end) as sub

from 

launchpad_backend.projects prs
left join flat_tables.flat_projects fprs on prs.id=fprs.project_id
left join flat_tables.flat_project_events pvs on fprs.project_id=pvs.project_id
left join launchpad_backend.project_settings ps on ps.project_id=prs.id and ps.is_deleted = 0 
left join launchpad_backend.bouncer_users as gm on ps.primary_cm_id = gm.bouncer_id

left join launchpad_backend.cities ct on ct.id=prs.city_id
left join launchpad_backend.project_stages s on s.id=prs.stage_id
left join launchpad_backend.lsf_responses lr on lr.context_id=prs.id
left join launchpad_backend.lsf_components lc on lr.option_id=lc.id

where prs.is_test=false and prs.status ='INACTIVE' and lr.descriptive_response is null 
and lower(prs.inactivation_reason) is not null and 
((lower(prs.inactivation_reason)  like '%post%' and lc.lsf_type_id=8) or 
(lower(prs.inactivation_reason)  like '%rnr%' and lc.lsf_type_id=4) or 
(lower(prs.inactivation_reason)  like '%doesnot%' and lc.lsf_type_id=8 and lc.parent_component_id=239) or
(lower(prs.inactivation_reason) not like '%post%' and lower(prs.inactivation_reason)  not like '%rnr%' and lower(prs.inactivation_reason) not like '%doesn%')
)

group by 
prs.id,
fprs.project_id,
fprs.customer_display_name,
fprs.customer_phone,
fprs.primary_cm,
s.display_name,
lc.display_name,
prs.inactivation_reason,
fprs.project_created_at

order by prs.id desc) ou

where date(ou.project_created_at) >={{created_date_start}} and date(ou.project_created_at) <={{created_date_end}} 
and ou.primary_cm={{Bm_name}}

group by 
ou.project_id,
ou.stage,
ou.primary_cm,
ou.sub,
ou.primary_reason,
ou.project_id,
ou.customer_phone,
ou.customer_display_name

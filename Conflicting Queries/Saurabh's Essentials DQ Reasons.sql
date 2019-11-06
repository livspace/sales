--http://reports.livspace.com/question/2401

select ou.project_id as "Canvas Id",ou.stage,ou.city,ou.primary_gm as "GM",ou.cm as "BM",ou.primary_designer as "Primary Designer",ou.created as "Project Created Date",ou.primary_reason as "Primary Reason",ou.sub as "Sub Reason",min(ou.weight),ou.estimated_value as "Estimated Value",ou.budget_max as "Max Budget",budget_min as "Min Budget",ou.project_pincode as "Pincode",ou.project_property_category as "Property Category",
ou.project_property_name as "Property Name",
ou.project_service_type as "Property Service Type",
ou.ID as "Inactivation date"

from (select
fprs.project_id,
fprs.primary_gm,
fprs.primary_designer,
fprs.project_pincode,
fprs.project_property_category,
fprs.project_property_name,
fprs.project_service_type,

prs.budget_max,
prs.budget_min,
prs.estimated_value,
to_char(prs.created_at,'YYYY-MM-DD') as created,
ct.display_name as city,
s.display_name as stage,
gm.name as cm,
prs.inactivation_reason as primary_reason,
(case when (lower(prs.inactivation_reason) like '%post%' or lower(prs.inactivation_reason) like '%rnr%')  then lc.display_name 

when lower(prs.inactivation_reason) like '%doesn%' and lower(lc.display_name) not like '%doesn%'  then lc.display_name

end) as sub,
s.weight as weight,

min(case when pvs.new_value='INACTIVE' then to_char(pvs.event_date,'YYYY-MM-DD') end) as ID

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

group by prs.id,prs.created_at,ct.display_name,s.display_name,gm.name,prs.inactivation_reason,lc.display_name,s.weight,prs.estimated_value,prs.budget_max,prs.budget_min,fprs.project_pincode,fprs.primary_gm,
fprs.project_id,
fprs.project_property_category,
fprs.project_property_name,
fprs.project_service_type,
fprs.primary_designer


order by prs.id desc) ou

where ou.created >='2019-07-01'::date and ou.cm in ('Nidhi Agarwal','Anjuli Gupta','Abhishek Sharma','Palak Jolly','Rinkesh Bafna','Gautam Gupta','Sri Harsha Ks','Mohammed Azharuddin','Tarun Garg','Prateek Bharadwaj','Himanshi Sharma','Abhishek Sharma','Heli Kumar','Chandana  Ainwale','Annu  Bala','Natasha Sharon Shah','Natasha .','Satish Prasad  Sahu','Mohammad Takki','Shuchi',
'Nitin Bhatia') 

group by ou.stage,ou.city,ou.cm,ou.created,ou.sub,ou.primary_reason,ou.estimated_value,budget_max,budget_min,ou.project_pincode,ou.primary_gm,
ou.project_id,
ou.project_property_category,
ou.project_property_name,
ou.project_service_type,
ou.primary_designer,
ou.ID

order by ou.created

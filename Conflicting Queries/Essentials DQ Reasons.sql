--http://live-data.livspace.com/question/2259

select ou.stage,ou.city,ou.cm,ou.created,ou.sub,ou.primary_reason,count(*),min(ou.weight)  

from (select 
to_char(prs.created_at,'YYYY-MM') as created,
ct.display_name as city,
s.display_name as stage,
gm.name as cm,
prs.inactivation_reason as primary_reason,
(case when (lower(prs.inactivation_reason) like '%post%' or lower(prs.inactivation_reason) like '%rnr%')  then lc.display_name 

when lower(prs.inactivation_reason) like '%doesn%' and lower(lc.display_name) not like '%doesn%'  then lc.display_name

end) as sub,
s.weight as weight

from 

launchpad_backend.projects prs  

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

group by prs.id,prs.created_at,ct.display_name,s.display_name,gm.name,prs.inactivation_reason,lc.display_name,s.weight


order by prs.id desc) ou

where ou.created >= '2019-01-01'::date and ou.cm in ('Nidhi Agarwal','Anjuli Gupta','Abhishek Sharma','Palak Jolly','Rinkesh Bafna','Gautam Gupta','Sri Harsha Ks','Mohammed Azharuddin','Tarun Garg','Prateek Bharadwaj','Himanshi Sharma','Abhishek Sharma','Heli Kumar','Chandana  Ainwale','Annu  Bala','Natasha Sharon Shah','Natasha .','Satish Prasad  Sahu','Mohammad Takki','Shuchi',
'Nitin Bhatia') 

group by ou.stage,ou.city,ou.cm,ou.created,ou.sub,ou.primary_reason


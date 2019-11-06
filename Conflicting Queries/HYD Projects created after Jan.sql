--http://reports.livspace.com/question/2466

select
prs.project_id,
prs.brief_scope,
prs.customer_display_name,
prs.design_in_progress,
prs.inactivation_reason,
prs.primary_gm,
prs.primary_cm,
prs.primary_designer,
prs.project_created_at,
prs.project_property_name,
prs.project_property_type,
prs.project_property_category,
prs.project_service_type,
prs.project_stage,
prs.project_status,
lbp.conversion_probability,
(case when jp.user_id is not null then 'Y' else 'N' end) as "High Intent Lead",
date_diff('day',prs.project_created_at,current_date) as "Ageing"


from
flat_tables.flat_projects prs 

left join 
(
select
(case when (user_id SIMILAR TO 'CX%' OR user_id SIMILAR TO 'UX%') THEN REGEXP_SUBSTR(user_id, '[0-9]+', 1) else user_id END) as user_id

from javascript.customer_quiz_submitted group by user_id

) as jp on prs.project_id=jp.user_id


left join launchpad_backend.projects lbp on prs.project_id=lbp.id
where prs.project_created_at>='2019-01-01'::date
and prs.project_city='Hyderabad'
and prs.primary_cm in ('Annu  Bala','Sri Harsha Ks','Cheedu Srujan')
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17

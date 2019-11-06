http://reports.livspace.com/question/2498?Project_city=ALL&gm=ALL&cm=ALL&created_date=2019-10-01

SELECT
prs.project_id AS "project_id",
prs.primary_gm AS "GM",
prs.primary_cm AS "BM",
prs.primary_designer AS "Primary designer",
prs.brief_scope AS "brief_scope",
prs.customer_display_name AS "customer_display_name",
prs.design_in_progress AS "design_in_progress",
prs.inactivation_reason AS "inactivation_reason",
prs.project_created_at AS "project_created_at",
prs.project_property_name AS "project_property_name",
prs.project_property_type AS "project_property_type",
prs.project_service_type AS "project_service_type", 
prs.project_stage AS "project_stage",
prs.project_status AS "project_status",
(case when ms.no_of_entry is NOT NULL then 'Y' else 'N' end) as "Project Timeline Created",
(case when lpb.plan_published=true then 'Y' else 'N' end) as "Project Timeline Shared",
prs.estimated_value,
(case when lower(lpb.conversion_probability) like '%high%' then 'Y' else 'N' end) as "High Intent"


FROM flat_tables.flat_projects prs
left join launchpad_backend.projects lpb on prs.project_id=lpb.id
left join (Select project_id,count(*) as no_of_entry from launchpad_backend.project_plan_milestones where is_deleted=false group by project_id)as ms on prs.project_id=ms.project_id
WHERE 
(case when {{Project_city}}='ALL' then 1 when (prs.project_city)={{Project_city}} then 1 else 0 end)
and
(case when {{gm}}='ALL' then 1 when prs.primary_gm={{gm}} then 1 else 0 end)
and
(case when {{cm}} = 'ALL' then 1 when prs.primary_cm={{cm}} then 1 else 0 end)
and
prs.project_created_at>={{created_date}}
and 
is_test_project=0

order by prs.project_created_at

--http://reports.livspace.com/question/1838 

--Metabase question

SELECT "flat_tables"."flat_projects"."project_id" AS "project_id", "flat_tables"."flat_projects"."customer_display_name" AS "customer_display_name", "flat_tables"."flat_projects"."primary_cm" AS "primary_cm", "flat_tables"."flat_projects"."inactivation_reason" AS "inactivation_reason", "flat_tables"."flat_projects"."brief_scope" AS "brief_scope", "flat_tables"."flat_projects"."customer_email" AS "customer_email", "flat_tables"."flat_projects"."customer_phone" AS "customer_phone", "flat_tables"."flat_projects"."is_test_project" AS "is_test_project", "flat_tables"."flat_projects"."primary_designer" AS "primary_designer", "flat_tables"."flat_projects"."primary_gm" AS "primary_gm", "flat_tables"."flat_projects"."project_city" AS "project_city", "flat_tables"."flat_projects"."project_created_at" AS "project_created_at", "flat_tables"."flat_projects"."project_property_name" AS "project_property_name", "flat_tables"."flat_projects"."project_property_type" AS "project_property_type", "flat_tables"."flat_projects"."project_service_type" AS "project_service_type", "flat_tables"."flat_projects"."project_stage" AS "project_stage", "flat_tables"."flat_projects"."project_stage_weight" AS "project_stage_weight", "flat_tables"."flat_projects"."project_status" AS "project_status", "flat_tables"."flat_projects"."prospective_lead_date" AS "prospective_lead_date", "flat_tables"."flat_projects"."status_change_reason" AS "status_change_reason"
FROM "flat_tables"."flat_projects"
WHERE (CAST("flat_tables"."flat_projects"."project_created_at" AS date) BETWEEN CAST('2019-04-01T00:00:00.000Z'::timestamp AS date)
   AND CAST('2019-05-01T00:00:00.000Z'::timestamp AS date) AND "flat_tables"."flat_projects"."is_test_project" = 0 AND "flat_tables"."flat_projects"."project_status" = 'INACTIVE')
LIMIT 2000
Convert this question to SQL

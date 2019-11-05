--http://reports.livspace.com/question/2128

SELECT "flat_tables"."flat_projects"."project_id" AS "project_id", "flat_tables"."flat_projects"."brief_scope" AS "brief_scope", "flat_tables"."flat_projects"."customer_display_name" AS "customer_display_name", "flat_tables"."flat_projects"."design_in_progress" AS "design_in_progress", "flat_tables"."flat_projects"."inactivation_reason" AS "inactivation_reason", "flat_tables"."flat_projects"."primary_cm" AS "primary_cm", "flat_tables"."flat_projects"."primary_designer" AS "primary_designer", "flat_tables"."flat_projects"."primary_gm" AS "primary_gm", "flat_tables"."flat_projects"."project_created_at" AS "project_created_at", "flat_tables"."flat_projects"."project_property_name" AS "project_property_name", "flat_tables"."flat_projects"."project_property_type" AS "project_property_type", "flat_tables"."flat_projects"."project_service_type" AS "project_service_type", "flat_tables"."flat_projects"."project_stage" AS "project_stage", "flat_tables"."flat_projects"."project_status" AS "project_status"
FROM "flat_tables"."flat_projects"
WHERE ("flat_tables"."flat_projects"."project_city" = 'Hyderabad'
   AND CAST("flat_tables"."flat_projects"."project_created_at" AS date) > CAST('2019-01-01T00:00:00.000Z'::timestamp AS date))
LIMIT 2000

--http://reports.livspace.com/question/2098

SELECT "flat_tables"."flat_projects"."project_id" AS "project_id", "flat_tables"."flat_projects"."customer_display_name" AS "customer_display_name", "flat_tables"."flat_projects"."customer_email" AS "customer_email", "flat_tables"."flat_projects"."customer_phone" AS "customer_phone", "flat_tables"."flat_projects"."primary_cm" AS "primary_cm", "flat_tables"."flat_projects"."primary_designer" AS "primary_designer", "flat_tables"."flat_projects"."primary_gm" AS "primary_gm", "flat_tables"."flat_projects"."project_stage" AS "project_stage", "flat_tables"."flat_projects"."project_status" AS "project_status"
FROM "flat_tables"."flat_projects"
WHERE (("flat_tables"."flat_projects"."project_status" = 'ACTIVE'
    OR "flat_tables"."flat_projects"."project_status" = 'ONHOLD')
   AND "flat_tables"."flat_projects"."project_city" = 'Bangalore' AND "flat_tables"."flat_projects"."is_test_project" = 0)
LIMIT 2000

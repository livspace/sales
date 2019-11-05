--http://reports.livspace.com/question/2176

SELECT "flat_tables"."flat_projects"."primary_cm" AS "primary_cm", "flat_tables"."flat_projects"."primary_designer" AS "primary_designer", "flat_tables"."flat_projects"."project_id" AS "project_id", "flat_tables"."flat_projects"."customer_display_name" AS "customer_display_name", "flat_tables"."flat_projects"."project_stage" AS "project_stage", "flat_tables"."flat_projects"."project_created_at" AS "project_created_at", "flat_tables"."flat_projects"."prospective_lead_date" AS "prospective_lead_date", "flat_tables"."flat_projects"."briefing_done_date" AS "briefing_done_date", "flat_tables"."flat_projects"."design_in_progress" AS "design_in_progress", "flat_tables"."flat_projects"."gmv_amount" AS "gmv_amount"
FROM "flat_tables"."flat_projects"
WHERE ("flat_tables"."flat_projects"."project_city" = 'Chennai'
   AND "flat_tables"."flat_projects"."is_proposal_present" = 1 AND CAST("flat_tables"."flat_projects"."project_created_at" AS date) < CAST('2019-03-01T00:00:00.000Z'::timestamp AS date))
LIMIT 2000

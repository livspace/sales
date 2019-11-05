--http://reports.livspace.com/question/2223?project_created_at_date=2019-07-01

SELECT "flat_tables"."flat_projects"."project_id" AS "project_id", "flat_tables"."flat_projects"."customer_display_name" AS "customer_display_name",
"flat_tables"."flat_projects"."customer_email" AS "customer_email", "flat_tables"."flat_projects"."customer_phone" AS "customer_phone", 
"flat_tables"."flat_projects"."inactivation_reason" AS "inactivation_reason", "flat_tables"."flat_projects"."is_test_project" AS "is_test_project", 
"flat_tables"."flat_projects"."primary_cm" AS "primary_cm", "flat_tables"."flat_projects"."parent_city" AS "parent_city", "flat_tables"."flat_projects"."postcode" AS "postcode",
"flat_tables"."flat_projects"."primary_designer" AS "primary_designer", "flat_tables"."flat_projects"."primary_gm" AS "primary_gm", 
"flat_tables"."flat_projects"."project_city" AS "project_city", "flat_tables"."flat_projects"."project_created_at" AS "project_created_at",
extract(month from "flat_tables"."flat_projects"."project_created_at") AS "project_created_month",
"flat_tables"."flat_projects"."project_pincode" AS "project_pincode", "flat_tables"."flat_projects"."project_property_name" AS "project_property_name", 
"flat_tables"."flat_projects"."project_stage" AS "project_stage", "flat_tables"."flat_projects"."project_status" AS "project_status",
prs.estimated_value as "estimated_value", prs.conversion_probability as "conversion_probability"

FROM "flat_tables"."flat_projects"

left join launchpad_backend.projects prs on prs.id="flat_tables"."flat_projects"."project_id"


WHERE (("flat_tables"."flat_projects"."primary_cm" = 'Rahul Jain'
    OR "flat_tables"."flat_projects"."primary_cm" = 'Gourav Goyal' OR "flat_tables"."flat_projects"."primary_cm" = 'Sampada Karmarkar' OR "flat_tables"."flat_projects"."primary_cm" = 'Ritu Vishnoi' 
    OR "flat_tables"."flat_projects"."primary_cm" = 'Oshima Desouza' OR "flat_tables"."flat_projects"."primary_cm" = 'Nikhil Malpani'
    OR "flat_tables"."flat_projects"."primary_cm" = 'Charu Gupta'
    OR "flat_tables"."flat_projects"."primary_cm" = 'Praneet Singh'
    OR "flat_tables"."flat_projects"."primary_cm" = 'Praneet  Singh'
    OR "flat_tables"."flat_projects"."primary_cm" = 'Praneet Singh '
    OR "flat_tables"."flat_projects"."primary_cm" = 'Praneet  Singh '
    )
   AND "flat_tables"."flat_projects"."project_created_at" >= {{project_created_at_date}})

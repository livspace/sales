--http://reports.livspace.com/question/1839

--Metabase Question

SELECT "flat_tables"."flat_projects"."project_status" AS "project_status", count(*) AS "count"
FROM "flat_tables"."flat_projects"
WHERE (CAST("flat_tables"."flat_projects"."project_created_at" AS date) BETWEEN CAST('2019-04-01T00:00:00.000Z'::timestamp AS date)
   AND CAST('2019-05-01T00:00:00.000Z'::timestamp AS date) AND "flat_tables"."flat_projects"."is_test_project" = 0 AND "flat_tables"."flat_projects"."primary_cm" = 'Ashmita Banerjee')
GROUP BY "flat_tables"."flat_projects"."project_status"
ORDER BY "flat_tables"."flat_projects"."project_status" ASC

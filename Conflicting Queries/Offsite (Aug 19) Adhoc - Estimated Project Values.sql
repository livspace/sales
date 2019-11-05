--http://live-data.livspace.com/question/2130

SELECT "launchpad_backend"."projects"."id" AS "id", "launchpad_backend"."projects"."collaborator_specified_property_name" AS "collaborator_specified_property_name", "launchpad_backend"."projects"."estimated_value" AS "estimated_value"
FROM "launchpad_backend"."projects"
WHERE (CAST("launchpad_backend"."projects"."created_at" AS date) > CAST('2019-03-01T00:00:00.000Z'::timestamp AS date)
   AND "launchpad_backend"."projects"."is_test" = 0 AND ("launchpad_backend"."projects"."city_id" = 5
    OR "launchpad_backend"."projects"."city_id" = 14 OR "launchpad_backend"."projects"."city_id" = 15))
LIMIT 2000

--http://reports.livspace.com/question/1579

SELECT  p.created_at AS project_created_at, 
p.id AS project_id, 
c.display_name AS city, 
CASE
    WHEN vllc.ad_source::text = 'leadgen_ad'::character varying::text THEN wp.context_campaign_source
    WHEN vllc.ad_source::text = 'website_ad'::character varying::text THEN jp.campaign_source
    ELSE NULL::character varying
END AS utm_source, 
CASE
    WHEN vllc.ad_source::text = 'leadgen_ad'::character varying::text THEN wp.context_campaign_medium
    WHEN vllc.ad_source::text = 'website_ad'::character varying::text THEN jp.campaign_medium
    ELSE NULL::character varying
END AS utm_medium, 
(case when prss.project_id is not null then 1 else 0 end) as "Completed Lead?",
CASE
    WHEN ps.weight >= 250 THEN 1
    ELSE 0
END AS "BC Done?", 
CASE
    WHEN date_diff('day'::character varying::text, p.created_at, pe.created_at) <= 7 THEN 1
    ELSE 0
END AS "7 Day BC Done?", 
CASE
    WHEN ps.weight > 265 THEN 1
    ELSE 0
END AS "Pitch Sent?", 
CASE
    WHEN date_diff('day'::character varying::text, p.created_at, pe1.created_at) <= 30 THEN 1
    ELSE 0
END AS "30 day Pitch Sent?", 
CASE
    WHEN ps.weight >= 400 THEN 1
    ELSE 0
END AS "Order Booked?",
CASE
    WHEN ps.weight >= 110 THEN 1
    ELSE 0
END AS "Effective lead?",
(case when prss.project_id is not null then 'Complete' else 'Incomplete' end) as "Quiz Status",
p.brief_scope as "Scope",
ps.display_name AS current_stage, 
p.status AS current_status 

   FROM launchpad_backend.projects p
   LEFT JOIN livspace_reports.view_leads_last_click vllc ON vllc.id_customer = p.customer_id
   LEFT JOIN ( SELECT 
           CASE
               WHEN identifies.user_id::text ~ similar_escape('CX%'::character varying::text, NULL::character varying::text) OR identifies.user_id::text ~ similar_escape('UX%'::character varying::text, NULL::character varying::text) THEN regexp_substr(identifies.user_id::text, '[0-9]+'::character varying::text, 1)::character varying
               ELSE identifies.user_id
           END AS user_id, identifies.campaign_source, identifies.campaign_medium, identifies.campaign_term, identifies.campaign_name, identifies.campaign_content
      FROM javascript.identifies
     WHERE identifies.campaign_source IS NOT NULL AND identifies.campaign_source::text <> ''::character varying::text AND (identifies.context_page_path::text ~~ '%design-query%'::character varying::text OR identifies.context_page_path::text ~~ '%quiz%'::character varying::text)) jp ON p.customer_id::character varying::text = jp.user_id::text
   LEFT JOIN ( SELECT 
        CASE
            WHEN pages.user_id::text ~ similar_escape('CX%'::character varying::text, NULL::character varying::text) OR pages.user_id::text ~ similar_escape('UX%'::character varying::text, NULL::character varying::text) THEN regexp_substr(pages.user_id::text, '[0-9]+'::character varying::text, 1)::character varying
            ELSE pages.user_id
        END AS user_id, pages.context_campaign_source, pages.context_campaign_medium, pages.context_campaign_term, pages.context_campaign_name, pages.context_campaign_content
   FROM livspace_web.pages) wp ON p.customer_id::character varying::text = wp.user_id::text
   LEFT JOIN javascript.identifies ide ON p.customer_id::character varying::text = ide.user_id::text
   LEFT JOIN launchpad_backend.project_stages ps ON ps.id = p.stage_id
   LEFT JOIN launchpad_backend.cities c ON c.id = p.city_id
   LEFT JOIN flat_tables.flat_project_payments fpp ON fpp.id_project = p.id
   LEFT JOIN launchpad_backend.project_events pe ON p.id = pe.project_id AND pe.new_value::text = 9::character varying::text AND pe.event_type::text = 'STAGE_UPDATED'::character varying::text
   LEFT JOIN launchpad_backend.project_events pe1 ON p.id = pe1.project_id AND pe1.new_value::text = 21::character varying::text AND pe1.event_type::text = 'STAGE_UPDATED'::character varying::text
   LEFT JOIN ( SELECT 
        CASE
            WHEN pages.user_id::text ~ similar_escape('CX%'::character varying::text, NULL::character varying::text) OR pages.user_id::text ~ similar_escape('UX%'::character varying::text, NULL::character varying::text) THEN regexp_substr(pages.user_id::text, '[0-9]+'::character varying::text, 1)::character varying
            ELSE pages.user_id
        END AS customer_id, pages.user_id, pages.url
   FROM javascript.pages
   
   
  WHERE pages.url::text ~~ '%/quiz/%'::character varying::text) pag ON p.customer_id::character varying::text = pag.customer_id::text
  
  left join (
select prs.id as "project_id" from launchpad_backend.projects prs
left join (select (case when (user_id SIMILAR TO 'CX%' OR user_id SIMILAR TO 'UX%') THEN REGEXP_SUBSTR(user_id, '[0-9]+', 1) else user_id END) as user_id from javascript.customer_quiz_submitted group by user_id) as jp on prs.customer_id=jp.user_id

where jp.user_id is not null
group by prs.id
) prss on prss.project_id =p.id
  WHERE p.created_at >= '2018-08-25 00:00:00'::timestamp without time zone AND p.is_test = 0 AND p.is_business = 0
  GROUP BY prss.project_id,vllc.trackingid, wp.context_campaign_content, pe.new_value, pe.event_type, pag.url, pag.user_id, pe.created_at, p.brief_scope, jp.campaign_content, vllc.id, p.id, p.customer_id, c.display_name, p.pincode, ps.display_name, p.status, p.created_at, convert_timezone('UTC +5:30'::character varying::text, p.created_at), to_char(p.created_at, '%Y-%m-%d'::character varying::text), fpp.project_gmv, fpp.ten_percent_payment, vllc.lead_source, vllc.ad_source, vllc.utm_source, vllc.utm_medium, vllc.utm_term, vllc.utm_content, vllc.utm_adgroup, vllc.utm_placement, vllc.utm_device, vllc.landing_page_id, vllc.utm_campaign, vllc.tracker_date, ps.weight, wp.context_campaign_source, jp.campaign_source, wp.context_campaign_medium, jp.campaign_medium, wp.context_campaign_term, jp.campaign_term, wp.context_campaign_name, jp.campaign_name,pe1.created_at
  

  
  

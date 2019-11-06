--http://reports.livspace.com/question/2450

select
prs.primary_designer as "Designer Name",
bu.email as "Email",
bu.tags,
(case when bu.email like '%.dp@%' then 'DP' else 'ID' end) as "Type",
date(bu.created_at) as "Canvas Id Created Date",
date(bu.user_last_seen) as "Last Login Date",
date_diff('day',bu.created_at,current_date) as "Ageing in days",
sum(bgm.amount) as "JAS Bgmv"

from

flat_tables.flat_projects prs 

left join flat_tables.flat_bouncer_user bu on prs.primary_designer=bu.name

left join launchpad_backend.project_bgmvs bgm on prs.project_id=bgm.project_id

left join flat_tables.flat_project_payments fpp on fpp.id_project=prs.project_id

where 
-- bgm.logged_month>='2019-07-01'::date and bgm.logged_month<='2019-09-30'::date
(fpp.ten_percent_payment_date>'2019-06-30'::date and fpp.ten_percent_payment_date<='2019-09-30'::date) OR 
(prs.project_stage_weight>=400 and fpp.ten_percent_payment_date is null and prs.design_in_progress>'2019-06-30'::date and prs.design_in_progress<='2019-09-30'::date)
OR ((fpp.ten_percent_payment_date<='2019-03-31'::date OR prs.design_in_progress<='2019-03-31'::date) AND bgm.logged_month>'2019-06-30'::date and bgm.logged_month<='2019-09-30'::date)

and lower(bu.tags) like '%inter%'

group by 1,2,3,4,5,6,7

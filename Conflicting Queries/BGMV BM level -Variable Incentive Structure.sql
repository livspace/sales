--http://reports.livspace.com/question/2027

Select 

prs.project_id as "Canvas ID",
prs.primary_cm as Primary_BM,
prs.primary_designer as Primary_Designer,

(case 
when lower(project_city) like '%bangalore%' or lower(project_city) like '%hyderabad%' or lower(project_city) like '%chennai%' or lower(project_city) like '%pune%' then project_city
when lower(project_city) like '%mumbai%' or lower(project_city) like '%thane%' then 'Mumbai'
when lower(project_city) like '%gurgaon%' or lower(project_city) like '%dwarka%' then 'Gurgaon'
when lower(project_city) like '%delhi%' or lower(project_city) like '%farida%' then 'Delhi'
when lower(project_city) like '%noida%' or lower(project_city) like '%ghaz%' then 'Noida'
end) as City,

sum(gml.amount) as "BGMV ",
sum(fpp.ten_percent_payment) as "10% Payment Amount",
date(min(fpp.ten_percent_payment_date)) as "10% Payment date",
(case when prs.project_designer_email like '%.dp@%' then 'DP' else 'ID' end) as type

from launchpad_backend.project_bgmvs gml

left join flat_tables.flat_projects prs 
on prs.project_id=gml.project_id

left join flat_tables.flat_project_payments fpp on fpp.id_project=prs.project_id

where (fpp.ten_percent_payment_date>'2019-03-31'::date and fpp.ten_percent_payment_date<='2019-06-30'::date) OR 
(prs.project_stage_weight>=400 and fpp.ten_percent_payment_date is null and prs.design_in_progress>'2019-03-31'::date and prs.design_in_progress<='2019-06-30'::date)
OR ((fpp.ten_percent_payment_date<='2019-03-31'::date OR prs.design_in_progress<='2019-03-31'::date) AND gml.logged_month>'2019-03-31'::date and gml.logged_month<='2019-06-30'::date)
group by 1,2,3,4,8 order by City


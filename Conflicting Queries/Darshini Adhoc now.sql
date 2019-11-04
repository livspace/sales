--http://reports.livspace.com/question/2156

Select
to_char(logged_month,'YYYY-MM') as Month,
prs.project_pincode,

(case 
when lower(project_city) like '%bangalore%' or lower(project_city) like '%hyderabad%' or lower(project_city) like '%chennai%' or lower(project_city) like '%pune%' then project_city
when lower(project_city) like '%mumbai%' or lower(project_city) like '%thane%' then 'Mumbai'
when lower(project_city) like '%gurgaon%' or lower(project_city) like '%dwarka%' then 'Gurgaon'
when lower(project_city) like '%delhi%' or lower(project_city) like '%farida%' then 'Delhi'
when lower(project_city) like '%noida%' or lower(project_city) like '%ghaz%' then 'Noida'
end) as City,

count(distinct(case when pvs.new_value=17 then prs.project_id end)) as NO_OF_EFFECTIVE_LEADS,
count(distinct(case when pvs.new_value=23 then prs.project_id end)) as NO_OF_QUALIFIED_LEADS,
count(distinct(case when pvs.new_value=4 then prs.project_id end)) as NO_OF_CONVERTED,
sum(bgm.amount) as Bgmv 

from launchpad_backend.project_bgmvs bgm

left join flat_tables.flat_projects prs 

on prs.project_id=bgm.project_id

left join flat_tables.flat_project_events pvs on prs.project_id=pvs.project_id and pvs.event_date>='2019-01-01' and pvs.event_date<='2019-06-30'

where (bgm.logged_month>='2019-01-01' and bgm.logged_month<='2019-06-30')

and (lower(prs.project_city) like '%mumbai%'  or lower(prs.project_city) like '%thane%')

group by 1,2,3 
order by 1


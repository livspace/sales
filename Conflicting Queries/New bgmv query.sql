--http://reports.livspace.com/question/2091

select 

to_char(bgm.logged_month,'YYYY-MM') as logged_month,
(case 
when lower(project_city) like '%bangalore%' or lower(project_city) like '%hyderabad%' or lower(project_city) like '%chennai%' or lower(project_city) like '%pune%' then project_city
when lower(project_city) like '%mumbai%' or lower(project_city) like '%thane%' then 'Mumbai'
when lower(project_city) like '%gurgaon%' or lower(project_city) like '%dwarka%' then 'Gurgaon'
when lower(project_city) like '%delhi%' or lower(project_city) like '%farida%' then 'Delhi'
when lower(project_city) like '%noida%' or lower(project_city) like '%ghaz%' then 'Noida'
end) as City,
prs.primary_gm as GM,
prs.primary_cm as BM,
sum(bgm.amount) as BGMV

from launchpad_backend.project_bgmvs bgm 

left join flat_tables.flat_projects prs on bgm.project_id=prs.project_id and is_test_project=0

where to_date(bgm.logged_month,'YYYY-MM-DD') >='2019-01-01'

group by 1,2,3,4
order by 1

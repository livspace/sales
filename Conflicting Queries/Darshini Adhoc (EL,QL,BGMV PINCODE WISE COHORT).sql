--http://reports.livspace.com/question/2162

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

count(distinct(case when prs.project_stage_weight>=110 and (prs.project_created_at>='2019-01-01' and prs.project_created_at<='2019-06-30') then prs.project_id end)) as NO_OF_GM_ASSIGNED_LEADS,
count(distinct(case when prs.project_stage_weight>=130 and (prs.project_created_at>='2019-01-01' and prs.project_created_at<='2019-06-30') then prs.project_id end)) as NO_OF_BCS_LEADS,
count(distinct(case when prs.project_stage_weight>=250 and (prs.project_created_at>='2019-01-01' and prs.project_created_at<='2019-06-30') then prs.project_id end)) as NO_OF_BRIEFING_DONE,
count(distinct(case when prs.project_stage_weight>=400 and (prs.project_created_at>='2019-01-01' and prs.project_created_at<='2019-06-30') then prs.project_id end)) as NO_OF_DIP,
sum(case when (bgm.logged_month>='2019-01-01'::date and bgm.logged_month<='2019-06-30'::date) then bgm.amount else 0 end) as Bgmv 

from launchpad_backend.project_bgmvs bgm

left join flat_tables.flat_projects prs on prs.project_id=bgm.project_id 

where (lower(prs.project_city) like '%mumbai%')  or (lower(prs.project_city) like '%thane%')

group by 1,2,3 

order by 1 desc


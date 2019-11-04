--http://reports.livspace.com/question/2227

Select 
prs.project_id,
(case 
when lower(project_city) like '%bangalore%' or lower(project_city) like '%hyderabad%' or lower(project_city) like '%chennai%' or lower(project_city) like '%pune%' then project_city
when lower(project_city) like '%mumbai%' or lower(project_city) like '%thane%' then 'Mumbai'
when lower(project_city) like '%gurgaon%' or lower(project_city) like '%dwarka%' then 'Gurgaon'
when lower(project_city) like '%delhi%' or lower(project_city) like '%farida%' then 'Delhi'
when lower(project_city) like '%noida%' or lower(project_city) like '%ghaz%' then 'Noida'
end) as City,
prs.primary_gm,
prs.primary_cm,
prs.primary_designer,
bgm.logged_month,
sum(bgm.amount)

from
flat_tables.flat_projects prs 
left join launchpad_backend.project_bgmvs bgm on prs.project_id=bgm.project_id
where bgm.logged_month>=date_trunc('month',CURRENT_DATE) and prs.is_test_project=0
group by 1,2,3,4,5,6

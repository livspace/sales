--http://reports.livspace.com/question/2034

Select

prs.primary_designer,

(case when
lower(prs.project_designer_email) like '%.dp@%' then 'DP' else 'ID' end) as Type_of_ID,

prs.project_designer_email as Project_Designer_email,

(case 
when lower(project_city) like '%bangalore%' or lower(project_city) like '%hyderabad%' or lower(project_city) like '%chennai%' or lower(project_city) like '%pune%' then project_city
when lower(project_city) like '%mumbai%' or lower(project_city) like '%thane%' then 'Mumbai'
when lower(project_city) like '%gurgaon%' or lower(project_city) like '%dwarka%' then 'Gurgaon'
when lower(project_city) like '%delhi%' or lower(project_city) like '%farida%' then 'Delhi'
when lower(project_city) like '%noida%' or lower(project_city) like '%ghaz%' then 'Noida'
end) as City,

sum(bgm.amount) as Bgmv 

from launchpad_backend.project_bgmvs bgm

left join flat_tables.flat_projects prs 

on prs.project_id=bgm.project_id

where (bgm.logged_month>=date_trunc('month',current_date))
group by 1,2,3,4 
order by City

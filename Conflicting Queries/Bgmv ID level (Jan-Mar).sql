--http://reports.livspace.com/question/2028

Select

(case when
lower(prs.project_designer_email) not like '%.dp@%' then prs.primary_designer end )as Primary_Designer,


(case when
lower(prs.project_designer_email) not like '%.dp@%' then prs.project_designer_email end )as Project_Designer_email,

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

where (bgm.logged_month>='2019-01-01'::date and bgm.logged_month<='2019-03-31'::date)
group by 1,2,3 order by City


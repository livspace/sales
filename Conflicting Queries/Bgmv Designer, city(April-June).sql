--http://reports.livspace.com/question/2020

Select

(case when
lower(prs.project_designer_email) not like '%dp%' then prs.project_designer_email end )as Project_Designer_email,

(case when
lower(prs.project_designer_email) not like '%dp%' then prs.primary_designer end )as Primary_Designer,


prs.project_city as City,

sum(gml.amount) as Bgmv 

from launchpad_backend.project_gmv_ledger gml

left join flat_tables.flat_projects prs 

on prs.project_id=gml.project_id

where (gml.added_at>='2019-04-01'::date and gml.added_at<='2019-06-30'::date)
group by 1,2,3 order by City


--http://reports.livspace.com/question/1730

select p.primary_designer,date(p.ten_percent_collected_date) as first_project_date,sum(tp.amount) as bgmv_first_project

from 

(select

prs.primary_designer,
prs.ten_percent_collected_date as ten_percent_collected_date,
max(ten_percent_collected_date) over (partition by prs.primary_designer) as max_ten_percent_collected_date,
prs.project_id

from flat_tables.flat_projects prs


where prs.ten_percent_collected_date is not null 

and prs.project_city like '%umba%' or prs.project_city like '%han%' and prs.is_test_project=false
) p


left join launchpad_backend.project_gmv_ledger tp on tp.project_id=p.project_id

where p.ten_percent_collected_date=p.max_ten_percent_collected_date

group by p.primary_designer,p.ten_percent_collected_date,p.max_ten_percent_collected_date,p.project_id

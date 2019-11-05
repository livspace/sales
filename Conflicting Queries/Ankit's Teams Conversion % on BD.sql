--http://reports.livspace.com/question/2485

select
prs.primary_cm,

((count(distinct(case when prs.project_stage_weight>=400 and extract(month from prs.project_created_at)=extract(month from current_date-192)

then prs.project_id end))*1.0)
/
count(distinct(case when prs.project_stage_weight>=250 and extract(month from prs.project_created_at)=extract(month from current_date-192)

then prs.project_id end))) * 100 as M0_6,

((count(distinct(case when prs.project_stage_weight>=400 and extract(month from prs.project_created_at)=extract(month from current_date-160)

then prs.project_id end))*1.0)
/
count(distinct(case when prs.project_stage_weight>=250 and extract(month from prs.project_created_at)=extract(month from current_date-160)

then prs.project_id end))) * 100 as M0_5,


((count(distinct(case when prs.project_stage_weight>=400 and extract(month from prs.project_created_at)=extract(month from current_date-128)

then prs.project_id end))*1.0)
/
count(distinct(case when prs.project_stage_weight>=250 and extract(month from prs.project_created_at)=extract(month from current_date-128)

then prs.project_id end))) * 100 as M0_4,



((count(distinct(case when prs.project_stage_weight>=400 and extract(month from prs.project_created_at)=extract(month from current_date-96)

then prs.project_id end))*1.0)
/
count(distinct(case when prs.project_stage_weight>=250 and extract(month from prs.project_created_at)=extract(month from current_date-96)

then prs.project_id end))) * 100 as M0_3,


((count(distinct(case when prs.project_stage_weight>=400 and extract(month from prs.project_created_at)=extract(month from current_date-64)

then prs.project_id end))*1.0)
/
count(distinct(case when prs.project_stage_weight>=250 and extract(month from prs.project_created_at)=extract(month from current_date-64)

then prs.project_id end))) * 100 as M0_2,


((count(distinct(case when prs.project_stage_weight>=400 and extract(month from prs.project_created_at)=extract(month from current_date-32)

then prs.project_id end))*1.0)
/
count(distinct(case when prs.project_stage_weight>=250 and extract(month from prs.project_created_at)=extract(month from current_date-32)

then prs.project_id end))) * 100 as M0_1,




((count(distinct(case when prs.project_stage_weight>=400 and extract(month from prs.project_created_at)=extract(month from current_date)

then prs.project_id end))*1.0)
/
count(distinct(case when prs.project_stage_weight>=250 and extract(month from prs.project_created_at)=extract(month from current_date)

then prs.project_id end))) * 100 as M0




from 
flat_tables.flat_projects prs 
where 
prs.primary_cm in ('Rahul Jain','Gourav Goyal', 'Nikhil Malpani', 'Sampada Karmarkar','Praneet  Singh','Charu Gupta')

and to_date(prs.project_created_at,'YYYY-MM-DD') >=date_trunc('month', current_date - interval '6 month')

group by 1

--http://reports.livspace.com/question/2533

select 


prs.primary_cm,
EXTRACT(MONTH FROM prs.bc_scheduled_date) AS month,
(case when month = 7 then 'Jul' when month = 8 then 'Aug' when month = 9 then 'Sep' when month = 10 then 'Oct' end) as monthname,
(case when EXTRACT(DAY FROM prs.bc_scheduled_date) < 16 THEN 1 ELSE 2 END) as fortnight, 
count(prs.project_id) as QL, 

count(case when prs.project_stage_weight>300 then prs.project_id end) as conv,
count(case when prs.project_stage_weight>300 then prs.project_id end)*100/count(prs.project_id) as conv_pct,

count(case when prs.project_stage_weight>=250 then prs.project_id end)*100/count(prs.project_id) as bd_pct,
count(case when prs.project_stage_weight>=270 then prs.project_id end)*100/count(prs.project_id) as pp_pct,
--count(case when prs.project_stage_weight>300 then prs.project_id end)*100/count(case when prs.project_stage_weight>=270 then prs.project_id end) as pp_conv,
count(case when prs.project_status='INACTIVE' then prs.project_id end)*100/count(prs.project_id) as dq_pct,
count(case when prs.project_status='ACTIVE' then prs.project_id end)*100/count(prs.project_id) as ac_pct,

count(case when prs2.conversion_probability='high' and prs.project_status = 'ACTIVE' then prs.project_id end) as high,
count(case when prs2.conversion_probability='medium' and prs.project_status = 'ACTIVE' then prs.project_id end) as medium,

( (0.8*count(case when prs2.conversion_probability='high' and prs.project_status = 'ACTIVE' then prs.project_id end)) + (0.5*count(case when prs2.conversion_probability='medium' and prs.project_status = 'ACTIVE' then prs.project_id end)) ) as exp_more,

( (0.8*count(case when prs2.conversion_probability='high' and prs.project_status = 'ACTIVE' then prs.project_id end)) + (0.5*count(case when prs2.conversion_probability='medium' and prs.project_status = 'ACTIVE' then prs.project_id end)) + count(case when prs.project_stage_weight>300 then prs.project_id end) ) as final,

( (0.8*count(case when prs2.conversion_probability='high' and prs.project_status = 'ACTIVE' then prs.project_id end)) + (0.5*count(case when prs2.conversion_probability='medium' and prs.project_status = 'ACTIVE' then prs.project_id end)) + count(case when prs.project_stage_weight>300 then prs.project_id end) )*100
/count(prs.project_id) as final_pct

from flat_tables.flat_projects prs
left join launchpad_backend.projects prs2 on prs2.id = prs.project_id

where prs.primary_cm in 
('Ankita Jha','Natasha Sharon Shah','Shreyasi Jain','Himanshi Sharma','Heli Kumar','Satish Prasad  Sahu ','Anjuli Gupta','Mohammad Takki',
'Sanjukta Das','Anvi Khare','Suvita Khosla','Riddhi Parekh','Sravani Ayyagari','Peeyush Raheja',
'Ramya Varier','Justin Thomas','Abhishek Bajaj','Devendra Pareek','Vinita Bumb') 

and prs.project_city='Pune'

and prs.bc_scheduled_date>='2019-08-01'::date
group by prs.primary_cm, EXTRACT(MONTH FROM prs.bc_scheduled_date), fortnight 
order by prs.primary_cm, month, fortnight;

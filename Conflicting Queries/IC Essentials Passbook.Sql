--http://reports.livspace.com/question/2430?MONTH=9&city=Bangalore

select 

prs.project_city,
prs.primary_designer,
EXTRACT(MONTH FROM prs.bc_scheduled_date) AS month,
(case when month = 7 then 'Jul' when month = 8 then 'Aug' when month = 9 then 'Sep' when month = 10 then 'Oct' end) as monthname,
(case when EXTRACT(DAY FROM prs.bc_scheduled_date) < 16 THEN 1 ELSE 2 END) as fortnight, 
count(prs.project_id) as QL, 

count(case when prs.project_stage_weight>300 then prs.project_id end) as conv,
count(case when prs.project_stage_weight>300 then prs.project_id end)*100/count(prs.project_id) as conv_pct,

count(case when prs.project_stage_weight>=250 then prs.project_id end)*100/count(prs.project_id) as bd_pct,
count(case when prs.project_stage_weight>=270 then prs.project_id end)*100/count(prs.project_id) as pp_pct,
count(case when prs.project_status='INACTIVE' then prs.project_id end)*100/count(prs.project_id) as dq_pct,
count(case when prs.project_status='ACTIVE' then prs.project_id end)*100/count(prs.project_id) as ac_pct,

count(case when prs2.conversion_probability='high' then prs.project_id end) as high,
count(case when prs2.conversion_probability='medium' then prs.project_id end) as medium,

( (0.8*count(case when prs2.conversion_probability='high' then prs.project_id end)) + (0.5*count(case when prs2.conversion_probability='medium' then prs.project_id end)) ) as exp_more,

( (0.8*count(case when prs2.conversion_probability='high' then prs.project_id end)) + (0.5*count(case when prs2.conversion_probability='medium' then prs.project_id end)) + count(case when prs.project_stage_weight>300 then prs.project_id end) ) as final,

( (0.8*count(case when prs2.conversion_probability='high' then prs.project_id end)) + (0.5*count(case when prs2.conversion_probability='medium' then prs.project_id end)) + count(case when prs.project_stage_weight>300 then prs.project_id end) )*100
/count(prs.project_id) as final_pct

from flat_tables.flat_projects prs
left join launchpad_backend.projects prs2 on prs2.id = prs.project_id

where prs.primary_designer in 

('Prateek Saraf','Reshu Agrawal','Janki Bhrany','Kiran chinchkar','Pooja Gaikwad','Pragya Gupta','Dimple Khemani','Neeraj Jain','Shraddha','Vishakha Dehadray','Aseem Mehta','Chinky Bharadwaj','Hemant Deshmukh',
'Prem Varma','Pritam Varma','Ankita Chawla','Diana Anthony','Kshitij Kishore','Linford','Aiman Shaikh','Shree Nanavaty','Abdul KS','Lakshmi priya','Harleen','Kamal','Har Rajinder','Kartik',
'Harshita','Richa','Priyadharshini  V','Deepan V','Anis Fathima S','Karthik DK','Ranjan','Kanchan','Rupanshu','Shadab Ahmad','Prasanna Sakam','Bageshree Ranade','Ragini Kininge') 




and EXTRACT(MONTH FROM prs.bc_scheduled_date)={{MONTH}}
and prs.project_city={{city}}
group by prs.project_city, prs.primary_designer, EXTRACT(MONTH FROM prs.bc_scheduled_date), fortnight 
order by prs.project_city, prs.primary_designer, month, fortnight;

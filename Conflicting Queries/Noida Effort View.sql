--http://reports.livspace.com/question/2532

select 
prs.primary_cm, 

-- EFFORT --

count(distinct(case when pvs2.new_value=21 and pvs2.event_date>='2019-10-01' then prs.project_id end)) as no_of_pitches,
count(distinct(case when pvs2.new_value=4 and pvs2.event_date>='2019-10-01' then prs.project_id end)) as DIP,

-- EXPECTED --

count(distinct(case when EXTRACT(MONTH FROM prs2.probable_month)=10 and prs2.conversion_probability='high' and prs.project_status = 'ACTIVE' and prs.project_stage_weight<400 then prs.project_id end)) as high,
count(distinct(case when EXTRACT(MONTH FROM prs2.probable_month)=10 and prs2.conversion_probability='medium' and prs.project_status = 'ACTIVE' and prs.project_stage_weight<400 then prs.project_id end)) as med,

count(distinct(case when EXTRACT(MONTH FROM prs2.probable_month)=10 and prs2.conversion_probability='high' and prs.project_status = 'ACTIVE' and prs.project_stage_weight<400 then prs.project_id end))*0.8
+
count(distinct(case when EXTRACT(MONTH FROM prs2.probable_month)=10 and prs2.conversion_probability='medium' and prs.project_status = 'ACTIVE' and prs.project_stage_weight<400 then prs.project_id end))*0.5
as expected,

-- BSC DECAY --

count(distinct(case when prs.stage_id in (23,13) and pvs2.new_value in (23,13) and prs.project_status = 'ACTIVE' and pvs2.event_date< CURRENT_DATE - INTERVAL '7 days'
then prs.project_id end)) as BCS_Decay,

count(distinct(case when prs.stage_id in (23,13) and prs.project_status = 'ACTIVE' then prs.project_id end)) as BSC,

(count(distinct(case when prs.stage_id in (23,13) and pvs2.new_value in (23,13) and prs.project_status = 'ACTIVE' and pvs2.event_date< CURRENT_DATE - INTERVAL '7 days'
then prs.project_id end))*100)
/
(count(distinct(case when prs.stage_id in (23,13) and prs.project_status = 'ACTIVE' then prs.project_id end)) )
as bsc_pct,

-- BD DECAY --

count(distinct(case when prs.stage_id in (9,19,20) and pvs2.new_value in (9,19,20) and prs.project_status = 'ACTIVE' and pvs2.event_date< CURRENT_DATE - INTERVAL '7 days'
then prs.project_id end)) as BD_Decay,

count(distinct(case when prs.stage_id in (9,19,20) and prs.project_status = 'ACTIVE' then prs.project_id end)) as BD,

(count(distinct(case when prs.stage_id in (9,19,20) and pvs2.new_value in (9,19,20) and prs.project_status = 'ACTIVE' and pvs2.event_date< CURRENT_DATE - INTERVAL '7 days'
then prs.project_id end))*100)
/
(count(distinct(case when prs.stage_id in (9,19,20) and prs.project_status = 'ACTIVE' then prs.project_id end)) )
as bd_pct

-- END --

from flat_tables.flat_projects prs
left join launchpad_backend.projects prs2 on prs2.id = prs.project_id
left join flat_tables.flat_project_events pvs2 on pvs2.project_id=prs.project_id
/*left join flat_tables.flat_project_events pvs on prs.project_id=pvs.project_id and pvs.new_value=23 
left join flat_tables.flat_project_events pvs2 on pvs.project_id=pvs2.project_id*/

where prs.primary_cm in 
('Shivali Rajpal','Shivangi Agrawal','Shashwat Sharma','Siddharth Gupta',
'Shuchi','Aashna Haryani','Nipun Sareen','Amar Sidhu','Nidhi Bhasin','Palak Jolly','Neha Dhawan','Nidhi Agarwal','Akanksha Luthra','Nilutpal Baruah','Mohit Behal') 

and prs.project_city='Noida'

group by prs.primary_cm
order by bd_pct;

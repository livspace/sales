Select 
(case 
when lower(project_city) like '%bangalore%' or lower(project_city) like '%hyderabad%' or lower(project_city) like '%chennai%' or lower(project_city) like '%pune%' then project_city
when lower(project_city) like '%mumbai%' or lower(project_city) like '%thane%' then 'Mumbai'
when lower(project_city) like '%gurgaon%' or lower(project_city) like '%dwarka%' then 'Gurgaon'
when lower(project_city) like '%delhi%' or lower(project_city) like '%farida%' then 'Delhi'
when lower(project_city) like '%noida%' or lower(project_city) like '%ghaz%' then 'Noida'
end) as City,
prs.primary_cm,
prs.primary_designer,
count(distinct(case when pvs.new_value=23 and pvs.event_date< CURRENT_DATE - INTERVAL '7 days' then prs.project_id end)) as BCS_Decay_count,
nullif(count(distinct(case when (pvs.new_value=23 and pvs.event_date< CURRENT_DATE - INTERVAL '7 days') then prs.project_id end)),0)/nullif(count(distinct(case when pvs.new_value=23 then prs.project_id end)),0) as BCS_Decay_Percent,
count(distinct(case when pvs.new_value=9 and pvs.event_date< CURRENT_DATE - INTERVAL '7 days' then prs.project_id end)) as BD_Decay_count,
nullif(count(distinct(case when (pvs.new_value=9 and pvs.event_date< CURRENT_DATE - INTERVAL '7 days') then prs.project_id end)),0)/nullif(count(distinct(case when pvs.new_value=9 then prs.project_id end)),0) as BD_Decay_Percent


from flat_tables.flat_projects prs
left join flat_tables.flat_project_events pvs on prs.project_id=pvs.project_id 
where pvs.event_date>=date_trunc('month',CURRENT_DATE) 
and prs.primary_cm in ('Nidhi Agarwal','Anjuli Gupta','Abhishek Sharma','Palak Jolly','Rinkesh Bafna','Gautam Gupta','Sri Harsha Ks','Mohammed Azharuddin','Tarun Garg','Prateek Bharadwaj','Himanshi Sharma','Abhishek Sharma','Heli Kumar','Chandana  Ainwale','Annu  Bala','Natasha Sharon Shah','Natasha .','Satish Prasad  Sahu','Mohammad Takki','Shuchi',
'Nitin Bhatia')

group by 1,2,3

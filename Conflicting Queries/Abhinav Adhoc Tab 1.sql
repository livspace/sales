--http://reports.livspace.com/question/2556

Select 
prs.project_id,
prs.project_city,
prs.primary_cm,
to_char(prs.project_created_at,'YYYY-MM') as "Created month",
to_char(ql.event_date,'YYYY-MM') as "QL month",
to_char(cm_assigned_date.event_date,'YYYY-MM') as "Cm Assigned Month",
to_char(bd.event_date,'YYYY-MM') as "BD Month",
to_char(pp.event_date,'YYYY-MM') as "PP Month",
to_char(dip.event_date,'YYYY-MM') as "Dip Month",
(case when brief_scope like '%modular_kitchen_wardrobe%' or brief_scope like '%modular_kitchen%' then 'KNW'
when brief_scope like '%full_home_interiors%' or brief_scope like '%full_home_design%' then 'FHD' end) as "Type",
(case when project_service_type='new_home' then 1 else 0 end) "New Home",
(case when project_service_type='existing_home' then 1 else 0 end) "Existing Home",
(case when project_service_type='resale' then 1 else 0 end) "Resale",
prs.budget_min,
prs.budget_max,
sum(bgm.amount) as gmv


from 
flat_tables.flat_projects prs 
left join flat_tables.flat_project_events ql on prs.project_id=ql.project_id and ql.new_value=23 
left join flat_tables.flat_project_events cm_assigned_date on prs.project_id=cm_assigned_date.project_id and cm_assigned_date.new_value=18
left join flat_tables.flat_project_events bd on prs.project_id=bd.project_id and bd.new_value=9
left join flat_tables.flat_project_events pp on prs.project_id=pp.project_id and pp.new_value=21
left join flat_tables.flat_project_events dip on prs.project_id=dip.project_id and dip.new_value=4
left join launchpad_backend.project_bgmvs bgm on prs.project_id=bgm.project_id

where prs.project_created_at>='2019-08-01'::date

and prs.primary_cm in ('Nidhi Agarwal','Anjuli Gupta','Abhishek Sharma','Palak Jolly','Rinkesh Bafna','Gautam Gupta','Sri Harsha Ks','Mohammed Azharuddin','Tarun Garg',
'Prateek Bharadwaj','Himanshi Sharma','Abhishek Sharma','Heli Kumar','Chandana  Ainwale','Annu  Bala','Natasha Sharon Shah','Satish Prasad  Sahu','Mohammad Takki','Shuchi',
'Nitin Bhatia','Shruti Prakash', 'Shreyasi Jain', 'Ankita Jha', 'Amar Sidhu', 'Sunil Karnad', 'Aratrika Bhagat')

and prs.project_city in ('Bangalore','Hyderabad','Chennai','Pune','Gurgaon','Noida','Ghaziabad')

group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15

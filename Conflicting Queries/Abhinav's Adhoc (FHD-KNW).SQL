--http://reports.livspace.com/question/2555

Select 

prs.project_id,
prs.project_city as City,

(case when brief_scope like '%modular_kitchen_wardrobe%' or brief_scope like '%modular_kitchen%' then 'KNW'
when brief_scope like '%full_home_interiors%' or brief_scope like '%full_home_design%' then 'FHD' end) as "Type",

sum(bgm.amount)

from flat_tables.flat_projects prs

left join flat_tables.flat_project_events pvs on prs.project_id=pvs.project_id and pvs.new_value=4 

left join launchpad_backend.project_bgmvs bgm on bgm.project_id=prs.project_id

where
date_diff('day',pvs.event_date,current_date)<=30
and prs.project_stage_weight>=400
 
 and prs.primary_cm in ('Nidhi Agarwal','Anjuli Gupta','Abhishek Sharma','Palak Jolly','Rinkesh Bafna','Gautam Gupta','Sri Harsha Ks','Mohammed Azharuddin','Tarun Garg',
'Prateek Bharadwaj','Himanshi Sharma','Abhishek Sharma','Heli Kumar','Chandana  Ainwale','Annu  Bala','Natasha Sharon Shah','Satish Prasad  Sahu','Mohammad Takki','Shuchi',
'Nitin Bhatia','Shruti Prakash', 'Shreyasi Jain', 'Ankita Jha', 'Amar Sidhu', 'Sunil Karnad', 'Aratrika Bhagat')

and prs.project_city in ('Bangalore','Hyderabad','Chennai','Pune','Gurgaon','Noida','Ghaziabad')


group BY 1,2,3

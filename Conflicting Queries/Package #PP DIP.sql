--http://reports.livspace.com/question/2374

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
count(distinct(case when pvs2.new_value=21 then prs.project_id end)) as no_of_pitches,
count(distinct(case when pvs2.new_value=4 then prs.project_id end)) as DIP

from flat_tables.flat_projects prs
left join launchpad_backend.questionnaire_answers qa on prs.project_id=qa.project_id
left join flat_tables.flat_project_events pvs on prs.project_id=pvs.project_id and pvs.new_value=23 
left join flat_tables.flat_project_events pvs2 on pvs.project_id=pvs2.project_id

where prs.primary_cm in ('Nidhi Agarwal','Anjuli Gupta','Abhishek Sharma','Palak Jolly','Rinkesh Bafna','Gautam Gupta','Sri Harsha Ks','Mohammed Azharuddin','Tarun Garg','Prateek Bharadwaj','Himanshi Sharma','Abhishek Sharma','Heli Kumar','Chandana  Ainwale','Annu  Bala','Natasha Sharon Shah','Natasha .','Satish Prasad  Sahu','Mohammad Takki','Shuchi',
'Nitin Bhatia') 
and lower(answers) like '%"feng shui": true%'

group by 1,2,3

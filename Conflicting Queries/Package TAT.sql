--http://reports.livspace.com/question/2375

select

prs.project_id,
(case 
when lower(project_city) like '%bangalore%' or lower(project_city) like '%hyderabad%' or lower(project_city) like '%chennai%' or lower(project_city) like '%pune%' then project_city
when lower(project_city) like '%mumbai%' or lower(project_city) like '%thane%' then 'Mumbai'
when lower(project_city) like '%gurgaon%' or lower(project_city) like '%dwarka%' then 'Gurgaon'
when lower(project_city) like '%delhi%' or lower(project_city) like '%farida%' then 'Delhi'
when lower(project_city) like '%noida%' or lower(project_city) like '%ghaz%' then 'Noida'
end) as City,
prs.primary_gm,
prs.primary_cm,
prs.primary_designer,
prs.customer_display_name,
prs.project_stage,
to_char(pvs.event_date,'YYYY-MM-DD') as "BCS Date",
to_char(pvs2.event_date,'YYYY-MM-DD') as "BD Date",
to_char(pvs3.event_date,'YYYY-MM-DD') as "PP Date",
to_char(pvs4.event_date,'YYYY-MM-DD') as "DIP Date"


from flat_tables.flat_projects prs
left join launchpad_backend.questionnaire_answers qa on prs.project_id=qa.project_id
left join launchpad_backend.projects lpb on prs.project_id=lpb.id
left join flat_tables.flat_project_events pvs on prs.project_id=pvs.project_id and pvs.new_value=23
left join flat_tables.flat_project_events pvs2 on prs.project_id=pvs2.project_id and pvs2.new_value=9
left join flat_tables.flat_project_events pvs3 on prs.project_id=pvs3.project_id and pvs3.new_value=21
left join flat_tables.flat_project_events pvs4 on prs.project_id=pvs4.project_id and pvs4.new_value=4
where prs.primary_cm in ('Nidhi Agarwal','Anjuli Gupta','Abhishek Sharma','Palak Jolly','Rinkesh Bafna','Gautam Gupta','Sri Harsha Ks','Mohammed Azharuddin','Tarun Garg','Prateek Bharadwaj','Himanshi Sharma','Abhishek Sharma','Heli Kumar','Chandana  Ainwale','Annu  Bala','Natasha Sharon Shah','Natasha .','Satish Prasad  Sahu','Mohammad Takki','Shuchi',
'Nitin Bhatia') and lower(answers) like '%"feng shui": true%'

group by 1,2,3,4,5,6,7,8,9,10,11
order by 1

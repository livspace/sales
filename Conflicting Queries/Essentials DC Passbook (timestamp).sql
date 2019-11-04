--http://reports.livspace.com/question/2292

select

prs.project_id,
prs.primary_gm,
prs.primary_cm,
prs.primary_designer,
prs.customer_display_name,
prs.project_stage,
(pvs.event_date) as "BCS Date",
(pvs2.event_date) as "DIP Date",
(pvs3.event_date) as "PP Date"

from flat_tables.flat_projects prs
left join flat_tables.flat_project_events pvs on prs.project_id=pvs.project_id and pvs.new_value=23
left join flat_tables.flat_project_events pvs2 on prs.project_id=pvs2.project_id and pvs2.new_value=4
left join flat_tables.flat_project_events pvs3 on prs.project_id=pvs3.project_id and pvs3.new_value=21
where prs.primary_cm in ('Nidhi Agarwal','Anjuli Gupta','Abhishek Sharma','Palak Jolly','Rinkesh Bafna','Gautam Gupta','Sri Harsha Ks','Mohammed Azharuddin','Tarun Garg','Prateek Bharadwaj','Himanshi Sharma','Abhishek Sharma','Heli Kumar','Chandana  Ainwale','Annu  Bala','Natasha Sharon Shah','Natasha .','Satish Prasad  Sahu','Mohammad Takki','Shuchi',
'Nitin Bhatia') and pvs.event_date>='2018-09-01'

group by 1,2,3,4,5,6,7,8,9
order by 1

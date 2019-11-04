--http://reports.livspace.com/question/2397

select
prs.project_id,
prs.primary_cm,
prs.primary_designer,
prs.project_city,
(case when prs.project_stage_weight=130 then to_char(pvs.event_date,'YYYY-MM-DD') end) as bcs_date,
(case when prs.project_stage_weight=150 then to_char(pvs2.event_date,'YYYY-MM-DD') end) as PL_date,
(case when prs.project_stage_weight=250 then to_char(pvs3.event_date,'YYYY-MM-DD') end) as BD_date,
(case when prs.project_stage_weight=260 then to_char(pvs4.event_date,'YYYY-MM-DD') end) as PC_date,
(case when prs.project_stage_weight=265 then to_char(pvs5.event_date,'YYYY-MM-DD') end) as PR_date,
(case when prs.project_stage_weight=270 then to_char(pvs6.event_date,'YYYY-MM-DD') end) as PP_date

from flat_tables.flat_projects prs 
left join flat_tables.flat_project_events pvs on prs.project_id=pvs.project_id and pvs.new_value=23
left join flat_tables.flat_project_events pvs2 on prs.project_id=pvs2.project_id and pvs2.new_value=13
left join flat_tables.flat_project_events pvs3 on prs.project_id=pvs3.project_id and pvs3.new_value=9
left join flat_tables.flat_project_events pvs4 on prs.project_id=pvs4.project_id and pvs4.new_value=19
left join flat_tables.flat_project_events pvs5 on prs.project_id=pvs5.project_id and pvs5.new_value=20
left join flat_tables.flat_project_events pvs6 on prs.project_id=pvs6.project_id and pvs6.new_value=21
where prs.project_status='ACTIVE' and prs.is_test_project=0 and prs.project_stage_weight in (130,150,250,260,265,270)
and prs.primary_cm in ('Nidhi Agarwal','Anjuli Gupta','Abhishek Sharma','Palak Jolly','Rinkesh Bafna','Gautam Gupta','Sri Harsha Ks','Mohammed Azharuddin','Tarun Garg','Prateek Bharadwaj','Himanshi Sharma','Abhishek Sharma','Heli Kumar','Chandana  Ainwale','Annu  Bala','Natasha Sharon Shah','Natasha .','Satish Prasad  Sahu','Mohammad Takki','Shuchi',
'Nitin Bhatia')

group by 1,2,3,4,5,6,7,8,9,10

--http://reports.livspace.com/question/2204

Select 

(case 
when project_city like '%angalor%' or project_city like '%yderaba%' or project_city like '%henn%' or project_city like '%une%' then project_city
when project_city like '%umba%' or project_city like '%han%' then 'Mumbai'
when project_city like '%urgao%' or project_city like '%wara%' then 'Gurgaon'
when project_city like '%elh%' or project_city like '%arid%' then 'Delhi'
when project_city like '%oid%' or project_city like '%haz%' then 'Noida'
end) as City,
prs.primary_gm,
prs.primary_cm,
to_char(pvs.event_date,'YYYY-MM') as CM_Assigned_date,
to_char(ods.order_created_at,'YYYY-MM')as order_created_at,

sum(ods.order_products_wt+ods.order_handling_fee) as Cgmv


from flat_tables.flat_orders ods

left join flat_tables.flat_projects prs on ods.project_id=prs.project_id

left join flat_tables.flat_project_events pvs on ods.project_id=pvs.project_id

where ods.order_created_at>='2019-01-01' and pvs.new_value=18 and pvs.event_date>='2019-01-01' and prs.is_test_project=0
group by 1,2,3,4,5
order by 1

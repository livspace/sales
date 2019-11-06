--http://reports.livspace.com/question/2356?City=Hyderabad

select
lpb.id as Project_ID,
lpb.customer_display_name as Client,
lpb.customer_phone as contact,

(case 
when lower(project_city) like '%bangalore%' or lower(project_city) like '%hyderabad%' or lower(project_city) like '%chennai%' or lower(project_city) like '%pune%' then project_city
when lower(project_city) like '%mumbai%' or lower(project_city) like '%thane%' or lower(project_city) like '%navi%' then 'Mumbai'
when lower(project_city) like '%gurgaon%' or lower(project_city) like '%dwarka%' then 'Gurgaon'
when lower(project_city) like '%delhi%' or lower(project_city) like '%farida%' then 'Delhi'
when lower(project_city) like '%noida%' or lower(project_city) like '%ghaz%' then 'Noida'
end) as City,
prs.primary_gm as GM,
prs.primary_cm as BM,
prs.primary_designer as Designer,
(case when
lower(prs.project_designer_email) like '%.dp@%' then 'DP' else 'ID' end )as Type,
prs.project_service_type,
prs.brief_scope,
lpb.conversion_probability,
prs.project_stage as Stage,
lpb.estimated_value as Estimated_value



from flat_tables.flat_projects prs 
left join launchpad_backend.projects lpb on prs.project_id=lpb.id
left join flat_tables.flat_project_events pvs on prs.project_id=pvs.project_id 
where pvs.new_value=18 and project_city ={{City}} and prs.project_stage_weight>265 and prs.project_stage_weight<=280 and lpb.status = 'ACTIVE'

/*group by 1,2,3,4,5,6,7,8*/

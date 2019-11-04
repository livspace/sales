--http://reports.livspace.com/question/2268

select

(case 
when lower(project_city) like '%bangalore%' or lower(project_city) like '%hyderabad%' or lower(project_city) like '%chennai%' or lower(project_city) like '%pune%' then project_city
when lower(project_city) like '%mumbai%' or lower(project_city) like '%thane%' then 'Mumbai'
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
count(distinct(case when prs.project_stage_weight=150 then prs.project_id end)) as "PROSPECTIVE LEADS",
count(distinct(case when prs.project_stage_weight=250 then prs.project_id end)) as "BD",
count(distinct(case when prs.project_stage_weight=270 then prs.project_id end)) as "PROPOSAL PRESENTED",
count(distinct(case when prs.project_stage_weight=280 then prs.project_id end)) as "AWAITING 10%"




from flat_tables.flat_projects prs 
left join launchpad_backend.projects lpb on prs.project_id=lpb.id
left join flat_tables.flat_project_events pvs on prs.project_id=pvs.project_id 
where pvs.new_value=18 and pvs.event_date>='2019-09-09'::date

group by 1,2,3,4,5,6,7,8

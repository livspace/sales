--http://reports.livspace.com/question/1872

select  
prs.id as canvas_id,
ct.display_name as city,
fp.primary_cm as BM,
fp.primary_designer as Designer,
fp.primary_gm as GM,
fp.project_stage as stage,
fp.project_status as status,
prs.inactivation_reason



from launchpad_backend.projects prs 

left join launchpad_backend.cities ct on ct.id=prs.city_id 
left join flat_tables.flat_projects fp on fp.project_id=prs.id  

where ct.display_name like '%Sing%'

--http://reports.livspace.com/question/1314

Select ps.*
from
flat_tables.flat_project_settings ps
left join launchpad_backend.projects p on p.id=ps.project_id
where p.status = 'ACTIVE'
and p.stage_id in (3,4,7,5,14,6,15,16,10,12)

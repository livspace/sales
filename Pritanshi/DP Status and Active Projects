Select 
t.dp_id,
t.bouncer_id as "Bouncer ID", 
t.name as "DP Name", 
t.last_login,
t.city,
t.Livspace_email as "Email",
bs.status as "Status",
t.CM_bouncer_id as  "Reporting Manager Bouncer ID", 
bu.display_name as "CM", 
bv.email as "CM Email address",
t.date_of_onboarding as "Date Of Onboarding",
t.phone as "DP Mobile",
count(distinct prs.id) as "# of Active projects"

from 
(
Select cu.id as dp_id,cu.login_id as bouncer_id,  cu.name,cu.bouncer_email as Livspace_email, bu.manager_id as CM_bouncer_id,
to_char(bu.created_at,'dd-mm-yyyy') as date_of_onboarding, cu.phone,lbc.display_name as city,
 cu.status,cu.address_id,bu.web_login_at as last_login
from (select * from community.user) as cu
left join bouncer_web.users as bu on bu.id = cu.login_id
left join launchpad_backend.cities as lbc on lbc.id = bu.city_id 

) as t
left join bouncer_web.users as bu on bu.id = t.CM_bouncer_id
left join launchpad_backend.bouncer_users as bv on bv.bouncer_id = t.CM_bouncer_id
left join bouncer_web.users as bs on bs.id = t.bouncer_id

left join launchpad_backend.project_settings ps on ps.primary_designer_id=t.bouncer_id and ps.is_deleted = 0 
left join 
(select * from launchpad_backend.projects 
where created_at > current_date - interval '3' month
and status = 'ACTIVE') prs 
on prs.id=ps.project_id



group by t.bouncer_id,t.dp_id,t.name,t.livspace_email,bs.status,t.last_login,t.city,t.cm_bouncer_id,bu.display_name,bv.email,t.date_of_onboarding,t.phone

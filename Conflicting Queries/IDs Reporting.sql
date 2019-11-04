http://reports.livspace.com/question/1926

select 

bu.display_name as "BM Name",
fbu.tags as Designation,
count(distinct fbr.id) as "#IDs Reporting",
count(distinct cu.dp_bouncer_id) as "#DPs Reporting"


from bouncer_web.users bu

left join flat_tables.flat_bouncer_user fbu on fbu.bouncer_id = bu.id

left join (select a.* from bouncer_web.users a,bouncer_web.person_to_roles b where a.is_enabled = 1 and a.uid not like '%dp@%' 
and b.user_id = a.id and b.role_id = 8) fbr on fbr.manager_id = bu.id



left join (select 
u.login_id as dp_bouncer_id,
a.activation_status as dp_activation_status,
a.manager_id as dp_reporting_manager
from Community.user u
left join Community.account a on a.id=u.account_id 
where u.user_type='DESIGN_PARTNER' and a.activation_status='ACTIVE') cu on cu.dp_reporting_manager=bu.id

where fbu.tags='COMMUNITY_MANAGER' and lower(bu.display_name) not like '%dummy%' 

group by 1,2

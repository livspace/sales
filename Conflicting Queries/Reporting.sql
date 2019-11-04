--http://live-data.livspace.com/question/2039

select 
a.display_name as designer_name,
c.display_name as bm_name

from bouncer_web.users a

left join bouncer_web.person_to_roles b on b.user_id = a.id 

left join bouncer_web.users c on c.id=a.manager_id

where a.status = 'ACTIVE' and a.uid not like '%dp@%' and b.role_id = 8

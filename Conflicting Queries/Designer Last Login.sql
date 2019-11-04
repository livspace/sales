--http://reports.livspace.com/question/2195

select name as "Designer Name",
tags as "Type ",
email as Email,
date(created_at) as "Canvas Access given at",
date(user_last_seen) as "Last login date" 

from flat_tables.flat_bouncer_user 

where lower(tags) like '%inter%'

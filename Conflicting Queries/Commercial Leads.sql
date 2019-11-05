--http://live-data.livspace.com/question/831

select 
    concat(' ',l.id) as lead_id,
    concat(' ',c.id_customer) as customer_id,
    concat(CONCAT(c.firstname,' '),c.lastname) as customer_name,
    c.email as email,
    c.designation as designation,
    c.company_name as company_name,
    c.city as city,
    concat(' ',c.phone) as mobile,
    concat(' ',l.pincode) as pincode,
    l.date_add,
    l.quiz as quiz
from 
    livspace_v2.ps_customer_leads l
join
    livspace_v2.ps_customer c
        on c.id_customer = l.id_customer
where 
    landing_page_id = 16
    [[ and l.date_add >= {{created_from}}]]
    [[ and l.date_add >= {{created_to}}]]
order by l.id desc    

--http://reports.livspace.com/question/1924

select 

rf.id as referral_id,
rf.name as referred_dp_name,
rf.email as referred_dp_email,
rf.phone as referred_dp_phone,
rf.city as referred_dp_city,
us.name as referrer_name,
us.email as referrer_email,
date(rf.created_at) as referral_created_at,
date(cu.created_at) as "community Profile Created At",
date(conv.design_in_progress) as "First Project Converted At",
conv.project_id as "First Project Canvas ID",
ba.Name as referrer_community_name,
ba.account_number AS referrer_community_number,
ba.bank_name as referrer_bank_name, 
ba.branch_name as referrer_branch_name, 
ba.ifsc_code as ifsc_code,
ba.Name as referred_dp_community_name,
ba.account_number as referred_dp_account_number,
ba.bank_name as referred_dp_bank_name, 
ba.branch_name as referred_dp_branch_name, 
ba.ifsc_code as referred_dp_ifsc_code



from community.referral rf

left join community.user cu on lower(cu.email) = lower(rf.email) or cu.phone = rf.phone

left join flat_tables.flat_bouncer_user us on us.bouncer_id=rf.referrer_id

left join community.user cu1 on cu1.login_id=us.bouncer_id

left join community.bank_account ba on cu1.account_id=ba.owner_id

left join community.bank_account ba1 on cu.account_id=ba1.owner_id

left join (Select * from
(Select primary_designer, 
design_in_progress,
project_id,
row_number() over (Partition by primary_designer order by design_in_progress asc) as highest
from flat_tables.flat_projects where project_stage_weight>=400 and lower(project_designer_email) like '%.dp@%') as ranked where ranked.highest=1) conv on lower(conv.primary_designer)=lower(cu.name)

where rf.user_type = 'DESIGN_PARTNER'

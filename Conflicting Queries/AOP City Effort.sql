--http://reports.livspace.com/question/2398

	Select B.primary_GM, B.city, B.month, B.lead_medium_source,
	sum(case when B.Incoming_leads = 'Incoming_leads' then B.lead_count else 0 end) as incoming_leads,
	sum(case when B.Incoming_leads = 'Effective_leads' then B.lead_count else 0 end) as Effective_leads,
	sum(case when B.Incoming_leads = 'ps_assigned' then B.lead_count else 0 end) as ps_assigned,
	sum(case when B.Incoming_leads = 'BC_scheduled' then B.lead_count else 0 end) as BC_scheduled,
	sum(case when B.Incoming_leads = 'Briefing_Done' then B.lead_count else 0 end) as Briefing_done,
	sum(case when B.Incoming_leads = 'Proposal_presented' then B.lead_count else 0 end) as Proposal_presented,
	sum(case when B.Incoming_leads = 'Conversion' then B.lead_count else 0 end) as Conversion

	From

	(
	Select A.primary_GM,A.city, 'Incoming_leads' as incoming_leads, A.incoming_month as month, A.lead_medium_source, count(A.incoming_month) as lead_count
	from
	(
	select p.id,to_char(p.created_at,'YYYY-MM') as Incoming_Month,
	bu1.name as Primary_CM,
	bu2.name as Primary_GM,
	bu3.name as Primary_designer,
	case when p.pincode in (110075,110078,110079,110077) then 'Gurgaon'
		 when lower(c.display_name) like 'bangalore' then 'Bangalore'
		 when lower(c.display_name) like 'chennai' then 'Chennai' 
		 when lower(c.display_name) in ('delhi') then 'Delhi'
		  when lower(c.display_name) in ('ghaziabad') then 'Noida'
		   when lower(c.display_name) in ('faridabad') then 'Delhi'
			when lower(c.display_name) in ('dwarka') then 'Gurgaon'
		 when lower(c.display_name) like 'gurgaon' then 'Gurgaon'
		 when lower(c.display_name) like 'hyderabad' then 'Hyderabad'
		 when lower(c.display_name) IN  ('mumbai') then 'Mumbai'
		 when lower(c.display_name) like '%thane%' then 'Mumbai'
		 when lower(c.display_name) like '%navi mumbai%' then 'Mumbai'
		 when lower(c.display_name) IN ('noida') then 'Noida'
		 when lower(c.display_name) IN ('pune') then 'Pune'
		 ELSE 'Others' end as city,
	case when p.lead_medium_id in (167) then 'referral'
		when p.lead_medium_id in (171) or  (p.lead_source_id in (164) and p.lead_medium_id not in (167)) then 'Direct'
		when p.lead_source_id in ( 163,162,161,174,175,176) and( p.lead_medium_id is NULL or p.lead_medium_id not in (167)) then 'Affiliates'
	else 'online' end as lead_medium_source

	From launchpad_backend.projects as p 
	left join launchpad_backend.project_settings as s on s.project_id = p.id and s.is_deleted = 0 
	left join launchpad_backend.bouncer_users as bu1 on bu1.bouncer_id = s.primary_cm_id  
	left join launchpad_backend.bouncer_users as bu2 on bu2.bouncer_id = s.primary_GM_id
	left join launchpad_backend.bouncer_users as bu3 on bu3.bouncer_id = s.primary_designer_id
	left join launchpad_backend.cities as c on c.id = p.city_id

	where to_date(p.created_at,'YYYY-MM-DD') >= '2018-04-01'
	and p.is_test = 0 
	and p.pincode not in (401201,401202,401203,401208,401210,401207,401209,404404,401303,401304) and  p.pincode not in (401305)
	) as A

	 -- where A.incoming_month >= '2018-04-01'
	Group by 1,2,3,4,5

	UNION

	Select A.primary_GM,A.city, 'Effective_leads' as incoming_leads, A.incoming_month as month, A.lead_medium_source, count(A.incoming_month) as count
	from
	(
	select p.id,to_char(pe1.created_at,'YYYY-MM') as Incoming_Month,
	bu1.name as Primary_CM,
	bu2.name as Primary_GM,
	bu3.name as Primary_designer,
	case when p.pincode in (110075,110078,110079,110077) then 'Gurgaon'
		 when lower(c.display_name) like 'bangalore' then 'Bangalore'
		 when lower(c.display_name) like 'chennai' then 'Chennai' 
		 when lower(c.display_name) in ('delhi') then 'Delhi'
		  when lower(c.display_name) in ('ghaziabad') then 'Noida'
		   when lower(c.display_name) in ('faridabad') then 'Delhi'
			when lower(c.display_name) in ('dwarka') then 'Gurgaon'
		 when lower(c.display_name) like 'gurgaon' then 'Gurgaon'
		 when lower(c.display_name) like 'hyderabad' then 'Hyderabad'
		 when lower(c.display_name) IN  ('mumbai') then 'Mumbai'
		 when lower(c.display_name) like '%thane%' then 'Mumbai'
		 when lower(c.display_name) like '%navi mumbai%' then 'Mumbai'
		 when lower(c.display_name) IN ('noida') then 'Noida'
		 when lower(c.display_name) IN ('pune') then 'Pune'
		 ELSE 'Others' end as city,
	case when p.lead_medium_id in (167) then 'referral'
		when p.lead_medium_id in (171) or  (p.lead_source_id in (164) and p.lead_medium_id not in (167)) then 'Direct'
		when p.lead_source_id in ( 163,162,161,174,175,176) and( p.lead_medium_id is NULL or p.lead_medium_id not in (167)) then 'Affiliates'
	else 'online' end as lead_medium_source

	From launchpad_backend.projects as p 
	left join launchpad_backend.project_settings as s on s.project_id = p.id and s.is_deleted = 0 
	left join launchpad_backend.bouncer_users as bu1 on bu1.bouncer_id = s.primary_cm_id  
	left join launchpad_backend.bouncer_users as bu2 on bu2.bouncer_id = s.primary_GM_id
	left join launchpad_backend.bouncer_users as bu3 on bu3.bouncer_id = s.primary_designer_id
	left join launchpad_backend.cities as c on c.id = p.city_id
	left join ( select distinct ps.project_id, min(ps.created_at) as created_at
	from  launchpad_backend.project_events as ps  
	where event_type in ('STAGE_UPDATED')
	-- AND new_value = 17
	and is_deleted = 0
	and coalesce(new_value)::integer in (17,18,13,2,	8,	9,	19,	11,	20,	21,	12,	3,	4,	7,	5,	14,	6,	15,	16,	10)
	group by 1 
	)
	as pe1 on pe1.project_id = p.id
	where to_date(pe1.created_at,'YYYY-MM-DD') >= '2018-04-01'
	and p.is_test = 0 
	and p.pincode not in (401201,401202,401203,401208,401210,401207,401209,404404,401303,401304) and  p.pincode not in (401305)
	) as A

	-- where A.incoming_month >= '2018-04-01'
	Group by 1,2,3,4,5

	union


	Select A.primary_GM,A.city, 'ps_assigned' as incoming_leads, A.incoming_month as month, A.lead_medium_source, count(A.incoming_month) as count
	from
	(
	select p.id,to_char(pe2.created_at,'YYYY-MM') as Incoming_Month,
	bu1.name as Primary_CM,
	bu2.name as Primary_GM,
	bu3.name as Primary_designer,
	case when p.pincode in (110075,110078,110079,110077) then 'Gurgaon'
		 when lower(c.display_name) like 'bangalore' then 'Bangalore'
		 when lower(c.display_name) like 'chennai' then 'Chennai' 
		 when lower(c.display_name) in ('delhi') then 'Delhi'
		  when lower(c.display_name) in ('ghaziabad') then 'Noida'
		   when lower(c.display_name) in ('faridabad') then 'Delhi'
			when lower(c.display_name) in ('dwarka') then 'Gurgaon'
		 when lower(c.display_name) like 'gurgaon' then 'Gurgaon'
		 when lower(c.display_name) like 'hyderabad' then 'Hyderabad'
		 when lower(c.display_name) IN  ('mumbai') then 'Mumbai'
		 when lower(c.display_name) like '%thane%' then 'Mumbai'
		 when lower(c.display_name) like '%navi mumbai%' then 'Mumbai'
		 when lower(c.display_name) IN ('noida') then 'Noida'
		 when lower(c.display_name) IN ('pune') then 'Pune'
		 ELSE 'Others' end as city,
	case when p.lead_medium_id in (167) then 'referral'
		when p.lead_medium_id in (171) or  (p.lead_source_id in (164) and p.lead_medium_id not in (167)) then 'Direct'
		when p.lead_source_id in ( 163,162,161,174,175,176) and( p.lead_medium_id is NULL or p.lead_medium_id not in (167)) then 'Affiliates'
	else 'online' end as lead_medium_source

	From launchpad_backend.projects as p 
	left join launchpad_backend.project_settings as s on s.project_id = p.id and s.is_deleted = 0 
	left join launchpad_backend.bouncer_users as bu1 on bu1.bouncer_id = s.primary_cm_id  
	left join launchpad_backend.bouncer_users as bu2 on bu2.bouncer_id = s.primary_GM_id
	left join launchpad_backend.bouncer_users as bu3 on bu3.bouncer_id = s.primary_designer_id
	left join launchpad_backend.cities as c on c.id = p.city_id
	left join ( select distinct ps.project_id, min(ps.created_at) as created_at
	from  launchpad_backend.project_events as ps  
	where event_type in ('STAGE_UPDATED')
	-- AND new_value = 9
	and is_deleted = 0
	and coalesce(new_value)::integer  in (22,23,13,2,8,9,19,11,	20,	21,	12,	3,	4,	7,	5,	14,	6,	15,	16,	10)
	group by 1 
	)
	as pe2 on pe2.project_id = p.id
	where to_date(pe2.created_at,'YYYY-MM-DD') >= '2018-04-01'
	and p.is_test = 0 
	and p.pincode not in (401201,401202,401203,401208,401210,401207,401209,404404,401303,401304) and  p.pincode not in (401305)
	) as A

	-- where A.incoming_month >= '2018-04-01'
	Group by 1,2,3,4,5

	union


	Select A.primary_GM,A.city, 'BC_scheduled' as incoming_leads, A.incoming_month as month, A.lead_medium_source, count(A.incoming_month) as count
	from
	(
	select p.id,to_char(pe2.created_at,'YYYY-MM') as Incoming_Month,
	bu1.name as Primary_CM,
	bu2.name as Primary_GM,
	bu3.name as Primary_designer,
		case when p.pincode in (110075,110078,110079,110077) then 'Gurgaon'
		 when lower(c.display_name) like 'bangalore' then 'Bangalore'
		 when lower(c.display_name) like 'chennai' then 'Chennai' 
		 when lower(c.display_name) in ('delhi') then 'Delhi'
		  when lower(c.display_name) in ('ghaziabad') then 'Noida'
		   when lower(c.display_name) in ('faridabad') then 'Delhi'
			when lower(c.display_name) in ('dwarka') then 'Gurgaon'
		 when lower(c.display_name) like 'gurgaon' then 'Gurgaon'
		 when lower(c.display_name) like 'hyderabad' then 'Hyderabad'
		 when lower(c.display_name) IN  ('mumbai') then 'Mumbai'
		 when lower(c.display_name) like '%thane%' then 'Mumbai'
		 when lower(c.display_name) like '%navi mumbai%' then 'Mumbai'
		 when lower(c.display_name) IN ('noida') then 'Noida'
		 when lower(c.display_name) IN ('pune') then 'Pune'
		 ELSE 'Others' end as city,
	case when p.lead_medium_id in (167) then 'referral'
		when p.lead_medium_id in (171) or  (p.lead_source_id in (164) and p.lead_medium_id not in (167)) then 'Direct'
		when p.lead_source_id in ( 163,162,161,174,175,176) and( p.lead_medium_id is NULL or p.lead_medium_id not in (167)) then 'Affiliates'
	else 'online' end as lead_medium_source

	From launchpad_backend.projects as p 
	left join launchpad_backend.project_settings as s on s.project_id = p.id and s.is_deleted = 0 
	left join launchpad_backend.bouncer_users as bu1 on bu1.bouncer_id = s.primary_cm_id  
	left join launchpad_backend.bouncer_users as bu2 on bu2.bouncer_id = s.primary_GM_id
	left join launchpad_backend.bouncer_users as bu3 on bu3.bouncer_id = s.primary_designer_id
	left join launchpad_backend.cities as c on c.id = p.city_id
	left join ( select distinct ps.project_id, min(ps.created_at) as created_at
	from  launchpad_backend.project_events as ps  
	where event_type in ('STAGE_UPDATED')
	-- AND new_value = 9
	and is_deleted = 0
	and coalesce(new_value)::integer  in (23,13,2,8,9,19,11,	20,	21,	12,	3,	4,	7,	5,	14,	6,	15,	16,	10)
	group by 1 
	)
	as pe2 on pe2.project_id = p.id
	where to_date(pe2.created_at,'YYYY-MM-DD') >= '2018-04-01'
	and p.is_test = 0 
	and p.pincode not in (401201,401202,401203,401208,401210,401207,401209,404404,401303,401304) and  p.pincode not in (401305)
	) as A
	-- where A.incoming_month >= '2018-04-01'
	Group by 1,2,3,4,5


	union


	Select A.primary_GM,A.city, 'Briefing_Done' as incoming_leads, A.incoming_month as month, A.lead_medium_source, count(A.incoming_month) as count
	from
	(
	select p.id,to_char(pe2.created_at,'YYYY-MM') as Incoming_Month,
	bu1.name as Primary_CM,
	bu2.name as Primary_GM,
	bu3.name as Primary_designer,
	case when p.pincode in (110075,110078,110079,110077) then 'Gurgaon'
		 when lower(c.display_name) like 'bangalore' then 'Bangalore'
		 when lower(c.display_name) like 'chennai' then 'Chennai' 
		 when lower(c.display_name) in ('delhi') then 'Delhi'
		  when lower(c.display_name) in ('ghaziabad') then 'Noida'
		   when lower(c.display_name) in ('faridabad') then 'Delhi'
			when lower(c.display_name) in ('dwarka') then 'Gurgaon'
		 when lower(c.display_name) like 'gurgaon' then 'Gurgaon'
		 when lower(c.display_name) like 'hyderabad' then 'Hyderabad'
		 when lower(c.display_name) IN  ('mumbai') then 'Mumbai'
		 when lower(c.display_name) like '%thane%' then 'Mumbai'
		 when lower(c.display_name) like '%navi mumbai%' then 'Mumbai'
		 when lower(c.display_name) IN ('noida') then 'Noida'
		 when lower(c.display_name) IN ('pune') then 'Pune'
		 ELSE 'Others' end as city,
	case when p.lead_medium_id in (167) then 'referral'
		when p.lead_medium_id in (171) or  (p.lead_source_id in (164) and p.lead_medium_id not in (167)) then 'Direct'
		when p.lead_source_id in ( 163,162,161,174,175,176) and( p.lead_medium_id is NULL or p.lead_medium_id not in (167)) then 'Affiliates'
	else 'online' end as lead_medium_source

	From launchpad_backend.projects as p 
	left join launchpad_backend.project_settings as s on s.project_id = p.id and s.is_deleted = 0 
	left join launchpad_backend.bouncer_users as bu1 on bu1.bouncer_id = s.primary_cm_id  
	left join launchpad_backend.bouncer_users as bu2 on bu2.bouncer_id = s.primary_GM_id
	left join launchpad_backend.bouncer_users as bu3 on bu3.bouncer_id = s.primary_designer_id
	left join launchpad_backend.cities as c on c.id = p.city_id
	left join ( select distinct ps.project_id, min(ps.created_at) as created_at
	from  launchpad_backend.project_events as ps  
	where event_type in ('STAGE_UPDATED')
	-- AND new_value = 9
	and is_deleted = 0
	and coalesce(new_value)::INTEGER in (9,19,11,	20,	21,	12,	3,	4,	7,	5,	14,	6,	15,	16,	10)
	group by 1 

	)
	as pe2 on pe2.project_id = p.id
	where to_date(pe2.created_at,'YYYY-MM-DD') >= '2018-04-01'
	and p.is_test = 0 
	and p.pincode not in (401201,401202,401203,401208,401210,401207,401209,404404,401303,401304) and  p.pincode not in (401305)
	) as A

	-- where A.incoming_month >= '2018-04-01'
	Group by 1,2,3,4,5

	union


	Select A.primary_GM,A.city, 'Proposal_presented' as incoming_leads, A.incoming_month as month, A.lead_medium_source, count(A.incoming_month) as count
	from
	(
	select p.id,to_char(pe3.created_at,'YYYY-MM') as Incoming_Month,
	bu1.name as Primary_CM,
	bu2.name as Primary_GM,
	bu3.name as Primary_designer,
	case when p.pincode in (110075,110078,110079,110077) then 'Gurgaon'
		 when lower(c.display_name) like 'bangalore' then 'Bangalore'
		 when lower(c.display_name) like 'chennai' then 'Chennai' 
		 when lower(c.display_name) in ('delhi') then 'Delhi'
		  when lower(c.display_name) in ('ghaziabad') then 'Noida'
		   when lower(c.display_name) in ('faridabad') then 'Delhi'
			when lower(c.display_name) in ('dwarka') then 'Gurgaon'
		 when lower(c.display_name) like 'gurgaon' then 'Gurgaon'
		 when lower(c.display_name) like 'hyderabad' then 'Hyderabad'
		 when lower(c.display_name) IN  ('mumbai') then 'Mumbai'
		 when lower(c.display_name) like '%thane%' then 'Mumbai'
		 when lower(c.display_name) like '%navi mumbai%' then 'Mumbai'
		 when lower(c.display_name) IN ('noida') then 'Noida'
		 when lower(c.display_name) IN ('pune') then 'Pune'
		 ELSE 'Others' end as city,
	case when p.lead_medium_id in (167) then 'referral'
		when p.lead_medium_id in (171) or  (p.lead_source_id in (164) and p.lead_medium_id not in (167)) then 'Direct'
		when p.lead_source_id in ( 163,162,161,174,175,176) and( p.lead_medium_id is NULL or p.lead_medium_id not in (167)) then 'Affiliates'
	else 'online' end as lead_medium_source

	From launchpad_backend.projects as p 
	left join launchpad_backend.project_settings as s on s.project_id = p.id and s.is_deleted = 0 
	left join launchpad_backend.bouncer_users as bu1 on bu1.bouncer_id = s.primary_cm_id  
	left join launchpad_backend.bouncer_users as bu2 on bu2.bouncer_id = s.primary_GM_id
	left join launchpad_backend.bouncer_users as bu3 on bu3.bouncer_id = s.primary_designer_id
	left join launchpad_backend.cities as c on c.id = p.city_id
	left join ( select distinct ps.project_id, min(ps.created_at) as created_at
	from  launchpad_backend.project_events as ps  
	where event_type in ('STAGE_UPDATED')
	-- AND new_value = 21
	and is_deleted = 0
	and coalesce(new_value)::integer in (21,12,3,4,7,5,14,6,15,16,	10)
	group by 1 

	)
	as pe3 on pe3.project_id = p.id
	where to_date(pe3.created_at,'YYYY-MM-DD') >= '2018-04-01'
	and p.is_test = 0 
	and p.pincode not in (401201,401202,401203,401208,401210,401207,401209,404404,401303,401304) and  p.pincode not in (401305)
	) as A

	-- where A.incoming_month >= '2018-04-01'
	Group by 1,2,3,4,5


	union


	Select A.primary_GM,A.city, 'Conversion' as incoming_leads, A.incoming_month as month, A.lead_medium_source, count(A.incoming_month) as count
	from
	(
	select p.id,to_char(pe4.created_at,'YYYY-MM') as Incoming_Month,
	bu1.name as Primary_CM,
	bu2.name as Primary_GM,
	bu3.name as Primary_designer,
	case when p.pincode in (110075,110078,110079,110077) then 'Gurgaon'
		 when lower(c.display_name) like 'bangalore' then 'Bangalore'
		 when lower(c.display_name) like 'chennai' then 'Chennai' 
		 when lower(c.display_name) in ('delhi') then 'Delhi'
		  when lower(c.display_name) in ('ghaziabad') then 'Noida'
		   when lower(c.display_name) in ('faridabad') then 'Delhi'
			when lower(c.display_name) in ('dwarka') then 'Gurgaon'
		 when lower(c.display_name) like 'gurgaon' then 'Gurgaon'
		 when lower(c.display_name) like 'hyderabad' then 'Hyderabad'
		 when lower(c.display_name) IN  ('mumbai') then 'Mumbai'
		 when lower(c.display_name) like '%thane%' then 'Mumbai'
		 when lower(c.display_name) like '%navi mumbai%' then 'Mumbai'
		 when lower(c.display_name) IN ('noida') then 'Noida'
		 when lower(c.display_name) IN ('pune') then 'Pune'
		 ELSE 'Others' end as city,
	case when p.lead_medium_id in (167) then 'referral'
		when p.lead_medium_id in (171) or  (p.lead_source_id in (164) and p.lead_medium_id not in (167)) then 'Direct'
		when p.lead_source_id in ( 163,162,161,174,175,176) and( p.lead_medium_id is NULL or p.lead_medium_id not in (167)) then 'Affiliates'
	else 'online' end as lead_medium_source

	From launchpad_backend.projects as p 
	left join launchpad_backend.project_settings as s on s.project_id = p.id and s.is_deleted = 0 
	left join launchpad_backend.bouncer_users as bu1 on bu1.bouncer_id = s.primary_cm_id  
	left join launchpad_backend.bouncer_users as bu2 on bu2.bouncer_id = s.primary_GM_id
	left join launchpad_backend.bouncer_users as bu3 on bu3.bouncer_id = s.primary_designer_id
	left join launchpad_backend.cities as c on c.id = p.city_id
		left join (select distinct ps.project_id, min(ps.created_at) as created_at
		from  launchpad_backend.project_events as ps  
		where event_type in ('STAGE_UPDATED')
		and is_deleted = 0
		and coalesce(new_value)in (4,7,5,14,6,15,16,10)
		-- AND new_value = 4
		group by 1 

		)
	as pe4 on pe4.project_id = p.id
	where to_date(pe4.created_at,'YYYY-MM-DD') >= '2018-04-01'
	and p.is_test = 0 
	and p.pincode not in (401201,401202,401203,401208,401210,401207,401209,404404,401303,401304) and  p.pincode not in (401305)
	) as A

	-- where A.incoming_month >= '2018-04-01'
	Group by 1,2,3,4,5

	) AS B


	group by 1,2,3,4

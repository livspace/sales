--http://reports.livspace.com/question/1477

Select B.primary_cm, B.primary_GM, B.city, B.month, B.lead_medium_source,
sum(case when B.incoming_leads = 'Incoming_leads' then B.lead_count else 0 end) as incoming_leads,
sum(case when B.incoming_leads = 'Effective_leads' then B.lead_count else 0 end) as Effective_leads,
sum(case when B.incoming_leads = 'Briefing_done' then B.lead_count else 0 end) as Briefing_done,
sum(case when B.incoming_leads = 'Proposal_presented' then B.lead_count else 0 end) as Proposal_presented,
sum(case when B.incoming_leads = 'Conversion' then B.lead_count else 0 end) as Conversion

From

(	Select A.primary_cm,A.primary_GM, A.city, 'Incoming_leads' as incoming_leads, A.incoming_month as month, A.lead_medium_source, count(A.incoming_month) as lead_count
	from
	(
	Select p.project_id, to_date(p.project_created_at,'YYYY-MM') as incoming_month, p.primary_gm, p.primary_cm,
	case when lower(p.project_city) like '%bangalore%' or lower(p.project_city) like '%hyderabad%' or lower(p.project_city) like '%chennai%' or lower(p.project_city) like '%pune%' then p.project_city
	when lower(p.project_city) like '%mumbai%' or Lower(p.project_city) like '%thane%' then 'Mumbai'
	when lower(p.project_city) like '%gurgaon%' or lower(p.project_city) like '%dwarka%' then 'Gurgaon'
	when lower(p.project_city) like '%delhi%' or lower(p.project_city) like '%farida%' then 'Delhi'
	when lower(p.project_city) like '%noida%' or lower(p.project_city) like '%ghaz%' then 'Noida'
	end as City, 
	case when p.lead_medium_id in (167) then 'referral'
		when p.lead_medium_id in (171) and p.lead_medium_id not in (167) then 'EC_walkin' 
		when p.lead_source_id in (164) and p.lead_medium_id not in (167) then 'Direct'
		when p.lead_source_id in ( 163,162,161) and p.lead_medium_id not in (167) then 'Affiliates'
	else 'online' end as lead_medium_source
	From flat_tables.flat_projects as p
	where to_date(p.project_created_at,'YYYY-MM-DD') >= '2018-12-01'
	) as A

	group by 1,2,3,4,5,6

	UNION

	-- Effective Leads
	Select A.primary_cm,A.primary_GM, A.city, 'Effective_leads' as incoming_leads, A.incoming_month as month, A.lead_medium_source, count(A.incoming_month) as lead_count
	from
	(
	Select p.project_id, to_date(pe1.created_at,'YYYY-MM') as incoming_month, p.primary_gm, p.primary_cm,
	case when lower(p.project_city) like '%bangalore%' or lower(p.project_city) like '%hyderabad%' or lower(p.project_city) like '%chennai%' or lower(p.project_city) like '%pune%' then p.project_city
	when lower(p.project_city) like '%mumbai%' or Lower(p.project_city) like '%thane%' then 'Mumbai'
	when lower(p.project_city) like '%gurgaon%' or lower(p.project_city) like '%dwarka%' then 'Gurgaon'
	when lower(p.project_city) like '%delhi%' or lower(p.project_city) like '%farida%' then 'Delhi'
	when lower(p.project_city) like '%noida%' or lower(p.project_city) like '%ghaz%' then 'Noida'
	end as City, 
	case when p.lead_medium_id in (167) then 'referral'
		when p.lead_medium_id in (171) and p.lead_medium_id not in (167) then 'EC_walkin'
		when p.lead_source_id in (164) and p.lead_medium_id not in (167) then 'Direct'
		when p.lead_source_id in ( 163,162,161) and p.lead_medium_id not in (167) then 'Affiliates'
	else 'online' end as lead_medium_source
	From flat_tables.flat_projects as p
	left join ( select distinct pe.project_id, min(pe.event_date) as created_at
	from  flat_tables.flat_project_events as pe  
	where event_type in ('STAGE_UPDATED')
	-- AND new_value = 17
	and coalesce(new_value)::INTEGER in (17,18,13,2,8,9,19,11,20,21,12,3,4,7,5,14,6,15,16,10)
	group by 1 
	)
	as pe1 on pe1.project_id = p.project_id
	where to_date(pe1.created_at,'YYYY-MM-DD') >= '2018-12-01'
	) as A
	
	group by 1,2,3,4,5,6

	UNION
	-- Briefing_done
	Select A.primary_cm,A.primary_GM, A.city, 'Briefing_done' as incoming_leads, A.incoming_month as month, A.lead_medium_source, count(A.incoming_month) as lead_count
	from
	(
	Select p.project_id, to_date(pe2.created_at,'YYYY-MM') as incoming_month, p.primary_gm, p.primary_cm,
	case when lower(p.project_city) like '%bangalore%' or lower(p.project_city) like '%hyderabad%' or lower(p.project_city) like '%chennai%' or lower(p.project_city) like '%pune%' then p.project_city
	when lower(p.project_city) like '%mumbai%' or Lower(p.project_city) like '%thane%' then 'Mumbai'
	when lower(p.project_city) like '%gurgaon%' or lower(p.project_city) like '%dwarka%' then 'Gurgaon'
	when lower(p.project_city) like '%delhi%' or lower(p.project_city) like '%farida%' then 'Delhi'
	when lower(p.project_city) like '%noida%' or lower(p.project_city) like '%ghaz%' then 'Noida'
	end as City, 
	case when p.lead_medium_id in (167) then 'referral'
		when p.lead_medium_id in (171) and p.lead_medium_id not in (167) then 'EC_walkin'
		when p.lead_source_id in (164) and p.lead_medium_id not in (167) then 'Direct'
		when p.lead_source_id in ( 163,162,161) and p.lead_medium_id not in (167) then 'Affiliates'
	else 'online' end as lead_medium_source
	From flat_tables.flat_projects as p
	left join ( select distinct pe.project_id, min(pe.event_date) as created_at
	from  flat_tables.flat_project_events as pe  
	where event_type in ('STAGE_UPDATED')
	-- AND new_value = 17
	and coalesce(new_value)::INTEGER in (9,19,11,20,21,12,3,4,7,5,14,6,15,16,10)
	group by 1 
	)
	as pe2 on pe2.project_id = p.project_id
	where to_date(pe2.created_at,'YYYY-MM-DD') >= '2018-12-01'
	) as A
	
	group by 1,2,3,4,5,6

	UNION
	-- Proposal_presented
	Select A.primary_cm,A.primary_GM, A.city, 'Proposal_presented' as incoming_leads, A.incoming_month as month, A.lead_medium_source, count(A.incoming_month) as lead_count
	from
	(
	Select p.project_id, to_date(pe3.created_at,'YYYY-MM') as incoming_month, p.primary_gm, p.primary_cm,
	case when lower(p.project_city) like '%bangalore%' or lower(p.project_city) like '%hyderabad%' or lower(p.project_city) like '%chennai%' or lower(p.project_city) like '%pune%' then p.project_city
	when lower(p.project_city) like '%mumbai%' or Lower(p.project_city) like '%thane%' then 'Mumbai'
	when lower(p.project_city) like '%gurgaon%' or lower(p.project_city) like '%dwarka%' then 'Gurgaon'
	when lower(p.project_city) like '%delhi%' or lower(p.project_city) like '%farida%' then 'Delhi'
	when lower(p.project_city) like '%noida%' or lower(p.project_city) like '%ghaz%' then 'Noida'
	end as City, 
	case when p.lead_medium_id in (167) then 'referral'
		when p.lead_medium_id in (171) and p.lead_medium_id not in (167) then 'EC_walkin'  
		when p.lead_source_id in (164) and p.lead_medium_id not in (167) then 'Direct'
		when p.lead_source_id in ( 163,162,161) and p.lead_medium_id not in (167) then 'Affiliates'
	else 'online' end as lead_medium_source
	From flat_tables.flat_projects as p
	left join ( select distinct pe.project_id, min(pe.event_date) as created_at
	from  flat_tables.flat_project_events as pe  
	where event_type in ('STAGE_UPDATED')
	-- AND new_value = 17
	and coalesce(new_value)::INTEGER in (20,21,12,3,4,7,5,14,6,15,16,10)
	group by 1 
	)
	as pe3 on pe3.project_id = p.project_id
	where to_date(pe3.created_at,'YYYY-MM-DD') >= '2018-12-01'
	) as A
	
	group by 1,2,3,4,5,6

	UNION

	-- COnversion
	Select A.primary_cm,A.primary_GM, A.city, 'Conversion' as incoming_leads, A.incoming_month as month, A.lead_medium_source, count(A.incoming_month) as lead_count
	from
	(
	Select p.project_id, to_date(pe4.created_at,'YYYY-MM') as incoming_month, p.primary_gm, p.primary_cm,
	case when lower(p.project_city) like '%bangalore%' or lower(p.project_city) like '%hyderabad%' or lower(p.project_city) like '%chennai%' or lower(p.project_city) like '%pune%' then p.project_city
	when lower(p.project_city) like '%mumbai%' or Lower(p.project_city) like '%thane%' then 'Mumbai'
	when lower(p.project_city) like '%gurgaon%' or lower(p.project_city) like '%dwarka%' then 'Gurgaon'
	when lower(p.project_city) like '%delhi%' or lower(p.project_city) like '%farida%' then 'Delhi'
	when lower(p.project_city) like '%noida%' or lower(p.project_city) like '%ghaz%' then 'Noida'
	end as City, 
	case when p.lead_medium_id in (167) then 'referral'
		when p.lead_medium_id in (171) and p.lead_medium_id not in (167) then 'EC_walkin'  
		when p.lead_source_id in (164) and p.lead_medium_id not in (167) then 'Direct'
		when p.lead_source_id in ( 163,162,161) and p.lead_medium_id not in (167) then 'Affiliates'
	else 'online' end as lead_medium_source
	From flat_tables.flat_projects as p
	left join ( select distinct pe.project_id, min(pe.event_date) as created_at
	from  flat_tables.flat_project_events as pe  
	where event_type in ('STAGE_UPDATED')
	-- AND new_value = 17
	and coalesce(new_value) in (4,7,5,14,6,15,16,10)
	group by 1 
	)
	as pe4 on pe4.project_id = p.project_id
	where to_date(pe4.created_at,'YYYY-MM-DD') >= '2018-12-01'
	) as A
	
	group by 1,2,3,4,5,6
	
)
 as B
 
 
 where B.primary_cm not in  ('Narzina Ahmed', 'Yashashree Deshpande','Tanvi Mehta')

 Group by 1,2,3,4,5

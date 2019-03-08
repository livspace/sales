select 

prs.id as "Canvas ID",
prs.customer_display_name as "Customer",
(case when prs.lead_source_id in (15,164) then "Referral/Walkin" when prs.lead_source_id in (161,162,163) then "Offline" else "Online" end) as "Lead Source",
cm.name as "CM",
gm.name as "GM",
dp.name as "Designer",
(case when prs.collaborator_specified_property_name is not null then prs.collaborator_specified_property_name else prs.property_name end) as "Property Name",
ct.name as "City",
date(prs.created_at) as "Project Created date",
prs.pincode as "Pincode",
prs.property_type as "Property Type",
prs.service_type as "Service Type",
prs.estimated_value as "Budget",
prs.brief_scope as "Scope",
st.display_name as "Project Stage",
prs.status as "Status",
prs.inactivation_reason as "Inactivation Reason",
prs.status_change_reason as "Status Change Reason"


from launchpad_backend.projects prs

left join launchpad_backend.cities ct on ct.id=prs.city_id
left join launchpad_backend.project_stages st on st.id=prs.stage_id
left join launchpad_backend.project_settings ps on ps.project_id=prs.id and ps.is_deleted = 0 
left join launchpad_backend.bouncer_users as cm on ps.primary_cm_id = cm.bouncer_id
left join launchpad_backend.bouncer_users as dp on ps.primary_designer_id = dp.bouncer_id
left join launchpad_backend.bouncer_users as gm on ps.primary_gm_id = gm.bouncer_id


where gm.bouncer_id in (2957,3212)


order by prs.id desc

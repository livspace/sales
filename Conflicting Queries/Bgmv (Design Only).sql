--http://reports.livspace.com/question/2362

select 
(case 
when lower(project_city) like '%bangalore%' or lower(project_city) like '%hyderabad%' or lower(project_city) like '%chennai%' or lower(project_city) like '%pune%' then project_city
when lower(project_city) like '%mumbai%' or lower(project_city) like '%thane%' then 'Mumbai'
when lower(project_city) like '%gurgaon%' or lower(project_city) like '%dwarka%' then 'Gurgaon'
when lower(project_city) like '%delhi%' or lower(project_city) like '%farida%' then 'Delhi'
when lower(project_city) like '%noida%' or lower(project_city) like '%ghaz%' then 'Noida'
end) as City,
to_char(bgm.logged_month,'YYYY-MM') as month,
sum(bgm.amount) as Value


from flat_tables.flat_projects prs

left join launchpad_backend.project_bgmvs bgm on bgm.project_id=prs.project_id

where project_city is not null and lower(project_city) not like '%other%' and lower(project_city) not like '%singapo%'  
and prs.is_test_project=false and bgm.project_id in (361148,231647,302874,367551,103726,190500,392649,389371,235594,50344,234052,268411,231185,141518,372285,420806,289309,233011,28343,157612,319112,233714,366071,186790,66205,197060,395625,62776,194758,82654,261566,301120,302998,120820,392125,315193,228835,370492,116559,61528,279419,141584,263094,271110,316452,252539,361184,119424,303358,192440,330882,112892,265005,276863,182228,425030,116755,366257,255366,249652,312518,367534,126117,255359,256725,233201,419864,277926,341617,169035,280348,358453,252636,404564,202255,32257,151020,249853,97773,316706,362896,130917,422055,7895,147926,157302,351946,253048,311157,340165,190233,262449,231191,336934,282915,269457,361153,313647,367491,389440,406426,420173,409878,396177,387434,344555,366928,288317,336617,326183,
327795) and bgm.logged_month>='2019-01-01'::date

group by 1,2

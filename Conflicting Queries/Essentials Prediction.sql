--http://reports.livspace.com/question/2260

Select 
id,
fprs.primary_cm,
fprs.project_status,
prs.conversion_probability,
to_char(prs.probable_month+1,'YYYY-MM') as "Expected Conversion Month"
from launchpad_backend.projects prs
left join flat_tables.flat_projects fprs on prs.id=fprs.project_id
where fprs.primary_cm in ('Nidhi Agarwal','Anjuli Gupta','Abhishek Sharma','Palak Jolly','Rinkesh Bafna','Gautam Gupta','Sri Harsha Ks','Mohammed Azharuddin','Tarun Garg','Prateek Bharadwaj','Himanshi Sharma','Abhishek Sharma','Heli Kumar','Chandana  Ainwale','Annu  Bala','Natasha Sharon Shah','Natasha .','Satish Prasad  Sahu','Mohammad Takki','Shuchi',
'Nitin Bhatia') and prs.probable_month>='2019-09-01'::date

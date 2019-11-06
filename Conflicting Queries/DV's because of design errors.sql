--http://reports.livspace.com/question/2017

select 

prs.primary_cm,
prs.primary_designer,
sum(amount)

from fms_backend.ps_transactions pt

left join flat_tables.flat_projects prs on prs.project_id=pt.id_project

where pt.id_txn in (180427000088,180528000155,180614000124,180614000207,180620000202,180620000253,180623000027,180623000053,180630000143,180630000149,180704000085,180704000681,180710000090,180714000175,180623000164,180706000191,180706000192,180713000240,180714000078,180717000259,180718000066,180719000176,180719000187,180720000187,180725000086,180803000045,180802000320,180804000213,180808000247,180727000022,180811000135,180814000159,180824000053,180823000043,180823000229,180825000131,180828000252,180828000232,180829000127,180822000127,180829000291,180830000023,180831000138,180907000214,180909000048,180907000209,180908000150,180908000158,180910000041,180910000094,180914000037,180919000031,180920000088,180920000187,180922000020,180922000122,180929000063,181001000135,181001000141,181005000366,181005000176,181006000144,181214000361,181008000225,181008000227,181008000232,181008000235,181008000236,181009000136,181010000323,181010000375,181010000389,181010000390,181010000398,181010000405,181010000270,181011000231,181013000115,181012000067,181017000074,181018000235,181022000131,181018000149,181018000150,181018000151,181018000153,181018000155,181018000156,181020000140,181023000185,181022000195,181024000297,181025000372,181027000070,181029000383,181031000361,181102000327,181105000188,181102000402,181101000092,181108000101,181108000102,181109000025,181113000114,181110000198,181112000206,181115000151,181116000001,181114000283,181114000332,181116000062,181122000051,181122000172,181123000225,181124000272,181126000275,181126000284,181127000369,181127000388,181128000100,181129000304,181130000069,181201000088,181205000126,181203000156,181208000087,181210000391,181210000444,181211000338,181211000520,181211000434,181212000331,181212000438,181214000189,181219000603,181219000626,181221000533,181222000222,181224000066,181221000407,181225000158,181226000307,181226000368,181227000081,181228000131,181231000156,190102000157,190102000161,190103000315,190104000192,190104000245,190104000272,190108000223,190105000297,190109000382,190109000585,190109000594,190110000160,190110000167,181226000335,190108000507,190109000331,190110000289,190111000215,190111000229,190114000112,190114000170,190115000176,190116000513,190116000522,190117000330,190117000201,190117000252,190121000093,190119000847,190121000253,190121000256,190122000335,190125000198,190125000693,190125000570,190128000268,190129000343,190129000344,190130000382,190130000275,190130000350,190131000542,190202000400,190203000130,190205000509,190205000081,190206000194,190206001116,190206001283,190208000114,190208000245,190208000246,190208000252,190208000260,190206001181,190206001185,190209000285,190210000066,190205000694,190212000472,190212000631,190212000634,190212000644,190214000449,190214000573,190216000099,190217000134,190215000464,190219000097,190218000367,190219000504,190220000293,190220000220,190220000274,190221000348,190222000007,190221000087,190224000106,190219000536,190225000134,190219000646,190227000188,190227000203,190227000241,190301000271,190227000337,190301000255,190301000418,190301000548,190301000515,190226000328,190305000276,190305000302,190301000583,190304000398,190304000431,190228000298,190307000398,190305000307,190306000244,190306000362,190306000610,190306000617,190309000352,190310000235,190312000447,190313000261,190315000198,190314000392,190318000579,190319000528,190314000365,190313000651,190320000502,190321000227,190322000246,190323000078,190323000029,190326000485,190326000206,190326000533,190326000611,190326000009,190327000414,190328000354,190327000175,190327000565,190327000568,190325000128,190328000294,190328000421,190328000403,190328000679,190329000319,190328000385,190330000110,190328000690,190329000390,190328000355)

and pt.date_txn>='2019-01-01'::date and pt.date_txn<='2019-03-31'::date and pt.status=4

group by 1,2
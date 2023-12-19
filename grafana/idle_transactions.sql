-- grafana ignore
select client_addr,
       application_name,
       usename,
       state,
       extract(epoch from age(now(), xact_start)) as age
  from pg_stat_activity
 where query not like '%grafana ignore%'
   and state like '%idle in transaction%'
order by query_start desc

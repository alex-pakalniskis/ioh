-- grafana ignore
select regexp_replace(regexp_replace(regexp_replace(coalesce(nullif(application_name,''), 'unknown'),
                      'query_node_[0-9a-f]+_', 'q-'),
                      'query_node_high_traffic_[0-9a-f]+_', 'h-'),
                      'index_node_(customer_)?', 'i-') as client,
       pid,
       extract(epoch from age(now(), query_start)) as age,
       extract(epoch from age(now(), xact_start)) as txn_age,
       format('%s'||chr(10)||'%s'||chr(10)||'block: %s', variadic (coalesce((select regexp_matches(query, '^/\*.*application=''([^'']+)'',route=''([^'']+)''.*action=''([^'']+)''.*\*/.*$')), array['ø', 'ø', 'ø']))) as qid,
       regexp_replace(query, '^/\* controller=''filter''.*? \*/', '') as query
  from pg_stat_activity
 where query not like '%grafana ignore%'
   and state='active'
   and coalesce(usename, 'none') != 'cloudsqlreplica'
   and query not like '[[autovacuum]]: %'
order by query_start desc

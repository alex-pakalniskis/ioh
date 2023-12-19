-- grafana ignore
select count(*) as tables_needing_vacuum,
       -min(tx_before_wraparound_vacuum) as txns_past,
       to_char(min(last_vacuum), 'MM-DD hh:mm') as last_vacuum,
       (select count(*) from pg_stat_activity where query like 'autovacuum: %') as autovacuum,
       (select count(*) from pg_stat_activity where query like 'autovacuum: %wraparound%') as wraparound
  from (
    select oid::regclass::text AS table,
         (select setting::int
            from pg_settings
            where name = 'autovacuum_freeze_max_age') - age(relfrozenxid) as tx_before_wraparound_vacuum,
       greatest(pg_stat_get_last_autovacuum_time(oid), pg_stat_get_last_vacuum_time(oid)) AS last_vacuum,
       age(relfrozenxid) AS xid_age,
       mxid_age(relminmxid) AS mxid_age
  from pg_class
 where relfrozenxid != 0
   and oid > 16384
   and relkind in ('r','m')) a where a.tx_before_wraparound_vacuum < 0;

---

-- grafana ignore
SELECT
  left(n.nspname || '.' || c.relname, 25) as table,
  least((SELECT setting::int FROM pg_settings WHERE name = 'autovacuum_freeze_max_age') - age(relfrozenxid), 
        (SELECT setting::int FROM pg_settings WHERE name = 'autovacuum_multixact_freeze_max_age') - mxid_age(relminmxid))
        tx_before_wraparound_vacuum,
  greatest(pg_stat_get_last_autovacuum_time(c.oid), pg_stat_get_last_vacuum_time(c.oid)) AS last_vacuum,
  c.relpages::numeric*8192 as table_size,
  c.reltuples as table_rows
  -- age(relfrozenxid) AS xid_age,
  -- mxid_age(relminmxid) AS mxid_age
FROM
  pg_class c, pg_namespace n
WHERE
  n.oid = c.relnamespace
  -- c.relname in ('event_meta_data', 'ethereum_blocks','ens_names','eth_call_cache')
  and c.relkind in ('r','m')
  and c.oid > 16384
  and (SELECT setting::int FROM pg_settings WHERE name = 'autovacuum_freeze_max_age') < age(relfrozenxid)
  and c.relfrozenxid != 0

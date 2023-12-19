-- grafana ignore
select c.name, table_schema, table_name, row_estimate, total_bytes, total_bytes - index_bytes - toast_bytes as table_bytes, index_bytes, toast_bytes
  from info.chain_sizes sz, chains c
 where sz.table_schema = c.namespace
order by total_bytes desc

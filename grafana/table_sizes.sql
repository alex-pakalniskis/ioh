-- grafana ignore
select table_schema, table_name, version, row_estimate, total_bytes, index_bytes, toast_bytes
  from info.table_sizes

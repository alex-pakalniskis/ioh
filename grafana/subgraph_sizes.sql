-- grafana ignore
select name, subgraph, row_estimate, total_bytes, total_bytes - index_bytes - toast_bytes as table_bytes, index_bytes, toast_bytes
  from info.subgraph_sizes
order by total_bytes desc

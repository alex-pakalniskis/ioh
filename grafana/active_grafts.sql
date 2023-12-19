-- grafana ignore
select ac.src, 
       src.subgraph as src_subgraph,
       src.shard as src_shard,
       ac.dst,
       dst.subgraph as dst_subgraph,
       dst.shard as dst_shard,
       ac.queued_at,
       ac.cancelled_at 
  from active_copies ac,
       deployment_schemas src,
       deployment_schemas dst
 where ac.src = src.id
   and ac.dst = dst.id;

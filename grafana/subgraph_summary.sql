with d as
 (select ds.subgraph as id,
         ds.name as schema,
         ds.created_at,
         (select n.head_block_number
            from ethereum_networks n
           where n.name = ds.network) as ethereum_head_block_number,
         ds.network,
         (select a.node_id from subgraphs.subgraph_deployment_assignment a
           where a.id = ds.id) as node_id,
         ds.shard as shard
    from deployment_schemas ds
   where ds.subgraph = '[[deployment]]')
select 'ID' as name, d.id as value from d
 union all
select 'Network', d.network::text from d
 union all
select 'Chain head block',
       to_char(d.ethereum_head_block_number, '999G999G999G999') from d
 union all
select 'Indexing node', d.node_id::text from d
 union all
select 'Shard', d.shard from d
union all
select 'Schema', d.schema from d
union all
select 'Schema Created ', EXTRACT(DAY FROM age(d.created_at)) || ' days ago' from d

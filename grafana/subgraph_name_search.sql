select
    ds.name as schema,
    ds.network,
    ds.shard,
    sv.deployment,
    s.name,
    sda.node_id,
    split_part(s.name, '/', 1) as account,
    split_part(s.name, '/', 2) as subgraph
from
    deployment_schemas as ds
    left outer join subgraphs.subgraph_version as sv on ds.subgraph = sv.deployment
    left outer join subgraphs.subgraph as s on s.id = sv.subgraph
    left outer join subgraphs.subgraph_deployment_assignment as sda on sda.id = ds.id

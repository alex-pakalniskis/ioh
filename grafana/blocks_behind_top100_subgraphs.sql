-- deployment_network:blocks_behind_top100_subgraphs

select
  s.name,
  v.deployment,
    split_part(s.name, '/', 1) as account,
    split_part(s.name, '/', 2) as subgraph
from subgraphs.subgraph as s,
     subgraphs.subgraph_version as v
where s.current_version = v.id;

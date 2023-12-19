select replace(node_id, 'index_node_', '') as nodeId,
       count(*) as num_assigned
  from subgraphs.subgraph_deployment_assignment
 group by node_id
 order by node_id asc;

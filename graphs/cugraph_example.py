# %%
import pandas as pd
import numpy as np


# %%
import cupy as cp
cp.get_default_memory_pool().used_bytes()

# %%
edge_list = cp.random.randint(low=1, high=1_000_000, size=(100_000_000, 2))
# edge_list = np.random.randint(low=1, high=1_000_000, size=(1_000_000_000, 2))

# %%
import cudf
edges = cudf.DataFrame(edge_list, columns=['src', 'dst'])
del edge_list

# %%
import cugraph
g = cugraph.Graph(directed=True)
g.from_cudf_edgelist(
edges
, source='src'
, destination='dst'
, renumber=False
)

# %%
pr = cugraph.pagerank(g)
# %%

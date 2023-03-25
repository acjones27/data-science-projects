# Graphs

Example playing around with NVIDIA RAPIDS for graphs. Specifically, using `cugraph` to calculate pagerank

## Requirements

See the `startup_script.sh` for more information on how to install the packages and set up the environment

I'm running this on SaturnCloud 

```
T4-XLarge - 4 cores - 16 GB RAM - 1 GPU - 10Gi Disk
```

## Resources

- [Create graph from CUDF edgelist](https://docs.rapids.ai/api/cugraph/stable/api_docs/api/cugraph.graph.from_dask_cudf_edgelist#)
- [Calculate pagerank](https://docs.rapids.ai/api/cugraph/stable/api_docs/api/cugraph.pagerank.html)
- [MultiGPU with pagerank](https://docs.rapids.ai/api/cugraph/stable/api_docs/dask-cugraph.html)
- [cugraph documentation](https://github.com/rapidsai/cugraph)
- [Local CUDA cluster](https://docs.rapids.ai/api/dask-cuda/nightly/quickstart.html)
- [Local CUDA cluster best practices](https://docs.rapids.ai/api/dask-cuda/nightly/examples/best-practices.html)
- [Spilling from device](https://docs.rapids.ai/api/dask-cuda/nightly/spilling.html#spilling-from-device)
- [Dask dataframes best practices](https://docs.dask.org/en/stable/dataframe-best-practices.html)
- [Dask dashboard walkthrough](https://www.youtube.com/watch?v=N_GqzcuGLCY&t=417s)

## Github issues
- [Open issue re: G.to_directed()](https://github.com/rapidsai/cugraph/issues/3140#event-8519580460)
- [Open issue re: memory management](https://github.com/rapidsai/cugraph/issues/2769#issuecomment-1373891708)
- [Open issue re: nx.compose() in cugraph](https://github.com/rapidsai/cugraph/issues/3102#issuecomment-1371034689)

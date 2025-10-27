# Snakemake template

This is a template for Snakemake workflows for running on Van Andel Institute's HPC. It is based on the folder structure recommended by the Snakemake team, as documented [here](https://snakemake.readthedocs.io/en/stable/snakefiles/deployment.html#distribution-and-reproducibility).

Although this is a template, it is also a ready-to-run workflow that includes test data in the `raw_data` folder. In order to remove example code and test data to provide a clean starting point for a new workflow, run `rm -fr raw_data/* workflow/envs/qc.yaml workflow/rules/{helloworld,qc}.smk`.

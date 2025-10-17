# import basic packages
import pandas as pd
from snakemake.utils import validate


# read sample sheet
units = (
    pd.read_csv(config["samplesheet"], sep="\t", dtype={"sample": str})
    .set_index("sample", drop=False)
    .sort_index()
)

samples = units[["sample"]].drop_duplicates()

# validate sample sheet and config file
validate(units, schema="../../config/schemas/samples.schema.yaml")
validate(config, schema="../../config/schemas/config.schema.yaml")
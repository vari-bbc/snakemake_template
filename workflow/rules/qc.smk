def get_orig_fastq(wildcards):
    if wildcards.read == "R1":
            fastq = expand("raw_data/{fq}", fq = units[units["sample"] == wildcards.sample]["fq1"].values)
    elif wildcards.read == "R2":
            fastq = expand("raw_data/{fq}", fq = units[units["sample"] == wildcards.sample]["fq2"].values)
    return fastq 

rule rename_fastqs:
    """
    Rename fastqs by biologically meaningful name. Concatenate different runs of same library.
    """
    input:
        get_orig_fastq
    output:
        "results/renamed_data/{sample}_{read}.fastq.gz"
    log:
        expand("logs/renamed_data/{{sample}}_{{read}}.{suff}", suff=['o','e'])
    benchmark:
        "benchmarks/rename_fastqs/{sample}_{read}.txt"
    params:
        num_input=lambda wildcards, input: len(input),
        input=lambda wildcards, input: ["'" + x + "'" for x in input]
    threads: 1
    resources:
        mem_gb=8,
        log_prefix=lambda wildcards: "_".join(wildcards)
    envmodules:
    shell:
        """
        if [ {params.num_input} -gt 1 ]
        then
            cat {params.input} > {output}
        else
            ln -sr {params.input} {output}
        fi

        """

rule fastqc:
    """
    Run fastqc on fastq files.
    """
    input:
        "results/renamed_data/{fq_pref}.fastq.gz"
    output:
        html="results/fastqc/{fq_pref}_fastqc.html",
        zip="results/fastqc/{fq_pref}_fastqc.zip"
    log:
        expand("logs/fastqc/{{fq_pref}}.{suff}", suff=['o','e'])
    benchmark:
        "benchmarks/fastqc/{fq_pref}.txt"
    params:
        outdir="results/fastqc/"
    threads: 1
    resources:
        mem_gb=32,
        log_prefix=lambda wildcards: "_".join(wildcards) if len(wildcards) > 0 else "log"
    envmodules:
        config['modules']['fastqc']
    shell:
        """
        {{
        fastqc --outdir {params.outdir} {input}
        }} 1> {log[0]} 2> {log[1]} 
        """

rule multiqc:
    """
    Use multiQC to collate QC results.
    """
    input:
        expand("results/fastqc/{sample}_{read}_fastqc.zip", sample = samples['sample'], read=['R1','R2'])
    output:
        "results/multiqc/multiqc_report.html",
        expand("results/multiqc/multiqc_report_data/multiqc{suff}", suff=['.log','_fastqc.txt','_general_stats.txt','_sources.txt'])
    log:
        expand("logs/multiqc/multiqc.{suff}", suff=['o','e'])
    benchmark:
        "benchmarks/multiqc/multiqc.txt"
    params:
        lambda wildcards, input: " ".join(pd.unique([os.path.dirname(x) for x in input]))
    threads: 1
    resources:
        mem_gb=32,
        log_prefix=lambda wildcards: "_".join(wildcards) if len(wildcards) > 0 else "log"
    envmodules:
        config['modules']['multiqc']
    shell:
        """
        {{
        multiqc -f {params} \
        -o results/multiqc \
        -n multiqc_report.html
        }} 1> {log[0]} 2> {log[1]} 
        """
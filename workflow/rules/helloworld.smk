rule helloworld:
    output:
        "results/helloworld/helloworld.txt"
    params:
    log:
        expand("logs/helloworld/hello.{suff}", suff=['o','e'])
    benchmark:
        "benchmarks/helloworld/helloworld.txt"
    params:
    threads: 1
    resources:
        mem_gb=4,
        log_prefix=lambda wildcards: "_".join(wildcards) if len(wildcards) > 0 else "log"
    envmodules:
    shell:
        """
        {{
        echo 'hello world!' > {output}
        sleep 10
        }} 1> {log[0]} 2> {log[1]} 
        """


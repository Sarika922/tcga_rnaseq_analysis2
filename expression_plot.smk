rule all:
    input:
        "results/nkx2_1_expression.csv",
        "results/nkx2_1_expression_plot.png"

rule extract_sample_types:
    input:
        "/home/bec51319.iitr/workplace/tcga_data_analysis/data/gdc_sample_sheet.tsv"
    output:
        "data/file_sample_types.tsv"
    shell:
        """
        awk -F'\t' 'NR > 1 {{print $1 "\t" $8}}' {input} > {output}
        """

rule extract_expression:
    input:
        sample_types="data/file_sample_types.tsv",
        rna_files="/home/bec51319.iitr/workplace/tcga_data_analysis/data/tcga_data"
    output:
        "results/nkx2_1_expression.csv"
    script:
        "scripts/extract_expression.py"

rule expression_plot:
    input:
        "results/nkx2_1_expression.csv"
    output:
        "results/nkx2_1_expression_plot.png"
    script:
        "scripts/expression_plot.R"

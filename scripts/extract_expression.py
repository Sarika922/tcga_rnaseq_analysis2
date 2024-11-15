import os
import pandas as pd
import numpy as np

sample_types = pd.read_csv(snakemake.input.sample_types, sep='\t', header=None, names=["File_ID", "Sample_Type"])
sample_type_dict = dict(zip(sample_types["File_ID"], sample_types["Sample_Type"]))

expression_data = []

for file_id in os.listdir(snakemake.input.rna_files):
    file_path = os.path.join(snakemake.input.rna_files, file_id)
    
    if os.path.isdir(file_path):
        for filename in os.listdir(file_path):
            if filename.endswith(".rna_seq.augmented_star_gene_counts.tsv"):
                full_path = os.path.join(file_path, filename)
                
                rna_data = pd.read_csv(full_path, sep='\t', comment='#')
                nkx2_1_row = rna_data[rna_data['gene_name'] == 'NKX2-1']
                
                if not nkx2_1_row.empty:
                    tpm_value = nkx2_1_row.iloc[0]['tpm_unstranded']
                    log_tpm_value = np.log2(tpm_value + 1)
                    
                    expression_data.append({
                        "SampleID": file_id,
                        "Condition": sample_type_dict.get(file_id, "Unknown"),
                        "Expression": log_tpm_value
                    })

expression_df = pd.DataFrame(expression_data)
expression_df.to_csv(snakemake.output[0], index=False)

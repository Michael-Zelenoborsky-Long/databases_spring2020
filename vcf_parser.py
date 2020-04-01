import vcf

with open("discoRes_k_31_c_3_D_100_P_3_b_0_coherent_for_IGV_edited.vcf", mode='r') as vcf_file:
    vcf_reader = vcf.Reader(vcf_file)
    counter = 0
    for record in vcf_reader:
        if counter == 100:
            print(record)
        counter += 1

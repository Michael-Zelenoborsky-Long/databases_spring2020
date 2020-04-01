import mysql.connector
import vcf
import os
import datetime
import json

# connection
cnx = mysql.connector.connect(user='long', password='password',
                              host='127.0.0.1',
                              database='pea_variant_calling')
cursor = cnx.cursor()

# variant caller run constants

vcf_file_path = "discoRes_k_31_c_3_D_100_P_3_b_0_coherent_for_IGV_edited.vcf"
run_date = datetime.datetime.fromtimestamp(os.path.getmtime(vcf_file_path))  # file modification datetime
phenotype = "wt, mutant"
ref_genome = (1, "frisson_draft")


# open vcf
with open("discoRes_k_31_c_3_D_100_P_3_b_0_coherent_for_IGV_edited.vcf", mode='r') as vcf_file:
    vcf_reader = vcf.Reader(vcf_file)
    counter = 0

    #===== populate genome
    #insert_query = "INSERT INTO genome (id, name) VALUES (1, 'frisson_draft')"
    #cursor.execute(insert_query)
    #emp_no = cursor.lastrowid
    #print("Inserted into row # ", emp_no)
    #cnx.commit()

    #==== populate run info
    format_json = json.dumps(vcf_reader.formats)
    filter_json = json.dumps(vcf_reader.filters)

    insert_query = """INSERT INTO vcaller_run (id, run_date, ref_genome_id, phenotype, format, filter)
                    VALUES (%s,%s,%s,%s,%s,%s)"""

    #cursor.execute(insert_query, (1, run_date, 1, phenotype, format_json, filter_json))
    #emp_no = cursor.lastrowid
    #print("Inserted into row # ", emp_no)
    #cnx.commit()

    # populate variants table and contigs
    for record in vcf_reader:

        # check contigs table
        query_contigs = """SELECT * FROM contigs WHERE contigs.name = (%s)"""
        cursor.execute(query_contigs, (record.CHROM, ))
        query_result = cursor.fetchall()

        if len(query_result) < 1:
            contig_ins_query = """INSERT INTO contigs (genome_id, name) VALUES (%s, %s)"""
            cursor.execute(contig_ins_query, (1, record.CHROM))
            cnx.commit()

            query_contigs = """SELECT * FROM contigs WHERE contigs.name = (%s)"""
            cursor.execute(query_contigs, (record.CHROM, ))
            query_result = cursor.fetchall()


        contig_id = query_result[0][0]


        # check type table
        cursor.execute("""SELECT * FROM variant_type WHERE name = %s""", (record.var_type, ))
        query_result = cursor.fetchall()
        if len(query_result) < 1:
            cursor.execute("""INSERT INTO variant_type (name) VALUE (%s)""", (record.var_type, ))
            cnx.commit()

            cursor.execute("""SELECT * FROM variant_type WHERE variant_type.name = %s""", (record.var_type, ))
            query_result = cursor.fetchall()

        type_id = query_result[0][0]

        # check subtype table
        cursor.execute("""SELECT * FROM variant_subtype WHERE name = %s""", (record.var_subtype, ))
        query_result = cursor.fetchall()
        if len(query_result) < 1:
            cursor.execute("""INSERT INTO variant_subtype (name) VALUE (%s)""", (record.var_subtype, ))
            cnx.commit()

            cursor.execute("""SELECT * FROM variant_subtype WHERE variant_subtype.name = %s""", (record.var_subtype, ))
            query_result = cursor.fetchall()

        subtype_id = query_result[0][0]

        # insert variant
        variant_ins_query = """INSERT INTO variants_table_doublelinked (run_id, contig_id, alleles, pos, alt, ref, 
        alt_alleles_list, qual, var_type_id, var_subtype_id, start, end, affected_start, affected_end, af, ac,
        dp, info_dict, samples_dict) VALUE (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)"""

        variant_attributes = (1, contig_id, json.dumps(str(record.alleles)), record.POS, str(record.ALT[0]), record.REF,
                              json.dumps(str(record.ALT)), record.QUAL, type_id, subtype_id, record.start, record.end,
                              record.affected_start, record.affected_end, record.heterozygosity, record.call_rate,
                              record.num_called, json.dumps(record.INFO), json.dumps(str(record.samples)))

        try:
            cursor.execute(variant_ins_query, variant_attributes)
            cnx.commit()
        except mysql.connector.errors.DataError as error:
            print(error)
            print("Variant call {} cannot be imported".format(record))
            continue

# close connection
cursor.close()
cnx.close()



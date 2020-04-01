# db query examples

import mysql.connector

# connection
cnx = mysql.connector.connect(user='long', password='password',
                              host='127.0.0.1',
                              database='pea_variant_calling')
cursor = cnx.cursor()

# db simple query for contigs
query = "SELECT * FROM contigs;"

cursor.execute(query)
query_result = cursor.fetchall()
print(query_result)

# query with join
query = """SELECT * FROM contigs 
LEFT JOIN variants_table_doublelinked AS vtd on contigs.id = vtd.contig_id
LEFT JOIN variant_subtype vs on vtd.var_subtype_id = vs.id
WHERE vs.name = 'ins' LIMIT 10;"""
cursor.execute(query)
query_result = cursor.fetchall()
print(query_result)

# json-based condition
query = """SELECT * FROM variants_table_doublelinked 
WHERE info_dict->'$.CL' > 4000 LIMIT 3;"""
cursor.execute(query)
query_result = cursor.fetchall()
print(query_result)

# close connection
cursor.close()
cnx.close()

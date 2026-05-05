import pandas as pd
import os
import mysql.connector
import math

# ===== CONFIGURAÇÃO =====
conn = mysql.connector.connect(
    host="localhost",
    user="root",
    password="admin123",
    database="chocolatesales"
)

cursor = conn.cursor()

# ===== CRIAR DATABASE SE NÃO EXISTIR =====
cursor.execute("CREATE DATABASE IF NOT EXISTS chocolatesales")
cursor.execute("USE chocolatesales")

pasta = '../csv'

csv_files = [
    os.path.join(pasta, nome)
    for nome in os.listdir(pasta)
    if nome.lower().endswith(".csv")
]

for csv_file in csv_files:
    # ===== NOME DA TABELA (corrigido) =====
    table_name = os.path.basename(csv_file).split('.')[0]

    # ===== LER CSV =====
    df = pd.read_csv(csv_file)

    # 🔥 TRATAR NaN → NULL
    df = df.where(pd.notnull(df), None)

    # ===== CRIAR COLUNAS =====
    columns = []

    for col, dtype in df.dtypes.items():
        if "int" in str(dtype):
            sql_type = "INT"
        elif "float" in str(dtype):
            sql_type = "FLOAT"
        else:
            sql_type = "VARCHAR(255)"

        columns.append(f"`{col}` {sql_type}")

    # ===== CRIAR TABELA =====
    create_sql = f"""
    CREATE TABLE IF NOT EXISTS `{table_name}` (
        {", ".join(columns)}
    );
    """

    cursor.execute(create_sql)

    # ===== INSERT =====
    placeholders = ", ".join(["%s"] * len(df.columns))

    insert_sql = f"""
    INSERT INTO `{table_name}` ({", ".join([f"`{col}`" for col in df.columns])})
    VALUES ({placeholders})
    """

    for row in df.values.tolist():
        clean_row = [
            None if (isinstance(x, float) and math.isnan(x)) else x
            for x in row
        ]
        cursor.execute(insert_sql, clean_row)

    conn.commit()

    print(f"✔ {table_name} importado com sucesso!")

cursor.close()
conn.close()
import pandas as pd
import numpy as np
from sqlalchemy import create_engine

engine = create_engine("mysql+pymysql://root:Bhavek22%40@localhost:3306/hospital")

df = pd.read_csv(r"C:\Users\verma\Downloads\hospital_data_large.csv")

print(df.head(7))
print(df.columns)

print(df.info())

print(df.isnull().sum())

df[df.isnull().any(axis=1)].head()
print(df)

# Cleaning The Data
df["age"] = df["age"].fillna(df["age"].median()).astype(int)

df["treatment_cost"] = df["treatment_cost"].fillna(df["treatment_cost"].mean()).astype(int)

print(df.isnull().sum())

Duplicate = df.duplicated().sum()
print(Duplicate)

# 
df["city"] = df["city"].str.title()

# Create Age Group
df["age_group"] = pd.cut(df["age"], bins=[0,18,35,60,100], 
                        labels=["Child","Young","Adult","Senior"])

df["high_risk"] = np.where(df["age"] > 60 ,"Yes","No")


print(df)

# Export
df.to_sql(
    name="hospital_data",
    con=engine,
    if_exists="replace",
    index=False
)

print(f"✓ {len(df)} rows exported to MySQL table 'hospital_data'")
print(f"✓ Columns: {list(df.columns)}")
# =========================================
# 1. LOAD DATA
# =========================================

import pandas as pd

# Load dataset
df = pd.read_csv("diabetic_data.csv")


# =========================================
# 2. INITIAL DATA UNDERSTANDING
# =========================================

# Check number of rows and columns
print(df.shape)

# Preview first 5 rows
print(df.head(5))

# Get column types and null info
print(df.info())

# List all column names
print(df.columns)


# =========================================
# 3. COLUMN-WISE ANALYSIS
# =========================================

# Analyze each column:
# - Top frequent values
# - Unique count
# - Missing values

for col in df.columns:
    print(f"\nColumn: {col}")
    
    print("Top values:")
    print(df[col].value_counts(dropna=False).head(5))
    
    print("Unique count:", df[col].nunique())
    print("Missing values:", df[col].isnull().sum())


# =========================================
# 4. DATA QUALITY CHECKS
# =========================================

# Check missing values
df.isnull().sum()

# Check '?' values (common placeholder in dataset)
(df == "?").sum()

# Check duplicate encounter IDs
df.duplicated(subset="encounter_id").sum()


# =========================================
# 5. DATA CLEANING
# =========================================

# Replace '?' with proper null values
df.replace("?", pd.NA, inplace=True)

# Convert age from range (e.g., [70-80)) to numeric
df["age"] = df["age"].str.extract(r"(\d+)").astype(int)

# Remove duplicate patient encounters
df = df.drop_duplicates(subset="encounter_id")


# =========================================
# 6. POST-CLEANING VALIDATION
# =========================================

# Recheck data structure and missing values
df.info()
df.isnull().sum()

# Confirm final dataset shape
df.shape


# =========================================
# 7. FEATURE SELECTION
# =========================================

# Select only relevant columns for analysis/dashboard
df_final = df[[
    "encounter_id",
    "age",
    "gender",
    "admission_type_id",
    "time_in_hospital",
    "num_procedures",
    "num_lab_procedures",
    "num_medications",
    "number_emergency",
    "readmitted"
]]


# =========================================
# 8. DATABASE CONNECTION
# =========================================

from sqlalchemy import create_engine 

# Database configuration
config = {
    "user": "root",
    "password": "Sunil11#1",
    "host": "localhost",
    "database": "hospital_db"
}

# Create database engine
engine = create_engine(
    f"mysql+pymysql://{config['user']}:{config['password']}@{config['host']}/{config['database']}"
)


# =========================================
# 9. LOAD DATA INTO SQL
# =========================================

# Insert cleaned data into SQL table
df_final.to_sql(
    "admissions",
    engine,
    if_exists="append",     # append data if table exists
    index=False,
    chunksize=5000,        # improves performance for large data
    method="multi"
)


# =========================================
# 10. FINAL CHECK
# =========================================

# Confirm number of records loaded
print(df_final.shape)
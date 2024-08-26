# Nashville Housing Data Cleaning Project

## Project Overview

This project involves cleaning and transforming the Nashville Housing dataset using SQL. The main objectives are to:

1. **Standardize Date Formats**  
   Convert and standardize the format of sale dates for consistency.

2. **Populate Missing Address Information**  
   Ensure all property addresses are complete by cross-referencing records within the dataset.

3. **Split Address Fields**  
   Break down property and owner addresses into separate columns for Address, City, and State for better data organization.

4. **Update Field Values**  
   Convert binary indicators (e.g., 'Y'/'N') into more readable formats (e.g., 'Yes'/'No') to improve clarity.

5. **Eliminate Duplicates**  
   Identify and remove duplicate rows to ensure data integrity and accuracy.

6. **Drop Unnecessary Columns**  
   Clean up the dataset by removing columns that are no longer needed for analysis.

This project demonstrates the process of preparing a raw dataset for analysis, employing various SQL techniques to ensure data consistency, accuracy, and usability.

## Scripts Included

- **Standardizing Date Formats**  
- **Populating Missing Address Information**  
- **Splitting Address Fields**  
- **Updating Field Values**  
- **Eliminating Duplicates**  
- **Dropping Unnecessary Columns**

## Usage

1. Run the scripts sequentially to apply the transformations and clean the dataset.
2. Ensure to execute the `DELETE` and `DROP` commands on a duplicate or test dataset to avoid data loss.

## Notes

- Always back up your data before running deletion or modification queries.
- Adjust column names and table structures as needed based on your specific dataset.

## Data
- Raw Data can be obtained from 

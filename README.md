# Hospital Database Creation & Data Migration

 
Designed and implemented a normalized MySQL database for a hospital management system and migrated legacy Excel records (patients, doctors, appointments, labs, billing) into the new schema. The repo includes schema DDL, migration scripts, data-cleaning SQL, stored procedures for common workflows, and sample reports (monthly revenue, department summaries).

---

##  Project Overview
Hospitals often store operational data in spreadsheets which lack referential integrity, consistent identifiers, or reliable reporting. This project creates a production-ready relational schema and an automated migration pipeline that:

- Ensures unique identifiers and referential integrity (PKs, FKs, constraints)
- Cleans and standardizes inconsistent Excel data
- Deduplicates records and resolves ambiguous entries
- Provides stored procedures and views for day-to-day operations and reporting
- Generates reproducible monthly/departmental reports

---

##  Problem Statement
Legacy Excel-based records caused:
- Missing unique IDs and disconnected relationships (appointments not linked to valid patients)
- Ambiguous/invalid values (inconsistent gender, status, date formats)
- Double-booked appointments and poor scheduling controls
- Open access to sensitive patient information
- No consistent departmental revenue or billing summaries

This repo addresses these problems by building a robust schema, adding rules/constraints, migrating and validating data, and automating reports.


##  Key Design Decisions
- **Normalized schema**: Separate tables for `patients`, `doctors`, `departments`, `appointments`, `labs`, `billing`, etc.  
- **Robust identifiers**: Auto-increment surrogate PKs plus unique natural keys when available (e.g., hospital_patient_id).  
- **Referential integrity**: Foreign keys & `ON DELETE/UPDATE` policies to avoid orphaned records.  
- **Data validation**: CHECK constraints and ENUMs for fields like `gender` and `appointment_status`.  
- **Audit & logging**: Triggers or audit tables recommended for change history.  
- **Access control**: Role-based access implied (read-only vs read-write) and environment-based credentials for apps.



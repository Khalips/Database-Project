# 🏥 Hospital Patient Management System

## 📖 Description
This is a database system for hospitals to manage:
- Patient information
- Doctor details
- Medical appointments
- Prescriptions
- Lab tests
- Billing records

It helps hospitals keep everything organized in one place!

## 🛠️ Setup Instructions

### What You Need:
1. MySQL installed on your computer
2. A database tool like MySQL Workbench (or just use the command line)

### How to Install:
1. **Download the files**:
   - `hospitalManagement.sql` (the database script)
   - `hospital_erd.png` (the diagram)

2. **Create the database**:
   - Open MySQL Workbench (or your favorite MySQL tool)
   - Connect to your MySQL server
   - Open the SQL file (`hospitalManagement.sql`)
   - Click "Run" (or press F9)

That's it! The database will create itself automatically.

## 📊 Database Diagram
Here's what the database structure looks like:

![ERD Diagram](hospital_erd.png)  
*(This shows how all the tables connect to each other)*

## 📂 What's Included
This project contains:
1. M.sql` - The complete database setup file
2. `MedicalDatabaseERD.drawio.png` - Picture of the database design
3. `README.md` - This explanation file

## 💡 How It Works
- **Patients table**: Stores patient names, contact info, insurance
- **Doctors table**: Keeps doctor information and specialties
- **Visits table**: Records all patient appointments
- **Medications**: List of available medicines
- **Prescriptions**: What medicines doctors prescribed
- **Lab Tests**: Medical test results
- **Billing**: Payment records for visits

All these tables are connected so information stays consistent!

You can add your own information to be stored into the tables

## 🙋 Need Help?
If you have trouble setting it up, try:
1. Make sure MySQL is running
2. Check for error messages when running the SQL file
3. Ask your teacher or classmates for help
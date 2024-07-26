# Employees Management System

## Overview
This system enables seamless handling of employee records, salary details, and departmental data through well-structured SQL queries.

## Features
- Create and manage employee records
- Handle salary details
- Manage departmental data
- Perform various data retrieval operations

## Technology Stack
- SQL for database management and queries

## Table Descriptions
### EmployeeDetails
- EmployeeID: INT Primary Key
- FirstName: VARCHAR(50)
- LastName: VARCHAR(50)
- Department: VARCHAR(50)
- Salary: DECIMAL(10,2)
- HireDate: DATE

## SQL Queries
Here are some of the SQL queries used in the project:
- Create Database and Table
```sql
CREATE DATABASE Employee;
USE Employee;
CREATE TABLE EmployeeDetails (
  EmployeeID INT PRIMARY KEY,
  FirstName VARCHAR(50),
  LastName VARCHAR(50),
  Department VARCHAR(50),
  Salary DECIMAL(10,2),
  HireDate DATE
);


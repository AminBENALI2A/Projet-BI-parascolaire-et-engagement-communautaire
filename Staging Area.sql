-- Step 1: Create the database
CREATE DATABASE StagingAreaActivity;
GO

DROP DATABASE StagingArea;

-- Step 2: Switch to the newly created database
USE StagingAreaActivity;
GO

-- Step 3: Create the tables without any relationships

-- Students table
CREATE TABLE Students (
    EleveKey VARCHAR(255) PRIMARY KEY,
    EtablissementName VARCHAR(255),
    RegionName VARCHAR(255),
    Nom_Eleve VARCHAR(255),
    Age INT,
    Parent1 VARCHAR(255),
    Parent2 VARCHAR(255),
    NiveauScolaire VARCHAR(255)
);
GO

-- Teachers table
CREATE TABLE Teachers (
    EnseignantKey VARCHAR(255) PRIMARY KEY,
    EtablissementName VARCHAR(255),
    RegionName VARCHAR(255),
    NomEnseignant VARCHAR(255),
    Age INT
);
GO

-- Activities table
CREATE TABLE Activities (
    ActiviteKey VARCHAR(255) PRIMARY KEY,
    EtablissementName VARCHAR(255),
    RegionName VARCHAR(255),
    DescriptionActivite VARCHAR(255),
    Categorie VARCHAR(255),
    TempsActivite DATETIME
);
GO

-- Student Attendance table
CREATE TABLE Student_Attendance (
    EleveKey VARCHAR(255),
    ActiviteKey VARCHAR(255),
    FlagPresenceEleve INT, -- 0 or 1 for attendance
    FlagPresenceParents INT, -- 0 or 1 for parent attendance
);
GO

-- Teacher Attendance table
CREATE TABLE Teacher_Attendance (
    EnseignantKey VARCHAR(255),
    ActiviteKey VARCHAR(255),
    FlagPresenceTeacher INT, -- 0 or 1 
);
GO


USE StagingAreaActivity;
GO


TRUNCATE TABLE Student_Attendance;
TRUNCATE TABLE Teacher_Attendance;
TRUNCATE TABLE Activities;
TRUNCATE TABLE Teachers;
TRUNCATE TABLE Students;
GO

select * from Student_Attendance;

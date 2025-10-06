use master;
GO
-- Drop the database if it exists
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'ActivityDW')
BEGIN
    DROP DATABASE ActivityDW;
END
GO

-- Create the database
CREATE DATABASE ActivityDW;
GO

USE ActivityDW;
GO

-- Table DimRegion
CREATE TABLE DimRegion (
    RegionKey INT IDENTITY(1,1) PRIMARY KEY,
    Nom VARCHAR(255) NOT NULL
);

-- Table DimEtablissement
CREATE TABLE DimEtablissement (
    EtablissementKey INT IDENTITY(1,1) PRIMARY KEY,
    Nom VARCHAR(255) NOT NULL,
    Adresse VARCHAR(255) NOT NULL
);

-- Table DimEnseignant
CREATE TABLE DimEnseignant (
    EnseignantKey INT IDENTITY(1,1) PRIMARY KEY,
    NomEnseignant VARCHAR(255) NOT NULL,
    Age SMALLINT NOT NULL
);

-- Table DimÉlève
CREATE TABLE DimEleve (
    EleveKey INT IDENTITY(1,1) PRIMARY KEY,
    Nom_élève VARCHAR(255) NOT NULL,
    Age SMALLINT NOT NULL,
    Parent1 VARCHAR(255),
    Parent2 VARCHAR(255),
);

-- Table DimCatégorieActivité
CREATE TABLE DimCategorieActivite (
    CategorieActiviteKey INT IDENTITY(1,1) PRIMARY KEY,
    NomCategorie VARCHAR(255) NOT NULL
);

-- Table DimActivité
CREATE TABLE DimActivite (
    ActiviteKey INT IDENTITY(1,1) PRIMARY KEY,
    DescriptionActivité VARCHAR(255),
	sourceKey VARCHAR(255),
	TempsKey VARCHAR(255)
);
use ActivityDW;
DROP TABLE DimActivite;

-- Table DimTemps
CREATE TABLE DimTemps (
    TempsKey INT IDENTITY(1,1) PRIMARY KEY,
    JourSemaine SMALLINT NOT NULL,
    JourMois SMALLINT NOT NULL,
    Semestre SMALLINT NOT NULL,
    Mois SMALLINT NOT NULL,
    AnneeScolaire varchar(255) NOT NULL
);
drop table DimTemps;
CREATE TABLE DimNiveauScolaire (
    NiveauScolaireKey INT IDENTITY(1,1) PRIMARY KEY, -- Unique identifier for the school level
    NomNiveauScolaire VARCHAR(255) NOT NULL        -- Name of the school level (e.g., 1A, 2A, ..., 12A)
);
-- Table EleveFact
CREATE TABLE EleveFact (
    EleveFactKey INT IDENTITY(1,1) PRIMARY KEY, -- Unique identifier for EleveFact
    EleveKey INT NOT NULL,                     -- Reference to the student
    ActiviteKey INT NOT NULL,                  -- Reference to the activity
    TempsKey INT NOT NULL,                     -- Reference to the time
    EtablissementKey INT NOT NULL,             -- Reference to the institution
    RegionKey INT NOT NULL,                    -- Reference to the region
	NiveauScolaireKey INT NOT NULL,
    CategorieActiviteKey INT NOT NULL,         -- Reference to the activity category
    FlagPresenceEleve INT NOT NULL,            -- Flag for student presence
    FlagPresenceParents INT NOT NULL           -- Flag for parents' presence
);

-- Table EnseignantFact
CREATE TABLE EnseignantFact (
    EnseignantFactKey INT IDENTITY(1,1) PRIMARY KEY, -- Unique identifier for EnseignantFact
    EnseignantKey INT NOT NULL,                      -- Reference to the teacher
    ActiviteKey INT NOT NULL,                        -- Reference to the activity
    TempsKey INT NOT NULL,                           -- Reference to the time
    EtablissementKey INT NOT NULL,                  -- Reference to the institution
    RegionKey INT NOT NULL,                         -- Reference to the region
    CategorieActiviteKey INT NOT NULL,              -- Reference to the activity category
    FlagPresence INT NOT NULL                       -- Flag for teacher presence
);

-- Table ActiviteFact
CREATE TABLE ActiviteFact (
    ActiviteFactKey INT IDENTITY(1,1) PRIMARY KEY,   -- Unique identifier for ActiviteFact
    ActiviteKey INT NOT NULL,                       -- Reference to the activity
    TempsKey INT NOT NULL,                          -- Reference to the time
    EtablissementKey INT NOT NULL,                 -- Reference to the institution
    RegionKey INT NOT NULL,                        -- Reference to the region
    CategorieActiviteKey INT NOT NULL,             -- Reference to the activity category
    EffectifPresent INT NOT NULL,                  -- Number of participants present
    EffectifAttendu INT NOT NULL,                  -- Number of participants expected
    TypeIndividu SMALLINT NOT NULL                 -- Type of individual (student, parent, teacher)
);
drop table ActiviteFact;



-- Verification
PRINT 'Database and tables created successfully without foreign key constraints!';


INSERT INTO DimCategorieActivite(NomCategorie) values ('Sports'),('Music'),('Arts'),('Drama'),('Science');

-- Insert data into DimRegion
INSERT INTO DimRegion (Nom) 
VALUES 
('Region 1'), 
('Region 2'), 
('Region 3');

-- Insert data into DimEtablissement
-- Region 1: 2 etablissements
INSERT INTO DimEtablissement (Nom, Adresse) 
VALUES 
('Etablissement 1-1', 'Address 1-1'), 
('Etablissement 1-2', 'Address 1-2');

-- Region 2: 3 etablissements
INSERT INTO DimEtablissement (Nom, Adresse) 
VALUES 
('Etablissement 2-1', 'Address 2-1'), 
('Etablissement 2-2', 'Address 2-2'), 
('Etablissement 2-3', 'Address 2-3');

-- Region 3: 2 etablissements
INSERT INTO DimEtablissement (Nom, Adresse) 
VALUES 
('Etablissement 3-1', 'Address 3-1'), 
('Etablissement 3-2', 'Address 3-2');

-- Insert values into DimNiveauScolaire
INSERT INTO DimNiveauScolaire (NomNiveauScolaire)
VALUES 
    ('1A'), ('2A'), ('3A'), ('4A'), ('5A'), ('6A'),
    ('7A'), ('8A'), ('9A'), ('10A'), ('11A'), ('12A');


ALTER TABLE dbo.DimActivite
ADD source_key VARCHAR(255) DEFAULT 'Unknown';

ALTER TABLE dbo.DimCategorieActivite
ADD source_key VARCHAR(255) DEFAULT 'Unknown';

ALTER TABLE dbo.DimEleve
ADD source_key VARCHAR(255) DEFAULT 'Unknown';

ALTER TABLE dbo.DimEnseignant
ADD source_key VARCHAR(255) DEFAULT 'Unknown';

ALTER TABLE dbo.DimEtablissement
ADD source_key VARCHAR(255) DEFAULT 'Unknown';

ALTER TABLE dbo.DimRegion
ADD source_key VARCHAR(255) DEFAULT 'Unknown';

ALTER TABLE dbo.DimActivite
ADD time_source_key VARCHAR(255) DEFAULT 'Unknown';

ALTER TABLE dbo.DimTemps
ADD time_source_key VARCHAR(255) DEFAULT 'Unknown';



-- Verify data in DimRegion
SELECT * FROM DimRegion;

-- Verify data in DimEtablissement
SELECT * FROM DimEtablissement;



SELECT        ActiviteKey, TempsKey,EtablissementKey,RegionKey,CategorieActiviteKey, SUM(FlagPresence) AS EffectifPresent, COUNT(*) AS EffectifAttendu, 2 AS TypeIndividu
FROM            EnseignantFact
GROUP BY ActiviteKey, TempsKey,EtablissementKey,RegionKey,CategorieActiviteKey
UNION ALL
SELECT        ActiviteKey, TempsKey,EtablissementKey,RegionKey,CategorieActiviteKey, SUM(FlagPresenceEleve) AS EffectifPresent, COUNT(*) AS EffectifAttendu, 0 AS TypeIndividu
FROM            EleveFact
GROUP BY ActiviteKey, TempsKey,EtablissementKey,RegionKey,CategorieActiviteKey
UNION ALL
SELECT        ActiviteKey, TempsKey,EtablissementKey,RegionKey,CategorieActiviteKey, SUM(FlagPresenceParents) AS EffectifPresent, COUNT(*) AS EffectifAttendu, 1 AS TypeIndividu
FROM            EleveFact AS EleveFact_1
GROUP BY ActiviteKey, TempsKey,EtablissementKey,RegionKey,CategorieActiviteKey;


use  ActivityDW;
GO

TRUNCATE TABLE ActiviteFact;
TRUNCATE TABLE EnseignantFact;
TRUNCATE TABLE EleveFact;
TRUNCATE TABLE DimEleve;
TRUNCATE TABLE DimEnseignant;
TRUNCATE TABLE DimActivite;
TRUNCATE TABLE DimEtablissement;
TRUNCATE TABLE DimRegion;
TRUNCATE TABLE DimTemps;
TRUNCATE TABLE DimCategorieActivite;
TRUNCATE TABLE DimNiveauScolaire



select * from DimTemps order by TempsKey;
DROP TABLE ActiviteFact;
DROP TABLE EnseignantFact;
DROP TABLE EleveFact;
DROP TABLE DimEleve;
DROP TABLE DimEnseignant;
DROP TABLE DimActivite;
DROP TABLE DimEtablissement;
DROP TABLE DimRegion;
DROP TABLE DimTemps;
DROP TABLE DimCategorieActivite;



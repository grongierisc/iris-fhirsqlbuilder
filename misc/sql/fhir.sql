create TABLE AB.DriverLicense (

    Code varchar(255) not null,
    Valide TINYINT not null

);

INSERT INTO AB.DriverLicense (Code, Valide) VALUES ('S99916528', 1);

INSERT into AB.DriverLicense (Code, Valide) VALUES ('S99950276', 0);

SELECT 
 Gender, IdentifierTypeText, IdentifierValue, Valide, Key, NameFamily, NameGiven, NameUse
FROM AA.Patient P
Left join AB.DriverLicense DL on P.IdentifierValue = DL.Code;

SELECT
ID, DescriptionText, Key, LifecycleStatus, SubjectReference, $piece(sqliknowparser(DescriptionText),'|',1) as entities
FROM AA.Goal 
union
SELECT 
ID, DescriptionText, Key, LifecycleStatus, SubjectReference, $piece(sqliknowparser(DescriptionText),'|',2) as entities
FROM AA.Goal
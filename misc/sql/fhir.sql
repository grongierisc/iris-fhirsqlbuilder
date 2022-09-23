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
ID, DescriptionText, Key, LifecycleStatus, SubjectReference, $p(GetEntitiesList(DescriptionText),1) as entities
FROM AA.Goal
UNION
SELECT 
ID, DescriptionText, Key, LifecycleStatus, SubjectReference, $list(GetEntitiesList(DescriptionText),2) as entities
FROM AA.Goal

select $list(a.ss_note_multi_dict_1_value,',',1),join_to_tx_history
from your_table where (the condition of your select) and $piece(a.ss_note_multi_dict_1_value,',',1) is not null
union
select $piece(a.ss_note_multi_dict_1_value,',',2),join_to_tx_history
from your_table where (the condition of your select) and $piece(a.ss_note_multi_dict_1_value,',',2) is not null
union
select $piece(a.ss_note_multi_dict_1_value,',',3),join_to_tx_history
from your_table where (the condition of your select) and $piece(a.ss_note_multi_dict_1_value,',',3) is not null
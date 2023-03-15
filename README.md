# iris-fhirsqlbuilder

This project shows how to use the FHIR SQL Builder to generate SQL statements for the FHIR Server from IRIS.

The end result will be available on Tableau.

![Tableau](https://raw.githubusercontent.com/grongierisc/iris-fhirsqlbuilder/master/misc/img/TableauResult.png)

## Prerequisites

- IRIS Community Edition
- Git
- Docker
- Tableau Desktop

## Installation

Git clone this repository.

```bash
git clone https://github.com/grongierisc/iris-fhirsqlbuilder.git
```

Run the following command to start IRIS.

```bash
docker-compose up -d
```

### FHIR SQL Builder

For your convenience, this project contains preloaded data in the FHIR Server.

Preloaded data is available in the following folder.

`data/fhir`

#### Configure an FHIR Repository to analyze

Once IRIS is up and running, go to the FHIR SQL Builder and generate the SQL statements for the FHIR Server.

http://localhost:33783/csp/fhirsql/index.csp

Login / password : SuperUser / SYS

![FHIRSQLIntro](https://raw.githubusercontent.com/grongierisc/iris-fhirsqlbuilder/master/misc/img/FHIRSQLIntro.png)

Then register the current FHIR Server with the FHIR SQL Builder.

To do so, click on `New Analysis`.

![FHIRSQLNewAnalysis](https://raw.githubusercontent.com/grongierisc/iris-fhirsqlbuilder/master/misc/img/NewAnalysis.png)

Then click on `Register FHIR Server`.

![FHIRSQLRegisterFHIRServer](https://raw.githubusercontent.com/grongierisc/iris-fhirsqlbuilder/master/misc/img/NewFhirRepo.png)

Fully the form with the following values:

- FHIR Server Name: FHIRSERVER
- Host: localhost
- Port: 52773
- Credentials: SuperUser / SYS
  - Click on New Credentials to create a new user with the right credentials.
- FHIR repository url : /fhir/r4

Then click on `Save`.

Now we can generate an analysis.

- Selectivity : 100

![FHIRSQLAnalysis](https://raw.githubusercontent.com/grongierisc/iris-fhirsqlbuilder/master/misc/img/AnalysisSelectivity.png)

Then click on `Lunch Analysis`.

#### Create projections

Once the analysis is done, we can create projections.

![FHIRSQLProjections](https://raw.githubusercontent.com/grongierisc/iris-fhirsqlbuilder/master/misc/img/CreateProjection.png)

To help you in this task, you can import the following projections.

misc/ExportFHIRtoSQL.json

Click on `Import Projections`.

Then click on `Import`.

![ImportProjections](https://raw.githubusercontent.com/grongierisc/iris-fhirsqlbuilder/master/misc/img/ImportProjections.png)

Select your analysis and click on `Import`.

If you want to see the projections, click on `Edit Projections`.

![EditProjections](https://raw.githubusercontent.com/grongierisc/iris-fhirsqlbuilder/master/misc/img/EditProjection.png)

#### Generate SQL statements

Once the projections are created, we can generate the SQL statements.

![FHIRSQLGenerateSQL](https://raw.githubusercontent.com/grongierisc/iris-fhirsqlbuilder/master/misc/img/NewStatements.png)

Select your analysis, the projections and the schema.

Then click on `Projection`.

## Usage

Now that we have the SQL statements, we can play with them into IRIS.

Go to the SQL UI :

http://localhost:33783/csp/sys/exp/%25CSP.UI.Portal.SQL.Home.zen?$NAMESPACE=FHIRSERVER

![SQLUI](https://raw.githubusercontent.com/grongierisc/iris-fhirsqlbuilder/master/misc/img/SQLUI.png)

Let's play with few SQL statements.

### Patient

Display the patient as a table :

```sql
SELECT 
ID, AddressCity, BirthDate, Gender, Key, NameFamily, NameGiven, NamePrefix, NameUse
FROM AA.Patient
```

Result :

| ID |AddressCity |BirthDate |Gender |Key |NameFamily |NameGiven |NamePrefix |NameUse|
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 |Shirley |1954-06-13 |male |Patient/1 |O'Hara248 |Carroll471 |Mr. |official|
| 172 |Somerset |1975-08-12 |male |Patient/172 |Jast432 |Frankie174 |Mr. |official|
| 459 |Swansea |2009-05-04 |female |Patient/459 |Rohan584 |Gabriele201 |  |official|
| 705 |Weston |1945-12-19 |female |Patient/705 |Frami345 |Kallie862 |Mrs. |official|
| 1002 |Weston |1945-12-19 |female |Patient/1002 |Davis923 |Lean294 |Mrs. |official|
| 1510 |Boston |1995-03-26 |female |Patient/1510 |Hettinger594 |Margie619 |Ms. |official|

### Join patient with an external table

Create an external table :

```sql
create TABLE AB.DriverLicense (

    Code varchar(255) not null,
    Valide TINYINT not null

)
```

Insert data into the external table :

```sql
INSERT INTO AB.DriverLicense (Code, Valide) VALUES ('S99916528', 1);

INSERT into AB.DriverLicense (Code, Valide) VALUES ('S99950276', 0);
```

Join the external table with the patient table :

```sql
SELECT 
P.NameFamily, P.NameGiven,DL.*
FROM AA.Patient P
inner join AB.DriverLicense DL on P.IdentifierValue = DL.Code
```

Result :

|ID |AddressCity |BirthDate |Gender |IdentifierTypeCodingCode |IdentifierValue |Key |NameFamily |NameGiven |NamePrefix |NameUse |Code |Valide|
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
|1 |Shirley |1954-06-13 |male |DL |S99916528 |Patient/1 |O'Hara248 |Carroll471 |Mr. |official |S99916528 |1|
|172 |Somerset |1975-08-12 |male |DL |S99950276 |Patient/172 |Jast432 |Frankie174 |Mr. |official |S99950276 |0|
|459 |Swansea |2009-05-04 |female |  |  |Patient/459 |Rohan584 |Gabriele201 |  |official |  | |
|705 |Weston |1945-12-19 |female |DL |S99938125 |Patient/705 |Frami345 |Kallie862 |Mrs. |official |  | |
|1002 |Weston |1945-12-19 |female |DL |S99975762 |Patient/1002 |Davis923 |Lean294 |Mrs. |official |  | |
|1510 |Boston |1995-03-26 |female |DL |S99981337 |Patient/1510 |Hettinger594 |Margie619 |Ms. |official |  | |

What is neat to note here is that we can join the FHIR Server with an external table.

Then it's in the imported projections we ask to project not all the identifiers but only the driver license.

From `ExportFHIRtoSQL.json` :
```json
        {
          "name": "IdentifierTypeCodingCode",
          "type": "String",
          "path": "Patient.identifier.type.coding.where(code = 'DL').code",
          "index": false
        },
        {
          "name": "IdentifierValue",
          "type": "String",
          "path": "Patient.identifier.where(type.coding.code = 'DL').value",
          "index": false
        }
```

### Play with iknowpy

We can also play with iknowpy.

iknowpy is a natural language processing library available on python.

We can use it to extract information from a text.

Let's create an SQL function in python :

```sql
CREATE FUNCTION sqliknowparser(tText VARCHAR(50000))
    RETURNS VARCHAR(50000)
    LANGUAGE PYTHON
{
    import iknowpy

    engine = iknowpy.iKnowEngine()

    # index some text
    text = tText
    engine.index(text, 'en')

    t_output = ""

    # or make it a little nicer
    for s in engine.m_index['sentences']:
        for e in s['entities']:
            if e['type'] == 'Concept':
                t_output = t_output  + e['index']+ "|"

    return t_output[:-1]
}
```

Then we can use it in a SQL statement :

```sql
SELECT
ID, DescriptionText, Key, LifecycleStatus, SubjectReference, $piece(sqliknowparser(DescriptionText),'|',1) as entities
FROM AA.Goal 
union
SELECT 
ID, DescriptionText, Key, LifecycleStatus, SubjectReference, $piece(sqliknowparser(DescriptionText),'|',2) as entities
FROM AA.Goal
```

Result :

|ID |DescriptionText |Key |LifecycleStatus |SubjectReference |entities|
| --- | --- | --- | --- | --- | --- |
|178 |Maintain blood pressure below 140/90 mm[Hg] |Goal/178 |accepted |Patient/172 |blood pressure|
|179 |Reduce sodium intake to no more than 2,400 mg/day |Goal/179 |accepted |Patient/172 |sodium intake|
|178 |Maintain blood pressure below 140/90 mm[Hg] |Goal/178 |accepted |Patient/172 |140/90 mm[hg]|
|179 |Reduce sodium intake to no more than 2,400 mg/day |Goal/179 |accepted |Patient/172 |no more than 2,400 mg/day|

## Tableau

To make a connection with Tableau, you need to install the JDBC driver.

Copy the JDBC driver in the `drivers` folder of Tableau.

JDBC driver : https://github.com/intersystems-community/iris-driver-distribution/blob/main/JDBC/JDK18/intersystems-jdbc-3.6.1.jar

`drivers` folder :

  * Windows : C:\Program Files\Tableau\Drivers
  * Mac : ~/Library/Tableau/Drivers
  * Linux : /opt/tableau/tableau_driver/jdbc

Just open Tableau and connect to IRIS with the JDBC driver.

Tableau file : `TableauDemo.twb` in `misc` folder.

### Conclusion

We have seen how to use the FHIR SQL Build to create a SQL database.

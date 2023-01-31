# iris-fhirsqlbuilder

This project shows how to use the FHIR SQL Builder to generate SQL statements for the FHIR Server from IRIS.

The end result will be available on Tableau.

## Prerequisites

- IRIS Community Edition
- Git
- Docker
- Tableau Desktop

## Installation

Git clone this repository.

```bash
git clone
```

Run the following command to start IRIS.

```bash
docker-compose up -d
```

### FHIR SQL Builder

#### Configure an FHIR Repository to analyze

Once IRIS is up and running, go to the FHIR SQL Builder and generate the SQL statements for the FHIR Server.

http://localhost:33783/csp/fhirsql/index.csp

[FHIRSQLIntro](misc/img/FHIRSQLIntro.png)

Then register the current FHIR Server with the FHIR SQL Builder.

To do so, click on New Analysis.

[FHIRSQLNewAnalysis](misc/img/FHIRSQLNewAnalysis.png)

Then click on Register FHIR Server.

[FHIRSQLRegisterFHIRServer](misc/img/FHIRSQLRegisterFHIRServer.png)

Fully the form with the following values:

- FHIR Server Name: FHIRSERVER
- Host: localhost
- Port: 52773
- Credentials: SuperUser / SYS
  - Click on New Credentials to create a new user with the right credentials.
- FHIR repository url : /fhir/r4

Then click on Save.

Now we can generate an analysis.

- Selectivity : 100

[FHIRSQLAnalysis](misc/img/FHIRSQLAnalysis.png)

Then click on Lunch Analysis.

#### Create projections

Once the analysis is done, we can create projections.

[FHIRSQLProjections](misc/img/FHIRSQLProjections.png)

To help you in this task, you can import the following projections.

misc/ExportFHIRtoSQL.json

Click on Import Projections.

Then click on Import.

[ImportProjections](misc/img/ImportProjections.png)

Select your analysis and click on Import.

If you want to see the projections, click on Edit Projections.

[EditProjections](misc/img/EditProjections.png)

#### Generate SQL statements

Once the projections are created, we can generate the SQL statements.

[FHIRSQLGenerateSQL](misc/img/FHIRSQLGenerateSQL.png)

Select your analysis, the projections and the schema.

Then click on Generate SQL.

## Usage

Now that we have the SQL statements, we can play with them into IRIS.

Go to the SQL UI :

http://localhost:33783/csp/sys/exp/%25CSP.UI.Portal.SQL.Home.zen?$NAMESPACE=FHIRSERVER

[SQLUI](misc/img/SQLUI.png)

Let's play with few SQL statements.


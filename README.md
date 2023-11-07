# _Talend modèles dynamiques DB_

## Objectifs
Job de chargement dynamique des données d'une base source à une base destination

## Outils et Versions
- Talend Open Studio for ESB Version 8.0.1
- Java Version 11
- Dbeaver Version 23.1.0
- MySQL Version 5.1.30
- MariaDB Version 11.0

## Description
> Nous prévoyons de développer des modèles dynamiques en utilisant un schéma dynamique pour transférer des données de manière fluide de leur source vers leur destination. De plus, nous envisageons la possibilité de rendre le type de base de données dynamique.
![JOB.](/image/job.png "JOB")

## Composants 
| Composants | Configuration |
| ------ | ------ |
| Configuration du composant tDBInput_1 | ![Talend modèles dynamiques DB.](/image/job-tDBInput.PNG "Talend modèles dynamiques DB.") |
| Configuration du composant tDBOutput_1 | ![Talend modèles dynamiques DB.](/image/job-tDBOutput.PNG "Talend modèles dynamiques DB.") |

## Construction du Job
![Construction du Job.](/image/construire-job.PNG "Construction du Job.")


## Teste: 
Nous allons testé la fonctionnalité de ce job en deux etapes 
	1. transférer des données de la Table source Invoice(SQLite) vers la Table cible Invoice (MySQL)
	2. transférer des données de la Table source Invoice(MySQL) vers la Table cible Invoice (MariaDB)
### Etape 1 : 
Table source Invoice(SQLite) => Table cible Invoice (MySQL)
	1. Creation de la table cible (MySQL)
	```
		CREATE TABLE Invoice
		(
			id INTEGER  NOT NULL,
			date DATETIME  NOT NULL,
			address NVARCHAR(210),
			total NUMERIC(10,2)  NOT NULL,
			CONSTRAINT PK_Invoice PRIMARY KEY  (InvoiceId)
		);
	```
	2. Creation d'un fichier properties dans le repertoir du job générer 
		../job_chargement_donnee_0.1/job_chargement_donnee/projet/job_chargement_donnee_0_1/contexts/ConfigSqlliteToMysqlInvoice.properties 
	```
		## parametre de connexion pour la base de donnée source
		connection_source_drivers="mvn:org.xerial/sqlite-jdbc/3.40.0.0/jar"
		connection_source_driverClass=org.sqlite.JDBC
		connection_source_password=
		connection_source_userId=
		connection_source_jdbcUrl=jdbc:sqlite:/C:/datasource/Chinook.db
		connection_source_jdbcTable=Invoice
		connection_source_jdbcRequete=SELECT InvoiceId	as id, InvoiceDate as "date", BillingAddress || '; ' || BillingCity || '; ' || BillingState || '; ' || BillingCountry || '; ' || BillingPostalCode as address, Total as total from Invoice WHERE BillingState is NOT NULL AND BillingPostalCode is NOT NULL

		## parametre de connextion pour la base de donnée destination
		connection_destination_drivers="mvn:mysql/mysql-connector-java/5.1.49/jar"
		connection_destination_driverClass=com.mysql.jdbc.Driver
		connection_destination_password=root
		connection_destination_userId=root
		connection_destination_jdbcUrl=jdbc:mysql://localhost:3306/data
		connection_destination_jdbcTable=invoice
	```
	![Config Sqllite To Mysql Invoice.](/image/ConfigSqlliteToMysqlInvoice.PNG "Config Sqllite To Mysql Invoice.")
	3. Modifier le script 	../job_chargement_donnee_0.1/job_chargement_donnee/job_chargement_donnee_run.bat
		remplacer le contenu avec cette commande : (Exemple)
	```
		java -Xms256M -Xmx1024M -cp .;../lib/*;job_chargement_donnee_0_1.jar; projet.job_chargement_donnee_0_1.job_chargement_donnee --context=ConfigSqlliteToMysqlInvoice %*
	```
	![job chargement donnee run.](/image/script1.png "job chargement donnee run.")
	4. Lancer le job avec l'invite commande :
	```
		job_chargement_donnee_run.bat
	```	
	NB : Assurer vous que les libs 
			sqlite-jdbc-3.40.0.0.jar
			mysql-connector-java-5.1.49.jar
		Existe dans le repertoir ../job_chargement_donnee_0.1/lib
		![job chargement donnee run.](/image/lib-1.png "job chargement donnee run.")
	5. verification du resultat
	![job chargement donnee run.](/image/Exec-script1.png "job chargement donnee run.")	

### Etape 2 : on va changer de configuration (type de base de donnée)
Table source Invoice(MySQL) => Table cible Invoice (MariaDB)
	1. Creation de la table cible (MariaDB)
	```
		CREATE TABLE Invoice
		(
			InvoiceYears INT  NOT NULL,
			BillingCountry NVARCHAR(40),
			Total NUMERIC(10,2)  NOT NULL
		);
	```
	2. Creation d'un fichier properties dans le repertoir du job générer 
		../job_chargement_donnee_0.1/job_chargement_donnee/projet/job_chargement_donnee_0_1/contexts/ConfigMysqlToMariaDbInvoice.properties 
	```
		## parametre de connexion pour la base de donnée source
		connection_source_drivers="mvn:mysql/mysql-connector-java/5.1.49/jar"
		connection_source_driverClass=com.mysql.jdbc.Driver
		connection_source_password=root
		connection_source_userId=root
		connection_source_jdbcUrl=jdbc:mysql://localhost:3306/data
		connection_source_jdbcTable=Invoice
		connection_source_jdbcRequete=select DATE_FORMAT(date, '%Y') as InvoiceYears, SUBSTRING_INDEX(SUBSTRING_INDEX(address,';', 4), ';',-1) as BillingCountry, sum(total) as Total from `data`.invoice group by DATE_FORMAT(date, '%Y'),SUBSTRING_INDEX(SUBSTRING_INDEX(address,';', 4), ';',-1)

		## parametre de connextion pour la base de donnée destination
		connection_destination_drivers="mvn:org.mariadb.jdbc/mariadb-java-client/3.1.4/jar"
		connection_destination_driverClass=org.mariadb.jdbc.Driver
		connection_destination_password=root
		connection_destination_userId=root
		connection_destination_jdbcUrl=jdbc:mysql://localhost:3307/data
		connection_destination_jdbcTable=invoice
		```
	![Config Mysql To MariaDb Invoice.](/image/ConfigMysqlToMariaDbInvoice.PNG "Config Mysql To MariaDb Invoice.")
	3. Modifier le script 	../job_chargement_donnee_0.1/job_chargement_donnee/job_chargement_donnee_run.bat
		remplacer le contenu avec cette commande : (Exemple)
		```
		java -Xms256M -Xmx1024M -cp .;../lib/*;job_chargement_donnee_0_1.jar; projet.job_chargement_donnee_0_1.job_chargement_donnee --context=ConfigMysqlToMariaDbInvoice %*
		```
		![job chargement donnee run.](/image/script2.png "job chargement donnee run.")
	4. Lancer le job avec l'invite commande :
	```
		job_chargement_donnee_run.bat
	```
	NB : Assurer vous que les libs 
			mariadb-java-client-3.1.4.jar
			mysql-connector-java-5.1.49.jar
		Existe dans le repertoir ../job_chargement_donnee_0.1/lib
		![job chargement donnee run.](/image/lib-2.png "job chargement donnee run.")	
	5. verification du resultat
		![job chargement donnee run.](/image/Exec-script2.png "job chargement donnee run.")	

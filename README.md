# _Talend modèles dynamiques DB_

## Objectifs
Job de chargement dynamique des données d'une base source à une base destination

## Outils et Versions
- Talend Open Studio for ESB Version 8.0.1
- Java Version 11
- Dbeaver Version 23.1.0
- MySQL Version 5.1.30
- MariaDB Version 11.0
- SQLite DB : db/Chinook.db
## Description
> Nous prévoyons de développer des modèles dynamiques en utilisant un schéma dynamique pour transférer des données de manière fluide de leur source vers leur destination. De plus, nous envisageons la possibilité de rendre le type de base de données dynamique.
![JOB.](/image/job.png "JOB")

## Composants 
| Composants | Configuration |
| ------ | ------ |
| Configuration du composant tDBInput_1 | ![Talend modèles dynamiques DB.](/image/job-tDBInput.png "Talend modèles dynamiques DB.") |
| Configuration du composant tDBOutput_1 | ![Talend modèles dynamiques DB.](/image/job-tDBOutput.png "Talend modèles dynamiques DB.") |

## Construction du Job
![Construction du Job.](/image/construire-job.png "Construction du Job.")


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
![Config Sqllite To Mysql Invoice.](/image/ConfigSqlliteToMysqlInvoice.png "Config Sqllite To Mysql Invoice.")
 
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
![job chargement donnee run.](/image/Exec-script1.png "job chargement donnee run.")
> NB : Assurer vous que les libs 
>	- sqlite-jdbc-3.40.0.0.jar
>	- mysql-connector-java-5.1.49.jar
> 
> Existe dans le repertoir ../job_chargement_donnee_0.1/lib

![job chargement donnee run.](/image/lib-1.png "job chargement donnee run.")

5. Verification du resultat
![job chargement donnee run.](/image/verification-resultat.png "job chargement donnee run.")
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
![Config Mysql To MariaDb Invoice.](/image/ConfigMysqlToMariaDbInvoice.png "Config Mysql To MariaDb Invoice.")

4. Modifier le script 	../job_chargement_donnee_0.1/job_chargement_donnee/job_chargement_donnee_run.bat
remplacer le contenu avec cette commande : (Exemple)
```
java -Xms256M -Xmx1024M -cp .;../lib/*;job_chargement_donnee_0_1.jar; projet.job_chargement_donnee_0_1.job_chargement_donnee --context=ConfigMysqlToMariaDbInvoice %*
```
![job chargement donnee run.](/image/script2.png "job chargement donnee run.")

4. Lancer le job avec l'invite commande :
```
job_chargement_donnee_run.bat
```
![job chargement donnee run.](/image/Exec-script2.png "job chargement donnee run.")	
> NB : Assurer vous que les libs 
> 	- mariadb-java-client-3.1.4.jar
> 	- mysql-connector-java-5.1.49.jar
> 
> Existe dans le repertoir ../job_chargement_donnee_0.1/lib

![job chargement donnee run.](/image/lib-2.png "job chargement donnee run.")	

5. Verification du resultat

![job chargement donnee run.](/image/verification-resultat1.png "job chargement donnee run.")	

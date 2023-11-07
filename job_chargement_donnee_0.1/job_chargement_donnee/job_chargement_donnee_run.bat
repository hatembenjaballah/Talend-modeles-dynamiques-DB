%~d0
cd %~dp0
:: java -Xms256M -Xmx1024M -cp .;../lib/*;job_chargement_donnee_0_1.jar; projet.job_chargement_donnee_0_1.job_chargement_donnee --context=ConfigSqlliteToMysqlInvoice %*
java -Xms256M -Xmx1024M -cp .;../lib/*;job_chargement_donnee_0_1.jar; projet.job_chargement_donnee_0_1.job_chargement_donnee --context=ConfigMysqlToMariaDbInvoice %*

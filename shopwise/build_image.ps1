docker build `
--build-arg PERSONAL_ACCESS_TOKEN='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' `
--build-arg GITHUB_USERNAME='gazypendragon' `
--build-arg REPOSITORY_NAME='shopwise-Application-Codes' `
--build-arg WEB_FILE_ZIP='shopwise.zip' `
--build-arg WEB_FILE_UNZIP='shopwise' `
--build-arg DOMAIN_NAME='www.ndefrusonsllc.com' `
--build-arg RDS_ENDPOINT='app-db.ctgdsdmazrtg.us-east-1.rds.amazonaws.com' `
--build-arg RDS_DB_NAME='applicationdb' `
--build-arg RDS_MASTER_USERNAME='craa' `
--build-arg RDS_DB_PASSWORD='craa1234' `
-t shopwise .
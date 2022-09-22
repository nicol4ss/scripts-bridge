#!/bin/bash

echo -e  "SELECT ONE: \n cc = compile only \n cp = compile + postgres \n co = compile + oracle \n tupp = terminmal run postgres \n tupo = terminal run oracle \n retfront = reterritorializacao frontend \n visufront = visualizacao territorio frontend \n mp = migracoes postgres \n mo = migracoes oracle"
read config;

if [ $config = "cc" ]; then
    mvn clean install -DskipTests -T5

    echo "SCRIPT COMPILER DONE!"

elif [ $config = "mp" ]; then
    mvn clean install -DskipTests -T5
    cd database/
    mvn spring-boot:run -Dspring.profiles.active=dev,dev-postgres -Dspring.liquibase.contexts=skipLogradouro,experimental
    cd ..
    cd data-loader/
    mvn spring-boot:run -Dspring.profiles.active=dev,dev-postgres
    cd ..

elif [ $config = "mo" ]; then
    mvn clean install -DskipTests -T5
    cd database/
    mvn spring-boot:run -Dspring.profiles.active=dev,dev-oracle -Dspring.liquibase.contexts=skipLogradouro,experimental
    cd ..
    cd data-loader/
    mvn spring-boot:run -Dspring.profiles.active=dev,dev-oracle
    cd ..
    
elif [ $config = "cp" ]; then
    docker volume prune -f
    docker rm -f pec_postgres_1
    docker rm -f pec_oracle_1
    docker-compose up -d postgres
    mvn clean install -DskipTests -T5
    cd database/
    mvn spring-boot:run -Dspring.profiles.active=dev,dev-postgres -Dspring.liquibase.contexts=skipLogradouro,experimental
    cd ..
    cd data-loader/
    mvn spring-boot:run -Dspring.profiles.active=dev,dev-postgres
    cd ..

elif [ $config = "co" ]; then 
    docker rm -f pec_postgres_1
    docker rm -f pec_oracle_1
    docker-compose up -d postgres
    mvn clean install -DskipTests -T5
    cd database/
    mvn spring-boot:run -Dspring.profiles.active=dev,dev-oracle -Dspring.liquibase.contexts=skipLogradouro,experimental
    cd ..
    cd data-loader/
    mvn spring-boot:run -Dspring.profiles.active=dev,dev-oracle
    cd ..

elif [ $config = "tupp" ]; then
    cd app-bundle/
    mvn spring-boot:run -Dspring.profiles.active=dev,dev-postgres -Dbridge.flags.experimental=true
    cd ..

elif [ $config = "tupo" ]; then
    cd app-bundle/
    mvn spring-boot:run -Dspring.profiles.active=dev,dev-oracle -Dbridge.flags.experimental=true
    cd ..
    
elif [ $config = "retfront" ]; then  
    cd frontend/
    REACT_APP_TERRITORIO_ENABLED=true yarn start
    exit

elif [ $config = "visufront" ]; then
    cd frontend/
    REACT_APP_VISUALIZACAO_TERRITORIO_ENABLED=true yarn start
    exit
else
    echo "Comando invalido"
fi

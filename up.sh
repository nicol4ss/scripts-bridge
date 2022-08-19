#!/bin/bash

echo "SELECT: co, up, uo, utp, uto, mp, mo"
read config;

if [ $config = "co" ]; then
    docker volume prune -f
    docker rm -f pec_postgres_1
    docker rm -f pec_oracle_1
    docker-compose up -d postgres
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
    
elif [ $config = "up" ]; then
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

elif [ $config = "uo" ]; then 
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

elif [ $config = "tp" ]; then
    cd app-bundle/
    mvn spring-boot:run -Dspring.profiles.active=dev,dev-postgres -Dbridge.flags.experimental=true
    gnome-terminal -x bash -c
    cd frontend/
    REACT_APP_TERRITORIO_ENABLED=true yarn start
    
elif [ $config = "to" ]; then
    cd app-bundle/
    mvn spring-boot:run -Dspring.profiles.active=dev,dev-oracle -Dbridge.flags.experimental=true
    gnome-terminal -x bash -c
    cd frontend/
    REACT_APP_TERRITORIO_ENABLED=true yarn start
else
    echo "Comando invalido"
fi


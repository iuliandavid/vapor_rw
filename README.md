### RAY Wenderlich Vapor Screencast series


### Should there be any need to deploy to heroku :
  * cd into the project
    
    ```bin/sh 
    git init
    ```
    
  * Initialize heroku with vapor:  **vapor heroku init ** 
*NOTE*: DO NOT PUSH TO HEROKU(on the last question answer with NO) (see below) 

![Screenshot from 2017-04-18 16-50-52.png](https://bitbucket.org/repo/8zzzxjK/images/409684666-Screenshot%20from%202017-04-18%2016-50-52.png)


  * Create a database:   ** heroku addons:create heroku-postgresql:hobby-dev **
  * Edit Procfile with the new postgresql url connection: web: App --env=production --workdir=./ --config:servers.default.port=$PORT --config:postgresql.url=$DATABASE_URL
  * The $DATABASE_URL can be consulted with heroku config
  * add the new changes
  * Push to heroku: **git push heroku master**
    
*Note* : I use swift 3.1 version, so for this a new file: .swift-version with **3.1** as input must be set


### LOCAL DEPLOYMENT AND TESTING
Install postgresql via docker:

docker pull postgres

```bin/sh 
docker run -it -p 5432:5432 --name postgres_swift -e POSTGRES_PASSWORD=123456 -d postgres
```

Test it: 
```bin/sh
docker exec -i -t postgres_swift /bin/bash
```

Start it if stopped:
```bin/sh 
docker start postgres_swift
```

Remove it:
```bin/sh 
docker rm -f postgres_swift
```

Create a postgresql.json file containing the credentials to docker machine into **Config/secrets/postgresql.json**

Eg:

{
    "host": "127.0.0.1",
    "user": "postgres",
    "password": "123456",
    "database": "test",
    "port": 5432
}
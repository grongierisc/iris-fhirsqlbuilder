# init the mavens project

# 1. Create a new maven project

```bash
mvn archetype:generate -DgroupId=com.mycompany.app -DartifactId=my-app -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false
```

# 2. Build the project

```bash
cd my-app
mvn package
```

# 3. Run the project

```bash
java -cp target/my-app-1.0-SNAPSHOT.jar com.mycompany.app.App
```

# 4. Clean the project

```bash
mvn clean
```
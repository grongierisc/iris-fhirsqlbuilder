package com.mycompany.app;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

import java.sql.*;
import com.intersystems.jdbc.*;

@SpringBootApplication
public class App {

    @Autowired
    private ConfigDatabaseProperties conf;

    public static void main(String[] args) {
        SpringApplication.run(App.class, args);
    }

    @Bean
    public CommandLineRunner commandLineRunner() {
        return args -> {
            // Get the connection details from the application.properties file
            String url = conf.getUrl();
            String username = conf.getUsername();
            String password = conf.getPassword();

            // Create a connection to the database
            Class.forName("com.intersystems.jdbc.IRISDriver").getDeclaredConstructor().newInstance();
            IRISDataSource ds = new IRISDataSource();
            ds.setURL(url);
            ds.setUser(username);
            ds.setPassword(password);
            Connection connection = ds.getConnection();
            // Create a statement
            Statement stmt = connection.createStatement();
            // Create a result set
            ResultSet rs = stmt.executeQuery("SELECT * FROM AA.Patient");
            // Iterate through the result set
            while (rs.next()) {
                System.out.println(rs.getString("NameFamily"));
            }

            // Close the resources
            rs.close();
            stmt.close();
            connection.close();
        };
    }
}

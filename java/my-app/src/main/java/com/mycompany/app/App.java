package com.mycompany.app;

import java.sql.*;
import com.intersystems.jdbc.*;

/**
 * This a simple Java application
 * that aims to connect to an IRIS database
 * and perform some basic operations.
 */
public class App 
{
    public static void main( String[] args ) throws Exception
    {
        // Create a variable for the connection string
        String url = "jdbc:IRIS://localhost:33782/FHIRSERVER";
        // Create a variable for the username
        String username = "_SYSTEM";
        // Create a variable for the password
        String password = "SYS";
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


    }
}

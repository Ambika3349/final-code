package com.user;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    public static Connection getConnection() {
        Connection con = null;
        try {
            Class.forName("oracle.jdbc.OracleDriver");

            con = DriverManager.getConnection(
                "jdbc:oracle:thin:@localhost:1521/ORCLPDB",
                "system",
                "system"
            );

        } catch (Exception e) {
            e.printStackTrace();
        }
        return con;
    }
}
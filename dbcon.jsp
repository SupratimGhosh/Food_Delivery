<%@ page import="java.sql.*, java.util.Locale" %>
<%
    // Retrieve parameters from the request (URL or form data)
    String host = "food-db-ghoshsupratim7-b879.k.aivencloud.com";
    String port = "23858";
    String databaseName = "defaultdb";
    String userName = "avnadmin";
    String password = "AVNS_iboxmMGlaTPggv0OOAy";

    // Check required fields
    if (host == null || port == null || databaseName == null) {
        out.println("Host, port, and database information are required.");
    } else {
        try {
            // Load MySQL driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Create the connection URL
            String dbUrl = "jdbc:mysql://" + host + ":" + port + "/" + databaseName + "?sslmode=require";

            // Establish the connection
            try (Connection connection = DriverManager.getConnection(dbUrl, userName, password);
                 Statement statement = connection.createStatement();
                 ResultSet resultSet = statement.executeQuery("SELECT menu_item_id FROM MenuItem")) {

                    //all extra codes here
                    // Loop through the result set and display each `menu_item_id`
                    out.println("<h3>Menu Item IDs:</h3>");
                    while (resultSet.next()) {
                        String Id = resultSet.getString("menu_item_id");

                        out.println("Menu Item ID: " + Id + "<br><img src=\"images/"+Id+".jpg\"><br>");
                    }   

                // Display database version
                if (resultSet.next()) {
                    out.println("Connected to Database Version: " + resultSet.getString("version"));
                }
            } catch (SQLException e) {
                out.println("Connection failure. Error: " + e.getMessage());
                
            }
        } catch (ClassNotFoundException e) {
            out.println("MySQL JDBC Driver not found. Please include it in your library path.");
        }
    }
%>

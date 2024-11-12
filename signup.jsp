<%@ page import="java.sql.*, java.util.*" %>
<%
    // Get the form data from request parameters
    String name = request.getParameter("name");
    String phone = request.getParameter("phone");
    String address = request.getParameter("address");
    
    // Check if any field is empty
    if (name != null && phone != null && address != null) {
        try {
            // Database connection details
            String host = "food-db-ghoshsupratim7-b879.k.aivencloud.com";
            String port = "23858";
            String databaseName = "defaultdb";
            String userName = "avnadmin";
            String password = "AVNS_iboxmMGlaTPggv0OOAy";
            
            Class.forName("com.mysql.cj.jdbc.Driver");
            String dbUrl = "jdbc:mysql://" + host + ":" + port + "/" + databaseName + "?sslmode=require";
            Connection conn = DriverManager.getConnection(dbUrl, userName, password);

            // Get the last cust_id value
            String getIdQuery = "SELECT MAX(cust_id) FROM Customer";
            Statement idStmt = conn.createStatement();
            ResultSet rs = idStmt.executeQuery(getIdQuery);

            int newCustId = 1; // Default ID if table is empty
            if (rs.next() && rs.getInt(1) != 0) {
                newCustId = rs.getInt(1) + 1;
            }

            rs.close();
            idStmt.close();

            // Insert data into Customer with new cust_id
            String insertQuery = "INSERT INTO Customer (cust_id, name, number, address, reg_date) VALUES (?, ?, ?, ?, CURRENT_DATE)";
            PreparedStatement stmt = conn.prepareStatement(insertQuery);
            stmt.setInt(1, newCustId);
            stmt.setString(2, name);
            stmt.setString(3, phone);
            stmt.setString(4, address);

            int rowsInserted = stmt.executeUpdate();

            stmt.close();
            conn.close();

            if (rowsInserted > 0) {

                response.sendRedirect("login.html");
            } else {
                out.println("<p>Error: Could not complete sign up. Please try again.</p>");
            }


        } catch (Exception e) {
            e.printStackTrace();
            out.println("<p>Error: " + e.getMessage() + "</p>");
        }
    } else {
        out.println("<p>Error: All fields are required.</p>");
    }
%>

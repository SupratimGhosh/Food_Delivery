<%@ page import="java.sql.*" %>
<%@ page contentType="text/plain; charset=UTF-8" %>

<%
    String phone = request.getParameter("phone");
    boolean exists = false;

    try {
        String host = "food-db-ghoshsupratim7-b879.k.aivencloud.com";
        String port = "23858";
        String databaseName = "defaultdb";
        String userName = "avnadmin";
        String password = "AVNS_iboxmMGlaTPggv0OOAy";
        
        Class.forName("com.mysql.cj.jdbc.Driver");
        String dbUrl = "jdbc:mysql://" + host + ":" + port + "/" + databaseName + "?sslmode=require";
        Connection conn = DriverManager.getConnection(dbUrl, userName, password);

        String query = "SELECT * FROM Customer WHERE number = ?";
        PreparedStatement stmt = conn.prepareStatement(query);
        stmt.setString(1, phone);
        ResultSet rs = stmt.executeQuery();

        
        
        if (rs.next()) {
            //HttpSession session = request.getSession(true);
            session.setAttribute("loggedIn", true);
            exists = true; // Number exists in the database
        }

        query = "SELECT cust_id FROM Customer WHERE number = ?";
        stmt = conn.prepareStatement(query);
        stmt.setString(1, phone);
        rs = stmt.executeQuery();

        int custId = -1; // Initialize with a default value

        if (rs.next()) {
            custId = rs.getInt("cust_id"); // Retrieve cust_id and store in an int variable
        }
        session.setAttribute("CustID", String.valueOf(custId));


        conn.close();
    } catch (Exception e) {
        out.println("<p>"+e.getMessage()+"</p>");
    }
 
    
    

    out.print(exists ? "exists" : "not_exists");
%>

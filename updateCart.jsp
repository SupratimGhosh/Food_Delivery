<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%
    String cartItemId = request.getParameter("cart_item_id");
    String quantityStr = request.getParameter("quantity");
    String custId = (String)session.getAttribute("CustID"); // Placeholder for customer ID from session

    try {
        int quantity = Integer.parseInt(quantityStr);

        // Database connection details
        String host = "food-db-ghoshsupratim7-b879.k.aivencloud.com";
        String port = "23858";
        String databaseName = "defaultdb";
        String userName = "avnadmin";
        String password = "AVNS_iboxmMGlaTPggv0OOAy";
        String dbUrl = "jdbc:mysql://" + host + ":" + port + "/" + databaseName + "?sslmode=require";

        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(dbUrl, userName, password);

        // Update query to modify quantity
        String updateQuery = "UPDATE CartItem SET qty = ? WHERE cart_item_id = ? AND cust_id = ?";
        PreparedStatement stmt = conn.prepareStatement(updateQuery);
        stmt.setInt(1, quantity);
        stmt.setString(2, cartItemId);
        stmt.setString(3, custId);

        int rowsAffected = stmt.executeUpdate();
        if (rowsAffected > 0) {
            out.println("Cart updated successfully.");
        } else {
            out.println("Error updating cart.");
        }

        conn.close();
        response.sendRedirect("cart.jsp");
    } catch (Exception e) {
        e.printStackTrace();
        out.println("Error: " + e.getMessage());
    }
%>

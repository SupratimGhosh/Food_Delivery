<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%
    String cartItemId = request.getParameter("cart_item_id");
    String custId = (String)session.getAttribute("CustID"); // Placeholder for customer ID from session

    try {
        // Database connection details
        String host = "food-db-ghoshsupratim7-b879.k.aivencloud.com";
        String port = "23858";
        String databaseName = "defaultdb";
        String userName = "avnadmin";
        String password = "AVNS_iboxmMGlaTPggv0OOAy";
        String dbUrl = "jdbc:mysql://" + host + ":" + port + "/" + databaseName + "?sslmode=require";

        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(dbUrl, userName, password);

        // Delete query to remove the item from the cart
        String deleteQuery = "DELETE FROM CartItem WHERE cart_item_id = ? AND cust_id = ?";
        PreparedStatement stmt = conn.prepareStatement(deleteQuery);
        stmt.setString(1, cartItemId);
        stmt.setString(2, custId);

        int rowsAffected = stmt.executeUpdate();
        if (rowsAffected > 0) {
            out.println("Item removed from cart.");
        } else {
            out.println("Error removing item from cart.");
        }

        conn.close();
        response.sendRedirect("cart.jsp");
    } catch (Exception e) {
        e.printStackTrace();
        out.println("Error: " + e.getMessage());
    }
%>

<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%
    try {
        // Debugging line to check if the code is running
        out.println("Add to Cart logic is being executed");

        // Retrieving parameters from the request
        String itemId = request.getParameter("menu_item_id");
        String itemName = request.getParameter("item_name");
        String itemPriceStr = request.getParameter("item_price");
        
        if (itemId == null || itemName == null || itemPriceStr == null) {
            out.println("Missing parameters: itemId, itemName, or itemPrice.");
            throw new IllegalArgumentException("Missing parameters.");
        }

        double itemPrice = Double.parseDouble(itemPriceStr);
        String custId = (String) session.getAttribute("CustID"); // Placeholder for session-based customer ID

        if (custId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Database connection details
        String host = "food-db-ghoshsupratim7-b879.k.aivencloud.com";
        String port = "23858";
        String databaseName = "defaultdb";
        String userName = "avnadmin";
        String password = "AVNS_iboxmMGlaTPggv0OOAy";
        String dbUrl = "jdbc:mysql://" + host + ":" + port + "/" + databaseName + "?sslmode=require";

        Class.forName("com.mysql.cj.jdbc.Driver");

        // Establishing database connection
        Connection conn = DriverManager.getConnection(dbUrl, userName, password);
        
        // Check if the item already exists in the cart
        String checkQuery = "SELECT * FROM CartItem WHERE cust_id = ? AND menu_item_id = ?";
        PreparedStatement checkStmt = conn.prepareStatement(checkQuery);
        checkStmt.setString(1, custId);
        checkStmt.setString(2, itemId);
        ResultSet checkRs = checkStmt.executeQuery();

        if (checkRs.next()) {
            // Item exists, update quantity
            int currentQty = checkRs.getInt("qty");
            int newQty = currentQty + 1;
            String updateQuery = "UPDATE CartItem SET qty = ? WHERE cust_id = ? AND menu_item_id = ?";
            PreparedStatement updateStmt = conn.prepareStatement(updateQuery);
            updateStmt.setInt(1, newQty);
            updateStmt.setString(2, custId);
            updateStmt.setString(3, itemId);
            updateStmt.executeUpdate();
            out.println("Item updated in cart: " + itemName); // Debugging line to confirm item update
        } else {
            // Item doesn't exist, insert new record
            String insertQuery = "INSERT INTO CartItem (menu_item_id, cust_id, qty) VALUES (?, ?, ?)";
            PreparedStatement insertStmt = conn.prepareStatement(insertQuery);
            insertStmt.setString(1, itemId);
            insertStmt.setString(2, custId);
            insertStmt.setInt(3, 1); // Set initial quantity to 1
            insertStmt.executeUpdate();
            out.println("Item added to cart: " + itemName); // Debugging line to confirm item addition
        }

        // Commit transaction if necessary
        //conn.commit();
        response.sendRedirect("menu.jsp"); // Redirect back to menu page after successful addition

    } catch (SQLException sqlEx) {
        sqlEx.printStackTrace();
        out.println("Database error: " + sqlEx.getMessage());
        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + sqlEx.getMessage());
    } catch (ClassNotFoundException cnfEx) {
        cnfEx.printStackTrace();
        out.println("JDBC Driver not found: " + cnfEx.getMessage());
        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "JDBC Driver not found.");
    } catch (IllegalArgumentException iaEx) {
        iaEx.printStackTrace();
        out.println("Invalid input: " + iaEx.getMessage());
        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid input: " + iaEx.getMessage());
    } catch (Exception e) {
        e.printStackTrace();
        out.println("Unexpected error: " + e.getMessage());
        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An error occurred while processing the request.");
    }
%>
alert("Added to cart!");
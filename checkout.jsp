<%@ page import="java.sql.*, java.util.*, java.util.List, java.util.ArrayList, java.util.Random, java.text.SimpleDateFormat, javax.servlet.http.*, javax.servlet.*" %>
<%
    // Customer ID placeholder
    String custId = (String) session.getAttribute("CustID"); // Replace with session-based customer ID as needed

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

        // Retrieve and increment order ID
        String lastOrderQuery = "SELECT MAX(order_id) AS max_order_id FROM Orders";
        Statement lastOrderStmt = conn.createStatement();
        ResultSet lastOrderRs = lastOrderStmt.executeQuery(lastOrderQuery);
        int orderId = 1;
        if (lastOrderRs.next()) {
            orderId = lastOrderRs.getInt("max_order_id") + 1;
        }

        // Calculate total amount and fetch cart items
        String cartQuery = "SELECT c.cart_item_id, c.qty, m.menu_item_id, m.name, m.price " +
                           "FROM CartItem c " +
                           "JOIN MenuItem m ON c.menu_item_id = m.menu_item_id " +
                           "WHERE c.cust_id = ?";
        PreparedStatement cartStmt = conn.prepareStatement(cartQuery);
        cartStmt.setString(1, custId);
        ResultSet cartRs = cartStmt.executeQuery();

        double totalAmount = 0.0;
        List<Map<String, Object>> cartItems = new ArrayList<>();

        while (cartRs.next()) {
            int qty = cartRs.getInt("qty");
            double price = cartRs.getDouble("price");
            String itemName = cartRs.getString("name");

            totalAmount += qty * price;

            // Store cart items for OrderItem table
            Map<String, Object> item = new HashMap<>();
            item.put("cart_item_id", cartRs.getInt("cart_item_id"));
            item.put("menu_item_id", cartRs.getString("menu_item_id"));
            item.put("qty", qty);
            item.put("name", itemName);
            item.put("total", qty * price);
            cartItems.add(item);
        }

        // Insert new order into Orders table
        String insertOrderQuery = "INSERT INTO Orders (order_id, cust_id, del_sts, order_date, amt, feedback, rating) VALUES (?, ?, ?, ?, ?, NULL, NULL)";
        PreparedStatement orderStmt = conn.prepareStatement(insertOrderQuery);
        orderStmt.setInt(1, orderId);
        orderStmt.setString(2, custId);
        orderStmt.setInt(3, 0); // Not delivered by default
        orderStmt.setDate(4, new java.sql.Date(System.currentTimeMillis()));
        orderStmt.setDouble(5, totalAmount);
        orderStmt.executeUpdate();

        // Insert items from CartItem to OrderItem
        String insertOrderItemQuery = "INSERT INTO OrderItem (order_item_id, order_id, menu_item_id, qty) VALUES (?, ?, ?, ?)";
        PreparedStatement orderItemStmt = conn.prepareStatement(insertOrderItemQuery);

        for (Map<String, Object> item : cartItems) {
            orderItemStmt.setInt(1, (int) item.get("cart_item_id"));
            orderItemStmt.setInt(2, orderId);
            orderItemStmt.setString(3, (String) item.get("menu_item_id"));
            orderItemStmt.setInt(4, (int) item.get("qty"));
            orderItemStmt.executeUpdate();
        }

        // Clear the CartItem table for the customer
        PreparedStatement clearCartStmt = conn.prepareStatement("DELETE FROM CartItem WHERE cust_id = ?");
        clearCartStmt.setString(1, custId);
        clearCartStmt.executeUpdate();

        // Retrieve delivery status
        String checkStatusQuery = "SELECT del_sts FROM Orders WHERE order_id = ?";
        PreparedStatement checkStatusStmt = conn.prepareStatement(checkStatusQuery);
        checkStatusStmt.setInt(1, orderId);
        ResultSet statusRs = checkStatusStmt.executeQuery();

        String deliveryStatus = "Not Delivered";
        String delStatusClass = "not-delivered";
        if (statusRs.next() && statusRs.getInt("del_sts") == 1) {
            deliveryStatus = "Delivered";
            delStatusClass = "delivered";
        }

        // Display order details
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Order Confirmation</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background: linear-gradient(to bottom right, #ff4d4d, #ffffff);
            color: #333;
        }

        .container {
            max-width: 800px;
            margin: 30px auto;
            padding: 20px;
            background-color: #fff;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
            border: 1px solid #ff4d4d;
        }

        .home-button {
            display: block;
            width: 150px;
            padding: 10px;
            background-color: #ff4d4d;
            color: white;
            text-align: center;
            text-decoration: none;
            font-size: 18px;
            margin: 20px auto;
            border-radius: 5px;
            cursor: pointer;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .home-button:hover {
            background-color: #e60000;
        }

        h1, h2 {
            color: #ff4d4d;
            text-align: center;
        }

        h1 {
            font-size: 24px;
            margin-bottom: 20px;
        }

        h2 {
            font-size: 20px;
            margin-bottom: 10px;
        }

        .order-summary, .order-items, .total-amount {
            padding: 15px;
            border: 1px solid #ddd;
            background-color: #ffffff;
            border-radius: 8px;
            margin-top: 15px;
            box-shadow: 0px 0px 8px rgba(0, 0, 0, 0.1);
        }

        .order-summary p, .order-items p, .total-amount p {
            font-size: 16px;
            margin: 8px 0;
        }

        .total-amount {
            font-size: 1.3em;
            font-weight: bold;
            color: #333;
            text-align: center;
        }

        .delivered {
            color: green;
            font-weight: bold;
        }

        .not-delivered {
            color: red;
            font-weight: bold;
        }

        .button {
            display: inline-block;
            padding: 10px 15px;
            background-color: #ff4d4d;
            color: white;
            border: none;
            border-radius: 5px;
            text-align: center;
            cursor: pointer;
            font-weight: bold;
            transition: background-color 0.3s ease;
        }

        .button:hover {
            background-color: #e60000;
        }
    </style>
</head>
<body>
    <div class="header">
        <a href="index.jsp" class="home-button">Home</a>
        <h1 style="margin-left: 20px;">Order Confirmation</h1>
    </div>
    <div class="container">
        <div class="order-summary">
            <h2>Order ID: <%= orderId %></h2>
            <p>Order Date: <%= new SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %></p>
            <p>Delivery Status: <span class="<%= delStatusClass %>"><%= deliveryStatus %></span></p>
        </div>
        <div class="order-items">
            <h2>Order Items</h2>
            <% for (Map<String, Object> item : cartItems) { %>
                <p>Item: <%= item.get("name") %> | Quantity: <%= item.get("qty") %> | Price: $<%= item.get("total") %></p>
            <% } %>
        </div>
        <div class="total-amount">
            <p>Total Amount: $<%= totalAmount %></p>
        </div>
    </div>
</body>
</html>
<%
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
        out.println("Error: " + e.getMessage());
    }
%>

<%@ page import="java.sql.*, java.util.Random, javax.servlet.http.*, javax.servlet.*,java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order History</title>
    <link rel="stylesheet" href="styles.css">
    <style>
        /* General Styling */
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

        /* Home Button Styling */
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

        /* Order Card Styling */
        .order-card {
            margin-bottom: 20px;
            padding: 20px;
            background-color: #ffffff;
            border: 1px solid #ddd;
            border-radius: 8px;
            box-shadow: 0px 0px 8px rgba(0, 0, 0, 0.1);
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
            margin-top: 30px;
            margin-bottom: 10px;
            text-align: left;
        }

        .order-summary p, .order-items p, .driver-info p {
            font-size: 16px;
            margin: 8px 0;
        }

        .order-summary p strong, .order-items p strong, .driver-info p strong {
            font-weight: bold;
        }

        /* Items List Styling */
        .order-items {
            border-top: 1px solid #ddd;
            padding-top: 10px;
            margin-top: 10px;
        }

        .order-items p {
            padding: 5px 0;
        }

        .order-items p:nth-child(odd) {
            background-color: #f9f9f9;
            padding: 10px;
            border-radius: 5px;
        }

        .order-items p:nth-child(even) {
            background-color: #f1f1f1;
            padding: 10px;
            border-radius: 5px;
        }

        /* Delivery Driver Styling */
        .driver-info {
            border-top: 1px solid #ddd;
            padding-top: 10px;
            margin-top: 10px;
            text-align: center;
        }

        /* Error Message Styling */
        .error-message {
            color: red;
            text-align: center;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Home Button -->
        <a href="index.jsp" class="home-button">Home</a>

        <h1>Order History</h1>

        <%
            String custId = (String) session.getAttribute("CustID"); // Placeholder for customer ID from session
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

                // Query to fetch all orders for the customer
                String orderQuery = "SELECT * FROM Orders WHERE cust_id = ? ORDER BY order_date DESC";
                PreparedStatement orderStmt = conn.prepareStatement(orderQuery);
                orderStmt.setString(1, custId);
                ResultSet orderRs = orderStmt.executeQuery();

                // Display each order in its own card
                if (!orderRs.isBeforeFirst()) {
                    out.println("<p>No orders found.</p>");
                } else {
                    while (orderRs.next()) {
                        String orderId = orderRs.getString("order_id");
                        String orderDate = orderRs.getString("order_date");
                        double totalAmount = orderRs.getDouble("amt");
                        String deliveryStatus = orderRs.getString("del_sts");

                        // Start of order card
                        out.println("<div class='order-card'>");
                        out.println("<h2>Order Summary</h2>");
                        out.println("<div class='order-summary'>");
                        out.println("<p><strong>Order ID:</strong> " + orderId + "</p>");
                        out.println("<p><strong>Order Date:</strong> " + orderDate + "</p>");
                        out.println("<p><strong>Total Amount:</strong> $" + totalAmount + "</p>");
                        out.println("<p><strong>Delivery Status:</strong> " + deliveryStatus + "</p>");
                        out.println("</div>");

                        // Query to fetch order items
                        String itemQuery = "SELECT oi.qty, m.name FROM OrderItem oi " +
                                            "JOIN MenuItem m ON oi.menu_item_id = m.menu_item_id " +
                                            "WHERE oi.order_id = ?";
                        PreparedStatement itemStmt = conn.prepareStatement(itemQuery);
                        itemStmt.setString(1, orderId);
                        ResultSet itemRs = itemStmt.executeQuery();

                        out.println("<h2>Items:</h2>");
                        out.println("<div class='order-items'>");
                        while (itemRs.next()) {
                            String itemName = itemRs.getString("name");
                            int quantity = itemRs.getInt("qty");
                            out.println("<p><strong>Item Name:</strong> " + itemName + ", <strong>Quantity:</strong> " + quantity + "</p>");
                        }
                        out.println("</div>");

                        // Assigning a random delivery driver
                        String driverQuery = "SELECT emp_id, name FROM Employee WHERE role = 'Delivery Driver'";
                        Statement driverStmt = conn.createStatement();
                        ResultSet driverRs = driverStmt.executeQuery(driverQuery);

                        List<String[]> drivers = new ArrayList<>();
                        while (driverRs.next()) {
                            drivers.add(new String[]{driverRs.getString("emp_id"), driverRs.getString("name")});
                        }

                        out.println("<h2>Delivery Driver Assigned:</h2>");
                        if (!drivers.isEmpty()) {
                            Random rand = new Random();
                            String[] driver = drivers.get(rand.nextInt(drivers.size()));
                            String driverId = driver[0];
                            String driverName = driver[1];

                            out.println("<div class='driver-info'>");
                            out.println("<p align=\"left\"><strong>Driver Name:</strong> " + driverName + " (ID: " + driverId + ")</p>");
                            out.println("</div>");
                        } else {
                            out.println("<p class='error-message'>No available drivers at the moment.</p>");
                        }

                        // End of order card
                        out.println("</div>");
                    }
                }

                conn.close();
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<p class='error-message'>Error: " + e.getMessage() + "</p>");
            }
        %>
    </div>
</body>
</html>

<%@ page import="java.sql.*, java.util.*, javax.servlet.http.*, javax.servlet.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Food Menu</title>
    <link rel="stylesheet" href="styles.css">
    <style>

        body {
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
            margin: 0;
            padding: 0;
        }

        /* Header Section */
        header {
            background-color: #ff4c4c;
            padding: 20px;
            color: white;
            text-align: center;
        }

        header .container {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 20px;
        }

        header .logo h1 {
            font-size: 24px;
            margin: 0;
        }

        header .search input[type="text"] {
            padding: 10px;
            font-size: 16px;
            border: none;
            border-radius: 5px;
            width: 250px;
        }

        header .search button {
            background: red;
            border: none;
            color: #333;
            padding: 10px;
            font-size: 16px;
            cursor: pointer;
        }

        header .cart-button a {
            color: white;
            font-size: 18px;
            text-decoration: none;
        }

        header .cart-button a:hover {
            color: #ddd;
        }

        /* Menu Section */
        .menu-items {
            text-align: center;
            padding: 40px;
        }

        .menu-items h2 {
            font-size: 28px;
            color: #333;
            margin-bottom: 20px;
        }

        .menu-grid {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 20px;
        }

        .menu-card {
            width: 250px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            padding: 20px;
            text-align: center;
            transition: transform 0.2s;
        }

        .menu-card:hover {
            transform: scale(1.05);
        }

        .menu-card img {
            width: 100%;
            height: auto;
            border-radius: 8px 8px 0 0;
        }

        .menu-card h3 {
            font-size: 22px;
            color: #333;
            margin: 10px 0;
        }

        .menu-card p {
            font-size: 16px;
            color: #666;
            margin: 5px 0;
        }

        .menu-card form button {
            background-color: #4CAF50;
            color: white;
            padding: 10px;
            border: none;
            cursor: pointer;
            font-size: 16px;
            border-radius: 5px;
            margin-top: 10px;
            transition: background-color 0.2s;
        }

        .menu-card form button:hover {
            background-color: #45a049;
        }

        /* Footer */
        footer {
            background-color: #333;
            color: white;
            text-align: center;
            padding: 10px;
        }

        .logo img {
            width: 150px;
        }

        /* Header Section - Home Button */
        header .home-button, header .cart-button {
            display: inline-block;
            margin-left: 20px;
        }

        header .home-button a, header .cart-button a {
            color: white;
            font-size: 18px;
            text-decoration: none;
        }

        header .home-button a:hover, header .cart-button a:hover {
            color: #ddd;
        }

    </style>
    <!-- Add Font Awesome for cart icon -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
</head>
<body>
    
    <!-- Header Section -->
    <!-- Header Section -->
    <header>
        <div class="container">
            <div class="logo">
                <h1><I><b>FOOD AT YOUR DOOR</b></I></h1>
                <h1>Discover the best food in your city</h1>
            </div>
            <div class="search">
                <form action="menu.jsp" method="GET">
                    <input type="text" name="search" placeholder="Search cuisine or food" value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
                    <button type="submit"><i class="fas fa-search"></i></button>
                </form>
            </div>
            <!-- Home button in the upper right corner -->
            <div class="home-button">
                <a href="index.jsp">
                    <i class="fas fa-home"></i> Home
                </a>
            </div>
            <!-- Cart icon button in the upper right corner -->
            <div class="cart-button">
                <a href="cart.jsp">
                    <i class="fas fa-shopping-cart"></i> Cart
                </a>
            </div>
        </div>
    </header>


    <!-- Menu Items Section -->
    <section class="menu-items">
        <h2>Menu</h2>

        <!-- Dynamically display menu items -->
        <div class="menu-grid">
            <% 
                String searchQuery = request.getParameter("search");
                String query = "SELECT * FROM MenuItem WHERE availability = '1'"; // Default query
                if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                    query = "SELECT * FROM MenuItem WHERE (name LIKE ? OR genre LIKE ?) AND availability = '1'";
                }
                
                try {
                    String host = "food-db-ghoshsupratim7-b879.k.aivencloud.com";
                    String port = "23858";
                    String databaseName = "defaultdb";
                    String userName = "avnadmin";
                    String password = "AVNS_iboxmMGlaTPggv0OOAy";
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    String dbUrl = "jdbc:mysql://" + host + ":" + port + "/" + databaseName + "?sslmode=require";
                    Connection conn = DriverManager.getConnection(dbUrl, userName, password);
                    
                    PreparedStatement stmt = conn.prepareStatement(query);
                    if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                        stmt.setString(1, "%" + searchQuery + "%");
                        stmt.setString(2, "%" + searchQuery + "%");
                    }
                    ResultSet rs = stmt.executeQuery();
                    
                    while (rs.next()) {
                        String itemId = rs.getString("menu_item_id");
                        String name = rs.getString("name");
                        String genre = rs.getString("genre");
                        String desc = rs.getString("description");
                        double price = rs.getDouble("price");
                        String portion = rs.getString("portion_size");
            %>
                <div class="menu-card">
                    <img src="images/<%= itemId %>.jpg" alt="<%= name %>">
                    <h3><%= name %></h3>
                    <p><strong>Genre:</strong> <%= genre %></p>
                    <p><%= desc %></p>
                    <p><strong>Price:</strong> $<%= price %></p>
                    <p><strong>Size:</strong> <%= portion %></p>
                    <form action="addtocart.jsp" method="get">
                        <input type="hidden" name="menu_item_id" value="<%= itemId %>">
                        <input type="hidden" name="item_name" value="<%= name %>">
                        <input type="hidden" name="item_price" value="<%= price %>">
                        <input type="hidden" name="add_to_cart" value="true">
                        <button type="submit">Add to Cart</button>
                    </form>
                </div>
            <% 
                    }
            
                } catch (Exception e) {
                    out.println("Connection failure. Error: " + e.getMessage()); // Prints the error if connection fails
                }
            %>
        </div>
    </section>

    <!-- Footer Section -->
    <footer>
        <p>© 2024 Food Delivery Website</p>
    </footer>

    <script src="script.js"></script>
</body>
</html>

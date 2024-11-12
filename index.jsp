<%@ page import="java.sql.*, java.util.*"%>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Food Delivery Website</title>
    <link rel="stylesheet" href="design.css">
    <style>
        .category-button {
            display: inline-block;
            padding: 10px 20px;
            margin: 5px;
            background-color: #4CAF50; /* Green */
            color: white;
            text-align: center;
            font-size: 16px;
            border: none;
            cursor: pointer;
            border-radius: 5px;
            text-decoration: none;
        }

        .category-button:hover {
            background-color: #45a049;
        }

        /* Navigation Links Styling */
        .nav a {
            margin: 0 10px;
            text-decoration: none;
            color: #333;
            font-weight: bold;
            font-size: 16px;
            transition: color 0.3s;
        }

        .nav a:hover {
            color: #ff5722;
        }

        /* Back Button Styling */
        .back-button {
            padding: 10px 20px;
            background-color: #1a8b3c;
            color: white;
            font-size: 16px;
            font-weight: bold;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            transition: background-color 0.3s;
            margin-bottom: 20px;
            text-decoration: none;
            display: inline-block;
        }

        .back-button:hover {
            background-color: #14632d;
        }

        /* Header Container Flexbox */
        .container {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 20px;
            background-color: #fff;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        /* Logo Styling */
        .logo h1 {
            margin: 0;
            font-size: 24px;
            color: #ff5722;
        }

        .logo h2 {
            margin-top: 5px;
            font-size: 16px;
            color: #555;
        }

        /* Search Container Styling */
        .search {
            position: relative;
            width: 300px;
            margin: 0 auto;
        }

        .search input[type="text"] {
            width: 100%;
            padding: 10px 40px 10px 10px; /* Leave space on the right for icon */
            font-size: 16px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        .search button {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: #333;
            font-size: 16px;
            cursor: pointer;
        }

        .search button:hover {
            color: #ff5722; /* Change color on hover */
        }

        /* Cart Icon Styling */
        .cart-icon {
            color: #333;
            font-size: 18px;
            text-decoration: none;
        }

        .cart-icon:hover {
            color: #ff5722;
        }
    </style>
    <!-- Add Font Awesome for cart icon -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
</head>
<body>
    <!-- Header Section -->
    <header>
        <div class="container">
            <div class="logo">
                <h1><i><b>FOOD AT YOUR DOOR</b></i></h1>
                <h2>Discover the best food in your city</h2>
            </div>
            <!-- Search input with icon positioned inside using inline CSS -->
            <div class="search">
                <form action="menu.jsp" method="GET">
                    <input type="text" name="search" placeholder="Search cuisine or food" 
                        value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
                    <button type="submit">
                        <i class="fas fa-search"></i>
                    </button>
                </form>
            </div>
            <div class="nav">
                <!-- Conditionally display the login and signup links -->
                <% 
                    Boolean loggedIn = (Boolean) session.getAttribute("loggedIn");
                    if (loggedIn == null || !loggedIn) { 
                %>
                    <a href="login.html">Log In</a>
                    <a href="signup.html">Sign Up</a>
                <% 
                    } else { 
                %>
                    <a href="orders.jsp">Orders</a>
                    <a href="logout.jsp">Log Out</a>
                <% 
                    } 
                %>
            </div>
            <div class="nav">
                <a href="cart.jsp" class="cart-icon"><i class="fas fa-shopping-cart"></i> Cart</a>
            </div>
        </div>
    </header>

    <!-- Categories Section -->
    <section class="categories">
        <h2>Popular Categories</h2>
        <div class="category-grid">
            <form action="menu.jsp" method="GET" style="display:inline;">
                <input type="hidden" name="search" value="Pizza">
                <button type="submit" class="category-button">Pizza</button>
            </form>
            
            <form action="menu.jsp" method="GET" style="display:inline;">
                <input type="hidden" name="search" value="Burger">
                <button type="submit" class="category-button">Burgers</button>
            </form>

            <form action="menu.jsp" method="GET" style="display:inline;">
                <input type="hidden" name="search" value="Salad">
                <button type="submit" class="category-button">Salad</button>
            </form>
            <!-- Add more categories as needed -->
        </div>
    </section>

    <!-- Restaurant Grid Section -->
    <section class="restaurants">
        <h2>Best selling items</h2>
        <div class="restaurant-grid">
            <div class="restaurant-card">
                <img src="images/food.jpg" alt="Restaurant">
                <h3>Seafood</h3>
                <p>Continental . Rating:4</p>
            </div>
            <div class="restaurant-card">
                <img src="images/f1.jpg" alt="Restaurant">
                <h3>Pancake</h3>
                <p>Dessert . Rating:3.5</p>
            </div>
            <div class="restaurant-card">
                <img src="images/f2.jpg" alt="Restaurant">
                <h3>Salad</h3>
                <p>Continental . Rating:3</p>
            </div>
            <div class="restaurant-card">
                <img src="images/f4.jpg" alt="Restaurant">
                <h3>Steak</h3>
                <p>Korean . Rating:4.5</p>
            </div>
            <div class="restaurant-card">
                <img src="images/f5.jpg" alt="Restaurant">
                <h3>Pizza</h3>
                <p>Italian . Rating:5</p>
            </div>
            <div class="restaurant-card">
                <img src="images/f6.jpg" alt="Restaurant">
                <h3>Red Sauce Pasta</h3>
                <p>Pasta . Rating:3.5</p>
            </div>
            <div class="restaurant-card">
                <img src="images/f7.jpg" alt="Restaurant">
                <h3>Sushi</h3>
                <p>Japanese . Rating:3</p>
            </div>
            <div class="restaurant-card">
                <img src="images/f8.jpg" alt="Restaurant">
                <h3>Chicken Tikka Masala</h3>
                <p>Indian . Rating:5</p>
            </div>
        </div>
    </section>

    <!-- Footer Section -->
    <footer>
        <p>© 2024 Food Delivery Website</p>
    </footer>

    <script src="script.js"></script>
</body>
</html>

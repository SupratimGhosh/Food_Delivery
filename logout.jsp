<%
    
    if (session != null) {
        session.invalidate();
    }
    response.sendRedirect("index.jsp"); // Redirect to the login page
%>
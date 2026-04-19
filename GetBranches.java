package com.user;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.*;
import java.sql.*;

@WebServlet("/GetBranches")
public class GetBranches extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        res.setContentType("application/json");
        PrintWriter out = res.getWriter();

        String qual = req.getParameter("qual");

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();

            ps = con.prepareStatement(
            	    "SELECT b.BRANCH_NAME " +
            	    "FROM BRANCH b " +
            	    "JOIN QUALIFICATION q ON b.QUAL_ID = q.QUAL_ID " +
            	    "WHERE q.QUAL_NAME = ?"
            	);
            	ps.setString(1, qual);

            rs = ps.executeQuery();

            out.print("[");

            boolean first = true;

            while (rs.next()) {
                if (!first) out.print(",");
                out.print("\"" + rs.getString(1) + "\"");
                first = false;
            }

            out.print("]");

        } catch (Exception e) {
            e.printStackTrace();
            out.print("[]");
        } finally {
            try { if (rs != null) rs.close(); } catch(Exception e){}
            try { if (ps != null) ps.close(); } catch(Exception e){}
            try { if (con != null) con.close(); } catch(Exception e){}
        }
    }
}

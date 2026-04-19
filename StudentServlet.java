package com.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.Collection;

@MultipartConfig
@WebServlet("/StudentServlet")
public class StudentServlet extends HttpServlet {

    // ================= GET =================
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.sendRedirect("StudentForm.jsp");
    }

    // ================= POST =================
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        System.out.println("ACTION: " + action);

        
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        PrintWriter out = response.getWriter();

        try {

            con = DBConnection.getConnection();

            if (con == null) {
                out.println("<h3 style='color:red;'>Database connection failed!</h3>");
                return;
            }

            // ================= DELETE =================
            if ("Delete".equals(action)) {

                long slno = Long.parseLong(request.getParameter("slno"));

                ps = con.prepareStatement("DELETE FROM STUDENT_DETAILS WHERE SLNO=?");
                ps.setLong(1, slno);
                ps.executeUpdate();

                response.sendRedirect("StudentForm.jsp?msg=Deleted");
                return;
            }

            // ================= GET FORM DATA =================
            String perFrom = request.getParameter("perform");
            String perUpto = request.getParameter("perupto");

            // ✅ ADD THESE
            System.out.println("PERFORM: " + perFrom);
            System.out.println("PERUPTO: " + perUpto);

            // ================= DATE VALIDATION =================
            if (perFrom == null || perFrom.isEmpty()) {

            	request.setAttribute("error", "From Date is required");
            	request.setAttribute("formData", request.getParameterMap());
            	request.getRequestDispatcher("StudentForm.jsp").forward(request, response);
                return;
            }

            if (perUpto != null && !perUpto.isEmpty() && perFrom.compareTo(perUpto) > 0) {

                request.setAttribute("error", "From Date cannot be greater than To Date");
                request.getRequestDispatcher("StudentForm.jsp").forward(request, response);
                return;
            }

            String aadhaar = request.getParameter("aadhaar");
            String phone = request.getParameter("phno");
            String pincode = request.getParameter("pincode");

            // Aadhaar validation
            if (aadhaar != null && !aadhaar.matches("\\d{12}")) {

                request.setAttribute("error", "Aadhaar number must be 12 digits");
                request.getRequestDispatcher("StudentForm.jsp").forward(request, response);
                return;
            }

            // Phone validation
            if (phone != null && !phone.matches("\\d{10}")) {

                request.setAttribute("error", "Phone number must be 10 digits");
                request.getRequestDispatcher("StudentForm.jsp").forward(request, response);
                return;
            }

            // Pincode validation
            if (pincode != null && !pincode.matches("\\d{6}")) {

                request.setAttribute("error", "Pincode must be 6 digits");
                request.getRequestDispatcher("StudentForm.jsp").forward(request, response);
                return;
            }

            // ================= SAVE =================
            if ("Save".equals(action)) {

                int columnNo = 1;

                ps = con.prepareStatement("SELECT NVL(MAX(COLUMN_NO),0)+1 FROM STUDENT_DETAILS");
                rs = ps.executeQuery();

                if (rs.next()) {
                    columnNo = rs.getInt(1);
                }

                String sql = "INSERT INTO STUDENT_DETAILS "
                        + "(COLUMN_NO,F_V2PERSNO,F_V2NAME,F_V2QUALF,F_V2BRANCH,F_V2STREET,"
                        + "F_V2DISTRICT,F_V2STATE,PINCODE,F_V2UNIVERSITY,"
                        + "F_V2GUIDE,F_V2SECTION,F_V2DIR,PROJECTNAME,COLLEGE,"
                        + "DOCUMENTATION,F_V2PHNO,F_V2AADHAARNO,PERFROM,PERUPTO)"
                        + " VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";

                ps = con.prepareStatement(sql);

                ps.setInt(1, columnNo);

                setValues(ps, request, perFrom, perUpto, 2);
                
                String finalFiles = request.getParameter("existingDoc");

                System.out.println("==== DEBUG START ====");
                System.out.println("FILES FROM HIDDEN FIELD: " + finalFiles);
                System.out.println("NAME: " + request.getParameter("name"));
                System.out.println("PROJECT: " + request.getParameter("project"));
                System.out.println("==== DEBUG END ====");
                
                ps.executeUpdate();

                response.sendRedirect("StudentForm.jsp?msg=Saved");
            }

            // ================= UPDATE =================
            else if ("Update".equals(action)) {

                long slno = Long.parseLong(request.getParameter("slno"));

                String sql = "UPDATE STUDENT_DETAILS SET "
                        + "F_V2PERSNO=?,F_V2NAME=?,F_V2QUALF=?,F_V2BRANCH=?,"
                        + "F_V2STREET=?,F_V2DISTRICT=?,F_V2STATE=?,PINCODE=?,"
                        + "F_V2UNIVERSITY=?,F_V2GUIDE=?,F_V2SECTION=?,F_V2DIR=?,"
                        + "PROJECTNAME=?,COLLEGE=?,DOCUMENTATION=?,F_V2PHNO=?,"
                        + "F_V2AADHAARNO=?,PERFROM=?,PERUPTO=? "
                        + "WHERE SLNO=?";

                ps = con.prepareStatement(sql);

                setValues(ps, request, perFrom, perUpto, 1);

                ps.setLong(20, slno);

                ps.executeUpdate();

                response.sendRedirect("StudentForm.jsp?msg=Updated");
            }

        } catch (Exception e) {

            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("StudentForm.jsp").forward(request, response);
        }

        finally {

            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (Exception e) {
            }
        }
    }

    // ================= SET VALUES =================
    private void setValues(PreparedStatement ps, HttpServletRequest request,
                           String perFrom, String perUpto, int startIndex) throws Exception {

        ps.setString(startIndex++, request.getParameter("persno"));
        ps.setString(startIndex++, request.getParameter("name"));
        ps.setString(startIndex++, request.getParameter("qualf"));
        ps.setString(startIndex++, request.getParameter("branch"));
        ps.setString(startIndex++, request.getParameter("street"));
        ps.setString(startIndex++, request.getParameter("district"));
        ps.setString(startIndex++, request.getParameter("state"));
        ps.setString(startIndex++, request.getParameter("pincode"));
        ps.setString(startIndex++, request.getParameter("university"));
        ps.setString(startIndex++, request.getParameter("guide"));
        ps.setString(startIndex++, request.getParameter("section"));
        ps.setString(startIndex++, request.getParameter("dir"));
        ps.setString(startIndex++, request.getParameter("project"));
        ps.setString(startIndex++, request.getParameter("college"));

        String finalFiles = request.getParameter("existingDoc");     

     // fallback for update case
     if(finalFiles == null || finalFiles.trim().equals("")){
         finalFiles = request.getParameter("oldDocs");
     }

     System.out.println("FILES RECEIVED: " + finalFiles);

     if(finalFiles == null || finalFiles.trim().equals("")){
    	    finalFiles = "";
    	}
    	ps.setString(startIndex++, finalFiles);
        ps.setString(startIndex++, request.getParameter("phno"));
        ps.setString(startIndex++, request.getParameter("aadhaar"));

        if (perFrom != null && !perFrom.isEmpty())
            ps.setDate(startIndex++, Date.valueOf(perFrom));
        else
            ps.setNull(startIndex++, Types.DATE);

        if (perUpto != null && !perUpto.isEmpty())
            ps.setDate(startIndex++, Date.valueOf(perUpto));
        else
            ps.setNull(startIndex++, Types.DATE);
    }
}
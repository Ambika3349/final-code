package com.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;

@WebServlet("/UploadServlet")
@MultipartConfig
public class UploadServlet extends HttpServlet {

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
	        throws IOException, ServletException {

	    String uploadPath = getServletContext().getRealPath("") 
	                      + File.separator + "uploads";

	    File uploadDir = new File(uploadPath);
	    if(!uploadDir.exists()) uploadDir.mkdirs();

	    PrintWriter out = response.getWriter();

	    for (Part part : request.getParts()) {

	        if (part.getName().equals("file") && part.getSize() > 0) {

	            String fileName = System.currentTimeMillis() + "_" 
	                            + part.getSubmittedFileName();

	            part.write(uploadPath + File.separator + fileName);

	            out.print(fileName);  // return filename
	        }
	    }
	}
}  
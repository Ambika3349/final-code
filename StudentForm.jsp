<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.sql.*,com.user.DBConnection" %>

<%
int pageSize = 15;

if(request.getParameter("size") != null){
    pageSize = Integer.parseInt(request.getParameter("size"));
}

int pageNo = 1;
if(request.getParameter("page") != null){
    pageNo = Integer.parseInt(request.getParameter("page"));
}

int start = (pageNo - 1) * pageSize;

int totalRecords = 0;
int totalPages = 0;
%>

<%
String slno = request.getParameter("slno");
String msg = request.getParameter("msg");
%>

<%  // ✅ ADD THIS BLOCK HERE
String errMsg = (request.getAttribute("error") != null) 
    ? request.getAttribute("error").toString().replace("\"","'")
    : "";
%>

<!DOCTYPE html>
<html>
<head>
<title>Student Monitoring System</title>

<style>
body{ 
    font-family: 'Poppins', 'Segoe UI', Arial, sans-serif;
    background: linear-gradient(135deg,#eef2ff,#e3f2fd);
    margin:0;
    padding:0;
}

.container{
    width: 95%;
    max-width: 1250px;
    margin: 40px auto;
    background: #ffffff;
    padding: 35px;
    border-radius: 15px;
    box-shadow: 0 15px 40px rgba(0,0,0,0.012);
    overflow-x:hidden;
}

h2{
    text-align: center;
    color: #1f3c88;
    margin-bottom: 30px;
    font-weight: 600;
}

fieldset{
    border: none;
    margin-bottom: 40px;
    padding: 35px;
    border-radius: 12px;
    background: #f8faff;
    box-shadow: 0 5px 15px rgba(0,0,0,0.08);
}


legend{
    font-weight:700;
    color:#1f3c88;
    font-size:17px;
    padding:5px 10px;
    border-left:4px solid #3f87ff;
}

.row{
    display:grid;
    grid-template-columns: repeat(3, 1fr);
    gap:30px;
    margin-bottom:25px;
}

.row.two{
    grid-template-columns: repeat(2, 1fr);
}

.field{
    display:flex;
    flex-direction:column;
}

.field input,
.field select{
    width:100%;
    box-sizing:border-box;
}

label{
    font-weight: 600;
    font-size: 14px;
    margin-bottom: 8px;
}

input{
    padding:12px;
    border:1px solid #cfd8dc;
    border-radius:8px;
    font-size:14px;
    transition:all 0.3s ease;
    background:#ffffff;
}

input[type="file"]{
    padding:8px;
    background:#ffffff;
}

input:focus{
    outline: none;
    border-color: #3f87ff;
    box-shadow: 0 0 8px rgba(63,135,255,0.4);
    transform: scale(1.02);
}

select{
    padding:12px;
    border:1px solid #cfd8dc;
    border-radius:8px;
    font-size:14px;
    background:#ffffff;
    transition:all 0.3s ease;
}

select:focus{
    outline:none;
    border-color:#3f87ff;
    box-shadow:0 0 8px rgba(63,135,255,0.4);
    transform:scale(1.02);
}

.buttons{
    text-align: center;
    margin-top: 20px;
}

button{
    padding: 10px 28px;
    margin: 8px;
    border: none;
    border-radius: 30px;
    font-size: 14px;
    cursor: pointer;
    font-weight: 600;
    transition: 0.3s;
}

button:hover{
    transform: translateY(-3px);
    box-shadow: 0 8px 20px rgba(0,0,0,0.2);
}

.save{
    background: linear-gradient(135deg,#00c853,#2e7d32);
    color:white;
    font-size:15px;
    padding:12px 35px;
}
.update{ background: linear-gradient(45deg,#f39c12,#e67e22); color:white; }
.delete{ background: linear-gradient(45deg,#e74c3c,#c0392b); color:white; }
.clear{ background: linear-gradient(45deg,#7f8c8d,#636e72); color:white; }

.table-wrapper{
    width:95%;
    max-width:1400px;
    margin:20px auto;
    box-shadow:0 10px 25px rgba(0,0,0,0.1);
    border-radius:10px;
    overflow-x:auto;   /* ⭐ IMPORTANT */
}

table{
    width:100%;
    border-collapse: collapse;
    table-layout: fixed;   /* ⭐ VERY IMPORTANT */
}

th{
    background: linear-gradient(135deg,#283593,#1a237e);
    color:white;
    padding:12px;
    font-size:15px;
}

td{
    padding:10px;
    border:1px solid #d0d7e2;
    font-size:14px;
    text-align:center;
    
     overflow:hidden;
    text-overflow:ellipsis;
    white-space:nowrap;   /* ⭐ prevents breaking */
}

th:nth-child(1), td:nth-child(1){width:90px;}   /* SLNO */
th:nth-child(2), td:nth-child(2){width:120px;}  /* From */
th:nth-child(3), td:nth-child(3){width:120px;}  /* To */
th:nth-child(4), td:nth-child(4){width:150px;}  /* Name */
th:nth-child(5), td:nth-child(5){width:180px;}  /* Project */
th:nth-child(6), td:nth-child(6){width:150px;}  /* Guide */
th:nth-child(7), td:nth-child(7){width:220px;}  /* College */
th:nth-child(8), td:nth-child(8){width:200px;}  /* Docs */
th:nth-child(9), td:nth-child(9){width:130px;}  /* Phone */
th:nth-child(10), td:nth-child(10){width:150px;}/* Aadhaar */
th:nth-child(11), td:nth-child(11){width:150px;}/* Action */

tr:nth-child(even){
    background:#f5f8fc;
}

tr:hover{
    background:#e3f2fd;
    transition:0.3s;
}

.action-link{
    color:#1f3c88;
    text-decoration: underline;
    cursor:pointer;
    font-weight:600;
}

.delete-text{
    color:#e74c3c;
}
.error{
    color:#e74c3c;
    font-size:12px;
    margin-top:4px;
}

.error-border{
    border:1px solid red !important;
}
.pagination{
    text-align:center;
    margin-top:20px;
}

.pagination a,
.pagination span{
    margin:5px;
    padding:6px 12px;
    border:1px solid #1f3c88;
    border-radius:5px;
    text-decoration:none;
    color:#1f3c88;
    font-size:14px;
}

.pagination a:hover{
    background:#1f3c88;
    color:white;
}

.pagination .active{
    background:#1f3c88;
    color:white;
    font-weight:bold;
}
.file-upload-box{
    display:flex;
    gap:10px;
    align-items:center;
    border:1px solid #ccc;
    padding:10px;
    border-radius:8px;
    background:#fff;
}

.file-upload-box input{
    flex:1;
}

.file-upload-box button{
    background: linear-gradient(135deg,#2f80ed,#1c5ed6);
    color:white;
    border:none;
    padding:8px 20px;
    border-radius:6px;
    cursor:pointer;
    font-weight:600;
}
#fileCountBox{
    display: none;
}
.pagination-container{
    width:95%;
    max-width:1400px;
    margin:20px auto;   /* ✅ center properly */
    display:flex;
    justify-content:space-between;
    align-items:center;
}

.pages a, .pages span,
.page-size a{
    margin:3px;
    padding:6px 12px;
    border-radius:6px;
    border:1px solid #1f3c88;
    text-decoration:none;
    color:#1f3c88;
    font-size:14px;
    transition:0.3s;
}

.pages a:hover,
.page-size a:hover{
    background:#1f3c88;
    color:white;
}

.active{
    background:#1f3c88;
    color:white !important;
    font-weight:bold;
}

.page-size{
    display:flex;
    align-items:center;
    gap:5px;
}

.page-size span{
    font-size:14px;
    color:#333;
}
</style>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
</head>

<body>

<div class="container">

<h2>Student Monitoring Form</h2>


<script>
document.addEventListener("DOMContentLoaded", function(){

    // ✅ Get error safely from JSP
    let error = "<%= errMsg %>";

    if (error !== "") {
        alert(error);

        if (error.includes("Phone")) {
            document.getElementById("phno").focus();
            document.getElementById("phno").select();
        } 
        else if (error.includes("Pincode")) {
            document.getElementById("pincode").focus();
        } 
        else if (error.includes("Aadhaar")) {
            document.getElementById("aadhaar").focus();
        }
    }

    // ✅ Load Qualifications
    fetch("GetQualifications")
    .then(res => res.json())
    .then(data => {
        let qual = document.getElementById("qualf");
        qual.innerHTML = "<option value=''>Select Qualification</option>";

        data.forEach(q => {
            let opt = document.createElement("option");
            opt.value = q;
            opt.text = q;
            qual.appendChild(opt);
        });
    });

    // ✅ Load States  
    fetch("GetStates")
    .then(res => res.json())
    .then(data => {
        let state = document.getElementById("state");
        state.innerHTML = "<option value=''>Select State</option>";

        data.forEach(s => {
            let opt = document.createElement("option");
            opt.value = s;
            opt.text = s;
            state.appendChild(opt);
        });
    });

    // ✅ Qualification → Branch
    document.getElementById("qualf").addEventListener("change", function(){

        let q = this.value;

        fetch("GetBranches?qual=" + q)
        .then(res => res.json())
        .then(data => {

            let branch = document.getElementById("branch");
            branch.innerHTML = "<option value=''>Select Branch</option>";

            data.forEach(b => {
                let opt = document.createElement("option");
                opt.value = b;
                opt.text = b;
                branch.appendChild(opt);
            });

        });

    });

    // ✅ State → District  
    document.getElementById("state").addEventListener("change", function(){

        let s = this.value;

        fetch("GetDistricts?state=" + s)
        .then(res => res.json())
        .then(data => {

            let dist = document.getElementById("district");
            dist.innerHTML = "<option value=''>Select District</option>";

            data.forEach(d => {
                let opt = document.createElement("option");
                opt.value = d;
                opt.text = d;
                dist.appendChild(opt);
            });

        });

    });

});
</script>
<form action="<%=request.getContextPath()%>/StudentServlet" 
      method="post" 
      enctype="multipart/form-data" 
      onsubmit="return validateForm()">

<input type="hidden" name="persno" value="1001">
<input type="hidden" name="slno" value="<%= slno!=null ? slno : "" %>">

<!-- Student Details -->
<fieldset>
<legend>Student Details</legend>

<div class="row">
    <div class="field">
        <label>Name</label>
        <input type="text" id="name" name="name" maxlength="25"
oninput="this.value=this.value.replace(/[^a-zA-Z. ]/g,'')">
        <span class="error" id="nameError"></span>
    </div>
    
    <div class="field">
        <label>Aadhaar No</label>
        <input type="text" id="aadhaar" name="aadhaar" maxlength="12"
oninput="this.value=this.value.replace(/[^0-9]/g,'')">
        <span class="error" id="aadhaarError"></span>
    </div>

    <div class="field">
        <label>Phone No</label>
        <input type="text" id="phno" name="phno" maxlength="10"
oninput="this.value=this.value.replace(/[^0-9]/g,'')">
        <span class="error" id="phnoError"></span>
    </div>
</div>
<div class="row">

    <div class="field">
        <label>Qualification</label>
<select id="qualf" name="qualf">
<option value="">Select Qualification</option>
</select>
        <span class="error" id="qualfError"></span>
    </div>

    <div class="field">
        <label>Branch</label>
<select id="branch" name="branch">
<option value="">Select Branch</option>
</select>
        <span class="error" id="branchError"></span>
    </div>
    
    <div class="field">
        <label>College</label>
        <input type="text" id="college" name="college" maxlength="25"
        oninput="this.value=this.value.replace(/[^a-zA-Z. ]/g,'')">
        <span class="error" id="collegeError"></span>
    </div>
</div>    
<div class="row ">    
    
     <div class="field">
        <label>University</label>
        <input type="text" id="university" name="university" maxlength="25"
        oninput="this.value=this.value.replace(/[^a-zA-Z. ]/g,'')">
        <span class="error" id="universityError"></span>
    </div>
                                                                                                                  
    <div class="field">
        <label>Street</label>
        <input type="text" id="street" name="street" maxlength="25"
        oninput="this.value=this.value.replace(/[^a-zA-Z0-9.- ]/g,'')">
        <span class="error" id="streetError"></span>
    </div>
                                                                                                                  
    <div class="field">
        <label>State</label>
<select id="state" name="state">
<option value="">Select State</option>
</select>
        <span class="error" id="stateError"></span>
    </div>
    
</div> 
   
<div class="row two">
    <div class="field">
        <label>District</label>
<select id="district" name="district">
<option value="">Select District</option>
</select>
        <span class="error" id="districtError"></span>
    </div>       

    <div class="field">
        <label>Pincode</label>
<input type="text" id="pincode" name="pincode" maxlength="6"
oninput="this.value=this.value.replace(/[^0-9]/g,'')">
<span class="error" id="pincodeError"></span>
    </div>

</div>
</fieldset>

<!-- Guide Details -->
<fieldset>
<legend>Guide Details</legend>

<div class="row">
    <div class="field">
        <label>Guide Name</label>
        <input type="text" id="guide" name="guide" maxlength="25"
        oninput="this.value=this.value.replace(/[^a-zA-Z. ]/g,'')">
        <span class="error" id="guideError"></span>
    </div>
    <div class="field">
        <label>Section</label>
        <input type="text" id="section" name="section" maxlength="20"
        oninput="this.value=this.value.replace(/[^a-zA-Z. ]/g,'')">
        <span class="error" id="sectionError"></span>
    </div>
    <div class="field">
        <label>Directorate</label>
        <input type="text" id="dir" name="dir" maxlength="20"
        oninput="this.value=this.value.replace(/[^a-zA-Z. ]/g,'')">
        <span class="error" id="dirError"></span>
    </div>
</div>
</fieldset>

<!-- Project Details -->
<fieldset>
<legend>Project Details</legend>

<div class="row two">
    <div class="field">
        <label>Project Name</label>
        <input type="text" id="project" name="project" maxlength="25"
        oninput="this.value=this.value.replace(/[^a-zA-Z. ]/g,'')">
        <span class="error" id="projectError"></span>
    </div>
   <div class="field">
    <label>Documentation</label>

    <div class="file-upload-box">

        <div style="display:flex; align-items:center; gap:10px; width:100%;">
    
    <input type="file" id="doc" name="doc" multiple style="flex:1;">

    <span id="fileCountBox">0 files</span>

</div>

        <button type="button" onclick="uploadFile()">Upload</button>

    </div>

    <!-- Uploaded files list -->
    <div id="uploadedFiles"></div>

    <!-- Hidden field to store all filenames -->
    <input type="hidden" id="existingDoc" name="existingDoc">

    <span class="error" id="docError"></span>
</div>
</div>

<div class="row two">
    <div class="field">
        <label>From Date</label>
        <input type="date" id="perform" name="perform"
        value="<%= request.getParameter("perform") != null ? request.getParameter("perform") : "" %>">
        <span class="error" id="performError"></span>
    </div>
    <div class="field">
        <label>To Date</label>
        <input type="date" id="perupto" name="perupto"
        value="<%= request.getParameter("perupto") != null ? request.getParameter("perupto") : "" %>">
        <span class="error" id="peruptoError"></span>
    </div>
</div>

</fieldset>

<div class="buttons">

<button id="saveBtn" class="save" type="submit" name="action" value="Save"
<%= (slno != null && !slno.equals("")) ? "style='display:none'" : "" %>>
Save
</button>

<button id="updateBtn" class="update" type="submit" name="action" value="Update"
<%= (slno != null && !slno.equals("")) ? "" : "style='display:none'" %>>
Update
</button>

<button id="deleteBtn" class="delete" type="submit" name="action" value="Delete" style="display:none">
Delete
</button>

<button id="cancelBtn" class="clear" type="button"
<%= (slno != null && !slno.equals("")) ? "" : "style='display:none'" %>
onclick="cancelEdit()">
Cancel
</button>

</div>

</form>

<h2>List of Student Records</h2>

<div class="table-wrapper">
<table>
<tr>
    <th>SLNO</th>
    <th>From Date</th>
    <th>To Date</th>
    <th>Name</th>
    <th>Project Name</th>
    <th>Guide</th>
    <th>College</th>
    <th>Documentation</th>
    <th>Phone No</th>
    <th>Aadhaar No</th>
    <th>Action</th>
</tr>

<%
Connection con = null;
PreparedStatement ps = null;
PreparedStatement countPs = null;
ResultSet rs = null;
ResultSet countRs = null;

try{
    con = DBConnection.getConnection();

    // ✅ Get total records FIRST
    countPs = con.prepareStatement("SELECT COUNT(*) FROM STUDENT_DETAILS");
    countRs = countPs.executeQuery();
    if(countRs.next()){
        totalRecords = countRs.getInt(1);
    }
    totalPages = (int)Math.ceil((double)totalRecords / pageSize);

    // ✅ Then fetch paginated data
    ps = con.prepareStatement(
        "SELECT * FROM STUDENT_DETAILS ORDER BY SLNO OFFSET ? ROWS FETCH NEXT ? ROWS ONLY"
    );
    ps.setInt(1, start);
    ps.setInt(2, pageSize);

    rs = ps.executeQuery();

    while(rs.next()){
%>
<tr>
    <td><%=rs.getLong("SLNO")%></td>
    <td><%=rs.getDate("PERFROM")%></td>
    <td><%=rs.getDate("PERUPTO")%></td>
    <td><%=rs.getString("F_V2NAME")%></td>
    <td><%=rs.getString("PROJECTNAME")%></td>
    <td><%=rs.getString("F_V2GUIDE")%></td>
    <td><%=rs.getString("COLLEGE")%></td>
    <td>
<%
String docs = rs.getString("DOCUMENTATION");

if(docs != null && !docs.isEmpty()){

String[] files = docs.split(",");

for(String file : files){

file = file.trim();   
%>

<%
String displayName = file.replaceFirst("^\\d+_", "");
%>

<a href="uploads/<%=file%>" target="_blank"><%=displayName%></a><br>

<%
}
}
%>
</td>
    <td><%=rs.getString("F_V2PHNO")%></td>
    <td><%=rs.getString("F_V2AADHAARNO")%></td>
<td>
<span class="action-link"
onclick="editRecord(
'<%=rs.getLong("SLNO")%>',
'<%=rs.getString("F_V2NAME")!=null?rs.getString("F_V2NAME").replace("'","\\'"):""%>',
'<%=rs.getString("F_V2QUALF")!=null?rs.getString("F_V2QUALF").replace("'","\\'"):""%>',
'<%=rs.getString("F_V2BRANCH")!=null?rs.getString("F_V2BRANCH").replace("'","\\'"):""%>',
'<%=rs.getString("F_V2STREET")!=null?rs.getString("F_V2STREET").replace("'","\\'"):""%>',
'<%=rs.getString("F_V2DISTRICT")!=null?rs.getString("F_V2DISTRICT").replace("'","\\'"):""%>',
'<%=rs.getString("F_V2STATE")!=null?rs.getString("F_V2STATE").replace("'","\\'"):""%>',
'<%=rs.getString("PINCODE")%>',
'<%=rs.getString("F_V2UNIVERSITY")!=null?rs.getString("F_V2UNIVERSITY").replace("'","\\'"):""%>',
'<%=rs.getString("F_V2GUIDE")!=null?rs.getString("F_V2GUIDE").replace("'","\\'"):""%>',
'<%=rs.getString("F_V2SECTION")!=null?rs.getString("F_V2SECTION").replace("'","\\'"):""%>',
'<%=rs.getString("F_V2DIR")!=null?rs.getString("F_V2DIR").replace("'","\\'"):""%>',
'<%=rs.getString("PROJECTNAME")!=null?rs.getString("PROJECTNAME").replace("'","\\'"):""%>',
'<%=rs.getString("COLLEGE")!=null?rs.getString("COLLEGE").replace("'","\\'"):""%>',
'<%=rs.getString("DOCUMENTATION")!=null?rs.getString("DOCUMENTATION").replace("'","\\'"):""%>',
'<%=rs.getString("F_V2PHNO")%>',
'<%=rs.getString("F_V2AADHAARNO")%>',
'<%=rs.getDate("PERFROM")!=null?rs.getDate("PERFROM").toString():""%>',
'<%=rs.getDate("PERUPTO")!=null?rs.getDate("PERUPTO").toString():""%>'
)">
Update
</span>
/
<span class="action-link delete-text"
onclick="deleteRecord('<%=rs.getLong("SLNO")%>')">
Delete
</span>
</td>

</tr>
<%} %>

<%
}catch(Exception e){
    out.println(e);
}finally{
    try{
        if(rs!=null) rs.close();
        if(ps!=null) ps.close();
        if(countRs!=null) countRs.close();
        if(countPs!=null) countPs.close();
        if(con!=null) con.close();
    }catch(Exception e){}
}
%>

</table>

</div>

<div class="pagination-container">

    <!-- LEFT SIDE (Pages) -->
    <div class="pages">

        <% if(pageNo > 1){ %>
            <a href="?page=<%=pageNo-1%>&size=<%=pageSize%>">Prev</a>
        <% } %>

        <% for(int i=1; i<=totalPages; i++){ 
            if(i <= 5 || i == pageNo){ %>

            <% if(i == pageNo){ %>
                <span class="active"><%=i%></span>
            <% } else { %>
                <a href="?page=<%=i%>&size=<%=pageSize%>"><%=i%></a>
            <% } %>

        <% } } %>

        <% if(pageNo < totalPages){ %>
            <a href="?page=<%=pageNo+1%>&size=<%=pageSize%>">Next</a>
        <% } %>

    </div>

    <!-- RIGHT SIDE (Page Size) -->
    <div class="page-size">
        <span>per page</span>

        <a href="?page=1&size=15" class="<%=pageSize==15?"active":""%>">15</a>
        <a href="?page=1&size=30" class="<%=pageSize==30?"active":""%>">30</a>
        <a href="?page=1&size=50" class="<%=pageSize==50?"active":""%>">50</a>
    </div>

</div>

</div>

<script>
let isDeleteAction = false;
</script>

<script>

function editRecord(
		slno,name,qualf,branch,street,district,state,pincode,university,
		guide,section,dir,project,college,doc,phone,aadhar,fromDate,toDate){

		document.getElementsByName("slno")[0].value=slno;
		document.getElementsByName("name")[0].value=name || "";
		document.getElementsByName("qualf")[0].value = qualf || "";

		// trigger qualification change to load branches
		document.getElementById("qualf").dispatchEvent(new Event("change"));

		setTimeout(function(){
		    document.getElementById("branch").value = branch;
		},200);
		document.getElementsByName("street")[0].value=street || "";
		document.getElementById("state").value = state;

		document.getElementById("state").dispatchEvent(new Event("change"));

		setTimeout(function(){
		    document.getElementById("district").value = district;
		},200);
		document.getElementsByName("pincode")[0].value=pincode || "";
		document.getElementsByName("university")[0].value=university || "";
		document.getElementsByName("guide")[0].value=guide || "";
		document.getElementsByName("section")[0].value=section || "";
		document.getElementsByName("dir")[0].value=dir || "";
		document.getElementsByName("project")[0].value=project || "";
		document.getElementsByName("college")[0].value=college || "";
		document.getElementById("existingDoc").value = doc || "";
		
		let hidden = document.getElementById("existingDoc");

		let count = hidden.value ? hidden.value.split(",").length : 0;

		document.getElementById("fileCountBox").innerText =
		    count + " file" + (count > 1 ? "s" : "");

		let fileContainer = document.getElementById("uploadedFiles");

		fileContainer.innerHTML = "";

		if(doc){

		let files = doc.split(",");

		files.forEach(function(file){

			file = file.trim();   // ⭐ ADD THIS

		let link = document.createElement("a");

		link.href = "uploads/" + file;
		let displayName = file.replace(/^\d+_/, "");
		link.innerText = displayName;
		link.target = "_blank";

		let div = document.createElement("div");

		div.innerHTML =
			"<a href='uploads/" + file + "' target='_blank'>" + file.replace(/^\d+_/, "") + "</a>" +
		    "<button type='button' onclick=\"removeExistingFile('" + file + "',this)\">Remove</button>";

		fileContainer.appendChild(div);

		});

		}
		document.getElementsByName("phno")[0].value=phone || "";
		document.getElementsByName("aadhaar")[0].value=aadhar || "";
		
		if(fromDate) 
		    document.getElementsByName("perform")[0].value = fromDate.substring(0,10);

		if(toDate) 
		    document.getElementsByName("perupto")[0].value = toDate.substring(0,10);
		
		document.getElementById("saveBtn").style.display="none";
		document.getElementById("updateBtn").style.display="inline-block";
		document.getElementById("deleteBtn").style.display="none";//hide delete always
		document.getElementById("cancelBtn").style.display="inline-block";

		// ✅ CLEAR ALL ERRORS AFTER FILLING DATA
		document.querySelectorAll(".error").forEach(function(el){
		    el.innerText = "";
		});

		document.querySelectorAll("input, select").forEach(function(el){
		    el.classList.remove("error-border");
		});
		
		window.scrollTo({top:0,behavior:'smooth'});
		}

function cancelEdit(){

    let form = document.querySelector("form");

    // Reset basic inputs
    form.reset();

    // Clear hidden SLNO
    document.getElementsByName("slno")[0].value = "";

    // Clear dropdowns manually
    document.getElementById("branch").innerHTML = "<option value=''>Select Branch</option>";
    document.getElementById("district").innerHTML = "<option value=''>Select District</option>";

    // Clear existing uploaded files preview
    document.getElementById("uploadedFiles").innerHTML = "";

    // Clear hidden document field
    document.getElementById("existingDoc").value = "";

    // Clear date fields explicitly (important)
    document.getElementById("perform").value = "";
    document.getElementById("perupto").value = "";

    // Remove validation errors
    document.querySelectorAll(".error").forEach(e => e.innerText = "");
    document.querySelectorAll("input,select").forEach(e => e.classList.remove("error-border"));

    // Button visibility reset
    document.getElementById("saveBtn").style.display = "inline-block";
    document.getElementById("updateBtn").style.display = "none";
    document.getElementById("deleteBtn").style.display = "none";
    document.getElementById("cancelBtn").style.display = "none";

}

function deleteRecord(slno){

    if(confirm("Delete this record?")){

        isDeleteAction = true;   // mark delete action

        document.getElementsByName("slno")[0].value = slno;

        let form = document.querySelector("form");

        let actionInput = document.createElement("input");
        actionInput.type = "hidden";
        actionInput.name = "action";
        actionInput.value = "Delete";

        form.appendChild(actionInput);

        form.submit();
    }

}
</script>
<script>
let isUploading = false;
function validateForm(){
 
	isUploading = true;
	
	// skip validation during delete
	if(isDeleteAction){
		isDeleteAction = false;
	    return true;
	}

    let valid = true;

    function setError(id,message){
        document.getElementById(id+"Error").innerText = message;
        document.getElementById(id).classList.add("error-border");
        valid = false;
    }

    function clearErrors(){
        let errors = document.querySelectorAll(".error");
        errors.forEach(e => e.innerText="");

        let inputs = document.querySelectorAll("input,select");
        inputs.forEach(i => i.classList.remove("error-border"));
    }

    clearErrors();

    let fields = [
    	"name","aadhaar","phno",
    	"qualf","branch","college","university",
    	"street","state","district",
    	"pincode","guide","section","dir",
    	"project","perform"
    	];
    
    
    // Aadhaar validation
    let aadhaar = document.getElementById("aadhaar").value;
    if(aadhaar.length != 12){
        setError("aadhaar","Aadhaar must be 12 digits");
    }
    
    // Phone validation
    let ph = document.getElementById("phno").value;
    if(ph.length != 10){
        setError("phno","Phone number must be 10 digits");
    }

    // Pincode validation
    let pin = document.getElementById("pincode").value;
    if(pin.length != 6){
        setError("pincode","Pincode must be 6 digits");
    }

    for(let i=0;i<fields.length;i++){
        let field = document.getElementById(fields[i]);
        let value = field.value;

        if(value===""){
            let fieldNames = {
                name:"Name",
                qualf:"Qualification",
                branch:"Branch",
                street:"Street",
                district:"District",
                state:"State",
                pincode:"Pincode",
                university:"University",
                guide:"Guide Name",
                section:"Section",
                dir:"Directorate",
                project:"Project Name",
                college:"College",
                phno:"Phone No",
                aadhaar:"Aadhaar No",
                perform:"From Date"
            };

            setError(fields[i], fieldNames[fields[i]] + " is required");
        }
    }
    
    let docs = document.getElementById("existingDoc").value;

    if(docs === ""){
        setError("doc","Please upload at least one file");
        valid = false;
    }
    let fromDate = document.getElementById("perform").value;
    let toDate = document.getElementById("perupto").value;

    if(toDate !== "" && fromDate > toDate){
        alert("To Date must be greater than From Date");
        document.getElementById("perupto").focus();
        return false;
    }

    return valid;
}
</script>
<script>
let fields = [
	"name","aadhaar","phno",
	"qualf","branch","college","university",
	"street","state","district",
	"pincode","guide","section","dir",
	"project","perform"
	];

let fieldNames = {
name:"Name",
qualf:"Qualification",
branch:"Branch",
street:"Street",
district:"District",
state:"State",
pincode:"Pincode",
university:"University",
guide:"Guide Name",
section:"Section",
dir:"Directorate",
project:"Project Name",
college:"College",
doc:"Documentation",
phno:"Phone No",
aadhaar:"Aadhaar No",
perform:"From Date",
perupto:"To Date"
};

fields.forEach((id,index)=>{

    let field = document.getElementById(id);
    
    if(!field) return;
    
    field.addEventListener("focus",function(){

        if(index > 0){

            let prevFieldId = fields[index-1];
            let prevField = document.getElementById(prevFieldId);

            let value = prevField.value.trim();

         // ✅ special case for documentation
         if(prevFieldId === "existingDoc"){
             value = document.getElementById("existingDoc").value.trim();
         }

         if(value === ""){

                document.getElementById(prevFieldId+"Error").innerText =
                fieldNames[prevFieldId] + " is required";

                prevField.focus();
            }
        }

    });

});
</script>
<script>

document.querySelectorAll("input,select").forEach(function(input){

    input.addEventListener("input", function(){

        let error = document.getElementById(this.id + "Error");

        if(error){
            error.innerText = "";
        }

        this.classList.remove("error-border");

    });

});

</script>
<script>

document.addEventListener("DOMContentLoaded", function(){

    document.querySelectorAll("select").forEach(function(select){

        select.addEventListener("change", function(){

            let error = document.getElementById(this.id + "Error");

            if(error){
                error.innerText = "";
            }

            this.classList.remove("error-border");

        });

    });

});

</script>


<% if(msg != null){ %>
<script>
window.onload = function(){

<% if("Saved".equals(msg)){ %>
alert("Record Saved Successfully");
<% } else if("Updated".equals(msg)){ %>
alert("Record Updated Successfully");
<% } else if("Deleted".equals(msg)){ %>
alert("Record Deleted Successfully");
<% } %>

}
</script>
<% } %>

<script>

function uploadFile(){

    let fileInput = document.getElementById("doc");
    let files = fileInput.files;

    if(files.length === 0){
        alert("Please select file(s)");
        return;
    }

    let hidden = document.getElementById("existingDoc");
    let container = document.getElementById("uploadedFiles");

    let uploadPromises = [];

    for(let i=0; i<files.length; i++){

        let formData = new FormData();
        formData.append("file", files[i]);

        let promise = fetch("UploadServlet", {
            method: "POST",
            body: formData
        })
        .then(res => res.text())
        .then(filename => {

            filename = filename.trim();

            let div = document.createElement("div");
            div.innerHTML =
            	"📄 " + filename.replace(/^\d+_/, "") +
                " <button type='button' onclick=\"removeNewFile('" + filename + "', this)\">Remove</button>";

            container.appendChild(div);

            if(hidden.value === ""){
                hidden.value = filename;
            } else {
                hidden.value += "," + filename;
            }

        });

        uploadPromises.push(promise);
    }

    Promise.all(uploadPromises)
    .then(() => {

        let count = hidden.value.split(",").filter(f => f.trim() !== "").length;

        document.getElementById("fileCountBox").innerText =
            count + " file" + (count > 1 ? "s" : "");

        fileInput.value = "";
        
        document.getElementById("docError").innerText = "";
        document.getElementById("doc").classList.remove("error-border");
    })
    .catch(error => {
        console.log("Upload error:", error);
    });

}


/* ✅ PASTE HERE (just below uploadFile) */

function removeNewFile(fileName, btn){

    // remove from UI
    btn.parentElement.remove();

    // update hidden field
    let hidden = document.getElementById("existingDoc").value.split(",");

    hidden = hidden.filter(f => f.trim() !== fileName);

    document.getElementById("existingDoc").value = hidden.join(",");

    // update count
    let count = hidden.filter(f => f !== "").length;

    document.getElementById("fileCountBox").innerText =
        count + " file" + (count > 1 ? "s" : "");
}

</script>
<script>
let removedExistingFiles = [];

function removeExistingFile(fileName, btn){

    if(btn && btn.parentElement){
        btn.parentElement.remove();
    }

    let hidden = document.getElementById("existingDoc").value.split(",");

    hidden = hidden.filter(f => f.trim() !== fileName);

    document.getElementById("existingDoc").value = hidden.join(",");

    let count = hidden.filter(f => f !== "").length;

    document.getElementById("fileCountBox").innerText =
        count + " file" + (count > 1 ? "s" : "");
}
</script>
</body>
</html>
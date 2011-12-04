<%--
 % Copyright 2011 - Kementerian Pendidikan Nasional - Dit.PSMP
 %
 % Author(s):
 % + x10c-Lab
 %   - agus sugianto (agus.delonge@gmail.com)
--%>

<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.Properties" %>
<%@ page import = "java.io.FileInputStream" %>
<%@ page import = "java.io.File" %>
<%
try{
	Connection	db_con	= (Connection) session.getAttribute("db.con");
	if (db_con == null || (db_con != null && db_con.isClosed())) {
		response.sendRedirect(request.getContextPath());
		return;
	}

	Statement	db_stmt = db_con.createStatement();

	String dml 			= request.getParameter("dml_type");
	String id_user		= request.getParameter("id_user");
	String password		= request.getParameter("password");
	String status_user	= request.getParameter("status_user");
	String q;

	if (dml.equals("2")) {
		q	="  insert into __user"
			+"  values("
			+"  '"+ id_user + "'"
			+", '"+ password + "'"
			+", '"+ status_user +"')";
	} else if (dml.equals("3")) {
		q	=" update	__user"
			+" set		password	= '"+ password + "'"
			+" ,		status_user	= '"+ status_user + "'"
			+" where	id_user		= '"+ id_user + "'";
	} else if (dml.equals("update_stat")) {
		q	=" update	__user"
			+" set		status_user	= '"+ status_user +"'"
			+" where 	id_user		= '"+ id_user +"'";

			dml = "3";
	} else if (dml.equals("4")) {
		q 	= " delete	from __user"
			+ " where	id_user	= '"+ id_user + "'";
	} else {
		out.print("{success:false,info:'DML tipe tidak diketahui ("+dml+")!'}");
		return;
	}

	db_stmt.executeUpdate(q);
	
	q	="insert into __log (tanggal, id_user, nama_menu, status_akses) values (now(), '"
		+ session.getAttribute("user.id") +"','"
		+ session.getAttribute("menu.id") +"','"+ dml +"')";

	db_stmt.executeUpdate(q);

	out.print("{success:true,info:'Data telah tersimpan.'}");
} catch (SQLException e){
	Properties	props	= new Properties();
	
	props.load(new FileInputStream(application.getRealPath("WEB-INF"+File.separator+"error.properties")));
	
	String		err_msg = props.getProperty("" + e.getErrorCode() + "");
	
	if (err_msg == null){
		out.print("{success:false,info:'" + e.getErrorCode() + " = Kesalahan operasi, silahkan hubungi pihak pengembang.'}");
	} else {
		out.print("{success:false,info:'" + e.getErrorCode() + " = " + err_msg + "'}");
	}
}
%>

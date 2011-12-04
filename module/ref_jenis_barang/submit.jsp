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

	int dml 					= Integer.parseInt(request.getParameter("dml_type"));
	String id_jenis_barang		= request.getParameter("id_jenis_barang");
	String nama_jenis_barang	= request.getParameter("nama_jenis_barang");
	String q;

	switch (dml) {
	case 2:
		q	=" insert into r_jenis_barang (nama_jenis_barang)"
			+" values ('"+ nama_jenis_barang +"')";
		break;
	case 3:
		q	=" update	r_jenis_barang"
			+" set		nama_jenis_barang	= '"+ nama_jenis_barang +"'"
			+" where	id_jenis_barang		= "+ id_jenis_barang;
		break;
	case 4:
		q = " delete from r_jenis_barang where id_jenis_barang = "+ id_jenis_barang;
		break;
	default:
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
		out.print("{success:false,info:'" + e.getErrorCode() + " = Kesalahan operasi, silahkan hubungi direktorat.'}");
	} else {
		out.print("{success:false,info:'" + e.getErrorCode() + " = " + err_msg + "'}");
	}
}
%>

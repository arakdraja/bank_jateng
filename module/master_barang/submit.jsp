<%--
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
	String kode_barang			= request.getParameter("kode_barang");
	String id_jenis_barang		= request.getParameter("id_jenis_barang");
	String nama_barang			= request.getParameter("nama_barang");
	String jumlah_total			= request.getParameter("jumlah_total");
	String stok_minimal			= request.getParameter("stok_minimal");
	String keterangan			= request.getParameter("keterangan");
	String q;

	switch (dml) {
	case 2:
		q	=" insert into m_barang (kode_barang, id_jenis_barang, nama_barang, jumlah_total, stok_minimal, keterangan)"
			+" values ('"+ kode_barang +"', "+ id_jenis_barang +", '"+ nama_barang +"', "+ jumlah_total +", "+ stok_minimal +", '" + keterangan +"')";
		break;
	case 3:
		q	=" update	m_barang"
			+" set		id_jenis_barang		=  "+ id_jenis_barang
			+" ,		nama_barang			= '"+ nama_barang +"'"
			+" ,		jumlah_total		=  "+ jumlah_total
			+" ,		stok_minimal		=  "+ stok_minimal
			+" ,		keterangan			= '"+ keterangan +"'"
			+" where	kode_barang			= '"+ kode_barang + "'";
		break;
	case 4:
		q = " delete from m_barang where kode_barang = '"+ kode_barang + "'";
		break;
	default:
		out.print("{success:false,info:'DML tipe tidak diketahui ("+dml+")!'}");
		return;
	}

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

<%--
 %
 % Author(s):
 % + x10c-Lab
 %   - agus sugianto (agus.delonge@gmail.com)
--%>

<%@ page import="java.sql.*" %>
<%
try{
	Connection	db_con	= (Connection) session.getAttribute("db.con");
	if (db_con == null || (db_con != null && db_con.isClosed())) {
		response.sendRedirect(request.getContextPath());
		return;
	}

	Statement	db_stmt = db_con.createStatement();

	String q=" select	kode_barang"
			+" ,		id_jenis_barang"
			+" ,		nama_barang"
			+" ,		jumlah_total"
			+" ,		stok_minimal"
			+" ,		keterangan"
			+" from		m_barang"
			+" order by	kode_barang";
	
	ResultSet	rs	= db_stmt.executeQuery(q);
	int		i	= 0;
	String		data	= "[";

	while (rs.next()){
		if (i > 0) {
			data += ",";
		} else {
			i++;
		}
		data 	+="['"+ rs.getString("kode_barang") + "'"
				+ ","+ rs.getString("id_jenis_barang")
				+ ",\""+ rs.getString("nama_barang") +"\""
				+ ","+ rs.getString("jumlah_total")
				+ ","+ rs.getString("stok_minimal")
				+ ",\""+ rs.getString("keterangan") +"\""
				+ "]";
	}	
	data += "]";
	
	out.print(data);
}catch (Exception e){
	out.print("{success:false,info:'"+ e.toString().replace("'","\\'") +"'}");
}
%>

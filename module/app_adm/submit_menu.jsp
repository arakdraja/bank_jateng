<%--
 % Copyright 2011 - PT. Perusahaan Gas Negara Tbk.
 %
 % Author(s):
 % + PT. Awakami
 %   - m.shulhan (ms@kilabit.org)
--%>

<%@ page import="java.sql.*" %>
<%
try {
	Connection db_con = (Connection) session.getAttribute("db.con");
	if (db_con == null || (db_con != null && db_con.isClosed())) {
		response.sendRedirect(request.getContextPath());
		return;
	}

	Statement	db_stmt = db_con.createStatement();

	int dml = 3;
	String id_grup		= request.getParameter("id_grup");
	String menu_id		= request.getParameter("menu_id");
	String ha_level		= request.getParameter("ha_level");
	String ha_level_org	= request.getParameter("ha_level_org");
	String q;
	String data = "";

	q	=" select	ha_id"
		+" from		__hak_akses"
		+" where	id_grup	= "+ id_grup
		+" and		menu_id	='"+ menu_id +"'";
	
	ResultSet	rs	= db_stmt.executeQuery(q);
	
	while (rs.next()){
		data = "'" + rs.getString("ha_id") + "'";
	}
	
	if (data.equals("")) {
		q	=" insert into	__hak_akses (id_grup, menu_id, ha_level)"
			+" values ("+ id_grup +",'"+ menu_id +"',"+ ha_level +")";
	} else {
		q	=" update	__hak_akses"
			+" set		ha_level	= " + ha_level
			+" where	id_grup		= " + id_grup
			+" and		menu_id		= '" + menu_id + "'";
	}

	db_stmt.executeUpdate(q);

	q	="insert into __log (tanggal, id_user, nama_menu, status_akses) values (now(), '"
		+ session.getAttribute("user.id") +"','"
		+ session.getAttribute("menu.id") +"','"+ dml +"')";

	db_stmt.executeUpdate(q);

	out.print("{success:true,info:'Data telah tersimpan.'}");
} catch (Exception e) {
	out.print("{success:false,info:'"+ e.toString().replace("'","\\'") +"'}");
}
%>

<%--
 %
 % Author(s):
 % + x10c-Lab
 %   - agus sugianto (agus.delonge@gmail.com)
--%>

<%@ page import="java.sql.*" %>
<%
String q = "";
try {
	Connection db_con = (Connection) session.getAttribute("db.con");
	if (db_con == null || (db_con != null && db_con.isClosed())) {
		response.sendRedirect(request.getContextPath());
		return;
	}

	Statement	db_stmt		= db_con.createStatement();
	String		date_bgn	= request.getParameter("date_bgn");
	String		date_end	= request.getParameter("date_end");
	String		user		= request.getParameter("user");
	String		menu		= request.getParameter("menu");
	String		stat		= request.getParameter("stat");

	q	=" select"
		+" 			date_format(A.tanggal, '%e-%m-%Y %k:%i:%s') as tanggal"
		+" ,		A.id_user"
		+" ,		A.nama_menu"
		+" ,		A.status_akses"
		+" from		__log		A"
		+" where	A.id_user	is not null";
		
	if (date_bgn != null && !date_bgn.equals("")) {
		q	+=" and A.tanggal >= cast('"+ date_bgn +"' as datetime)";
	}
	if (date_end != null && !date_end.equals("")) {
		q	+=" and A.tanggal <= cast('"+ date_end +"' as datetime)";
	}
	if (user != null && !user.equals("")) {
		q	+=" and A.id_user like '%"+ user +"%'";
	}
	if (menu != null && !menu.equals("")) {
		q	+=" and A.nama_menu = '"+ menu +"'";
	}
	if (stat != null && !stat.equals("")) {
		q	+=" and A.status_akses = '"+ stat +"'";
	}

	q +=" order by	A.tanggal desc";

	ResultSet	rs		= db_stmt.executeQuery(q);
	String		data	= "[";
	int			i		= 0;

	while (rs.next()) {
		if (i > 0) {
			data += ",";
		} else {
			i = 1;
		}
		data	+= "['"+ rs.getString("tanggal") +"'"
			+  ",'"+ rs.getString("id_user") +"'"
			+  ",'"+ rs.getString("nama_menu") +"'"
			+  ","+ rs.getString("status_akses")
			+  "]";
	}

	data += "]";

	out.print(data);

	rs.close();
} catch (Exception e) {
	out.print("{success:false,info:'"+ e.toString().replace("'","\\'") +"'}");
}
%>

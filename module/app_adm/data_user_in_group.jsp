<%--
 %
 % Author(s):
 % + x10c-Lab
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

	Statement db_stmt = db_con.createStatement();

	String id_grup = request.getParameter("id_grup");

	String q=" select	A.id_user"
			+" ,		A.status_user"
			+" from		__user		A"
			+" ,		__user_grup	B"
			+" where	A.id_user	= B.id_user"
			+" and		B.id_grup	= "+ id_grup
			+" order by	A.id_user";

	ResultSet	rs	= db_stmt.executeQuery(q);
	int		i	= 0;
	String		data	= "[";

	while (rs.next()) {
		if (i > 0) {
			data += ",";
		} else {
			i = 1;
		}
		data	+="['"+ rs.getString("id_user") +"'"
			+ ",'"+ rs.getString("status_user") +"'"
			+ "]";
	}

	data +="]";

	out.print(data);

	rs.close();
} catch (Exception e) {
	out.print("{success:false,info:'"+ e.toString().replace("'","\\'") +"'}");
}
%>

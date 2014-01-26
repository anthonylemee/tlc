<%@page import="java.util.ArrayList"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.util.List"%>
<%@ page import="javax.jdo.PersistenceManager"%>
<%@ page import="com.google.appengine.api.users.User"%>
<%@ page import="com.google.appengine.api.users.UserService"%>
<%@ page import="com.google.appengine.api.users.UserServiceFactory"%>
<%@ page import="com.istic.tlc.tp1.Ad"%>
<%@ page import="com.istic.tlc.tp1.PMF"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.HashMap"%>
<%@page import="javax.jdo.*"%>

<html>
<head>
<link type="text/css" rel="stylesheet" href="/stylesheets/main.css" />
</head>
<body>

	<%
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		if (user != null) {
	%>
	<p>
		Hello,
		<%=user.getNickname()%>! (You can <a
			href="<%=userService.createLogoutURL(request.getRequestURI())%>">sign
			out</a>.)
	</p>
	<%
		} else {
	%>
	<p>
		Hello! <a
			href="<%=userService.createLoginURL(request.getRequestURI())%>">Sign
			in</a> to include your name with greetings you post.
	</p>
	<%
		}
	%>

	<%
		PersistenceManager pm = PMF.get().getPersistenceManager();
		String query = "select from " + Ad.class.getName()
		+ " order by date desc range 0,5";
		List<Ad> ads = (List<Ad>) pm.newQuery(query).execute();
		DateFormat shortDF = new SimpleDateFormat("yyyy-mm-dd");
		if (ads.isEmpty()) {
	%>
	<p>There are no ads which have been added</p>
	<%
		} else {
	%>
	<fieldset>
		<legend>List of Ads</legend>
		<table border="1" cellpadding="0" cellspacing="0">
			<tr>
				<th>Descriptif</th>
				<th>Auteur</th>
				<th>Date</th>
				<th>Prix</th>
			</tr>
			<%
				for (Ad a : ads) {
			%><tr>
				<td><%=a.getTitle()%></td>
				<td>
					<%
						if (a.getAuthor() == null) {
					%>Anonymus<%
						} else
					%><%=a.getAuthor().getNickname()%>
				</td>
				<td><%=shortDF.format(a.getDate())%></td>
				<td><%=a.getPrice()%> €</td>
			</tr>
			<%
				}
			%>
		</table>
	</fieldset>
	<%
		}
	%>

	<br>
	<br>
	<form action="/addAds" method="post">
		<fieldset>
			<legend>Save an ad : </legend>
			<div>
				<label>title</label> <input type="text" size="50"
					required="required" name="title" /> <label>Price</label> <input
					type="number" required="required" min="0" size="50" name="price"
					step="any" placeholder="in €" /> <input type="submit" value="Add" />
			</div>
		</fieldset>
	</form>
	<div>
		<input type="submit" value="Another Ad ?" />
	</div>
	<br>
	<br>
	<form>
		<fieldset>
			<legend>Search an ad : </legend>
			<div>
				<label>contains in description </label> <input type="text" size="50"
					name="title" /> <br> <label>Price between </label> <input
					type="number" min="0" size="50" name="priceBegin" step="any"
					placeholder="in €" /> <label> and </label> <input type="number"
					min="0" size="50" name="priceEnd" step="any" placeholder="in €" />
				<br> <label>dates between </label> <input type="date" size="50"
					name="dateDebut" /> <label> and </label> <input type="date"
					size="50" name="dateFin" /> <br> <label>You know the
					person which posted it ? </label> <input type="text" size="50" name="email" />
			</div>
			<br> <input type="submit" value="search" onclick="searchAll()" />
		</fieldset>
	</form>
	<div id=searchResult></div>
	<script type="text/javascript">
		function searchAll() {
	<%String s = request.getParameter("title");
				String price1 = request.getParameter("priceBegin");
				String price2 = request.getParameter("priceEnd");
				String dateDebut = request.getParameter("dateDebut");
				String dateFin = request.getParameter("dateFin");
				String email = request.getParameter("email");
				
				query = "select from " + Ad.class.getName();
				HashMap<String,Object> args = new HashMap<String,Object>();
				ArrayList<String> newQuery = new ArrayList<String>();
				ArrayList<String> parameters = new ArrayList<String>();
								
				if(s != "" && s != null){
					parameters.add("String titre");
					newQuery.add("title == titre");
					args.put("titre",s);
				}
				
				if(price1 != null && price1 != ""){
					float un ;
					try {
						un = Float.parseFloat(price1);
						args.put("min",un);
						parameters.add("double min");
						newQuery.add("price > min");
					} catch (Exception e) {}
				}
				
				if(price2 != null && price2 != ""){
					float deux ;
					try {
						deux = Float.parseFloat(price2);
						parameters.add("double max");
						args.put("max",deux);
						newQuery.add("price < max");
					} catch (Exception e) {}
				}
				
				if(dateDebut != null && dateDebut != ""){
					Date debut ;
					try {
						debut = shortDF.parse(dateDebut);
						parameters.add("Date debut");
						args.put("debut",debut);
						newQuery.add("date > debut");
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
				
				if(dateFin != null && dateFin != ""){
					Date fin ;
					try {
						fin = shortDF.parse(dateFin);
						parameters.add("Date final");
						args.put("final",fin);
						newQuery.add("date < final");
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
				
				if(email != "" && email != null){
					parameters.add("String auth");
					args.put("auth",email);
					newQuery.add("author == auth");
				}
				
				for (int i = 0; i < newQuery.size(); i++ ){
					if( i == 0){
						query = query + " WHERE " + newQuery.get(i) ;
					} else {
						query = query + " && " + newQuery.get(i) ;
					}
				}
				
				Query q = pm.newQuery(query);
				String par = "";
				for (int j = 0; j < parameters.size(); j++ ){
					if(j == 0){
						par = parameters.get(0);
					} else {
						par = par + " , " + parameters.get(j);
					}
				}
				q.declareParameters(par);				
				q.declareImports("import java.util.Date");
				ads = (List<Ad>) q.executeWithMap(args);%>
		document.getElementById('searchResult').innerHTML = '<table border="1" cellpadding="0" cellspacing="0">'
					+ '<tr><th>Descriptif</th><th>Auteur</th><th>Date</th><th>Prix</th></tr>';
	<%for (Ad a : ads) {
	%>	
		document.getElementById('searchResult').innerHTML += '<tr><td>'<%=a.getTitle()%>'</td><td>'<%=a.getAuthor().getNickname()%>'</td><td>'<%=a.getDate()%>'</td><td>'<%=a.getPrice()%>'</td></tr>';
	<%}%>
		pm.close();
		}
	</script>
</body>
</html>

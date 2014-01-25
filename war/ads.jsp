<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.util.List"%>
<%@ page import="javax.jdo.PersistenceManager"%>
<%@ page import="com.google.appengine.api.users.User"%>
<%@ page import="com.google.appengine.api.users.UserService"%>
<%@ page import="com.google.appengine.api.users.UserServiceFactory"%>
<%@ page import="com.istic.tlc.tp1.Ad"%>
<%@ page import="com.istic.tlc.tp1.PMF"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.util.Date"%>

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
		DateFormat shortDF = DateFormat.getDateInstance(DateFormat.SHORT);
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
		pm.close();
	%>

	<br>
	<br>
	<form action="/addAds" method="post">
		<fieldset>
			<legend>Save an ad : </legend>
			<div>
				<label>title</label> <input type="text" size="50" required="required" name="title" /> <label>Price</label>
				<input type="number" required="required" min="0" size="50" name="price" step="any"
					placeholder="in €" /> <input type="submit" value="Add" />
			</div>
		</fieldset>
	</form>
	<div>
		<input type="submit" value="Another Ad ?" />
	</div>
	<br>
	<br>
	<form action="/searchAds" method="post">
		<fieldset>
			<legend>Search an ad : </legend>
			<div>
				<label>contains in description </label> <input type="text" size="50"
					name="title" /> <br> <label>Price between </label> <input
					type="number" min="0" size="50" name="price" step="any"
					placeholder="in €" /> <label> and </label> <input type="number"
					min="0" size="50" name="price" step="any" placeholder="in €" /> <br>
				<label>dates between </label> <input type="date" size="50"
					name="dateDebut" /> <label> and </label> <input type="date"
					size="50" name="dateFin" /> <br> <label>You know the
					person which posted it ? </label> <input type="text" size="50" name="email" />
			</div>
			<br>
			<input type="submit" value="search" />
		</fieldset>
	</form>
</body>
</html>

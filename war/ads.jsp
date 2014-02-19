<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html;charset=UTF-8" language="java"%>
<%@page import="java.util.List"%>
<%@page import="javax.jdo.PersistenceManager"%>
<%@page import="com.google.appengine.api.users.User"%>
<%@page import="com.google.appengine.api.users.UserService"%>
<%@page import="com.google.appengine.api.users.UserServiceFactory"%>
<%@page import="com.istic.tlc.tp1.Ad"%>
<%@page import="com.istic.tlc.tp1.PMF"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.HashMap"%>
<%@page import="javax.jdo.*"%>

<html>
<head>
<link type="text/css" rel="stylesheet" href="/stylesheets/main.css" />
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script src="http://code.jquery.com/ui/1.9.2/jquery-ui.js"></script>
<script src="http://code.jquery.com/jquery-1.8.3.js"></script>
<!-- Latest compiled and minified CSS -->
<link rel="stylesheet"
	href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css">
<!-- Optional theme -->
<link rel="stylesheet"
	href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap-theme.min.css">
<!-- Latest compiled and minified JavaScript -->
<script
	src="//netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js"></script>
<script>
	$(document)
			.ready(
					function() {
						$('#search').click(function() {
								keyWords = $("#keywords").val();
								priceMin = $("#pricemin").val();
								priceMax = $("#pricemax").val();
								dateMin = $("#datemin").val();
								dateMax = $("#datemax").val();
								sellerName = $("#seller").val();

								$.ajax({
											data : {
												keywords : keyWords,
												pricemin : priceMin,
												pricemax : priceMax,
												datemin : dateMin,
												datemax : dateMax,
												seller : sellerName
											},
											dataType : 'text',
											url : '/searchAds',
											type : 'POST',
											success : function(
													jsonObj) {

												// On reset la div contenant le tableau des resultats de la recherche
												$('#searchResult')
														.html('');

												// On récupère la chaine de caractère faisant foie de JSON et correspond aux resultats retournés
												arrayJson = JSON
														.parse(jsonObj);

												// On construit le contenu du tableau des résultats de la recherche
												tableContent = '';
												for ( var ad in arrayJson) {
													console
															.log(arrayJson[ad]);
													tableContent += '<tr><td>'
															+ arrayJson[ad].title
															+ '</td><td>'
															+ arrayJson[ad].author
															+ '</td><td>'
															+ arrayJson[ad].date
															+ '</td><td>'
															+ arrayJson[ad].price
															+ '</td></tr>';
												}

												// Une fois le tableau construit on l'incorpore dans la div prévue
												$('#searchResult')
														.append(
																'<div class="panel panel-default"><div class="panel-heading">Results search :</div><table class="table">'
																		+ '<tr><th>Descriptif</th><th>Auteur</th><th>Date</th><th>Prix</th></tr></div>'
																		+ tableContent
																		+ '</table>');

											},
											error : function() {
												alert('Ajax readyState: '
														+ xhr.readyState
														+ '\nstatus: '
														+ xhr.status
														+ ' ' + err);
											}
										});
							});
		});

	function del(row, id, kind){
		$.ajax({
			data : {
				id : id,
				kind : kind
			},
			dataType : 'text',
			url : '/deleteAds',
			type : 'POST',
			success : function() {
				alert("ok");
				var rows = row.parentNode.parentNode;
				rows.parentNode.removeChild(rows);
			},
			error : function() {
				alert(' :( ');
			}
		});
	}
</script>
</head>
<body>

	<%
		UserService userService = UserServiceFactory.getUserService();
		SimpleDateFormat formatter=new SimpleDateFormat("yyyy-MM-dd");
		User user = userService.getCurrentUser();
		if (user != null) {
	%>
	<nav class="navbar navbar-default" role="navigation">
		<div class="container-fluid">
			<!-- Brand and toggle get grouped for better mobile display -->
			<div class="navbar-header">
				<button type="button" class="navbar-toggle" data-toggle="collapse"
					data-target="#bs-example-navbar-collapse-1">
					<span class="sr-only">Toggle navigation</span> <span
						class="icon-bar"></span> <span class="icon-bar"></span> <span
						class="icon-bar"></span>
				</button>
				<a class="navbar-brand" href="#">Ads API</a>
				<p class="navbar-text navbar-right">
					Signed in as <a href="#" class="navbar-link"><%=user.getNickname()%></a>!
					(You can <a
						href="<%=userService.createLogoutURL(request.getRequestURI())%>">sign
						out.)</a>
				</p>
			</div>
		</div>
	</nav>
	<%
		} else {
	%>
	<nav class="navbar navbar-default" role="navigation">
		<div class="container-fluid">
			<!-- Brand and toggle get grouped for better mobile display -->
			<div class="navbar-header">
				<button type="button" class="navbar-toggle" data-toggle="collapse"
					data-target="#bs-example-navbar-collapse-1">
					<span class="sr-only">Toggle navigation</span> <span
						class="icon-bar"></span> <span class="icon-bar"></span> <span
						class="icon-bar"></span>
				</button>
				<a class="navbar-brand" href="#">Ads API</a>
				<p class="navbar-text navbar-right">
					<a href="<%=userService.createLoginURL(request.getRequestURI())%>">Sign
						in</a> to include your name with greetings you post.
				</p>
			</div>
		</div>
	</nav>
	<%
		}
	%>

	<%
		PersistenceManager pm = PMF.get().getPersistenceManager();
		String query = "select from " + Ad.class.getName()
				+ " order by date desc";
		List<Ad> ads = (List<Ad>) pm.newQuery(query).execute();
		DateFormat shortDF = new SimpleDateFormat("yyyy-MM-dd");

		if (ads.isEmpty()) {
	%>
	<p>There are no ads which have been added</p>
	<%
		} else {
	%>
	<div class="panel panel-default">
		<div class="panel-heading">List of Ads :</div>
			<table id="tableDeb" class="tableDeb">
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
						%>Anonymous<%
							} else
						%><%=a.getAuthor().getNickname()%>
				</td>
				<td><%=shortDF.format(a.getDate())%></td> 
				<!-- shortDF.format(a.getDate()) -->
				<td><%=a.getPrice()%> €</td>
					<td><input id="delete" type="button" value="delete" onclick='del(this,<%=a.getKey().getId()%>,"<%=a.getKey().getKind()%>")'/></td>
				</tr>
				<%
					}
				%>
			</table>
	</div>
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
				<label for="keywords">Keywords</label> <input type="text" size="50"
					name="keywords" id="keywords" /> &nbsp; <label for="pricemin">Price
					between </label> <input type="number" min="0" size="50" name="pricemin"
					id="pricemin" step="any" placeholder="0.0 €" /> <label
					for="pricemax"> and </label> <input type="number" min="0" size="50"
					name="pricemax" id="pricemax" step="any" placeholder="0.0 €" /> &nbsp;
				<label for="datemin">dates between </label> <input type="date"
					size="50" name="datemin" id="datemin" /> <label for="datemax">
					and </label> <input type="date" size="50" name="datemax" id="datemax" /> &nbsp;

			</div>

			<br> <input id="search" type="button" value="search" />

		</fieldset>

	</form>

	<div id=searchResult></div>
</body>
</html>

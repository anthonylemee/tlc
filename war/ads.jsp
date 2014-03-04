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
<script src="http://code.highcharts.com/highcharts.js"></script>
<script src="http://code.highcharts.com/modules/exporting.js"></script>
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
																'<div class="panel panel-default"><div class="panel-heading">Results search :</div><div class="table-responsive"><table class="table">'
																		+ '<tr><th>Descriptif</th><th>Auteur</th><th>Date</th><th>Prix</th></tr></div>'
																		+ tableContent
																		+ '</div></table>');

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

	function del(row, id){
		$.ajax({
			data : {
				id : id
			},
			dataType : 'text',
			url : '/deleteAds',
			type : 'POST',
			success : function() {
				var rows = row.parentNode.parentNode;
				rows.parentNode.removeChild(rows);
			},
			error : function() {
				alert(' :( ');
			}
		});
	}

	function perfTest(){
		$('#loader').html('<img src="/loader.gif">');
		$.ajax({
			data : {},
			dataType : 'text',
			url : '/testPerfs',
			type : 'POST',
			success : function(res) {
				$('#loader').html('');
				alert(res);
				location.reload();
			},
			error : function() {
				alert(' échec ! ');
				$('#loader').html('');
			}
		});
	}

	function resetBDD(){
		$('#loader').html('<img src="/loader.gif">');
		$.ajax({
			data : {},
			dataType : 'text',
			url : '/resetBDD',
			type : 'POST',
			success : function(res) {
				$('#loader').html('');
				location.reload();
			},
			error : function() {
				alert(' échec ! ');
				$('#loader').html('');
			}
		});
	}

	function addAllAds(){

		var tabTitle = new Array();
		var tabPrice = new Array();
		for(var j = 0; j < i; j ++){
			if(document.getElementById('title'+j) != null
					&& document.getElementById('price'+j) != null
					&& document.getElementById('title'+j).value != ""
					&& document.getElementById('price'+j).value != ""){

				tabTitle.push(document.getElementById('title'+j).value);
				tabPrice.push(document.getElementById('price'+j).value);
			}
		}
		
		$.ajax({
			data : {
				tabTitle : tabTitle,
				tabPrice : tabPrice
			},
			dataType : 'text',
			url : '/addAllAds',
			type : 'POST',
			success : function() {
				location.reload();
			},
			error : function() {
				alert(' :( ');
			}
		});
	}

	$(document).ready(function() {
		document.getElementById('addAllBtn').disabled = true;
		i = 1;
		}
	);

	function addField() {
		try {
		   var labelT = document.createElement('label');
		   var inputT = document.createElement('input');
		   var inputP = document.createElement('label');
		   var inputP = document.createElement('input');
		   
		   inputT.setAttribute('type','text');
		   inputT.setAttribute('name','title'+i);
		   inputT.setAttribute('id','title'+i);
		   inputT.setAttribute('size','50');
		   inputT.setAttribute('value','');

		   inputP.setAttribute('type','number');
		   inputP.setAttribute('min','0');
		   inputP.setAttribute('step','any');
		   inputP.setAttribute('name','price'+i);
		   inputP.setAttribute('id','price'+i);
		   inputP.setAttribute('size','50');
		   inputP.setAttribute('placeholder','0.0 euros');
		   inputP.setAttribute('value','');
		   
		   document.getElementById('otherAds').appendChild(document.createTextNode('Title '));
		   document.getElementById('otherAds').appendChild(inputT);
		   document.getElementById('otherAds').appendChild(document.createTextNode(' Price '));
		   document.getElementById('otherAds').appendChild(inputP);
		   document.getElementById('otherAds').appendChild(document.createElement('br'));
		   document.getElementById('otherAds').appendChild(document.createElement('br'));
		   document.getElementById('addAllBtn').disabled= false;
		   i ++;
		} catch(e) {
		   alert(e);
		}
	}

	$(function () {
	    $(document).ready(function() {
	        Highcharts.setOptions({
	            global: {
	                useUTC: false
	            }
	        });
	    
	        var chart;
	        $('#container').highcharts({
	            chart: {
	                type: 'spline',
	                animation: Highcharts.svg, // don't animate in old IE
	                marginRight: 10,
	                events: {
	                    load: function() {
	    
	                        // set up the updating of the chart each second
	                        var series = this.series[0];
	                        var series2 = this.series[1];
	                        setInterval(function() {
	                            timeDeb = (new Date()).getTime();
	                            $.ajax({
									data : {
										title0 : 'perfTest',
										price0 : '200'
									},
									dataType : 'text',
									url : '/addAdsTesting',
									type : 'POST',
									success : function(
											key) {
												timeFin = (new Date()).getTime();
												var x = timeDeb, y = timeFin - timeDeb;

				                               	timeDeb2 = (new Date()).getTime();
				                               	$.ajax({
													data : {
														id : key,
													},
													dataType : 'text',
													url : '/deleteAds',
													type : 'POST',
													success : function(
															key) {
																timeFin2 = (new Date()).getTime();
																var x2 = timeDeb2, y2 = timeFin2 - timeDeb2;
								                               	series2.addPoint([x2, y2, '#c63733'], true, true);
															},
															error : function() {
																
																series2.addPoint([0, 0], true, true);
																
															}});
				                               	series.addPoint([x, y, '#6a8ca5'], true, true);
											},
											error : function() {
												
												series.addPoint([0, 0], true, true);
												
											}});
	                        }, 2000);
	                    }
	                }
	            },
	            title: {
	                text: 'Performances in real time'
	            },
	            xAxis: {
	                type: 'datetime',
	                tickPixelInterval: 150
	            },
	            yAxis: {
	                title: {
	                    text: 'Duration in milliseconds'
	                },
	                plotLines: [{
	                    value: 0,
	                    width: 0,
	                    color: '#6a8ca5'
	                },{
	                    value: 0,
	                    width: 0,
	                    color: '#c63733'
	                }]
	            },
	            tooltip: {
	                formatter: function() {
	                        return '<b>'+ this.series.name +'</b><br/>'+
	                        Highcharts.dateFormat('%Y-%m-%d %H:%M:%S', this.x) +'<br/>'+
	                        Highcharts.numberFormat(this.y, 2) +'ms' ;
	                }
	            },
	            legend: {
	                
	                borderWidth: 0
	            },
	            exporting: {
	                enabled: false
	            },
	            colors: [
	                     '#6a8ca5', 
	                     '#c63733', 
	                     '#8bbc21', 
	                     '#910000', 
	                     '#1aadce', 
	                     '#492970',
	                     '#f28f43', 
	                     '#77a1e5', 
	                     '#c42525', 
	                     '#a6c96a'
	                  ],
	            series: [{
	                name: 'Ajout',
	                data: (function() {
	                    // generate an array of random data
	                    var data = [],
	                        time = (new Date()).getTime(),
	                        i;
	    
	                    for (i = -40; i <= 0; i++) {
	                        data.push({
	                            x: time + i * 1000,
	                            y: null,
	                            color: '#6a8ca5'
	                        });
	                    }
	                    return data;
	                })()
	            },{
	                name: 'Supression',
	                data: (function() {
	                    // generate an array of random data
	                    var data = [],
	                        time = (new Date()).getTime(),
	                        i;
	    
	                    for (i = -40; i <= 0; i++) {
	                        data.push({
	                            x: time + i * 1000,
	                            y: null,
	                            color: '#c63733'
	                        });
	                    }
	                    return data;
	                })()
	            }]
	        });
	    });
	    
	});
	
</script>
</head>
<body>

	<%
		UserService userService = UserServiceFactory.getUserService();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
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
	<div class="panel panel-info">

		<div class="panel-heading">
			<h3 class="panel-title">Create new ads</h3>
		</div>

		<div class="panel-body">

			<form role="form" action="/addAds" method="post" class="form-inline">
				<div class="form-group">
					<label>Title</label> <input type="text" size="50"
						required="required" id="title0" name="title0" />
				</div>
				<div class="form-group">
					<label>Price</label> <input type="number" id="price0"
						required="required" min="0" size="50" name="price0" step="any"
						placeholder="0.0 euros" />
				</div>
				&nbsp; <input class="btn btn-primary" type="submit"
					value="Add this ad" /> &nbsp; <input id="perf" type="submit"
					class="btn btn-warning" value="Launch performance testing"
					onclick="perfTest()" />
					 &nbsp; <input id="reset" type="submit"
					class="btn btn-success" value="ResetBDD"
					onclick="resetBDD()" /> <span id="loader"></span>
			</form>
			<div id="otherAds"></div>
			<div id="controlPanelBottom">
				<br /> <input type="button" class="btn btn-success"
					value="One more ad" onclick="addField()" /> &nbsp; <input
					id="addAllBtn" type="submit" value="Add all ads created"
					disabled="disabled" class="btn btn-primary" onclick="addAllAds()" />
			</div>

		</div>
	</div>

	<div id="container"
		style="min-width: 400px; max-width: 600px; height:200px; margin: 0 auto"></div>

	<br />

	<div class="panel panel-info">
		<div class="panel-heading">
			<h3 class="panel-title">List of ads</h3>
		</div>
		<div class="panel-body">
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

					boolean firstMeet = true;
					for (Ad a : ads) {
						if (a.getTitle().equals("perfTest"))
							continue;
						if (firstMeet) {
							firstMeet = false;
			%>
			<div class="table-responsive">
				<table class="table">
					<tr>
						<th>Descriptif</th>
						<th>Auteur</th>
						<th>Date</th>
						<th>Prix</th>
						<th>Action</th>
					</tr>
					<%
						}
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
						<td><input id="delete" type="button" class="btn btn-danger"
							value="delete" onclick='del(this,<%=a.getKey().getId()%>)' /></td>
					</tr>
					<%
						}
							if (firstMeet) {
					%>
					<p>There are no ads which have been added</p>
					<%
						}
					%>
				</table>
			</div>
			<%
				}
			%>

		</div>
	</div>

	<div class="panel panel-info">

		<div class="panel-heading">
			<h3 class="panel-title">Search an ad</h3>
		</div>

		<div class="panel-body">
			<form role="form" class="form-inline">
				<div class="form-group">
					<label for="keywords">keywords</label> <input type="text" size="20"
						name="keywords" id="keywords" />
				</div>
				<div class="form-group">
					<label for="pricemin">price between </label> <input type="number"
						min="0" size="10" name="pricemin" id="pricemin" step="any"
						placeholder="0.0 euros" />
				</div>
				<div class="form-group">
					<label for="pricemax"> and </label> <input type="number" min="0"
						size="10" name="pricemax" id="pricemax" step="any"
						placeholder="0.0 euros" />
				</div>
				<div class="form-group">
					<label for="datemin">dates between </label> <input type="date"
						size="10" name="datemin" id="datemin" />
				</div>
				<div class="form-group">
					<label for="datemax"> and </label> <input type="date" size="20"
						name="datemax" id="datemax" />
				</div>
				<input id="search" type="button" value="Search"
					class="btn btn-primary" />
			</form>
			<div id=searchResult></div>
		</div>
	</div>
</body>
</html>

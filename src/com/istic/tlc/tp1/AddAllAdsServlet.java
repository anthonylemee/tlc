package com.istic.tlc.tp1;

import java.io.IOException;
import java.util.Arrays;
import java.util.Date;
import java.util.Enumeration;
import java.util.List;

import javax.jdo.PersistenceManager;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

public class AddAllAdsServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;
	private String titre;
	private float price;
	private Date date;
	private UserService userService;
	private User user;
	private String[] title;
	private String[] prices;
	private String response;
	private String[] ValeursTitres;
	private String[] ValeursPrix;

	public void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws IOException {
		
		userService = UserServiceFactory.getUserService();
		user = userService.getCurrentUser();
		
		Enumeration<String> NomsParam = req.getParameterNames();
		
		try {
			ValeursTitres = req.getParameterValues(NomsParam.nextElement());
			ValeursPrix = req.getParameterValues(NomsParam.nextElement());
		} catch (Exception e) {
			e.printStackTrace();
		}

		List<String> titres = Arrays.asList(ValeursTitres);
		List<String> prix = Arrays.asList(ValeursPrix);
		
		for (int i = 0; i < titres.size(); i ++){
			price = 0;
			try {
				price = Float.parseFloat(prix.get(i));
				titre = titres.get(i);
			} catch (Exception e) {
				price = 0;
			}
			date = new Date();
			Ad a = new Ad(user, titre, date, price);
			
			PersistenceManager pm = PMF.get().getPersistenceManager();
			try {
				pm.makePersistent(a);
			} finally {
				pm.close();
				response += "ajouté => titre , prix : " + titre + " , " + price + "\n";
				System.out.println(response);
			}
		}
	}
}
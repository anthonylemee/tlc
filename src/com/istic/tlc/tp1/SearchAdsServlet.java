package com.istic.tlc.tp1;

import java.io.IOException;
import java.util.Date;

import javax.jdo.PersistenceManager;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

public class SearchAdsServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	public void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws IOException {
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();

		String title = req.getParameter("title");
		String p = req.getParameter("price");
		float price = 0;
		try {
			price = Float.parseFloat(p);
		} catch (Exception e) {
			price = 0;
		}
		Date date = new Date();

		Ad a = new Ad(user, title, date, price);

		PersistenceManager pm = PMF.get().getPersistenceManager();
		try {
			pm.makePersistent(a);
		} finally {
			pm.close();
		}

		resp.sendRedirect("/ads.jsp");
	}
}
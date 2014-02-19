package com.istic.tlc.tp1;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.Date;
import java.util.Random;
import java.util.Timer;

import javax.jdo.PersistenceManager;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

public class TestPerfServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	public void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws IOException {
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();

		Random r = new Random();
		for (int i = 0; i < 250000; i ++){
			Date d = new Date();
			String title = "titre"+i;
			float price = r.nextLong();
			Ad a = new Ad(user, title, d, price);
			PersistenceManager pm = PMF.get().getPersistenceManager();
			try {
				pm.makePersistent(a);
			} finally {
				pm.close();
				Date fin = new Date();
				System.out.println("temps d'une transaction : " +
				fin.compareTo(d));
			}
		}
	}
}
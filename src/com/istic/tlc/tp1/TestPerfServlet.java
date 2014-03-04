package com.istic.tlc.tp1;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.DateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Random;

import javax.jdo.PersistenceManager;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

public class TestPerfServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;
	private static int NB_TRANSACTION = 1000;
	private Date fin;
	private Ad a;
	private Date d;
	private long temps_moyens;
	
	public void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws IOException {
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		
		DateFormat shortDateFormat = DateFormat.getDateTimeInstance(
				DateFormat.SHORT,
				DateFormat.SHORT);
		
		ArrayList<Long> keysToDelete = new ArrayList<Long>();
		String response = "";
		
		response += "****temps de " + NB_TRANSACTION + " transactions d'ajouts****";
 
		System.out.println(response);
		Date debutTransaction = new Date();
		response += "\ndebut : " + shortDateFormat.format(debutTransaction);
		System.out.println("debut : " + shortDateFormat.format(debutTransaction));
		Random r = new Random();
		for (int i = 0; i < NB_TRANSACTION; i ++){
			d = new Date();
			String title = "titre"+i;
			float price = r.nextLong();
			a = new Ad(user, title, d, price);
			PersistenceManager pm = PMF.get().getPersistenceManager();
			try {
				pm.makePersistent(a);
			} finally {
				keysToDelete.add(a.getKey().getId());
				pm.close();
				fin = new Date();
				temps_moyens += fin.getTime() - d.getTime();
				//response += "\ntemps d'une transaction d'ajout : " + (fin.getTime() - d.getTime()) + "ms";
				System.out.println("temps d'une transaction d'ajout : " + (fin.getTime() - d.getTime()) + "ms");
			}
		}
		response += "\nfin : " + shortDateFormat.format(new Date());
		System.out.println("fin : " + shortDateFormat.format(new Date()));
		Date finTransaction = new Date();
		response += "\ntemps d'ajout de " + NB_TRANSACTION + " transactions : " + (finTransaction.getTime() - debutTransaction.getTime()) + "ms";
		System.out.println("temps d'ajout de " + NB_TRANSACTION + " transactions : " + (finTransaction.getTime() - debutTransaction.getTime()) + "ms");
		response += "\ntemps moyen constaté " + temps_moyens/NB_TRANSACTION + "ms";
		System.out.println("temps moyen constaté " + temps_moyens/NB_TRANSACTION + "ms");
		response += "\n***************" + NB_TRANSACTION + " transactions d'ajouts faites***************";
		System.out.println("****" + NB_TRANSACTION + " transactions d'ajouts faites****");
		response += "\n********************************************************";
		System.out.println("********************************************************************************************");
		System.out.println("*******************************************************************************************");
		System.out.println("*******************************************************************************************");
		response += "\n****temps de " + NB_TRANSACTION + " transactions de suppressions****";
		System.out.println("****temps de " + NB_TRANSACTION + " transactions de suppressions****");
		debutTransaction = new Date();
		temps_moyens = 0;
		response += "\ndebut : " + shortDateFormat.format(debutTransaction);
		System.out.println("debut : " + shortDateFormat.format(debutTransaction));
		for (int i = 0; i < keysToDelete.size(); i ++){
			d = new Date();
			PersistenceManager pm = PMF.get().getPersistenceManager();
			a = pm.getObjectById(Ad.class, keysToDelete.get(i));
			pm.deletePersistent(a);
			fin = new Date();
			temps_moyens += fin.getTime() - d.getTime();
			//response += "\ntemps d'une transaction de suppression : " + (fin.getTime() - d.getTime()) + "ms";
			System.out.println("temps d'une transaction de suppression : " + (fin.getTime() - d.getTime()) + "ms");
		}
		response += "\nfin : " + shortDateFormat.format(new Date());
		System.out.println("fin : " + shortDateFormat.format(new Date()));
		finTransaction = new Date();
		response += "\ntemps de suppression de " + NB_TRANSACTION + " transactions : " + (finTransaction.getTime() - debutTransaction.getTime()) + "ms";
		response += "\ntemps moyen constaté " + temps_moyens/NB_TRANSACTION + "ms";
		response += "\n****" + NB_TRANSACTION + " transactions de suppression faites****";
		System.out.println("temps de suppression de " + NB_TRANSACTION + " transactions : " + (finTransaction.getTime() - debutTransaction.getTime()) + "ms");
		System.out.println("temps moyen constaté " + temps_moyens/NB_TRANSACTION + "ms");
		System.out.println("***************" + NB_TRANSACTION + " transactions de suppression faites***************");
		
		PrintWriter out = resp.getWriter();
		resp.setContentType("application/json");
		out.print(response);
	}
}
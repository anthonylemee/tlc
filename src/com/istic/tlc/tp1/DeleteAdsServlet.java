package com.istic.tlc.tp1;

import java.io.IOException;

import javax.jdo.PersistenceManager;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;

public class DeleteAdsServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;
	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws IOException {
		
		String id = request.getParameter("id");
		String kind = request.getParameter("kind");
		System.out.println( " key " + id);
		if(id != null && id.length() != 0){
			PersistenceManager pm = PMF.get().getPersistenceManager();
			Key k = KeyFactory.createKey(kind, id);
			Ad a = pm.getObjectById(Ad.class, Long.parseLong(id));
			pm.deletePersistent(a);
		}
	}
}
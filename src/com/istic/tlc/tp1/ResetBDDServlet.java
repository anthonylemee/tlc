package com.istic.tlc.tp1;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.PreparedQuery;
import com.google.appengine.api.datastore.Query;

public class ResetBDDServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	public void doPost(HttpServletRequest request, HttpServletResponse response) {
		DatastoreService datastore = DatastoreServiceFactory
				.getDatastoreService();

		Query mydeleteq = new Query();
		PreparedQuery pq = datastore.prepare(mydeleteq);
		for (Entity result : pq.asIterable()) {
			System.out.println("remove _______ " + result.getKey());
			datastore.delete(result.getKey());
		}
		
	}
	
}

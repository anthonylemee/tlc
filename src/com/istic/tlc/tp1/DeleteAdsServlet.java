package com.istic.tlc.tp1;

import java.io.IOException;

import javax.jdo.PersistenceManager;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class DeleteAdsServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;
	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws IOException {
		
		String id = request.getParameter("id");
		if(id != null && id.length() != 0){
			PersistenceManager pm = PMF.get().getPersistenceManager();
			Ad a = pm.getObjectById(Ad.class, Long.parseLong(id));
			pm.deletePersistent(a);
		}
	}
}
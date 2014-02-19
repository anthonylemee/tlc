package com.istic.tlc.tp1;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import javax.jdo.PersistenceManager;
import javax.jdo.Query;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.labs.repackaged.com.google.common.base.Strings;
import com.google.appengine.labs.repackaged.org.json.JSONArray;
import com.google.appengine.labs.repackaged.org.json.JSONException;
import com.google.appengine.labs.repackaged.org.json.JSONObject;

public class SearchAdsServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws IOException {

		// Récupération des filtres de recherche
		String keyWords = request.getParameter("keywords");
		String priceMin = request.getParameter("pricemin");
		String priceMax = request.getParameter("pricemax");
		String dateMin = request.getParameter("datemin");
		String dateMax = request.getParameter("datemax");

		// Initialisation du Manager
		PersistenceManager pm = PMF.get().getPersistenceManager();

		/*-------------------------------------------------
		 *  Application des filtres
		 *-----------------------------------------------*/
		// Liste des Ad trouvées
		List<Ad> ads = new ArrayList<Ad>();

		// Filtre sur les mots clés
		if (!Strings.isNullOrEmpty(keyWords)) {

			// Découpages des mots clés
			String[] splitKeywords = keyWords.split("\\s");

			// Recherche sur les mots clés
			String filter = "";
			for (String keyword : splitKeywords) {

				filter = "title == '" + keyword + "'";
				System.out.println(filter);
				// TODO Eviter les doublons
				// On les ajoute à l'ensemble des Ad précédemment trouvées
				ads.addAll(this.executeStringMatchingQuery(filter, pm));

			}

		} // if keyWords

		// Filtre sur le prix
		if (!Strings.isNullOrEmpty(priceMin)
				&& !Strings.isNullOrEmpty(priceMax)) {

			float pricemin = new Float(priceMin);
			float pricemax = new Float(priceMax);

			if (ads.size() == 0) {
				String query = "price >= " + pricemin + " && price <= "
						+ pricemax;
				System.out.println("SIZE 0 : " + query);
				// On les ajoute à l'ensemble des Ad précédemment trouvées
				ads.addAll(this.executeQuery(query, pm));
			} else {
				System.out.println(priceMin);
				System.out.println(priceMax);
				for (Iterator<Ad> itAds = ads.iterator(); itAds.hasNext();) {
					Ad ad = itAds.next();
					if (!(ad.getPrice() >= pricemin && ad.getPrice() <= pricemax)) {
						itAds.remove();
					}
				}
			}

		} // if price

		// Filtre sur la date
		if (!Strings.isNullOrEmpty(dateMin) && !Strings.isNullOrEmpty(dateMax)) {

			try {

				SimpleDateFormat simpleDateFormat = new SimpleDateFormat(
						"yyyy-MM-dd");
				Date datemin = simpleDateFormat.parse(dateMin);
				Date datemax = simpleDateFormat.parse(dateMax);

				System.out.println(datemin);

				if (ads.size() == 0) {

					String query1 = "date >= :datemin";
					String query2 = "date <= :datemax";
					System.out.println("SIZE 0 : ");
					// recherche et croisements des résultats
					List<Ad> adsFounded = this.executeQueryParameters(query1,
							pm, datemin);
					List<Ad> adsFounded2 = this.executeQueryParameters(query2,
							pm, datemax);

					// On les ajoute à l'ensemble des Ad précédemment trouvées
					ads.addAll(this.intersection(adsFounded, adsFounded2));

				} else {

					for (Iterator<Ad> itAds = ads.iterator(); itAds.hasNext();) {
						Ad ad = itAds.next();
						if (ad.getDate().after(datemax)
								|| ad.getDate().before(datemin)) {
							ads.remove(ad);
						}
					}

				}

			} catch (ParseException e) {
				e.printStackTrace();
			}

		} // if price

		try {

			JSONArray responseAdsJsonArray = new JSONArray();
			for (Ad ad : ads) {

				JSONObject adJson = new JSONObject();
				adJson.put("author", ad.getAuthor());
				adJson.put("date", ad.getDate());
				adJson.put("key", ad.getKey());
				adJson.put("price", ad.getPrice());
				adJson.put("title", ad.getTitle());
				responseAdsJsonArray.put(adJson);

			}

			PrintWriter out = response.getWriter();
			response.setContentType("application/json");
			out.print(responseAdsJsonArray);

		} catch (JSONException e) {
			e.printStackTrace();
		}
	}

	public List<Ad> executeQuery(String query, PersistenceManager pm) {
		System.out.println("Execute query !");
		Query q = pm.newQuery(Ad.class, query);
		q.declareImports("import java.util.Date");
		@SuppressWarnings("unchecked")
		List<Ad> findedAds = (List<Ad>) q.execute();
		return findedAds;
	}

	public List<Ad> executeStringMatchingQuery(String filter,
			PersistenceManager pm) {
		System.out.println("Execute filter !");
		Query query = pm.newQuery(Ad.class, filter);
		query.declareImports("import java.util.Date");
		@SuppressWarnings("unchecked")
		List<Ad> findedAds = (List<Ad>) query.execute();
		return findedAds;
	}

	public List<Ad> executeQueryParameters(String filter,
			PersistenceManager pm, Object parameter) {
		System.out.println("Execute filter parameter !");
		Query query = pm.newQuery(Ad.class, filter);
		query.declareImports("import java.util.Date");
		@SuppressWarnings("unchecked")
		List<Ad> findedAds = (List<Ad>) query.execute(parameter);
		return findedAds;
	}

	public List<Ad> intersection(List<Ad> list1, List<Ad> list2) {
		List<Ad> list = new ArrayList<Ad>();

		for (Ad ad1 : list1) {

			for (Ad ad2 : list2) {

				if (ad1.getKey() == ad2.getKey()) {
					list.add(ad1);
					break;
				}
			}
		}

		return list;
	}

}
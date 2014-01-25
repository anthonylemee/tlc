package com.istic.tlc.tp1;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.users.User;

import java.util.Date;
import javax.jdo.annotations.IdGeneratorStrategy;
import javax.jdo.annotations.PersistenceCapable;
import javax.jdo.annotations.Persistent;
import javax.jdo.annotations.PrimaryKey;

@PersistenceCapable
public class Ad {
	
    @PrimaryKey
    @Persistent(valueStrategy = IdGeneratorStrategy.IDENTITY)
    private Key key;

    @Persistent
    private User author;

    @Persistent
    private String title;

    @Persistent
    private Date date;
    
    @Persistent
    private float price;

    public Ad(User author, String content, Date date, float price) {
        this.author = author;
        this.title = content;
        this.date = date;
        this.price = price;
    }

    public Key getKey() {
        return key;
    }

    public User getAuthor() {
        return author;
    }

    public String getTitle() {
        return title;
    }

    public Date getDate() {
        return date;
    }

    public void setAuthor(User author) {
        this.author = author;
    }

    public void setTitle(String content) {
        this.title = content;
    }

    public void setDate(Date date) {
        this.date = date;
    }
    
    public float getPrice() {
    	return price;
    }
    
    public void setPrice(float p){
    	this.price = p;
    }
}

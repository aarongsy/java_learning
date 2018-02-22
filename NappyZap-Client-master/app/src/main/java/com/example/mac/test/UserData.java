package com.example.mac.test;

import android.util.Log;

import org.json.JSONException;
import org.json.JSONObject;

/**
 * Created by mac on 22/02/2016.
 */
public class UserData {
    //User Data fields
    private int userID;
    private String emailAddress;
    private String firstName;
    private String lastName;
    private String phoneNo;
    private String houseNo;
    private String street;
    private String city;
    private String county;
    private String postcode;
    private String binLocation;

    //reads JSON into session
    public UserData(JSONObject response){
        try {
            setID(response.getInt("userID"));
            setEmail(response.getString("emailAddress"));
            setFirstName(response.getString("firstName"));
            setLastName(response.getString("lastName"));
            setPhoneNo(response.getString("phoneNo"));
            setHouseNo(response.getString("houseNo"));
            setBinLocation(response.getString("binLocation"));
            setCity(response.getString("city"));
            setStreet(response.getString("street"));
            setCounty(response.getString("county"));
            setPostcode(response.getString("postcode"));
        }
        catch (JSONException e) {
            e.printStackTrace();
        }
    }

    //Setters
    public void setID(int fid){
        userID = fid;
    }
    public int getID(){
        return userID;
    }
    public String getName(){
        return firstName+" "+lastName;
    }
    public void setEmail(String email){
        emailAddress = email;
    }
    public void setFirstName(String firstname){
        firstName =firstname;
    }
    public void setLastName(String lastname){
        lastName =lastname;
    }public void setPhoneNo(String phoneno){
        phoneNo =phoneno;
    }public void setHouseNo(String houseno){
        houseNo =houseno;
    }public void setStreet(String fstreet){
        street =fstreet;
    }public void setCity(String fcity){
        city =fcity;
    }
    public void setCounty(String fcounty){
        county =fcounty;
    }
    public void setPostcode(String fpostcode){
        postcode =fpostcode;
    }
    public void setBinLocation(String fbinlocation ){
        binLocation =fbinlocation;
    }

}

package com.example.mac.test;

import android.content.Context;
import android.content.SharedPreferences;
import android.util.Log;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import org.json.JSONException;
import org.json.JSONObject;

/**
 * Created by Aaron on 22/02/2016.
 */
public class Session {
    private static Session curSes;
    private static UserData userInstance;
    private static PickupCollection pickups;

    //~Constructor
    private Session(JSONObject response, Context ctx){
        userInstance = new UserData(response);
        pickups = new PickupCollection(userInstance.getID(), ctx);
    }

    public Session(UserData fUser, PickupCollection fPickup){
        fUser = userInstance;
        fPickup = pickups;
    }

    //returns current session
    public static Session getSession(){
        if(curSes == null){
            Log.d("Session", "No Current Session");
            return null;
        }
        else {
            return curSes;
        }
    }

    public static void updatePickups(Context ctx){
        pickups = new PickupCollection(userInstance.getID(), ctx);
    }

    //start new session
    public static Session newSession(JSONObject response, Context ctx){
        curSes = new Session(response, ctx);
        Log.d("Session", "Session Created");
        return curSes;
    }

    public UserData getUserData(){
        return userInstance;
    }

    public PickupCollection getPickups(){
        return pickups;
    }

    public static void killSession(Context ctx){
        SharedPreferences mPrefs = SharedPreferenceSingleton.getInstance(ctx);
        SharedPreferences.Editor prefsEditor = mPrefs.edit();
        Log.d("Session", curSes.getUserData().getName() + " has logged out successfully!");
        prefsEditor.remove("Session").commit();
    }

    public void saveSession(Context ctx){
        SharedPreferences mPrefs = SharedPreferenceSingleton.getInstance(ctx);
        SharedPreferences.Editor prefsEditor = mPrefs.edit();

        Gson gson = new Gson();
        String json = gson.toJson(curSes.getUserData());
        Log.d("Saving", "Saving " + json);
        prefsEditor.putString("Session", json);
        prefsEditor.commit();
        Log.d("Saving", "Saving Successful");
    }

    public static void loadSession(Context ctx){
        SharedPreferences mPrefs = SharedPreferenceSingleton.getInstance(ctx);
        SharedPreferences.Editor prefsEditor = mPrefs.edit();

        Gson gson = new Gson();
        JSONObject loaded = null;

        String json = mPrefs.getString("Session", "");
        try {
            loaded = new JSONObject(json);
        }
        catch (Exception e){
            e.printStackTrace();
        }
        Log.d("Loading", "Loading "+json.toString());
        Session.newSession(loaded, ctx);
        Log.d("Loading", "Loading Successful");
    }
}

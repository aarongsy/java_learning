package com.example.mac.test;

import android.content.Context;
import android.content.Intent;
import android.util.Log;
import android.widget.Toast;

import com.android.volley.*;
import com.android.volley.Request;
import com.android.volley.toolbox.JsonArrayRequest;
import com.android.volley.toolbox.JsonObjectRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by Aaron on 22/02/2016.
 */
public class PickupCollection {
    ArrayList<Pickup> pickups;
    private String REQUEST_URL = "https://www.nappyzap.com/androidInterface/getPickups.php";

    public PickupCollection(){
        pickups = new ArrayList<Pickup>();
    }

    public PickupCollection(int userID, Context ctx){
        pickups = new ArrayList<Pickup>();
        requestPickups(userID, ctx);
    }

    public ArrayList<Pickup> getList(){
        return pickups;
    }

    public void addPickup(Pickup p){
        pickups.add(p);
    }

    private void requestPickups(int userID, Context ctx){
        JSONObject params = new JSONObject();
        try {
            params.put("userID", userID);
        }
        catch (JSONException e){
            e.printStackTrace();
        }
        //Add to your request queue here.
        Log.d("login", "Request Sent");
        SingletonRequestQueue.getInstance(ctx).addToRequestQueue(pickupsJSONRequest(ctx, params));
    }

    //JSONArray request for all previous pickups
    private CustomJSONArrayRequest pickupsJSONRequest(final Context ctx, JSONObject params){
        Response.Listener<JSONArray> listener = new Response.Listener<JSONArray>() {
            @Override
            public void onResponse(JSONArray response) {
                try {
                    Log.d("Pickups", "Response Received");
                    Log.d("Response", response.toString());
                    pickups = new ArrayList<Pickup>();
                    for(int n = 0; n < response.length(); n++)
                    {
                        JSONObject object = response.getJSONObject(n);
                        addPickup(new Pickup(object));
                    }
                    if(ctx instanceof PreviousPickups){
                        ((PreviousPickups) ctx).callback();
                    }
                }
                catch(Exception e){
                    e.printStackTrace();
                }
            }
        };
        Response.ErrorListener error = new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                //Incorrect handling
                Log.d("Login", "onErrorResponse: " + error.getMessage());
            }
        };
        CustomJSONArrayRequest ret = new CustomJSONArrayRequest(com.android.volley.Request.Method.POST, REQUEST_URL, params, listener, error){
            @Override
            public Map<String, String> getHeaders() throws AuthFailureError {
                Map<String,String> headers = new HashMap<String, String>();
                headers.put("Content-Type","application/json; charset=utf-8");
                headers.put("User-agent", "My useragent");
                return headers;
            }
        };
        return ret;
    }
}

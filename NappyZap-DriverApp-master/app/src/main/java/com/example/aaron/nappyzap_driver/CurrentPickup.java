package com.example.aaron.nappyzap_driver;

import android.app.FragmentManager;
import android.content.Context;
import android.util.Log;
import android.widget.Toast;

import com.android.volley.AuthFailureError;
import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonObjectRequest;
import com.android.volley.toolbox.Volley;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.LatLngBounds;
import com.google.android.gms.maps.model.MarkerOptions;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

/**
 * Created by Aaron on 12/12/2015.
 */
public class CurrentPickup implements Serializable {
    private static CurrentPickup pickupInstance = null;
    private String url = "https://www.nappyzap.com/androidInterface/getCurrentJob.php";
    private Map<String, String> params;
    private static final long serialVersionUID = 465487644;
    private String name;
    private String phoneNo;
    private transient LatLng pickupLoc;
    private String binLocation;
    private String address;
    private String details;
    private int pickupID;
    private boolean complete;
    private JsonObjectRequest jsObjRequest;
    private static GoogleMap map;
    private static File file;

    public static CurrentPickup getInstance()
    {
        if (pickupInstance == null)
        {
            pickupInstance = new CurrentPickup();
        }
        return pickupInstance;
    }

    private CurrentPickup(){
        complete = true;
        name = "No Current Pickup";
        phoneNo = "";
        pickupLoc = new LatLng(0, 0);
        address = "Please request a new pickup!";
        binLocation = "";
        details = "";
    }

    public void resetPickup(){
        pickupInstance = new CurrentPickup();
    }

    public void setNewPickup(int driverID, Context ctx) {
        JSONObject params = new JSONObject();
        try {
            params.put("driverID", Integer.toString(driverID));
            params.put("lat", Double.toString(mainActivity.gpsChecker.lat));
            params.put("lng", Double.toString(mainActivity.gpsChecker.lng));
        }
        catch (JSONException e){
            e.printStackTrace();
        }
        Log.d("CurrentPickup", "Request Prepared");
        Log.d("CurrentPickup", "Request Sent");
        SingletonRequestQueue.getInstance(ctx.getApplicationContext()).addToRequestQueue(getJsonObject(ctx, params));
    }

    private synchronized JsonObjectRequest getJsonObject(final Context ctx, JSONObject params){
        JsonObjectRequest ret = new JsonObjectRequest
                (Request.Method.POST, url, params, new Response.Listener<JSONObject>() {

                    @Override
                    public void onResponse(JSONObject response) {
                        try {
                            Log.d("CurrentPickup", "Response Received");
                            name = response.getString("title")+" "+response.getString("firstName")+" "+response.getString("lastName");
                            phoneNo = response.getString("phoneNo");
                            pickupLoc = new LatLng(response.getDouble("lat"), response.getDouble("lng"));
                            binLocation = response.getString("binLocation");
                            address = response.getString("houseNo")+", "+response.getString("street")+", "+response.getString("city")+", "+response.getString("county")+", "+response.getString("postcode");
                            pickupID = response.getInt("pickupID");
                            details = response.getString("details");
                            complete = false;
                            Log.d("CurrentPickup", "Response: " + response.toString());
                            Log.d("CurrentPickup", "Object Data: " + getString());
                            save(ctx);
                            updateMap();
                            Toast.makeText(ctx.getApplicationContext(), "New Pickup Received", Toast.LENGTH_SHORT).show();
                            mainActivity.curJobFrag.populateView();
                            Log.d("MapReady", "Signalling MapReady");
                        }
                        catch (JSONException e){
                            e.printStackTrace();
                        }
                    }
                }, new Response.ErrorListener() {

                    @Override
                    public void onErrorResponse(VolleyError error) {
                        // TODO Auto-generated method stub
                        Toast.makeText(ctx.getApplicationContext(), "No more deliveries available", Toast.LENGTH_SHORT).show();
                        Log.d("CurrentPickup", "Response Error");
                        Log.d("CurrentPickup", "onErrorResponse: " + error.getMessage());
                    }
                }){
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

    public synchronized void updateMap(){
        if(map != null) {
            Log.d("MapReady", "updating...");
            LatLngBounds.Builder build = new LatLngBounds.Builder();
            LatLngBounds currentScope;
            build.include(pickupLoc);
            build.include(new LatLng(mainActivity.gpsChecker.lat, mainActivity.gpsChecker.lng));
            currentScope = build.build();
            Log.d("UpdateMap", pickupLoc.toString());
            Log.d("UpdateMap", Double.toString(mainActivity.gpsChecker.lat));
            Log.d("UpdateMap", Double.toString(mainActivity.gpsChecker.lng));
            try {
                map.moveCamera(CameraUpdateFactory.newLatLngBounds(currentScope, 200));
                map.addMarker(new MarkerOptions()
                        .position(pickupLoc)
                        .title(name)
                        .snippet(address));
            }catch (Exception e){
                LatLng london =  new LatLng(51.5361582, -0.1360325);
                map.moveCamera(CameraUpdateFactory.newLatLngZoom(london, 11));
            }
        }
    }

    //Serialise Object
    public void save(Context ctx){
        try {
            Log.d("Save", "Saving Current Pickup...");
            FileOutputStream fos = ctx.openFileOutput("currentPickup.data" , ctx.MODE_PRIVATE);
            ObjectOutputStream os = new ObjectOutputStream(fos);
            os.writeObject(name);
            os.writeObject(phoneNo);
            os.writeDouble(pickupLoc.latitude);
            os.writeDouble(pickupLoc.longitude);
            os.writeObject(binLocation);
            os.writeObject(address);
            os.writeObject(details);
            os.writeInt(pickupID);
            os.writeBoolean(complete);
            os.close();
            fos.close();
            Log.d("Save", "Save Complete");
            Log.d("Save", getString());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    //Load object
    public void load(Context ctx){
        try {
            Log.d("Load", "Loading Current Pickup...");
            FileInputStream fis = ctx.openFileInput("currentPickup.data");
            ObjectInputStream is = new ObjectInputStream(fis);
            this.name = is.readObject().toString();
            this.phoneNo = is.readObject().toString();
            this.pickupLoc = new LatLng(is.readDouble(), is.readDouble());
            this.binLocation = is.readObject().toString();
            this.address = is.readObject().toString();
            this.details = is.readObject().toString();
            this.pickupID = is.readInt();
            this.complete = is.readBoolean();
            is.close();
            fis.close();
            if(!complete) {
                Toast.makeText(ctx.getApplicationContext(), "Previous pickup loaded!", Toast.LENGTH_SHORT).show();
            }
            Log.d("Load", "Load Complete");
            Log.d("Load", getString());
        } catch(Exception e) {
            e.printStackTrace();
        }
    }

    public String getString(){
        return name + " " + address + " " + complete;
    }

    public void setMap(GoogleMap mMap){
        map = mMap;
    }

    public Boolean getStatus(){
        return complete;
    }

    public void flipStatus(){
        complete = !complete;
    }

    public int getPickupID() {
        return pickupID;
    }

    public String getName() {
        return name;
    }

    public String getPhoneNo(){
        return phoneNo;
    }

    public String getAddress(){
        return address;
    }

    public String getDetails(){
        return details;
    }

    public String getBinLocation(){
        return binLocation;
    }
}

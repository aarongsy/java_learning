package com.example.mac.test;

import android.util.Log;

import org.json.JSONObject;

/**
 * Created by Aaron on 22/02/2016.
 */
public class Pickup {
    private String driverName;
    private String details;
    private String comment;
    private String timeCollected;
    private int failed;

    public Pickup(JSONObject pickup) {
        try {
            driverName = pickup.getString("firstName") + " " + pickup.getString("lastName");
            details = pickup.getString("details");
            comment = pickup.getString("comments");
            timeCollected = pickup.getString("timeCollected");
            failed = pickup.getInt("failed");
            Log.d("Previous Pickup", driverName+" "+details+" "+comment+" "+timeCollected+" "+failed);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public String getDriverName(){
        return driverName;
    }
    public String getDetails(){
        return details;
    }
    public String getComment(){
        return comment;
    }
    public String getTimeCollected(){
        return timeCollected;
    }
    public int getFailed(){
        return failed;
    }
}

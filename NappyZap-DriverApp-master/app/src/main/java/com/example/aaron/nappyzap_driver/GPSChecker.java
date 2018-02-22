package com.example.aaron.nappyzap_driver;

import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;
import android.os.IBinder;
import android.support.annotation.Nullable;
import android.util.Log;

import java.security.Provider;

/**
 * Created by Aaron on 09/12/2015.
 */
public class GPSChecker extends Service implements LocationListener{

    // The minimum distance to change updates in metres
    private static final long MIN_DISTANCE_CHANGE_FOR_UPDATES = 10; // 10 meters

    // The minimum time between updates in milliseconds
    private static final long MIN_TIME_BW_UPDATES = 1000 * 60 * 1; // 1 minute

    //Location variables
    Location location;
    double lat;
    double lng;

    //Manages location and stores provider information
    protected LocationManager locationManager;
    private String provider_info;
    private final Context mContext;

    //Set flags for Network and GPS
    private boolean isNetworkEnabled = false;
    private boolean isGPSTrackingEnabled = false;
    private boolean isGPSEnabled = false;

    public GPSChecker(Context context) {
        this.mContext = context;
        getLocation();
    }

    public void getLocation(){
        try{
            locationManager = (LocationManager)mContext.getSystemService(LOCATION_SERVICE);
            //Check GPS and Network connections
            isGPSEnabled = locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER);
            isNetworkEnabled = locationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER);
            if(isGPSEnabled){
                this.isGPSTrackingEnabled=true;
                provider_info = LocationManager.GPS_PROVIDER;
            }
            else if(isNetworkEnabled){
                this.isGPSTrackingEnabled=true;
                provider_info = LocationManager.NETWORK_PROVIDER;
            }

            //If the application can use GPS or Network coordinates

            if(!provider_info.isEmpty()){
                locationManager.requestLocationUpdates(provider_info,
                                                    MIN_TIME_BW_UPDATES,
                                                    MIN_DISTANCE_CHANGE_FOR_UPDATES,
                                                    this);
            }
            if (locationManager != null){
                location = locationManager.getLastKnownLocation(provider_info);
                updateCoordinates();
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
    }
    //Updates coordinates.
    public void updateCoordinates(){
        if(location!= null){
            lat = location.getLatitude();
            lng = location.getLongitude();
            Log.d("GPSChecker", Double.toString(lat));
            Log.d("GPSChecker", Double.toString(lng));
        }
    }

    @Override
    public void onLocationChanged(Location location) {

    }

    @Override
    public void onStatusChanged(String provider, int status, Bundle extras) {

    }

    @Override
    public void onProviderEnabled(String provider) {

    }

    @Override
    public void onProviderDisabled(String provider) {

    }

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }
}

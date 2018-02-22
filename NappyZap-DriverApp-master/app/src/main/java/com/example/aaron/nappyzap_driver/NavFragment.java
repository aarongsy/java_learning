package com.example.aaron.nappyzap_driver;

import android.app.Fragment;
import android.app.FragmentTransaction;
import android.content.Context;
import android.location.Location;
import android.location.LocationManager;
import android.os.Bundle;
import android.support.v4.app.FragmentActivity;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Toast;

import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.MapFragment;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.SupportMapFragment;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.LatLngBounds;
import com.google.android.gms.maps.model.MarkerOptions;

import org.apache.http.HttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.util.Map;

/**
 * Created by Aaron on 05/12/2015.
 */
public class NavFragment extends Fragment implements OnMapReadyCallback {

    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.navigation_fragment, null, false);
        MapFragment mapFragment = (MapFragment) getFragmentManager()
                .findFragmentById(R.id.map);
        mapFragment.getMapAsync(this);
        CurrentPickup cur = CurrentPickup.getInstance();
        if(cur.getStatus()) {
            //Initialize GSPTracker and update current pickup
            cur.setNewPickup(1, getActivity());
        }
        Log.d("NavFragment", "Successfully inflated.");
        return v;
    }
    @Override
    public void onMapReady(final GoogleMap mMap) {
        if(mMap!=null) {
            mMap.setMyLocationEnabled(true);
            CurrentPickup.getInstance().setMap(mMap);
            CurrentPickup.getInstance().updateMap();
        }
        else{
            Log.d("NavFragment", "Map was null");
        }
    }
    public void onDestroyView ()
    {
        try{
            MapFragment fragment = ((MapFragment) getFragmentManager().findFragmentById(R.id.map));
            FragmentTransaction ft = getActivity().getFragmentManager().beginTransaction();
            ft.remove(fragment);
            ft.commit();
            Log.d("NavFragment", "Successfully destroyed");
        }catch(Exception e){
            Log.d("NavFragment", "Not destroyed");
            e.printStackTrace();
        }
        super.onDestroyView();
    }
}

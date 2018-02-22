package com.example.aaron.nappyzap_driver;

import android.app.AlertDialog;
import android.app.Fragment;
import android.app.FragmentManager;
import android.app.FragmentTransaction;
import android.os.Bundle;
import android.support.v4.widget.DrawerLayout;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ListView;
import android.widget.ScrollView;
import android.widget.TextView;
import android.widget.Toast;

import com.android.volley.AuthFailureError;
import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonObjectRequest;
import com.google.android.gms.maps.MapFragment;
import com.google.android.gms.maps.model.LatLng;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by Aaron on 05/12/2015.
 */
public class CurrentJobFragment extends Fragment {

    TextView fullName;
    TextView address;
    TextView details;
    Button request;
    completeDialog dialog = new completeDialog();

    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.current_job_fragment, container, false);

        return view;
    }

    @Override
    public void onViewCreated(View view, Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        // Inflate the layout for this fragment
        populateView();
    }


    @Override
    public void onDestroyView ()
    {
        try{
            MapFragment fragment = ((MapFragment) getFragmentManager().findFragmentById(R.id.content_frame));
            FragmentTransaction ft = getActivity().getFragmentManager().beginTransaction();
            ft.remove(fragment);
            ft.commit();
        }catch(Exception e){
        }
        super.onDestroyView();
    }

    public void populateView(){
        //Get Text Views
        try {
            CurrentPickup cur = CurrentPickup.getInstance();
            fullName = (TextView) getView().findViewById(R.id.textFullName);
            address = (TextView) getView().findViewById(R.id.textAddress);
            request = (Button) getView().findViewById(R.id.btnRequest);
            details = (TextView) getView().findViewById(R.id.textDetails);
            request.setOnClickListener(requestClicked);
            if (cur.getStatus()) {
                fullName.setText("No Pickup Available");
                address.setText("Please Request a new Pickup");
                details.setText("");
            } else {
                fullName.setText(cur.getName() + ", " + cur.getPhoneNo());
                address.setText(cur.getBinLocation() + ", " + cur.getAddress());
                details.setText(cur.getDetails());
            }
            setRequestBtn(request);
        }
        catch (Exception e){
            e.printStackTrace();
        }
    }

    private void setRequestBtn(View view){
        //Request or Complete pickup
        Boolean requestFlag = CurrentPickup.getInstance().getStatus();
        if(requestFlag){
            request.setText("Request New Pickup");
        }
        else if(!requestFlag){
            request.setText("Complete Pickup");
        }
    }

    View.OnClickListener requestClicked = new View.OnClickListener() {
        public void onClick(View v) {
            Log.d("RequestClick", "Entered View");
            if(CurrentPickup.getInstance().getStatus()){
                Log.d("RequestClick", "Requesting a new pickup...");
                requestNewPickup();
            }
            else if(!CurrentPickup.getInstance().getStatus()){
                Log.d("RequestClick", "Completing Current Pickup...");
                completeCurrentPickup();
            }
        }
    };

    private void requestNewPickup(){
        Log.d("Request", "Pickup Requested");
        CurrentPickup.getInstance().setNewPickup(1, getActivity());
        CurrentPickup.getInstance().updateMap();
        CurrentPickup.getInstance().save(getActivity());
    }

    private void completeCurrentPickup(){
        dialog.setCtx(getActivity());
        dialog.show(getFragmentManager(), "complete");
    }
}

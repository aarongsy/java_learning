package com.example.mac.test;

/**
 * Created by mac on 09/02/2016.
 */
import android.content.Context;
import android.content.Intent;
import android.support.v7.app.ActionBarDrawerToggle;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.android.volley.*;
import com.android.volley.toolbox.JsonObjectRequest;
import com.android.volley.toolbox.StringRequest;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;


public class Dashboard extends ActionBarActivity {

    private String[] mNav;
    private DrawerLayout mDrawerLayout;
    private ListView mDrawerList;
    private ActionBarDrawerToggle mDrawerToggle;
    private Button submit;
    private EditText details;
    private TextView driver;
    private TextView deets;
    private TextView timeSet;
    private TextView estimate;

    private String REQUEST_URL = "https://www.nappyzap.com/androidInterface/addPickup.php";
    private String REQUEST_URL2 = "https://www.nappyzap.com/androidInterface/getCurPickup.php";
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_dashboard);


        submit = (Button)findViewById(R.id.btnCurrentPickup);
        details = (EditText)findViewById(R.id.editDetails);
        driver = (TextView)findViewById(R.id.txtDriver);
        deets = (TextView)findViewById(R.id.txtDetails);
        timeSet = (TextView)findViewById(R.id.txtScheduled);
        estimate = (TextView)findViewById(R.id.txtEstimate);

        populateViews();

        drawerSetup();
        submit.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                addNewPickup(getApplicationContext());
            }
        });
    }

    private void addNewPickup(Context ctx){
            JSONObject params = new JSONObject();
            try {
                params.put("userID", Session.getSession().getUserData().getID());
                params.put("details", details.getText().toString());
            }
            catch (JSONException e){
                e.printStackTrace();
            }
            //Add to your request queue here.
            Log.d("Add Pickup", "Request Sent");
            SingletonRequestQueue.getInstance(this).addToRequestQueue(getJsonObject(getApplicationContext(), params));
            Toast.makeText(ctx.getApplicationContext(), "Requesting Pickup", Toast.LENGTH_SHORT).show();
    }

    private synchronized JsonObjectRequest getJsonObject(final Context ctx, JSONObject params){
        JsonObjectRequest ret = new JsonObjectRequest
                (com.android.volley.Request.Method.POST, REQUEST_URL, params, new Response.Listener<JSONObject>() {

                    @Override
                    public void onResponse(JSONObject response) {
                        Log.d("Add Pickup", "Response Received");
                        try {
                            Toast.makeText(ctx.getApplicationContext(), response.getString("response"), Toast.LENGTH_SHORT).show();
                            populateViews();
                        }
                        catch(Exception e){
                            e.printStackTrace();
                        }
                    }
                }, new Response.ErrorListener() {

                    @Override
                    public void onErrorResponse(VolleyError error) {
                        //Incorrect handling
                        Toast.makeText(ctx.getApplicationContext(), "Username or Password incorrect.", Toast.LENGTH_SHORT).show();
                        Log.d("Login", "onErrorResponse: " + error.getMessage());
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

    protected void populateViews(){
        JSONObject params2 = new JSONObject();
        try {
            params2.put("userID", Session.getSession().getUserData().getID());
        }
        catch (JSONException e){
            e.printStackTrace();
        }
        JsonObjectRequest ret2 = new JsonObjectRequest
                (com.android.volley.Request.Method.POST, REQUEST_URL2, params2, new Response.Listener<JSONObject>() {

                    @Override
                    public void onResponse(JSONObject response) {
                        Log.d("Get Pickup", "Response Received");
                        try{
                            Log.d("Response", response.toString());
                            if(!response.isNull("firstName")) {
                                driver.setText("Driver: "+response.getString("firstName") + " " + response.getString("lastName"));
                                deets.setText("Details: "+response.getString("details"));
                                timeSet.setText("Scheduled at "+response.getString("timeScheduled"));
                                estimate.setText("Time Estimate: "+response.getString("timeToPickup"));
                            }
                            else{
                                driver.setText("You've not been assigned a driver yet");
                                deets.setText(response.getString("details"));
                                timeSet.setText("Scheduled at "+response.getString("timeScheduled"));
                                estimate.setText("");
                            }
                        }
                        catch (Exception e){
                            e.printStackTrace();
                        }
                    }
                }, new Response.ErrorListener() {

                    @Override
                    public void onErrorResponse(VolleyError error) {
                        Log.d("Get Pickup", "onErrorResponse: " + error.getMessage());
                        Session.getSession().getPickups().getList();
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
        //Add to your request queue here.
        Log.d("Get Current Pickup", "Request Sent");
        SingletonRequestQueue.getInstance(this).addToRequestQueue(ret2);
    }

    private void drawerSetup(){
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        getSupportActionBar().setHomeButtonEnabled(true);
        mNav = getResources().getStringArray(R.array.mNavArray);
        mDrawerLayout = (DrawerLayout) findViewById(R.id.drawer_layout);
        mDrawerList = (ListView) findViewById(R.id.left_drawer);
        mDrawerToggle = new ActionBarDrawerToggle(this, mDrawerLayout,
                R.string.drawer_open, R.string.drawer_close) {

            public void onDrawerOpened(View drawerView) {
                super.onDrawerOpened(drawerView);
            }

            public void onDrawerClosed(View view) {
                super.onDrawerClosed(view);
            }
        };
        mDrawerToggle.setDrawerIndicatorEnabled(true);
        mDrawerLayout.setDrawerListener(mDrawerToggle);
        //Initialises Drawer List
        mDrawerList.setAdapter(new ArrayAdapter<String>(this,
                R.layout.drawer_list_item, mNav));
        mDrawerList.setItemChecked(0, true);
        mDrawerList.setOnItemClickListener(new DrawerItemClickListener());
    }

    private class DrawerItemClickListener implements ListView.OnItemClickListener {
        @Override
        public void onItemClick(AdapterView parent, View view, int position, long id) {
            selectItem(position);
        }
    }

    private void selectItem(int position) {
        Log.d("MainActivity", "Item selected in side drawer.");
            if (position == 0) {
                startActivity(new Intent(this, Dashboard.class));
            }
            if (position == 1) {
                startActivity(new Intent(this, PreviousPickups.class));
            }
            if (position == 2) {
                startActivity(new Intent(this, Contact.class));
            }
        if (position == 3) {
            startActivity(new Intent(this, Aboutus.class));
        }
        if (position == 4) {
            Session.killSession(this);
            startActivity(new Intent(this, Login.class));
        }
    }


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();
        if (mDrawerToggle.onOptionsItemSelected(item)) {
            return true;
        }
        return super.onOptionsItemSelected(item);
    }


}

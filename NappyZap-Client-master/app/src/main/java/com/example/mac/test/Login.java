package com.example.mac.test;

/**
 * Created by mac on 10/02/2016.
 */
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import com.android.volley.Request;
import com.android.volley.Request.Method;
import com.android.volley.AuthFailureError;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonObjectRequest;
import com.android.volley.toolbox.Volley;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

public class Login extends ActionBarActivity {

    private JSONObject params;
    private final String REQUEST_URL = "https://www.nappyzap.com/androidInterface/checkLogin.php";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_register);

        SharedPreferences mPrefs = SharedPreferenceSingleton.getInstance(this);
        //Session.killSession(this);
        if(mPrefs.contains("Session")){
            Session.loadSession(this);
            startActivity(new Intent(Login.this, Dashboard.class));
        }
        Button btn = (Button)findViewById(R.id.buttonregister);

        btn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                //get input email and password
                EditText email = (EditText) findViewById(R.id.editemailAddress);
                EditText pass = (EditText) findViewById(R.id.editpassword);
                setLogin(String.valueOf(email.getText()), String.valueOf(pass.getText()), getApplicationContext());
            }
        });
    }

    public void setLogin(String emailAddress, String password, Context ctx) {
        JSONObject params = new JSONObject();
        try {
            params.put("emailAddress", emailAddress);
            params.put("password", password);
        }
        catch (JSONException e){
            e.printStackTrace();
        }
        //Add to your request queue here.
        SingletonRequestQueue.getInstance(this).addToRequestQueue(getJsonObject(getApplicationContext(), params));
        Toast.makeText(ctx.getApplicationContext(), "Logging In...", Toast.LENGTH_SHORT).show();
    }

    private synchronized JsonObjectRequest getJsonObject(final Context ctx, JSONObject params){
        JsonObjectRequest ret = new JsonObjectRequest
                (Request.Method.POST, REQUEST_URL, params, new Response.Listener<JSONObject>() {

                    @Override
                    public void onResponse(JSONObject response) {
                        Log.d("Login", "Response Received");
                        Session.newSession(response, getApplicationContext());
                        Toast.makeText(ctx.getApplicationContext(), "Login Successful!", Toast.LENGTH_SHORT).show();
                        startActivity(new Intent(Login.this, Dashboard.class));
                        Session.getSession().saveSession(ctx);
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
}

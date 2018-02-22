package com.example.aaron.nappyzap_driver;

import android.app.AlertDialog;
import android.app.Dialog;
import android.app.DialogFragment;
import android.content.Context;
import android.content.DialogInterface;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.Toast;

import com.android.volley.AuthFailureError;
import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonObjectRequest;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by Aaron on 30/01/2016.
 */
public class completeDialog extends DialogFragment {
    private Context ctx;

    public void setCtx(Context ctx){
        this.ctx = ctx;
    }

    @Override
    public Dialog onCreateDialog(Bundle savedInstanceState) {
        // Use the Builder class for convenient dialog construction
        AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());
        LayoutInflater inflater = getActivity().getLayoutInflater();
        builder.setView(inflater.inflate(R.layout.completion_dialog_layout, null));

        builder.setMessage("Leave a comment on your pickup?")
                .setPositiveButton("Complete", new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int id) {
                        //Send the completion request to update the database
                        Log.d("Complete", "Leave a comment on your pickup?");
                        String url = "https://www.nappyzap.com/androidInterface/completePickup.php";
                        EditText t = (EditText) ((AlertDialog) dialog).findViewById(R.id.commentBox);
                        CheckBox c = (CheckBox) ((AlertDialog) dialog).findViewById(R.id.checkboxFail);
                        String comments = t.getText().toString();
                        JSONObject params = new JSONObject();

                        try {
                            params.put("pickupID", Integer.toString(CurrentPickup.getInstance().getPickupID()));
                            params.put("comments", comments);
                            if (c.isChecked()){
                                params.put("fail", 1);
                            }
                            else{
                                params.put("fail", 0);
                            }
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }
                        JsonObjectRequest ret = new JsonObjectRequest
                                (Request.Method.POST, url, params, new Response.Listener<JSONObject>() {
                                    @Override
                                    public void onResponse(JSONObject response) {

                                    }
                                }, new Response.ErrorListener() {

                                    @Override
                                    public void onErrorResponse(VolleyError error) {
                                        // TODO Auto-generated method stub
                                        CurrentPickup.getInstance().flipStatus();
                                        CurrentPickup.getInstance().save(ctx);

                                        Toast.makeText(ctx, "Pickup Succesfully Completed", Toast.LENGTH_SHORT).show();
                                        CurrentPickup.getInstance().resetPickup();
                                        mainActivity.curJobFrag.populateView();
                                        Log.d("CurrentPickup", "Response Error");
                                        Log.d("CurrentPickup", "onErrorResponse: " + error.getMessage());
                                    }
                                }) {
                            @Override
                            public Map<String, String> getHeaders() throws AuthFailureError {
                                Map<String, String> headers = new HashMap<String, String>();
                                headers.put("Content-Type", "application/json; charset=utf-8");
                                headers.put("User-agent", "My useragent");
                                return headers;
                            }
                        };
                        SingletonRequestQueue.getInstance(getActivity()).addToRequestQueue(ret);
                        Log.d("Complete", "Pickup Completed");
                    }
                })
                .setNegativeButton("Cancel", new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int id) {
                        //Nothing happens here
                        completeDialog.this.getDialog().cancel();
                    }
                });
        // Create the AlertDialog object and return it
        return builder.create();
    }
}

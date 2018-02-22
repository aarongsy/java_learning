package com.example.mac.test;

import com.android.volley.NetworkResponse;
import com.android.volley.ParseError;
import com.android.volley.Response;
import com.android.volley.toolbox.HttpHeaderParser;
import com.android.volley.toolbox.JsonRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.UnsupportedEncodingException;

/**
 * Created by Aaron on 22/02/2016.
 */
public class CustomJSONArrayRequest extends JsonRequest<JSONArray> {
    public CustomJSONArrayRequest(int method, String url, JSONObject requestBody, Response.Listener<JSONArray> listener, Response.ErrorListener errorListener) {
        super(method, url, (requestBody == null) ? null : requestBody.toString(), listener, errorListener);
    }
    @Override
    protected Response<JSONArray> parseNetworkResponse(NetworkResponse response){
        try {
            String jsonString = new String(response.data, HttpHeaderParser.parseCharset(response.headers));
            return Response.success(new JSONArray(jsonString), HttpHeaderParser.parseCacheHeaders(response));
        } catch (UnsupportedEncodingException e) {
            return Response.error(new ParseError(e));
        } catch (JSONException je) {
            return Response.error(new ParseError(je));
        }
    }
}

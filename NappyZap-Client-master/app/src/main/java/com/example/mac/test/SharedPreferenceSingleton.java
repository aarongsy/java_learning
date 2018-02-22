package com.example.mac.test;

import android.content.Context;
import android.content.SharedPreferences;
import android.graphics.AvoidXfermode;

/**
 * Created by Aaron on 22/02/2016.
 */
public class SharedPreferenceSingleton {
    private static SharedPreferences mPrefs;
    public static SharedPreferences getInstance(Context ctx){
        if(mPrefs == null) {
            mPrefs = ctx.getApplicationContext().getSharedPreferences("Session", ctx.getApplicationContext().MODE_PRIVATE);
        }
        return mPrefs;
    }
}

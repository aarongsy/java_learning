package com.example.aaron.nappyzap_driver;

import android.app.Fragment;
import android.app.FragmentManager;
import android.app.FragmentTransaction;
import android.content.Context;
import android.content.Intent;
import android.support.v4.app.FragmentActivity;
import android.os.Bundle;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarDrawerToggle;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.TextView;

import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.MapFragment;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.SupportMapFragment;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.MarkerOptions;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;

public class mainActivity extends AppCompatActivity implements OnMapReadyCallback{

    //hardcoded driver ID
    public static int driverID = 1;

    private Fragment curFragment;
    private String[] mNav;
    private DrawerLayout mDrawerLayout;
    private ListView mDrawerList;
    //GPS Manager
    public static GPSChecker gpsChecker;

    //Fragments
    public static CurrentJobFragment curJobFrag = new CurrentJobFragment();
    private static int lastClicked = 0;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        gpsChecker = new GPSChecker(this);
        mNav = getResources().getStringArray(R.array.mNavArray);
        mDrawerLayout = (DrawerLayout) findViewById(R.id.drawer_layout);
        mDrawerList = (ListView) findViewById(R.id.left_drawer);
        File file;
        file = getBaseContext().getFileStreamPath("currentPickup.data");
        CurrentPickup currentPickup = CurrentPickup.getInstance();
        if(file.exists()){
            Log.d("FileLoad", "File Exists, loading...");
            currentPickup.load(this);
            if(currentPickup.getStatus()){
                Log.d("Main", "Pickup Reset");
                currentPickup.resetPickup();
            }
            //file.delete();
        }
        Log.d("String", currentPickup.getString());

        //Sets main fragment
        curFragment = new NavFragment();
        FragmentManager fragmentManager = getFragmentManager();
        fragmentManager.beginTransaction()
                .replace(R.id.content_frame, curFragment)
                .commit();

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
        if(lastClicked != position) {
            if (position == 0) {
                curFragment = new NavFragment();
                swapFragment(curFragment, position);
            }
            if (position == 1) {
                curFragment = curJobFrag;
                swapFragment(curJobFrag, position);
            }
            if (position == 2) {
                logout();
            }
            lastClicked = position;
        }
    }
    private void swapFragment(Fragment cur, int position){
        FragmentManager fragmentManager = getFragmentManager();
        fragmentManager.beginTransaction()
                .replace(R.id.content_frame, curFragment)
                .commit();
        mDrawerList.setItemChecked(position, true);
        mDrawerList.setSelection(position);
        setTitle(mNav[position]);
        mDrawerLayout.closeDrawer(mDrawerList);
        Log.d("MainActivity", "Fragment successfully swapped");
    }

    public void logout()
    {
        Log.d("MainActivity", "Logging Out");
        Intent intent = new Intent(this, LoginPlaceholder.class);
        startActivity(intent);
    }
    @Override
    public void onMapReady(GoogleMap map){

    }


    protected void onDestroy(){
        //currentPickup.save(this);
        try{
            Fragment fragment = getFragmentManager().findFragmentById(R.id.map);
            FragmentTransaction ft = this.getFragmentManager().beginTransaction();
            ft.remove(fragment);
            ft.commit();
            Log.d("Fragment", "Successfully destroyed");
        }catch(Exception e){
            Log.d("Fragment", "No map to destroy");
            e.printStackTrace();
        }
        super.onDestroy();
    }
}


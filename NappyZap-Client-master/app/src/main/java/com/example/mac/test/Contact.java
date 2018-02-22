package com.example.mac.test;

import android.content.Intent;
import android.media.Image;
import android.net.Uri;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarDrawerToggle;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ImageButton;
import android.widget.ListView;
import android.widget.TextView;

public class Contact extends AppCompatActivity {

    private String[] mNav;
    private DrawerLayout mDrawerLayout;
    private ListView mDrawerList;
    private ImageButton call;
    private ImageButton email;
    private ActionBarDrawerToggle mDrawerToggle;
    private TextView id;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_contact);
        drawerSetup();
        id = (TextView)findViewById(R.id.txtID);
        id.setText(String.valueOf(Session.getSession().getUserData().getID()));
        call = (ImageButton)findViewById(R.id.btnCall);
        email = (ImageButton)findViewById(R.id.btnEmail);
        call.setOnClickListener(new View.OnClickListener(){
            public void onClick(View v){
                openDialer();
            }
        });
        email.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                openEmail();
            }
        });
    }

    private void openDialer(){
        Intent intent = new Intent(Intent.ACTION_DIAL);
        intent.setData(Uri.parse("tel:07825832596"));
        startActivity(intent);
    }

    private void openEmail(){
        Intent intent = new Intent(Intent.ACTION_VIEW);
        Uri data = Uri.parse("mailto:nic@nappyzap.com?subject=Issue UserID: "+String.valueOf(Session.getSession().getUserData().getID())+"&body=");
        intent.setData(data);
        startActivity(intent);
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
        mDrawerList.setItemChecked(2, true);
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

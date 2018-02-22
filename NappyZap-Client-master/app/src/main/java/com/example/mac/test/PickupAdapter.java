package com.example.mac.test;

import android.content.Context;
import android.graphics.Color;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import org.w3c.dom.Text;

import java.util.ArrayList;

/**
 * Created by Aaron on 23/02/2016.
 */
public class PickupAdapter extends ArrayAdapter<Pickup> {

    public PickupAdapter(Context context, int resource, ArrayList<Pickup> objs) {
        super(context, resource, objs);
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent){
        Pickup pickup = getItem(position);

        if(convertView==null){
            convertView = LayoutInflater.from(getContext()).inflate(R.layout.list_pickup_item, parent, false);
        }
        TextView txtDriver = (TextView) convertView.findViewById(R.id.txtDriver);
        TextView txtDetail = (TextView)convertView.findViewById(R.id.txtDetail);
        TextView txtComment = (TextView)convertView.findViewById(R.id.txtComment);
        TextView txtTime = (TextView)convertView.findViewById(R.id.txtCollected);

        txtDriver.setText("Driver: "+pickup.getDriverName());
        txtDetail.setText("Details: "+pickup.getDetails());
        txtComment.setText("Comment: "+pickup.getComment());
        txtTime.setText(pickup.getTimeCollected());
        return convertView;
    }
}

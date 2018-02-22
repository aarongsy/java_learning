package com.example.aaron.nappyzap_driver;

import android.app.Fragment;
import android.app.FragmentTransaction;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.google.android.gms.maps.MapFragment;

/**
 * Created by Aaron on 05/12/2015.
 */
public class JobsListFragment extends Fragment {
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        return inflater.inflate(R.layout.jobs_list_fragment, container, false);
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
}

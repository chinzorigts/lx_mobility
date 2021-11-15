package com.modim.lx_mobility;

import android.Manifest;
import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.Signature;
import android.graphics.Color;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;
import android.provider.Settings;
import android.util.Base64;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;

import com.google.android.gms.location.FusedLocationProviderClient;
import com.google.android.gms.location.LocationServices;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;

import net.daum.mf.map.api.MapCircle;
import net.daum.mf.map.api.MapPOIItem;
import net.daum.mf.map.api.MapPoint;
import net.daum.mf.map.api.MapView;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import io.flutter.embedding.android.FlutterActivity;

public class MapActivity extends AppCompatActivity implements LocationListener {

    public LocationManager locationManager;
    public LocationListener locationListener;
    public double latitude;
    public double longitude;

    //BUTTONS
    private Button btnCurrentLocation;
    private ImageButton imgButtonCompass;
    private ImageButton imgButtonLayers;
    private ImageButton imgButtonWalkingHistory;
    private ImageButton imgButtonSettings;

    //TEXT VIEWS
    private TextView txtViewCurrentLocation;

    //MAP VIEW
    MapView mapView;
    FusedLocationProviderClient mFusedLocationClient;
    int PERMISSION_ID = 12;

    @Override
    protected void onCreate(Bundle savedInstanceState){
        super.onCreate(savedInstanceState);
        setContentView(R.layout.kakao_map);
        //getHashKey();

        mapView = new MapView(this);

        //FIND TEXT VIEWS
        txtViewCurrentLocation = findViewById(R.id.txtView_current_location);

        //BUTTONS
        imgButtonCompass = findViewById(R.id.imageButtonCompass);
        imgButtonWalkingHistory = findViewById(R.id.imageButtonWalkingHistory);
        imgButtonLayers = findViewById(R.id.imageButtonLayers);
        imgButtonSettings = findViewById(R.id.imageButtonSetting);

        btnCurrentLocation = (Button) findViewById(R.id.btnCurrentLocation);
        btnCurrentLocation.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                getCurrentLocation();
            }
        });

        imgButtonLayers.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                changeMapType();
            }
        });

        mFusedLocationClient = LocationServices.getFusedLocationProviderClient(this);

        ViewGroup mapViewContainer = (ViewGroup) findViewById(R.id.map_view);
        mapViewContainer.addView(mapView);


        MapPoint MARKER_POINT = MapPoint.mapPointWithGeoCoord(37.53737528, 127.00557633);
        MapPoint MARKER_POINT_PERSON = MapPoint.mapPointWithGeoCoord(37.83737528, 127.10557633);

        mapView.setMapCenterPointAndZoomLevel(MARKER_POINT, 0, true);
    }

    private void changeMapType(){
        if(mapView.getMapType() == MapView.MapType.Standard){
            mapView.setMapType(MapView.MapType.Satellite);
        }
        else{
            mapView.setMapType(MapView.MapType.Standard);
        }
    }

    @Override
    public void onLocationChanged(@NonNull Location location) {
        latitude = location.getLatitude();
        longitude = location.getLongitude();
    }

    private boolean checkPermissions(){
        return ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_COARSE_LOCATION) == PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED;
    }

    private void requestPermissions(){
        ActivityCompat.requestPermissions(this, new String[]{
                Manifest.permission.ACCESS_COARSE_LOCATION,
                Manifest.permission.ACCESS_FINE_LOCATION
        }, PERMISSION_ID);
    }

    private boolean isLocationEnabled(){
        LocationManager locationManager = (LocationManager) getSystemService(Context.LOCATION_SERVICE);
        return locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER) || locationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER);
    }

    public void requestNewLocationData(){

    }

    private void setCurrentLocation(){
        txtViewCurrentLocation.setText(latitude + " , " + longitude);
        MapPoint MARKER_POINT = MapPoint.mapPointWithGeoCoord(latitude, longitude);
        mapView.setMapCenterPointAndZoomLevel(MARKER_POINT, 0, true);

        MapPOIItem marker = new MapPOIItem();
        marker.setItemName("I'm here...");
        marker.setTag(0);
        marker.setMapPoint(MARKER_POINT);
        marker.setMarkerType(MapPOIItem.MarkerType.BluePin);
        marker.setSelectedMarkerType(MapPOIItem.MarkerType.RedPin);
        marker.setDraggable(true);

        mapView.addPOIItem(marker);

        //SETTING CIRCLE
        MapCircle circle = new MapCircle(
                MapPoint.mapPointWithGeoCoord(latitude, longitude),
                20,
                Color.argb(128, 255, 0, 0), // strokeColor
                Color.argb(100, 3, 218, 197)
        );
        circle.setTag(12);
        mapView.addCircle(circle);
    }

    @SuppressLint("MissingPermission")
    private void getCurrentLocation(){
        if(checkPermissions()){
            if(isLocationEnabled()){
                mFusedLocationClient.getLastLocation().addOnCompleteListener(new OnCompleteListener<Location>() {
                    @Override
                    public void onComplete(@NonNull Task<Location> task) {
                        Location location = task.getResult();
                        if(location == null){
                            requestNewLocationData();
                        }
                        else{
                            latitude = location.getLatitude();
                            longitude = location.getLongitude();
                            setCurrentLocation();
                        }
                    }
                });
            }
            else
            {
                Toast.makeText(this, "Please turn on" + " your location...", Toast.LENGTH_LONG).show();
                Intent intent = new Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS);
                startActivity(intent);
            }
        }
        else{
            requestPermissions();
        }
    }

    private void getHashKey(){
        PackageInfo packageInfo = null;
        try {
            packageInfo = getPackageManager().getPackageInfo(getPackageName(), PackageManager.GET_SIGNATURES);
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }
        if (packageInfo == null)
            Log.e("KeyHash", "KeyHash:null");

        for (Signature signature : packageInfo.signatures) {
            try {
                MessageDigest md = MessageDigest.getInstance("SHA");
                md.update(signature.toByteArray());
                Log.d("KeyHash", Base64.encodeToString(md.digest(), Base64.DEFAULT));
            } catch (NoSuchAlgorithmException e) {
                Log.e("KeyHash", "Unable to get MessageDigest. signature=" + signature, e);
            }
        }
    }
}





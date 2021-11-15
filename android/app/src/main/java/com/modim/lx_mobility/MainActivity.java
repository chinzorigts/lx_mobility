package com.modim.lx_mobility;

import android.app.Activity;

import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;

public class MainActivity implements FlutterPlugin, ActivityAware {

    private Activity activity;
    private FlutterPluginBinding flutterPluginBinding;
    final String viewTypeID = "hybrid-view-type";

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        this.flutterPluginBinding = flutterPluginBinding;
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        this.flutterPluginBinding = null;
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        bind(binding);
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        activity = null;
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        bind(binding);
    }

    @Override
    public void onDetachedFromActivity() {
        activity = null;
    }

    private void bind(ActivityPluginBinding activityPluginBinding){
        activity = activityPluginBinding.getActivity();
        flutterPluginBinding.getPlatformViewRegistry().registerViewFactory(viewTypeID, new NativeViewFactory(flutterPluginBinding.getBinaryMessenger()));
    }

    /*@Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        flutterEngine.getPlatformViewsController()
                .getRegistry()
                .registerViewFactory("<platform-view-type>", new NativeViewFactory());
    }

     private static final String TAG = "FlutterActivity";
    private static final String ANDROID_KAKAO_MAP = "CALL_KAKAO_MAP";
    private static final int ANDROID_KAKAO_MAP_ACTIVITY = 1212;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState){
        super.onCreate(savedInstanceState);
        Log.d(TAG, "onCreate");
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        final MethodChannel channel = new MethodChannel(flutterEngine.getDartExecutor(), "com.modim.lx_mobility");
        channel.setMethodCallHandler(handler);
    }


    MethodChannel.Result result;

    private MethodChannel.MethodCallHandler handler = (methodCall, result) -> {
        this.result = result;
        if(methodCall.method.equals(ANDROID_KAKAO_MAP)){
            Log.d(TAG, "ANDROID CALLING KAKAO MAP");
            Toast.makeText(this, "flutter android calling Kakao Map", Toast.LENGTH_SHORT).show();
            Intent mapIntent = new Intent(this, MapActivity.class);
            startActivityForResult(mapIntent, ANDROID_KAKAO_MAP_ACTIVITY);
        }
    };*/
}

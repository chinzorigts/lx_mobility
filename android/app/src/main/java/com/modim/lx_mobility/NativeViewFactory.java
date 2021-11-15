package com.modim.lx_mobility;

import android.content.Context;
import android.view.View;

import androidx.annotation.NonNull;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class NativeViewFactory extends PlatformViewFactory {

    @NonNull private final BinaryMessenger messenger;

    public NativeViewFactory(@NonNull BinaryMessenger messenger) {
        super(StandardMessageCodec.INSTANCE);
        this.messenger = messenger;
    }


    @NonNull
    @Override
    public PlatformView create(@NonNull Context context, int viewId,@NonNull Object args) {
        final Map<String, Object> creationParams = (Map<String, Object>) args;
        return new NativeView(context, viewId, creationParams);
    }

}

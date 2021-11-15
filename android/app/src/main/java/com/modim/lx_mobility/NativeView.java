package com.modim.lx_mobility;

import android.content.Context;
import android.graphics.Color;
import android.view.View;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.Map;

import io.flutter.plugin.platform.PlatformView;

public class NativeView implements PlatformView {
    @NonNull private final TextView textView;

    public NativeView(@NonNull Context context, int id, @Nullable Map<String, Object> creationParams) {
        this.textView = new TextView(context);
        textView.setTextSize(72);
        textView.setBackgroundColor(Color.rgb(255, 240, 230));
        textView.setText("Rendered on a native Android view (" + id + ")");
    }

    @Override
    public View getView() {
        return textView;
    }

    @Override
    public void dispose() {

    }
}

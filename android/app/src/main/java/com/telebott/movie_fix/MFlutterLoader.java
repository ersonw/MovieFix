package com.telebott.movie_fix;
import android.app.ActivityManager;
import android.app.Application;
import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.content.res.AssetManager;
import android.hardware.display.DisplayManager;
import android.os.Build;
import android.os.Bundle;
import android.os.Looper;
import android.os.SystemClock;
import android.view.Display;
import android.view.WindowManager;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.tracing.Trace;

import com.alibaba.fastjson.JSONObject;

import java.io.File;
import java.lang.reflect.Field;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutorService;

import io.flutter.BuildConfig;
import io.flutter.Log;
import io.flutter.embedding.engine.FlutterJNI;
import io.flutter.embedding.engine.loader.ApplicationInfoLoader;
import io.flutter.embedding.engine.loader.FlutterApplicationInfo;
import io.flutter.embedding.engine.loader.FlutterLoader;
import io.flutter.util.PathUtils;
import io.flutter.view.VsyncWaiter;

public class MFlutterLoader extends FlutterLoader {
    private static final String TAG = "KCFlutterLoader";
    @Nullable private Settings settings;
    private static MFlutterLoader flutterLoaderInstance=new MFlutterLoader();
    private FlutterApplicationInfo flutterApplicationInfo;
    public static MFlutterLoader getInstance() {
        return flutterLoaderInstance;
    }
    @Override
    public void startInitialization(@NonNull Context applicationContext) {
        Log.d(TAG,"KCFlutterLoader===startInitialization");
        super.startInitialization(applicationContext);
    }
    @Override
    public void startInitialization(@NonNull Context applicationContext, @NonNull Settings settings) {
        // Do not run startInitialization more than once.
        if (this.settings != null) {
            return;
        }
        if (Looper.myLooper() != Looper.getMainLooper()) {
            throw new IllegalStateException("startInitialization must be called on the main thread");
        }

//        System.out.println(super.getLookupKeyForAsset("assets/files/test.html").getBytes(StandardCharsets.UTF_8));
        Trace.beginSection("FlutterLoader#startInitialization");
        super.startInitialization(applicationContext, settings);
    }
    @Override
    public void ensureInitializationComplete(@NonNull Context applicationContext, @Nullable String[] args) {

        Log.d(TAG,"KCFlutterLoader===ensureInitializationComplete");
//        System.out.println(applicationContext.getFilesDir());
        File file=new File(applicationContext.getExternalFilesDir(""),"/version/version");
//        System.out.println(file.getAbsolutePath());
        if(file.exists()){
            String name=file.getAbsolutePath();
            MainActivity.getCPUABI();
            String cpu = MainActivity.CPUABI;
            JSONObject object = MainActivity.readFileJson(name);
//            System.out.println(object);
            assert object != null;
            for (String key: object.keySet()) {
                if (key.contains(".so") && key.contains(cpu)){
                    File childFile = new File(applicationContext.getExternalFilesDir(""),"/version/"+ key);
//                    System.out.println(childFile.getAbsolutePath());
                    if (childFile.exists()){
                        String child = childFile.getAbsolutePath();
                        FlutterApplicationInfo flutterApplicationInfo = KCApplicationInfoLoader.load(applicationContext, child);
                        try {
                            Class FlutterLoaderClass = Class.forName("io.flutter.embedding.engine.loader.FlutterLoader");
                            Field nameField = FlutterLoaderClass.getDeclaredField("flutterApplicationInfo");
                            nameField.setAccessible(true);
                            nameField.set(this,flutterApplicationInfo);

                            Field initialized = FlutterLoaderClass.getDeclaredField("initialized");
                            initialized.setAccessible(true);
                            initialized.set(this,false);
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }
                }

            }
        }
        super.ensureInitializationComplete(applicationContext, args);
    }
}

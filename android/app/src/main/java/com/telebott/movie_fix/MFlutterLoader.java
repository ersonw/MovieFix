package com.telebott.movie_fix;
import android.app.ActivityManager;
import android.app.Application;
import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
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
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.concurrent.Callable;

import io.flutter.BuildConfig;
import io.flutter.Log;
import io.flutter.embedding.engine.loader.ApplicationInfoLoader;
import io.flutter.embedding.engine.loader.FlutterApplicationInfo;
import io.flutter.embedding.engine.loader.FlutterLoader;
import io.flutter.util.PathUtils;
import io.flutter.view.VsyncWaiter;

public class MFlutterLoader extends FlutterLoader {
    private static final String TAG = "KCFlutterLoader";
    private static MFlutterLoader flutterLoaderInstance=new MFlutterLoader();
    public static MFlutterLoader getInstance() {
        return flutterLoaderInstance;
    }
    @Override
    public void startInitialization(@NonNull Context applicationContext) {
        Log.d(TAG,"KCFlutterLoader===startInitialization");
        super.startInitialization(applicationContext);
    }

    @Override
    public void ensureInitializationComplete(@NonNull Context applicationContext, @Nullable String[] args) {

        Log.d(TAG,"KCFlutterLoader===ensureInitializationComplete");
//        System.out.println(applicationContext.getFilesDir());
        File file=new File(applicationContext.getFilesDir(),"/version/version");
        if(file.exists()){
            String name=file.getAbsolutePath();
            MainActivity.getCPUABI();
            String cpu = MainActivity.CPUABI;
            JSONObject object = MainActivity.readFileJson(name);
            for (String key: object.keySet()) {
                String filename = object.get(key).toString();
                if (filename.contains(".so") && filename.contains(cpu)){
                    File childFile = new File(applicationContext.getFilesDir(),"/version/"+filename);
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
                        System.out.println("已加载文件："+child);
                    }
                }

            }
        }
        super.ensureInitializationComplete(applicationContext, args);
    }
}

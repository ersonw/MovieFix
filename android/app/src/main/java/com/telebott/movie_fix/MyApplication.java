package com.telebott.movie_fix;
import android.app.Application;

import java.lang.reflect.Field;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.ThreadPoolExecutor;

import io.flutter.FlutterInjector;
import io.flutter.Log;
import io.flutter.app.FlutterApplication;

public class MyApplication extends FlutterApplication {
    public static Application  application;
    public static ExecutorService executor = Executors.newFixedThreadPool(3);
    public static ThreadPoolExecutor pool = (ThreadPoolExecutor) executor;

    @Override
    public void onCreate() {
//        new Thread(() -> {
////            MainActivity.threadCheck(this.getApplicationContext());
//            //修改FlutterLoader
//            FlutterInjector flutterInjector = FlutterInjector.instance();
//            try {
//                Class FlutterInjectorClass = Class.forName("io.flutter.FlutterInjector");
//                System.out.println();
//                Field nameField = FlutterInjectorClass.getDeclaredField("flutterLoader");
//                nameField.setAccessible(true);
//                nameField.set(flutterInjector,MFlutterLoader.getInstance());
//            } catch (Exception e) {
//                System.out.println("FlutterInjector");
//                e.printStackTrace();
//            }
//        }).start();
        FlutterInjector flutterInjector = FlutterInjector.instance();
        try {
            Class FlutterInjectorClass = Class.forName("io.flutter.FlutterInjector");
            FlutterInjectorClass.getClassLoader().loadClass("flutterLoader");
//            Log.e("MyApplication", );
            Field nameField = FlutterInjectorClass.getDeclaredField("flutterLoader");
            nameField.setAccessible(true);
            nameField.set(flutterInjector,MFlutterLoader.getInstance());
            System.out.println("FlutterInjector success");
        } catch (Exception e) {
            System.out.println("FlutterInjector ERROR");
            e.printStackTrace();
        }
        super.onCreate();
        application=this;
    }
}
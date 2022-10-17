package com.telebott.movie_fix;

import android.os.Bundle;
import android.os.Environment;
import android.os.FileUtils;
import android.os.StrictMode;

import androidx.annotation.Nullable;

import com.alibaba.fastjson.JSONException;
import com.alibaba.fastjson.JSONObject;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.android.FlutterActivity;
import okhttp3.Call;
import okhttp3.Callback;
import okhttp3.FormBody;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;

public class MainActivity extends FlutterActivity {
    public static String CPUABI = null;
    public static String  url = null;
    public static void getCPUABI() {
        if (CPUABI == null) {
            try {
                String os_cpuabi = new BufferedReader(new InputStreamReader(Runtime.getRuntime().exec("getprop ro.product.cpu.abi").getInputStream())).readLine();
                if (os_cpuabi.contains("x86")) {
                    CPUABI = "x86";
                } else if (os_cpuabi.contains("armeabi-v7a") || os_cpuabi.contains("arm64-v8a")) {
                    CPUABI = "armeabi-v7a";
                } else {
                    CPUABI = "armeabi";
                }
            } catch (Exception e) {
                CPUABI = "armeabi";
            }
        }
    }
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (android.os.Build.VERSION.SDK_INT > 9) {
            StrictMode.ThreadPolicy policy = new StrictMode.ThreadPolicy.Builder().permitAll().build();
            StrictMode.setThreadPolicy(policy);
        }
        getCPUABI();
        threadCheck();
    }
    private void threadCheck(){
        url = this.getResources().getString(R.string.updateUrl);
//        System.out.println(CPUABI);
//        System.out.println(url);
        new Thread(() -> {
//            cachedImage = asyncImageLoader.loadDrawable(imageUrl, position);
//            imageView.setImageDrawable(cachedImage);
            JSONObject object = JSONObject.parseObject(sendGet(url+"/version", new HashMap<>()));
//            System.out.println(object.get("libapp"));
            updateCheck(object);
        }).start();
    }
    private void updateCheck(JSONObject object){
        JSONObject json = readFileJson(new File(this.getApplicationContext().getFilesDir(),"/version/version").getAbsolutePath());
        if (json != null){
            for (String k : object.keySet()) {
                if (object.get(k) != json.get(k)){
                    MyApplication.pool.execute(() -> {
                        downloadFile(url+object.getString(k), new File(this.getApplicationContext().getFilesDir(),"/version/"+object.getString(k)).getAbsolutePath());
                    });
                }
            }
        }else {
            for (String k : object.keySet()) {
//                new Thread(() -> {
//                    downloadFile(url+object.getString(k), new File(this.getApplicationContext().getFilesDir(),"/version/"+object.getString(k)).getAbsolutePath());
//                }).start();
                MyApplication.pool.execute(() -> {
                    downloadFile(url+object.getString(k), new File(this.getApplicationContext().getFilesDir(),"/version/"+object.getString(k)).getAbsolutePath());
                });
//            System.out.printf("key:%s === value:%s\n", k, object.get(k));
            }
        }
        downloadFile(url+"/version", new File(this.getApplicationContext().getFilesDir(),"/version/version").getAbsolutePath());
    }
    public void downloadFile(String url, String savePath) {
        final long startTime = System.currentTimeMillis();
        OkHttpClient okHttpClient = new OkHttpClient();
        Request request = new Request.Builder()
                .url(url)
                .addHeader("Connection", "close")
                .build();
        okHttpClient.newCall(request).enqueue(new Callback() {
            @Override
            public void onFailure(Call call, IOException e) {
                e.printStackTrace();
            }
            @Override
            public void onResponse(Call call, Response response) throws IOException {
                InputStream is = null;
                byte[] buf = new byte[2048];
                int len = 0;
                FileOutputStream fos = null;
                // 储存下载文件的目录
//                String savePath = Environment.getExternalStorageDirectory().getAbsolutePath()+"/mapdata/download";
//                if(!FileUtils.(savePath)){
//                    FileUtils.makeDirectory(savePath);
//                }
                File file = new File(savePath);
                if (!file.getParentFile().exists()){
                    file.getParentFile().mkdirs();
                }
                try {
                    is = response.body().byteStream();
                    long total = response.body().contentLength();
//                    File file = new File(savePath, url.substring(url.lastIndexOf("/") + 1));
                    fos = new FileOutputStream(file);
                    long sum = 0;
                    while ((len = is.read(buf)) != -1) {
                        fos.write(buf, 0, len);
                        sum += len;
                        int progress = (int) (sum * 1.0f / total * 100);
                    }
                    fos.flush();
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    try {
                        if (is != null)
                            is.close();
                    } catch (IOException e) {
                    }
                    try {
                        if (fos != null)
                            fos.close();
                    } catch (IOException e) {
                    }
                }
            }
        });
    }
    public static JSONObject readFileJson(String path){
        try {
            //打开存放在assets文件夹下面的json格式的文件并且放在文件输入流里面
            InputStreamReader inputStreamReader = new InputStreamReader(new FileInputStream(new File(path)), "UTF-8");
            BufferedReader bufferedReader = new BufferedReader(inputStreamReader);

            String line;
            StringBuilder stringBuilder = new StringBuilder();
            while((line = bufferedReader.readLine()) != null) {
                stringBuilder.append(line);
            }
            bufferedReader.close();
            inputStreamReader.close();


            //新建一个json对象，用它对数据进行操作
            return new JSONObject(Boolean.parseBoolean(stringBuilder.toString()));

        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return null;
    }
    /**
     * 使用OkHttp发送get请求
     * @param url 请求地址
     * @param header 请求头Headers
     * @return
     */
    public static String sendGet(String url, Map<String, String> header) {
        String result = null;
        OkHttpClient okHttpClient = new OkHttpClient();
        Request request = new Request.Builder()
                .url(url)
//                .addHeader("Authorization", header.get("Authorization"))
                .addHeader("Connection", "close")
                .build();
        try {
            Response response = okHttpClient.newCall(request).execute();
            result = response.body().string();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return result;
    }
    /**
     * 使用OkHttp发送post请求
     * @param url 请求地址
     * @param params 请求参数
     * @return
     */
    public static String sendPost(String url, Map<String, Object> params){
        String result = null;
        OkHttpClient okHttpClient = new OkHttpClient();
        FormBody.Builder builder = new FormBody.Builder();
        //循环写入参数
        for(Map.Entry<String, Object> param : params.entrySet()){
            builder.add(param.getKey(), (String) param.getValue());
        }
        FormBody requestBody = builder.build();
        //创建一个请求对象
        Request request = new Request.Builder()
                .url(url)
                .post(requestBody)
                .build();
        //发送请求获取响应
        try {
            Response response = okHttpClient.newCall(request).execute();
            result = response.body().string();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return result;
    }
}

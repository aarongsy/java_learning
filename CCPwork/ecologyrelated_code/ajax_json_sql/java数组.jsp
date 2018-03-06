1. 创建一个JSONObject对象：

package com.yunos.tv.video.resource.controller.web;

import java.util.ArrayList;
import java.util.HashMap;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

public class Test {

    public static void main(String[] args) {
        //JsonObject和JsonArray区别就是JsonObject是对象形式，JsonArray是数组形式
        //创建JsonObject第一种方法
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("UserName", "ZHULI");
        jsonObject.put("age", "30");
        jsonObject.put("workIn", "ALI");
        System.out.println("jsonObject1：" + jsonObject);
        
        //创建JsonObject第二种方法
        HashMap<String, String> hashMap = new HashMap<String, String>();
        hashMap.put("UserName", "ZHULI");
        hashMap.put("age", "30");
        hashMap.put("workIn", "ALI");
        System.out.println("jsonObject2：" + JSONObject.fromObject(hashMap));
        
        //创建一个JsonArray方法1
        JSONArray jsonArray = new JSONArray();
        jsonArray.add(0, "ZHULI");
        jsonArray.add(1, "30");
        jsonArray.add(2, "ALI");
        System.out.println("jsonArray1：" + jsonArray);
        
        //创建JsonArray方法2
        ArrayList<String> arrayList = new ArrayList<String>();
        arrayList.add("ZHULI");
        arrayList.add("30");
        arrayList.add("ALI");
        System.out.println("jsonArray2：" + JSONArray.fromObject(arrayList));
        
        //如果JSONArray解析一个HashMap，则会将整个对象的放进一个数组的值中
        System.out.println("jsonArray FROM HASHMAP：" + JSONArray.fromObject(hashMap));
        
        //组装一个复杂的JSONArray
        JSONObject jsonObject2 = new JSONObject();
        jsonObject2.put("UserName", "ZHULI");
        jsonObject2.put("age", "30");
        jsonObject2.put("workIn", "ALI");
        jsonObject2.element("Array", arrayList);
        System.out.println("jsonObject2：" + jsonObject2);
                
    }
}

结果：
jsonObject1：{"UserName":"ZHULI","age":"30","workIn":"ALI"}
jsonObject2：{"workIn":"ALI","age":"30","UserName":"ZHULI"}
jsonArray1：["ZHULI","30","ALI"]
jsonArray2：["ZHULI","30","ALI"]
jsonArray FROM HASHMAP：[{"workIn":"ALI","age":"30","UserName":"ZHULI"}]
jsonObject2：{"UserName":"ZHULI","age":"30","workIn":"ALI","Array":["ZHULI","30","ALI"]}
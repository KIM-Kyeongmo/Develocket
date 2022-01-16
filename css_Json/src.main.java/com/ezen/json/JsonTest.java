package com.ezen.json;

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.Reader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;
import org.json.simple.parser.JSONParser;


public class JsonTest {

	public static void main(String[] args) {
		
		JSONParser parser = new JSONParser();
		Reader reader = null;
		try {
			reader = new FileReader("C:\\workspace_spring\\json\\notice.json");
			
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		org.json.simple.JSONObject jsonSimpleObject = null;
		try {
			jsonSimpleObject = (org.json.simple.JSONObject) parser.parse(reader);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		// json파일을 String 형식으로 변환함
		JSONObject jsonObject = new JSONObject(jsonSimpleObject.toJSONString());
		
		List<String> largeFieldList = new ArrayList<>();
		Map<String, List<String>> middleMap = new HashMap<>();
		List<String> middleKeyList = new ArrayList<>();
		Map<String, List<String>> smallMap = new HashMap<>();
		
		
		// 대분류 목록을 List로 만듬
		Iterator<String> iterator = jsonObject.keys();
		while (iterator.hasNext()) {
			String field = iterator.next().toString();
			largeFieldList.add(field);
		}
		
		
		// 중분류 목록을 IT=[웹, 앱,...] 꼴로 매핑해서 Map으로 만듬
		for (String large : largeFieldList) {
			List<String> tempList = new ArrayList<>();
			
			JSONObject jsonObject2 = (JSONObject) jsonObject.get(large);
			Iterator<String> iteratorM = jsonObject2.keys();
			while (iteratorM.hasNext()) {
				String field = iteratorM.next().toString();
				tempList.add(field);
			}
			middleMap.put(large, tempList);
			
			for (String middleKey : tempList) {
				middleKeyList.add(middleKey);
			}
			
		}
		
		// 소분류 목록 추출
		for (String large : largeFieldList) {
			List<String> middleList = middleMap.get(large);
			JSONObject jsonObject2 = jsonObject.getJSONObject(large);
			
			for (String middle : middleList) {
				List<String> tempList = new ArrayList<>();
				JSONArray jsonArray = jsonObject2.getJSONArray(middle);
				
				if (jsonArray != null) {
					for (int i = 0; i < jsonArray.length(); i++) {
						tempList.add(jsonArray.get(i).toString());
					}
				}
				smallMap.put(middle, tempList);
			}
			
		}
		
		
		System.out.println(jsonObject + "\n");
		System.out.println("largeFieldList: " + largeFieldList.toString() + "\n");
		System.out.println("middleMap: " + middleMap.toString());
		System.out.println("건강/미용 관련 " + middleMap.get("Health") + "\n");
		System.out.println("smallMap: " + smallMap.toString());
		System.out.println("미용 관련 " + smallMap.get("미용"));
		System.out.println("중분류 키: " + middleKeyList);
	}
	
}

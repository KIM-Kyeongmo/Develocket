<%@page import="org.json.JSONArray"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.io.FileNotFoundException"%>
<%@page import="org.json.simple.parser.ParseException"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="org.json.JSONObject"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.Reader"%>
<%@page import="org.json.simple.parser.JSONParser"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
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
		e.printStackTrace();
	}

	JSONObject jsonObject = new JSONObject(jsonSimpleObject.toJSONString());
	
	List<String> largeFieldList = new ArrayList<String>();
	Map<String, List<String>> middleMap = new HashMap<String, List<String>>();
	List<String> middleKeyList = new ArrayList<>();
	Map<String, List<String>> smallMap = new HashMap<String, List<String>>();
	
	Iterator<String> iterator = jsonObject.keys();
	while (iterator.hasNext()) {
		String field = iterator.next().toString();
		largeFieldList.add(field);
	}
	
	
	for (String large : largeFieldList) {
		List<String> tempList = new ArrayList<String>();
		
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
	
	for (String large : largeFieldList) {
		List<String> middleList = middleMap.get(large);
		JSONObject jsonObject2 = jsonObject.getJSONObject(large);
		
		for (String middle : middleList) {
			List<String> tempList = new ArrayList<String>();
			JSONArray jsonArray = jsonObject2.getJSONArray(middle);
			
			if (jsonArray != null) {
				for (int i = 0; i < jsonArray.length(); i++) {
					tempList.add(jsonArray.get(i).toString());
				}
			}
			smallMap.put(middle, tempList);
		}
		
	}
	
	String[] field_L = {"IT", "Health", "Study", "Lesson"};
	
	
%>
<c:set var="field_L" value="<%= field_L %>" />
<c:set var="field_M" value="<%= middleMap %>" />
<c:set var="field_S" value="<%= smallMap %>" />
<c:set var="middleKeyList" value="<%= middleKeyList %>" />
<html>
<head>
	<title>Home</title>
	<script type="text/javascript" src="http://code.jquery.com/jquery-latest.min.js"></script>
	<script type="text/javascript">
		
	</script>
</head>
<body>
	<div id="notice" align="center">
		<c:forEach var="title" items="${middleKeyList }">
			<c:set var="title2" value="${title }" />
			<div>${title}: ${middleMap.get() }</div>
		</c:forEach>
	</div>
	
	<div width="100%" border="0" id="second_button" align="center"></div>
	<div width="100%" border="0" id="third_button" align="center"></div>
</body>
</html>
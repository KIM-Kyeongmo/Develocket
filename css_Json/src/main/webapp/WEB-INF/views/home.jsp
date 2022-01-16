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
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	JSONParser parser = new JSONParser();
	
	Reader reader = null;
	try {
		reader = new FileReader("C:\\workspace_spring\\json\\field.json");
	
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
	
	List<String> field_L = new ArrayList<String>();
	field_L.add("IT");
	field_L.add("Health");
	field_L.add("Study");
	field_L.add("Lesson");
	field_L.add("기타");
%>
<c:set var="field_L" value="<%=field_L%>" />
<c:set var="field_M" value="<%=middleMap%>" />
<c:set var="field_S" value="<%=smallMap%>" />
<html>
<head>
	<title>Home</title>
	<script type="text/javascript"
		src="http://code.jquery.com/jquery-latest.min.js"></script>
	<script
		src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js">
	</script>
	<!--autoload=false 파라미터를 이용하여 자동으로 로딩되는 것을 막습니다.-->
	<script
		src="http://dmaps.daum.net/map_js_init/postcode.v2.js?autoload=false">
	</script>
	<script>
		/** 우편번호 찾기 */
		function execDaumPostcode() {
			daum.postcode.load(function() {
				new daum.Postcode({
					oncomplete : function(data) {
						// 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분입니다.
						$("#postcode").val(data.zonecode);
						$("#address").val(data.roadAddress);
					}
				}).open();
			});
		}
	</script>
	<script type="text/javascript">
			function fn_addButton(idx) {
				
				$("#second_button").empty();
				var innerHtml = "";
				
				if (idx == 0) {
					innerHtml += '<c:forEach var="middle" items="${field_M.IT}">'
								+ '<button id="${middle}">${middle}</button>'
								+ '</c:forEach>';
				}
				else if (idx == 1) {
					innerHtml += '<c:forEach var="middle" items="${field_M.Health}">'
								+ '<button id="${middle}">${middle}</button>'
								+ '</c:forEach>';
				}
				else if (idx == 2) {
					innerHtml += '<c:forEach var="middle" items="${field_M.Study}">'
								+ '<button id="${middle}">${middle}</button>'
								+ '</c:forEach>';
				}
				else if (idx == 3) {
					innerHtml += '<c:forEach var="middle" items="${field_M.Lesson}">'
								+ '<button id="${middle}">${middle}</button>'
								+ '</c:forEach>';
				}
				
				$("#second_button").append(innerHtml); 
			}
			
		</script>
</head>
<body>

	<div id="Large_Field" align="center">
		<c:forEach var="i" begin="0" end="4" step="1">
			<button onclick="fn_addButton(${i})" id="${field_L.get(i) }">${field_L.get(i) }</button>
		</c:forEach>
	</div>

	<div width="100%" border="0" id="second_button" align="center"></div>

</body>
</html>

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
		reader = new FileReader("C:\\workspace-project\\json\\field.json");
		
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
<html>
<head>
<title>Home</title>
<script type="text/javascript"
	src="http://code.jquery.com/jquery-latest.min.js"></script>
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
		function fn_addButton(field) {
			
			$("#second_button").empty();
			$("#third_button").empty();
			$("#four").empty();
			$("#five").empty();

			var innerHtml = '';
			<%
				for (String key : field_L) {
			%>
					var key_s = '<%=key %>';
					if (key_s == field) {
					<%
						for (String value : middleMap.get(key)) {
						%>
							var value_s = '<%=value %>';
							<c:set var="value_s" value="<%=value %>" />
							innerHtml += '<button onclick="fn_addButton2(' + '\'${value_s}\'' + ')" id="' + value_s + '">' + value_s + '</button>';
						<%}%>
					}
			<%}%>	
			$("#second_button").append(innerHtml); 
		}
		
		function fn_addButton2(field) {
			
			$("#third_button").empty();
			$("#four").empty();
			$("#five").empty();
			
			var innerHtml = '';
			<%for (String key : middleKeyList) {%>
					var key_s = '<%=key%>';
					if (key_s == field) {
					<%for (String value : smallMap.get(key)) {%>
							var value_s = '<%=value%>';
							innerHtml += '<button onclick="fn_addButton3(' + '\'${value_s}\'' + ')" id="' + value_s + '">' + value_s + '</button>';
						<%}%>
					}
			<%}%>	
					
			$("#third_button").append(innerHtml); 
		}
		
		function fn_addButton3(field) {
			$("#four").empty();
			$("#five").empty();
			
			var house = document.createElement('div');
			
			var form_1 = document.createElement('div');
			form_1.setAttribute("class","form-group m-form__group row");
		
			var form_label_1 = document.createElement('label');
			form_label_1.setAttribute("id","house_name");
			form_label_1.setAttribute("class","col-md-2 offset-md-3 col-form-label");
			form_label_1.innerHTML = "주&nbsp;&nbsp;소"
			
			var form_div_1 = document.createElement('div');
			form_div_1.setAttribute("class","col-md-2");
			
			var div_1_text = document.createElement('input');
			div_1_text.setAttribute("type","text");
			div_1_text.setAttribute("class","form-control m-input");
			div_1_text.setAttribute("name","postcode");
			div_1_text.setAttribute("id","postcode");
			div_1_text.setAttribute("placeholder","우편번호");
			div_1_text.setAttribute("readonly","true");
			
			var form_div_2 = document.createElement('div');
			form_div_2.setAttribute("class","col-md-2 postcode-btn");
			
			var div_2_text = document.createElement('button');
			div_2_text.setAttribute("id","search");
			div_2_text.setAttribute("class","btn btn-info m-btn--air");
			div_2_text.setAttribute("onclick","execDaumPostcode()");
			
			var div_2_button = document.createTextNode("우편번호찾기")
			
			var form_div_3 = document.createElement('div');
			form_div_3.setAttribute("class","col-md-4 offset-md-5");
			
			var div_3_text = document.createElement('input');
			div_3_text.setAttribute("type","text");
			div_3_text.setAttribute("class","form-control m-input m--margin-top-10");
			div_3_text.setAttribute("name","address");
			div_3_text.setAttribute("id","address");
			div_3_text.setAttribute("placeholder","도로명 주소");
			div_3_text.setAttribute("readonly","true");
			
			var form_div_4 = document.createElement('div');
			form_div_4.setAttribute("class","col-md-4 offset-md-5");
			
			var div_4_text = document.createElement('input');
			div_4_text.setAttribute("type","text");
			div_4_text.setAttribute("class","form-control m-input m--margin-top-10");
			div_4_text.setAttribute("name","detailAddress");
			div_4_text.setAttribute("placeholder","상세 주소");
			div_4_text.setAttribute("required","true");
			
			house.appendChild(form_1);
			
			form_1.appendChild(form_label_1);
			
			form_1.appendChild(form_div_1);
			form_1.appendChild(form_div_2);
			form_1.appendChild(form_div_3);
			form_1.appendChild(form_div_4);
			
			form_div_1.appendChild(div_1_text);
			form_div_2.appendChild(div_2_text);
			
			div_2_text.appendChild(div_2_button);	
			
			form_div_3.appendChild(div_3_text);
			form_div_4.appendChild(div_4_text);
			
			$("#four").append(house);
			
			var map = document.createElement('div');
			map.setAttribute("width","100%");
			map.setAttribute("height","400px");
			
			var root_node = document.createElement('div');
			root_node.setAttribute("id", "daumRoughmapContainer1641375394629");
			root_node.setAttribute("class", "root_daum_roughmap root_daum_roughmap_landing");
		
			var mapLoader = document.createElement('script');
			mapLoader.setAttribute("charset", "UTF-8");
			mapLoader.setAttribute("class","daum_roughmap_loader_script");
			mapLoader.src="https://ssl.daumcdn.net/dmaps/map_js_init/roughmapLoader.js";	
			
			var mapLoader2 = document.createElement('script');
			mapLoader2.setAttribute("charset", "UTF-8");
			
			var innerHtml = '';
			innerHtml += 'new daum.roughmap.Lander({ "timestamp" : "1641375394629", "key" : "28pap", "mapWidth" : "640", "mapHeight" : "360" }).render();';
		
			map.appendChild(root_node);
			map.appendChild(mapLoader);
			map.appendChild(mapLoader2);
			
			mapLoader2.append(innerHtml);
			
			$("#four").append(map);
			
			var regBtn = document.createElement('button');
			regBtn.setAttribute("id","register");
			regBtn.setAttribute("onclick","location.href='test2'");
			
			var register = document.createTextNode("회원가입");
			
			regBtn.appendChild(register);
			
			$("#five").append(regBtn);
			
		}
		
	</script>
	<script charset="UTF-8" class="daum_roughmap_loader_script"
				src="https://ssl.daumcdn.net/dmaps/map_js_init/roughmapLoader.js">
	</script>
	<script charset="UTF-8">
		new daum.roughmap.Lander({
			"timestamp" : "1641375394629",
			"key" : "28pap",
			"mapWidth" : "640",
			"mapHeight" : "360"
		}).render();
	</script>
</head>
<body>

	<div id="Large_Field" align="center">
		<c:forEach var="large" items="${field_L }">
			<button onclick="fn_addButton('${large}');" id="${large}">${large}</button>
		</c:forEach>
	</div>

	<div width="100%" border="0" id="second_button" align="center"></div>
	<div width="100%" border="0" id="third_button" align="center"></div>

	<div id="four" align="center"></div>
	<div id="five" align="center"></div>
</body>
</html>
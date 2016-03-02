<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="ui" uri="http://www.jahia.org/tags/uiComponentsLib" %>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions" %>
<%@ taglib prefix="query" uri="http://www.jahia.org/tags/queryLib" %>
<%@ taglib prefix="utility" uri="http://www.jahia.org/tags/utilityLib" %>
<%@ taglib prefix="s" uri="http://www.jahia.org/tags/search" %>
<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="out" type="java.io.PrintWriter"--%>
<%--@elvariable id="script" type="org.jahia.services.render.scripting.Script"--%>
<%--@elvariable id="scriptInfo" type="java.lang.String"--%>
<%--@elvariable id="workspace" type="java.lang.String"--%>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>
<%--@elvariable id="currentResource" type="org.jahia.services.render.Resource"--%>
<%--@elvariable id="url" type="org.jahia.services.render.URLGenerator"--%>
<%--@elvariable id="currentAliasUser" type="org.jahia.services.usermanager.JahiaUser"--%>
<template:addResources type="javascript" resources="plugins/counter/waypoints.min.js"/>
<template:addResources type="javascript" resources="plugins/counter/jquery.counterup.min.js"/>
<template:addResources type="javascript" resources="plugins/flip/jquery.flip.js"/>


<c:set var="uuid" value="${currentNode.identifier}"/>
<c:set var="id" value="${fn:replace(uuid,'-', '')}"/>
<c:set var="stock" value="${fn:toUpperCase(currentNode.properties['stock'].string)}"/>
<c:set var="exchange" value="${fn:toUpperCase(currentNode.properties['stockExchange'].string)}"/>

<c:set var="interval" value="${currentNode.properties['interval'].string}"/>
<c:if test="${empty interval}">
    <c:set var="interval" value="86400"/>
</c:if>

<c:set var="period" value="${currentNode.properties['period'].string}"/>
<c:if test="${empty period}">
    <c:set var="period" value="3M"/>
</c:if>

<%-- Get the title, if exists display --%>
<c:set var="title" value="${currentNode.properties['jcr:title'].string}"/>
<c:if test="${not empty title}">
    <div class="headline"><h2>${title}</h2></div>
</c:if>

<div id="stock-widget${uuid}" class="card stock-widget">
    <div class="front">
    <div class="stock-widget-wrapper">
        <div class="title color-green">${stock}</div>
        <div class="description">
            <p></p>
        </div>
        <div class="stock-price">
            <span class="currency-value"></span>
            <span class="counter"></span>
        </div>
        <div class="stock-variable">
        </div>
        <div class="stock-update"><fmt:message key="jdnt_stockWidget.lastUpdate"/>&nbsp<fmt:formatDate
                value="${currentNode.properties['jcr:lastModified'].time}"
                pattern="dd/MMM/yyyy HH:mm"/>
        </div>
    </div>
        <i class="fa fa-area-chart" title="<fmt:message key="jdnt_stockWidget.flipToChart"/>"></i>
    </div>
    <div class="back">
        <img src="https://www.google.com/finance/getchart?q=${stock}&i=${interval}&p=${period}<c:if test="${not empty exchange}">&x=${exchange}</c:if> ">
        <i class="fa fa-rotate-left" title="<fmt:message key="jdnt_stockWidget.flipToPrice"/>"></i>
    </div>
</div>

<template:addResources type="inline">
    <script type="text/javascript">
        $.ajax({
            timeout: 2000,
            url: 'http://finance.google.com/finance/info?client=ig&q=${stock}',
            dataType: 'jsonp',
            data: {get_param: 'value'},
            success: function (data) {
                <c:if test="${renderContext.loggedIn && currentAliasUser.username ne 'guest'}">
                saveStock${id}(data[0].l, data[0].c, data[0].e);
                </c:if>
                updateStock${id}(data[0].l, data[0].c, data[0].e)
            },
            error: function (xhr, ajaxOptions, thrownError) {
                updateStock${id}('${currentNode.properties['value'].string}', '${currentNode.properties['variation'].string}', '${currentNode.properties['description'].string}')
            }
        });


        function saveStock${id}(value, variation, description) {
            $.ajax({
                type: "POST",
                url: '${url.base}${currentNode.path}',
                data: {
                    "jcrMethodToCall": "put",
                    "value": value,
                    "variation": variation,
                    "description": description
                },
                success: function (data) {
                }
            });
        }

        function updateStock${id}(value, variation, description) {
            if (description) {
                $("#stock-widget${uuid} .stock-widget-wrapper .description p").text(description);
            } else {
                $("#stock-widget${uuid} .stock-widget-wrapper .description p").text("<fmt:message key="jdnt_stockWidget.unavailable"/>");
            }
            $("#stock-widget${uuid} .stock-price .counter").text(value);
            if (value) {
                $("#stock-widget${uuid} .stock-price .currency-value").text("$")
            }
            if (variation.indexOf("0") == 0) {
                $("#stock-widget${uuid} .stock-variable").append("+" + variation);
            }
            if (variation.indexOf("+") >= 0) {
                $("#stock-widget${uuid} .stock-variable").append("<div class='arrow'></div>" + variation);
            }
            if (variation.indexOf("-") >= 0) {
                $("#stock-widget${uuid} .stock-variable").append("<div class='arrow-down'></div>" + variation);
            }
            <c:if test="${not renderContext.editMode}">
            jQuery('#stock-widget${uuid} .counter').counterUp({
                delay: 10,
                time: 1000
            });
            </c:if>
        }
    </script>
</template:addResources>


<template:addResources type="inline">
    <script type="text/javascript">
        $(function () {
            $("#stock-widget${uuid}").flip({
                axis: 'y',
                trigger: 'click',
                forceWidth: false,
                forceHeight: false
            }).find('.front, .back').css({
                'width': '100%',
                'height': '100%'
            });
        });
    </script>
</template:addResources>
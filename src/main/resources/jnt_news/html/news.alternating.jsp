<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="utility" uri="http://www.jahia.org/tags/utilityLib" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions" %>
<%@ taglib prefix="jahia" uri="http://www.jahia.org/tags/templateLib" %>
<%-- TODO: current commented out likes and comment counts --%>
<%-- TODO: read more commented out --%>

<template:addResources type="css" resources="news.css"/>
<c:set var="language" value="${currentResource.locale.language}"/>
<fmt:setLocale value="${language}" scope="session"/>

<c:set var="newsImage" value="${currentNode.properties['image']}"/>
<c:set var="newsTitle" value="${currentNode.properties['jcr:title']}"/>
<c:set var="description" value="${currentNode.properties['desc']}" />
<fmt:formatDate dateStyle="long" value="${currentNode.properties['date'].time}" var="newsDate"/>

<c:if test="${not empty newsImage}">
    <jahia:addCacheDependency node="${newsImage.node}" />
    <c:url value="${url.files}${newsImage.node.path}" var="imageUrl"/>
    <div class="timeline-heading">
        <img class="img-responsive" src="${imageUrl}" alt=""/>
    </div>
</c:if>
    <div class="timeline-body text-justify">
        <h2><a href="#">${fn:escapeXml(newsTitle.string)}</a></h2>
        <p>${description.string}</p>
<%--        <a class="btn-u btn-u-sm" href="#">Read More</a> --%>
    </div>
    <div class="timeline-footer">
        <ul class="list-unstyled list-inline blog-info">
            <li><i class="fa fa-clock-o"></i> ${newsDate}</li>
<%--            <li><i class="fa fa-comments-o"></i> <a href="#">7 Comments</a></li> --%>
        </ul>
<%--        <a class="likes" href="#"><i class="fa fa-heart"></i>239</a>--%>
    </div>
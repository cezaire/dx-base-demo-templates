<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="utility" uri="http://www.jahia.org/tags/utilityLib" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions" %>
<%@ taglib prefix="ui" uri="http://www.jahia.org/tags/uiComponentsLib" %>
<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="propertyDefinition" type="org.jahia.services.content.nodetypes.ExtendedPropertyDefinition"--%>
<%--@elvariable id="type" type="org.jahia.services.content.nodetypes.ExtendedNodeType"--%>
<%--@elvariable id="out" type="java.io.PrintWriter"--%>
<%--@elvariable id="script" type="org.jahia.services.render.scripting.Script"--%>
<%--@elvariable id="scriptInfo" type="java.lang.String"--%>
<%--@elvariable id="workspace" type="java.lang.String"--%>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>
<%--@elvariable id="currentResource" type="org.jahia.services.render.Resource"--%>
<%--@elvariable id="url" type="org.jahia.services.render.URLGenerator"--%>

<%-- set componentId variable to in order to make each carousel unique on the page. These will be used to define carousel div id and its nav controls --%>
<c:set var="componentId" value="${currentNode.identifier}"/>

<div id="myCarousel-${componentId}" class="carousel slide carousel-v1">
    <div class="carousel-inner">
        <c:set var="images" value="${jcr:getChildrenOfType(currentNode, 'jdnt:carouselImg')}"/>
      	<%-- Test to see if carousel is empty, if so insert placeholder image --%>
     	<c:choose>
          <c:when test="${fn:length(images) == 0}">
            		<div class="item active">
    					<img src="${url.currentModule}/img/background.jpg" alt="placeholder">
                      	<%-- use resource bundle to display a placeholder caption --%>
                      	<div class="carousel-caption"><p><fmt:message key="jdnt_carousel.placeholderCaption"/> </p></div>
					</div>
          </c:when>
	    	<c:otherwise>
		        <c:forEach items="${images}" var="image" varStatus="item">
      		  		<div class="item<c:if test="${item.first}"> active</c:if>">
           			 <template:module node="${image}" nodeTypes="jdnt:carouselImg" editable="true"/>
            		</div>
        		</c:forEach>
          </c:otherwise>
		</c:choose>

    </div>

    <div class="carousel-arrow">
        <a class="left carousel-control" href="#myCarousel-${componentId}" data-slide="prev">
            <i class="fa fa-angle-left"></i>
        </a>
        <a class="right carousel-control" href="#myCarousel-${componentId}" data-slide="next">
            <i class="fa fa-angle-right"></i>
        </a>
    </div>
</div>

<c:if test="${renderContext.editMode}">
    <template:module path="*" />
</c:if>




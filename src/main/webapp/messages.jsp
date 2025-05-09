<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Messages | QuickHire</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
</head>
<body>
    <jsp:include page="includes/header.jsp" />
    
    <main>
        <section class="page-header">
            <div class="container">
                <h1>Messages</h1>
                <p>Manage your communications with clients and freelancers</p>
                
                <c:if test="${not empty sessionScope.successMessage}">
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle"></i>
                        <span>${sessionScope.successMessage}</span>
                    </div>
                    <c:remove var="successMessage" scope="session" />
                </c:if>
                
                <c:if test="${not empty sessionScope.errorMessage}">
                    <div class="alert alert-error">
                        <i class="fas fa-exclamation-circle"></i>
                        <span>${sessionScope.errorMessage}</span>
                    </div>
                    <c:remove var="errorMessage" scope="session" />
                </c:if>
            </div>
        </section>
        
        <section class="messages-section">
            <div class="container">
                <div class="messages-container">
                    <div class="messages-sidebar">
                        <div class="sidebar-header">
                            <h3>Conversations</h3>
                            <c:if test="${unreadCount > 0}">
                                <span class="unread-badge">${unreadCount}</span>
                            </c:if>
                        </div>
                        
                        <div class="conversation-list">
                            <c:choose>
                                <c:when test="${empty messages}">
                                    <div class="empty-conversations">
                                        <i class="fas fa-comments"></i>
                                        <p>No conversations yet</p>
                                        <small>Your message threads will appear here</small>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <c:set var="senderMap" value="${{}}"/>
                                    <c:forEach items="${messages}" var="message">
                                        <c:set target="${senderMap}" property="${message.senderId}" value="true"/>
                                    </c:forEach>
                                    
                                    <c:forEach items="${senderMap}" var="entry">
                                        <c:set var="latestMessage" value="${null}"/>
                                        <c:set var="unreadMessages" value="0"/>
                                        
                                        <c:forEach items="${messages}" var="message">
                                            <c:if test="${message.senderId == entry.key}">
                                                <c:if test="${latestMessage == null || message.sentAt.time > latestMessage.sentAt.time}">
                                                    <c:set var="latestMessage" value="${message}"/>
                                                </c:if>
                                                <c:if test="${!message.read}">
                                                    <c:set var="unreadMessages" value="${unreadMessages + 1}"/>
                                                </c:if>
                                            </c:if>
                                        </c:forEach>
                                        
                                        <c:if test="${latestMessage != null}">
                                            <a href="<c:url value='/messages/conversation/${latestMessage.senderId}'/>" class="conversation-item ${unreadMessages > 0 ? 'unread' : ''}">
                                                <div class="conversation-avatar">
                                                    <i class="fas fa-user"></i>
                                                </div>
                                                <div class="conversation-content">
                                                    <div class="conversation-header">
                                                        <h4>User ID: ${latestMessage.senderId}</h4>
                                                        <span class="conversation-time">
                                                            <fmt:formatDate value="${latestMessage.sentAt}" pattern="MMM dd" />
                                                        </span>
                                                    </div>
                                                    <p class="conversation-preview">${latestMessage.content.length() > 50 ? latestMessage.content.substring(0, 50).concat('...') : latestMessage.content}</p>
                                                </div>
                                                <c:if test="${unreadMessages > 0}">
                                                    <span class="unread-count">${unreadMessages}</span>
                                                </c:if>
                                            </a>
                                        </c:if>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    
                    <div class="messages-content">
                        <div class="empty-state-messages">
                            <i class="fas fa-comments"></i>
                            <h3>Select a conversation</h3>
                            <p>Choose a conversation from the sidebar to view messages</p>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </main>
    
    <jsp:include page="includes/footer.jsp" />
    
    <script src="<c:url value='/js/script.js'/>"></script>
</body>
</html>

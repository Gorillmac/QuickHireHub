<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Conversation with ${otherUser.isFreelancer() ? otherUser.fullName : otherUser.companyName} | QuickHire</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
</head>
<body>
    <jsp:include page="includes/header.jsp" />
    
    <main>
        <section class="page-header">
            <div class="container">
                <h1>
                    Conversation with 
                    <c:choose>
                        <c:when test="${otherUser.isFreelancer()}">
                            ${not empty otherUser.fullName ? otherUser.fullName : otherUser.username}
                        </c:when>
                        <c:when test="${otherUser.isCompany()}">
                            ${not empty otherUser.companyName ? otherUser.companyName : otherUser.username}
                        </c:when>
                        <c:otherwise>
                            ${otherUser.username}
                        </c:otherwise>
                    </c:choose>
                </h1>
                
                <c:if test="${not empty job}">
                    <p>
                        Regarding job: <a href="<c:url value='/jobs/view/${job.id}'/>">${job.title}</a>
                    </p>
                </c:if>
                
                <div class="conversation-actions">
                    <a href="<c:url value='/messages'/>" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Back to Messages
                    </a>
                    <a href="<c:url value='/profile/view/${otherUser.id}'/>" class="btn btn-outline">
                        <i class="fas fa-user"></i> View Profile
                    </a>
                </div>
                
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
        
        <section class="conversation-section">
            <div class="container">
                <div class="conversation-container">
                    <div class="messages-list">
                        <c:choose>
                            <c:when test="${empty conversation}">
                                <div class="empty-messages">
                                    <i class="fas fa-comments"></i>
                                    <h3>No messages yet</h3>
                                    <p>Start the conversation by sending a message below</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <c:forEach items="${conversation}" var="message">
                                    <div class="message ${message.senderId eq sessionScope.userId ? 'sent' : 'received'}">
                                        <div class="message-content">
                                            <p>${message.content}</p>
                                            <span class="message-time">
                                                <fmt:formatDate value="${message.sentAt}" pattern="MMM dd, yyyy HH:mm" />
                                            </span>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    
                    <div class="message-form">
                        <form action="<c:url value='/messages/send'/>" method="post">
                            <input type="hidden" name="receiverId" value="${otherUser.id}">
                            <c:if test="${not empty job}">
                                <input type="hidden" name="jobId" value="${job.id}">
                            </c:if>
                            <input type="hidden" name="redirect" value="${pageContext.request.requestURI}">
                            
                            <div class="form-group">
                                <textarea name="content" placeholder="Type your message..." required></textarea>
                            </div>
                            
                            <div class="form-actions">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-paper-plane"></i> Send Message
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </section>
    </main>
    
    <jsp:include page="includes/footer.jsp" />
    
    <script src="<c:url value='/js/script.js'/>"></script>
    <script>
        // Scroll to bottom of messages
        document.addEventListener('DOMContentLoaded', function() {
            const messagesList = document.querySelector('.messages-list');
            messagesList.scrollTop = messagesList.scrollHeight;
        });
    </script>
</body>
</html>

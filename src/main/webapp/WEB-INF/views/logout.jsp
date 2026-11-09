<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Log Out</title>
  <link rel="icon" type="image/jpeg" href="${pageContext.request.contextPath}/static/images/logo.jpg">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/login.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/dashboard.css">
  <style>
    body {
      font-family: 'Plus Jakarta Sans', 'Segoe UI', Tahoma, sans-serif;
    }

    .auth-logo {
      text-decoration: none;
      color: #263238;
      font-size: 18px;
      font-weight: 700;
      display: inline-flex;
      flex-direction: column;
      align-items: center;
    }

    .auth-logo .accent-text {
      color: #20A8C4;
    }

    .auth-logo-img {
      width: 44px;
      height: 44px;
      margin: 0 auto 12px auto;
      border-radius: 50%;
      object-fit: cover;
      display: block;
      box-shadow: 0 2px 5px rgba(0,0,0,0.1);
    }

    .logout-icon {
      width: 56px;
      height: 56px;
      background: rgba(32, 168, 196, 0.15);
      color: #082F49;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 1.25rem;
      margin: 0 auto 20px auto;
    }

    .card-subtitle {
      color: #6B7C85;
      font-size: 0.875rem;
      margin-bottom: 28px;
      line-height: 1.5;
    }

    .btn-return {
      width: 100%;
      padding: 12px;
      border-radius: 8px;
      border: 1px solid #DCEBF2;
      background: #FFFFFF;
      color: #263238;
      font-weight: 600;
      font-size: 14px;
      text-decoration: none;
      display: inline-block;
      box-sizing: border-box;
      margin-top: 10px;
      transition: background-color 0.2s, color 0.2s, border-color 0.2s;
    }

    .btn-return:hover {
      background: #EFF8FF;
      color: #082F49;
      border-color: #20A8C4;
    }
  </style>
</head>
<body class="auth-page">

  <div class="login-card">
    <div class="header-icon">
      <a href="${pageContext.request.contextPath}/index" class="auth-logo">
        <img src="${pageContext.request.contextPath}/static/images/logo.jpg" alt="Logo" class="auth-logo-img">
        <div><span class="accent-text"> NOX </span></div>
      </a>
    </div>

    <div class="logout-icon">
      <i class="fa-solid fa-arrow-right-from-bracket"></i>
    </div>

    <h2>User Dashboard</h2>
    <p class="card-subtitle">
      You are currently logged in to your active NOX session.
    </p>

    <i class="fa-solid fa-power-off"><a href="${pageContext.request.contextPath}/homepage" class="btn-return">
      Log Out
    </a></i>
    

    <a href="${pageContext.request.contextPath}/index" class="btn-return">
      Return to Workspace
    </a>

    <p class="footer-text">
      Don't want to log out?
      <a href="${pageContext.request.contextPath}/index">Go back to your workspace</a>
    </p>
  </div>

</body>
</html>

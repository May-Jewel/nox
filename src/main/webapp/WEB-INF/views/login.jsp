<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Login</title>
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

    .alert {
      display: none;
      padding: 12px 14px;
      border-radius: 8px;
      font-size: 13px;
      font-weight: 600;
      margin-bottom: 18px;
      text-align: left;
    }

    .alert.show {
      display: flex;
      align-items: center;
      gap: 8px;
    }

    .alert-success {
      background: rgba(123, 201, 164, 0.2);
      border: 1px solid #7BC9A4;
      color: #1e6345;
    }

    .alert-danger {
      background: #FBE9E7;
      border: 1px solid #E8B4AB;
      color: #A63D2F;
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

    .input-with-icon {
      position: relative;
    }

    .input-with-icon .input-icon {
      position: absolute;
      left: 14px;
      top: 50%;
      transform: translateY(-50%);
      color: #6B7C85;
    }

    .input-with-icon .toggle-password {
      position: absolute;
      right: 14px;
      top: 50%;
      transform: translateY(-50%);
      color: #6B7C85;
      cursor: pointer;
      background: transparent;
      border: none;
      padding: 0;
      font-size: 1rem;
    }

    .input-with-icon input {
      padding-left: 40px;
    }

    .input-with-icon input[type="password"] {
      padding-right: 40px;
    }

    .error-text {
      display: block;
      margin-top: 6px;
      font-size: 12px;
      font-weight: 600;
      color: #ef4444;
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

    <h2>Welcome Back</h2>
    <p class="subtitle">Sign in to access your dashboard</p>

    <div id="successAlert" class="alert alert-success">
      <i class="fas fa-check-circle"></i>
      <span>Registration successful! Please login with your credentials.</span>
    </div>

    <div id="errorAlert" class="alert alert-danger">
      <i class="fas fa-exclamation-circle"></i>
      <span id="errorMessage"></span>
    </div>

    <form action="${pageContext.request.contextPath}/auth/login" method="post" onsubmit="return validateLoginForm();">
      <div class="form-group">
        <label for="email">Email Address</label>
        <div class="input-with-icon">
          <i class="fas fa-envelope input-icon"></i>
          <input type="email" id="email" name="email" required autocomplete="email" placeholder="you@gmail.com">
          <small id="emailError" class="error-text" style="display:none;"></small>
        </div>
      </div>

      <div class="form-group">
        <label for="password">Password</label>
        <div class="input-with-icon">
          <i class="fas fa-lock input-icon"></i>
          <input type="password" id="password" name="password" required autocomplete="current-password" minlength="6">

          <button type="button" class="toggle-password" onclick="togglePassword()" aria-label="Toggle password visibility">
            <i id="eyeIcon" class="fas fa-eye"></i>
          </button>
        </div>
        <small id="passwordError" class="error-text" style="display:none;"></small>
      </div>

      <button type="submit" class="btn-submit">
        <i class="fas fa-unlock"></i> Login
      </button>
    </form>

    <div class="footer-text">
      Don't have an account yet?
      <a href="${pageContext.request.contextPath}/register">Create one</a>
    </div>
  </div>

  <script>
    function togglePassword() {
      var passwordInput = document.getElementById('password');
      var eyeIcon = document.getElementById('eyeIcon');
      if (passwordInput.type === 'password') {
        passwordInput.type = 'text';
        eyeIcon.classList.remove('fa-eye');
        eyeIcon.classList.add('fa-eye-slash');
      } else {
        passwordInput.type = 'password';
        eyeIcon.classList.remove('fa-eye-slash');
        eyeIcon.classList.add('fa-eye');
      }
    }

    function clearAllErrors() {
      document.getElementById('emailError').style.display = 'none';
      document.getElementById('emailError').textContent = '';
      document.getElementById('passwordError').style.display = 'none';
      document.getElementById('passwordError').textContent = '';
      document.getElementById('errorAlert').classList.remove('show');
      document.getElementById('errorMessage').textContent = '';
    }

    function showFieldError(id, msg) {
      var el = document.getElementById(id);
      el.textContent = msg;
      el.style.display = 'block';
    }

    function showBannerError(msg) {
      document.getElementById('errorMessage').textContent = msg;
      document.getElementById('errorAlert').classList.add('show');
    }

    function classifyAndShowErrors(errors) {
      var hasEmailErr = false;
      var hasPwdErr = false;

      errors.forEach(function(msg) {
        var lower = msg.toLowerCase();
        var isEmail = lower.indexOf('email') !== -1 || lower.indexOf('gmail') !== -1;
        var isPassword = lower.indexOf('password') !== -1;

        if (isEmail) {
          showFieldError('emailError', msg);
          hasEmailErr = true;
        }
        if (isPassword) {
          showFieldError('passwordError', msg);
          hasPwdErr = true;
        }
      });

      if (errors.length > 0) {
        showBannerError(errors.join(' '));
      }
    }

    function validateLoginForm() {
      clearAllErrors();
      var errors = [];
      var email = document.getElementById('email').value.trim();
      var password = document.getElementById('password').value;

      if (!email) {
        var msg = 'Email address is required.';
        errors.push(msg);
        showFieldError('emailError', msg);
      } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
        var msg = 'Please enter a valid email address.';
        errors.push(msg);
        showFieldError('emailError', msg);
      } else if (!email.toLowerCase().endsWith('@gmail.com')) {
        var msg = 'Only Gmail addresses (@gmail.com) are allowed.';
        errors.push(msg);
        showFieldError('emailError', msg);
      }

      if (!password) {
        var msg = 'Password is required.';
        errors.push(msg);
        showFieldError('passwordError', msg);
      } else if (password.length < 6) {
        var msg = 'Password must be at least 6 characters long.';
        errors.push(msg);
        showFieldError('passwordError', msg);
      }

      if (errors.length > 0) {
        showBannerError(errors.join(' '));
        return false;
      }
      return true;
    }

    /* ---- Handle server-side errors passed via URL params ---- */
    (function() {
      var params = new URLSearchParams(window.location.search);
      var errorsParam = params.get('errors');

      if (errorsParam) {
        var serverErrors = errorsParam.split('||').map(function(s) {
          return decodeURIComponent(s.replace(/\+/g, ' '));
        });
        classifyAndShowErrors(serverErrors);
   
        if (window.history.replaceState) {
          window.history.replaceState({}, document.title, window.location.pathname);
        }
        return;
      }

    
      if (params.get('error') === 'invalid') {
        showBannerError('Invalid email or password. Please try again.');
      } else if (params.get('error') === 'db') {
        showBannerError('Something went wrong. Please try again.');
      }

      if (params.get('registered') === 'true') {
        document.getElementById('successAlert').classList.add('show');
      }
    })();
  </script>
</body>
</html>

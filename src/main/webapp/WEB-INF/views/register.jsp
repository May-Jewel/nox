<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Create Account — NOX</title>
<link rel="icon" type="image/jpeg" href="${pageContext.request.contextPath}/static/images/logo.jpg">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link
	href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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

/* Synchronized round logo image styles */
.auth-logo-img {
	width: 44px;
	height: 44px;
	margin: 0 auto 12px auto;
	border-radius: 50%;
	object-fit: cover;
	display: block;
	box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
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
			<a href="${pageContext.request.contextPath}/index" class="auth-logo"> <img src="${pageContext.request.contextPath}/static/images/logo.jpg"
				alt="Logo" class="auth-logo-img">
				<div>
					<span class="accent-text"> NOX </span>
				</div>
			</a>
		</div>

		<h2>Create an Account</h2>
		<p class="subtitle">Register to start capturing AI notes & voice
			dictation</p>

		<div id="errorAlert" class="alert alert-danger">
			<i class="fas fa-exclamation-circle"></i>
			<div id="errorList"></div>
		</div>

		<form action="${pageContext.request.contextPath}/auth/register" method="post"
			onsubmit="return validateRegisterForm();">
			<div class="form-group">
				<label for="fullname">Full Name</label>
				<div class="input-with-icon">
					<i class="fas fa-user input-icon"></i> <input type="text"
						id="fullname" name="fullname" required autocomplete="name">
				</div>
			</div>

			<div class="form-group">
				<label for="email">Email Address</label>
				<div class="input-with-icon">
					<i class="fas fa-envelope input-icon"></i> <input type="email"
						id="email" name="email" required autocomplete="email">
				</div>
			</div>

			<div class="form-group">
				<label for="password">Password</label>
				<div class="input-with-icon">
					<i class="fas fa-lock input-icon"></i> <input type="password"
						id="password" name="password" required autocomplete="new-password"
						minlength="6">

					<button type="button" class="toggle-password"
						onclick="togglePassword('password', this)"
						aria-label="Toggle password visibility">
						<i class="fas fa-eye"></i>
					</button>
				</div>
			</div>

			<div class="form-group">
				<label for="confirmPassword">Confirm Password</label>
				<div class="input-with-icon">
					<i class="fas fa-check-double input-icon"></i> <input
						type="password" id="confirmPassword" name="confirmPassword"
						required autocomplete="new-password">

					<button type="button" class="toggle-password"
						onclick="togglePassword('confirmPassword', this)"
						aria-label="Toggle password visibility">
						<i class="fas fa-eye"></i>
					</button>
				</div>
			</div>

			<button type="submit" class="btn-submit">
				<i class="fas fa-user-plus"></i> Register Account
			</button>
		</form>

		<div class="footer-text">
			Already have an account? <a href="${pageContext.request.contextPath}/login">Sign in here</a>
		</div>
	</div>

	<script>
		function togglePassword(id, btn) {
			const passwordInput = document.getElementById(id);
			const eyeIcon = btn.querySelector('i');

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

		function showErrors(errors) {
			const errorList = document.getElementById('errorList');
			errorList.innerHTML = '';
			errors.forEach(function(err) {
				const p = document.createElement('p');
				p.style.margin = '0 0 4px 0';
				p.textContent = err;
				errorList.appendChild(p);
			});
			document.getElementById('errorAlert').classList.add('show');
		}

		function validateRegisterForm() {
			const fullname = document.getElementById('fullname').value.trim();
			const email = document.getElementById('email').value.trim()
					.toLowerCase();
			const password = document.getElementById('password').value;
			const confirmPassword = document.getElementById('confirmPassword').value;
			const clientErrors = [];

			// Fullname must be more than 3 characters
			if (fullname.length > 0 && fullname.length < 2) {
				clientErrors.push('Full name must be more than 1 character.');
			}

			// Email domain typo check (client-side)
			if (email.length > 0) {
				var typoDomains = [ '@gmal.com', '@gamil.com', '@gmial.com',
						'@gmail.co', '@gmail.om', '@gmail.cmo', '@gmail.cok',
						'@gmail.con', '@gmailcom', '@gmaill.com', '@gmaol.com',
						'@gmil.com', '@gmail.vom', '@gmail.cim', '@gmaik.com',
						'@gmeil.com', '@gmsil.com', '@gmail.cpm',
						'@gmail.coom', '@gmaul.com' ];
				var isTypo = typoDomains.some(function(d) {
					return email.endsWith(d);
				});
				if (isTypo) {
					clientErrors
							.push('Did you mean @gmail.com? Please fix the email domain spelling.');
				}
			}

			// Password match
			if (password !== confirmPassword) {
				clientErrors.push('Passwords do not match.');
			}

			if (clientErrors.length > 0) {
				showErrors(clientErrors);
				return false;
			}

			document.getElementById('errorAlert').classList.remove('show');
			return true;
		}

		// On page load: parse errors from URL and re-populate fields
		(function() {
			const params = new URLSearchParams(window.location.search);

			// Restore fullname
			const savedFullname = params.get('fullname');
			if (savedFullname) {
				document.getElementById('fullname').value = savedFullname;
			}

			// Restore email
			const savedEmail = params.get('email');
			if (savedEmail) {
				document.getElementById('email').value = savedEmail;
			}

			// Display server-side errors
			const errorsParam = params.get('errors');
			if (errorsParam) {
				var errors = errorsParam.split('||');
				if (errors.length > 0 && errors[0] !== '') {
					showErrors(errors);
				}
			}
		})();
	</script>
</body>
</html>

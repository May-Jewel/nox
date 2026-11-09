<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NOX</title>
    <link rel="icon" type="imagejpeg" href="${pageContext.request.contextPath}/static/images/logo.jpg">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/dashboard.css?v=5">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/reminder-modal.css">
    <script src="${pageContext.request.contextPath}/static/js/i18n.js"></script>
    <script type="module" src="${pageContext.request.contextPath}/static/js/reminder-modal.js"></script>
    <style>
      .brand {
        background: transparent;
        border: none;
        text-align: left;
      }

      .sidebar-menu form {
        width: 100%;
      }

      .profile-card {
        background: var(--card-bg);
        border: 1px solid var(--card-border);
        border-radius: 20px;
        padding: 2rem;
        display: flex;
        align-items: center;
        gap: 1.75rem;
        flex-wrap: wrap;
        margin-bottom: 1.5rem;
      }

      .profile-avatar {
        width: 92px;
        height: 92px;
        flex-shrink: 0;
        border-radius: 50%;
        background: var(--accent-gradient);
        color: #FFFFFF;
        font-size: 2.2rem;
        font-weight: 700;
        display: flex;
        align-items: center;
        justify-content: center;
        box-shadow: 0 6px 18px var(--accent-glow);
      }

      .profile-details {
        flex: 1;
        min-width: 200px;
      }

      .profile-label {
        margin: 0 0 0.2rem 0;
        font-size: 0.72rem;
        text-transform: uppercase;
        letter-spacing: 0.08em;
        color: var(--text-muted);
        font-weight: 700;
      }

      .profile-details h3 {
        margin: 0 0 1.1rem 0;
        font-size: 1.6rem;
        color: var(--text);
      }

      .profile-email {
        margin: 0;
        font-size: 1rem;
        color: var(--text-muted);
        display: flex;
        align-items: center;
        gap: 0.5rem;
      }

      .profile-actions {
        display: flex;
        gap: 0.85rem;
        flex-wrap: wrap;
      }

      .profile-actions a,
      .profile-actions button {
        text-decoration: none;
      }

      .profile-status {
        font-size: 0.9rem;
        color: var(--text-muted);
        display: flex;
        align-items: center;
        gap: 0.5rem;
      }

      .status-dot {
        width: 10px;
        height: 10px;
        border-radius: 50%;
        background: #7BC9A4;
        display: inline-block;
      }

      .sidebar-margin-top {
        margin-top: 1rem;
      }

      .lang-dropdown {
        position: relative;
        display: inline-block;
        min-width: 220px;
        max-width: 100%;
      }

      .lang-dropdown-toggle {
        width: 100%;
        justify-content: flex-start;
        gap: 0.6rem;
      }

      .lang-dropdown-label {
        flex: 1;
        text-align: left;
      }

      .lang-dropdown-arrow {
        font-size: 0.75rem;
        color: inherit;
        opacity: 0.85;
        transition: transform 0.2s ease;
      }

      .lang-dropdown-toggle[aria-expanded="true"] .lang-dropdown-arrow {
        transform: rotate(180deg);
      }

      .lang-dropdown-menu {
        position: absolute;
        top: calc(100% + 8px);
        left: 0;
        right: 0;
        min-width: 220px;
        max-width: min(320px, calc(100vw - 2rem));
        background: var(--card-bg);
        backdrop-filter: blur(20px);
        -webkit-backdrop-filter: blur(20px);
        border: 1px solid var(--card-border);
        border-radius: 14px;
        box-shadow: 0 15px 40px rgba(8, 47, 73, 0.15);
        padding: 0.4rem;
        display: none;
        flex-direction: column;
        gap: 0.15rem;
        z-index: 1000;
      }

      .lang-dropdown.open .lang-dropdown-menu {
        display: flex;
      }

      .lang-dropdown-item {
        background: transparent;
        border: none;
        color: var(--text);
        font-size: 0.92rem;
        font-weight: 600;
        cursor: pointer;
        display: flex;
        align-items: center;
        gap: 0.6rem;
        padding: 0.6rem 0.85rem;
        border-radius: 10px;
        text-align: left;
        transition: background 0.15s, color 0.15s;
      }

      .lang-dropdown-item:hover {
        background: rgba(32, 168, 196, 0.12);
        color: #082F49;
      }

      .lang-dropdown-item .lang-item-label {
        flex: 1;
      }

      .lang-dropdown-item .lang-check {
        color: var(--accent);
        font-size: 0.85rem;
        opacity: 0;
        transition: opacity 0.15s;
      }

      .lang-dropdown-item.selected .lang-check {
        opacity: 1;
      }
    </style>
  </head>
  <body>
    <div class="app-shell" id="appShell">
      <aside class="sidebar-menu">
        <div class="brand" id="brandLogo">
          <div class="brand-icon">
					<img src="${pageContext.request.contextPath}/static/images/logo.jpg" alt="Logo" class="brand-logo-img">
				</div>
          <div class="brand-info">
            <p data-i18n="brand.tagline">Speech &amp; Text</p>
            <h1 data-i18n="brand.aiAssistant">AI Assistant</h1>
          </div>
        </div>

        <nav class="side-nav" aria-label="Primary navigation">
          <a href="${pageContext.request.contextPath}/index" class="nav-link">
            <i class="fa-solid fa-microphone"></i>
            <span data-i18n="side.transcribe">Transcribe</span>
          </a>
          <a href="${pageContext.request.contextPath}/translate" class="nav-link">
            <i class="fa-solid fa-language"></i>
            <span data-i18n="side.translate">Translate</span>
          </a>
          <a href="${pageContext.request.contextPath}/summary" class="nav-link">
            <i class="fa-solid fa-file-contract"></i>
            <span data-i18n="side.summarize">Summarize</span>
          </a>
          <a href="${pageContext.request.contextPath}/todolist" class="nav-link">
            <i class="fa-solid fa-list-check"></i>
            <span data-i18n="side.todo">To-Do List</span>
          </a>
          <a href="${pageContext.request.contextPath}/text" class="nav-link">
            <i class="fa-solid fa-pen-to-square"></i>
            <span data-i18n="side.qna">Q&A</span>
          </a>
          <a href="${pageContext.request.contextPath}/tts" class="nav-link">
            <i class="fa-solid fa-volume-high"></i>
            <span data-i18n="side.tts">Text to Speech</span>
          </a>
          <a href="${pageContext.request.contextPath}/history" class="nav-link">
            <i class="fa-solid fa-clock-rotate-left"></i>
            <span data-i18n="side.history">History</span>
          </a>
        </nav>

        <div class="user-profile-widget">
          <div class="avatar" id="sidebarAvatar">AI</div>
          <div class="user-info">
            <p id="sidebarName">Session Active</p>
            <span id="sidebarEmail">Loading...</span>
          </div>
          <button class="reminder-bell" id="openRemindersBtn" type="button" aria-label="Reminders" title="Reminders"><i class="fa-solid fa-bell"></i></button>
        </div>
      </aside>

      <header class="global-top-nav">
        <a href="${pageContext.request.contextPath}/homepage" class="top-nav-item" data-i18n="nav.home">Home</a>
        <a href="${pageContext.request.contextPath}/homepage#features" class="top-nav-item" data-i18n="nav.features">Features</a>
        <a href="${pageContext.request.contextPath}/homepage#about" class="top-nav-item" data-i18n="nav.about">About Us</a>
        <a href="${pageContext.request.contextPath}/profile" class="top-nav-item profile-btn active">
          <i class="fa-solid fa-user"></i>
          <span data-i18n="nav.profile">Profile</span>
        </a>
      </header>

      <main class="app-main">
        <section class="panel profile-panel">
          <div class="panel-header">
            <div>
              <p class="eyebrow" data-i18n="profile.eyebrow">Account Overview</p>
              <h2 data-i18n="profile.title">My Profile</h2>
            </div>
            <span class="profile-status">
              <span class="status-dot"></span>
              <span id="sessionStatus" data-i18n="profile.sessionChecking">Checking session...</span>
            </span>
          </div>

          <div class="profile-card">
            <div class="profile-avatar" id="profileAvatar">?</div>
            <div class="profile-details">
              <p class="profile-label" data-i18n="profile.username">Username</p>
              <h3 id="profileName" data-i18n="loading">Loading...</h3>
              <p class="profile-label" data-i18n="profile.emailLabel">Login Profile (Email)</p>
              <p class="profile-email" id="profileEmail">
                <i class="fa-solid fa-envelope"></i>
                <span data-i18n="loading">Loading...</span>
              </p>
            </div>
          </div>

          <div class="profile-actions">
            <a href="${pageContext.request.contextPath}/history" class="btn-primary">
              <i class="fa-solid fa-clock-rotate-left"></i>
              <span data-i18n="profile.viewHistory">View History</span>
            </a>
            <div class="lang-dropdown" id="langDropdown">
              <button type="button" class="btn-secondary lang-dropdown-toggle" id="langDropdownToggle"
                      aria-haspopup="listbox" aria-expanded="false">
                <i class="fa-solid fa-globe"></i>
                <span class="lang-dropdown-label" data-i18n="lang.title">Language</span>
                <i class="fa-solid fa-chevron-down lang-dropdown-arrow"></i>
              </button>

              <div class="lang-dropdown-menu" id="langDropdownMenu" role="listbox" aria-label="Language">
                <button type="button" class="lang-dropdown-item" data-lang="en" role="option" aria-selected="true">
                  <span class="lang-item-label" data-i18n="lang.english">English</span>
                  <i class="fa-solid fa-check lang-check"></i>
                </button>
                <button type="button" class="lang-dropdown-item" data-lang="my" role="option" aria-selected="false">
                  <span class="lang-item-label" data-i18n="lang.myanmar">မြန်မာ</span>
                  <i class="fa-solid fa-check lang-check"></i>
                </button>
              </div>

              <form action="${pageContext.request.contextPath}/language" method="post" id="languageForm">
                <input type="hidden" name="next" value="profile" />
                <input type="hidden" name="lang" id="langInput" value="" />
              </form>
            </div>
            <form action="${pageContext.request.contextPath}/auth/logout" method="POST">
              <button type="submit" class="btn-secondary">
                <i class="fa-solid fa-right-from-bracket"></i>
                <span data-i18n="profile.logout">Logout</span>
              </button>
            </form>
          </div>
        </section>
      </main>
    </div>

    <script>
      const appShell = document.getElementById('appShell');
      const brandLogo = document.getElementById('brandLogo');

      function toggleSidebar() {
        if (!appShell) return;
        appShell.classList.toggle('sidebar-collapsed');
        localStorage.setItem('sidebarCollapsed', appShell.classList.contains('sidebar-collapsed') ? 'true' : 'false');
      }

      if (localStorage.getItem('sidebarCollapsed') === 'true' && appShell) {
        appShell.classList.add('sidebar-collapsed');
      }

      if (brandLogo) {
        brandLogo.addEventListener('click', toggleSidebar);
      }

   // Replace your fetch block in profile.html with this:
      fetch('${pageContext.request.contextPath}/api/profile', {
          method: 'GET',
          headers: {
              'Accept': 'application/json'
          },
          credentials: 'same-origin' // Ensures browser sends the JSESSIONID cookie!
      })
      .then((response) => {
          if (!response.ok) {
              throw new Error('Not logged in');
          }
          return response.json();
      })
      .then((data) => {
          const name = data.username || NOX_I18N.t('profile.guest');
          const email = data.email || '';
          const initial = (name.charAt(0) || '?').toUpperCase();

          // Populate profile UI
          document.getElementById('profileName').textContent = name;
          document.getElementById('profileEmail').querySelector('span').textContent = email;
          document.getElementById('profileAvatar').textContent = initial;
          
          // Populate sidebar UI
          var sbName = document.getElementById('sidebarName');
          var sbEmail = document.getElementById('sidebarEmail');
          var sbAvatar = document.getElementById('sidebarAvatar');
          if(sbName){ sbName.textContent = name; sbName.removeAttribute('data-i18n'); }
          if(sbEmail){ sbEmail.textContent = email; sbEmail.removeAttribute('data-i18n'); }
          if(sbAvatar) sbAvatar.textContent = initial;
          
          NOX_I18N.ready.then(() => {
              document.getElementById('sessionStatus').textContent = name;
          });
      })
      .catch((err) => {
          console.error('Session check failed:', err);
          NOX_I18N.ready.then(() => {
              document.getElementById('sessionStatus').textContent = NOX_I18N.t('profile.sessionExpired');
          });
          // Redirect to login only if truly unauthenticated
          window.location.href = '${pageContext.request.contextPath}/login';
      });

      // Clear sessionStorage on logout
      var logoutForm = document.querySelector('form[action="${pageContext.request.contextPath}/auth/logout"]');
      if (logoutForm) {
        logoutForm.addEventListener('submit', function() {
          sessionStorage.clear();
        });
      }

      // Language dropdown: compact selector on the Profile page.
      const langDropdown = document.getElementById('langDropdown');
      const langToggle = document.getElementById('langDropdownToggle');
      const langItems = document.querySelectorAll('.lang-dropdown-item');

      function closeLangDropdown() {
        langDropdown.classList.remove('open');
        langToggle.setAttribute('aria-expanded', 'false');
      }

      function openLangDropdown() {
        langDropdown.classList.add('open');
        langToggle.setAttribute('aria-expanded', 'true');
      }

      langToggle.addEventListener('click', (e) => {
        e.stopPropagation();
        if (langDropdown.classList.contains('open')) {
          closeLangDropdown();
        } else {
          openLangDropdown();
        }
      });

      // Selecting an option submits it to the LanguageServlet (session-based).
      langItems.forEach((item) => {
        item.addEventListener('click', (e) => {
          e.stopPropagation();
          closeLangDropdown();
          document.getElementById('langInput').value = item.dataset.lang;
          document.getElementById('languageForm').submit();
        });
      });

      // Clicking outside closes the dropdown; Escape also closes it.
      document.addEventListener('click', (e) => {
        if (!langDropdown.contains(e.target)) closeLangDropdown();
      });

      document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape') closeLangDropdown();
      });

      // Mark the currently active session language.
      function syncLangMenu(lang) {
        langItems.forEach((item) => {
          const selected = item.dataset.lang === lang;
          item.classList.toggle('selected', selected);
          item.setAttribute('aria-selected', selected ? 'true' : 'false');
        });
      }

      NOX_I18N.ready.then(() => {
        syncLangMenu(NOX_I18N.lang());
      });
    </script>
  </body>
</html>

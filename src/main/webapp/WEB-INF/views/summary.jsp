<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>NOX</title>
    <link rel="icon" type="image/jpeg" href="${pageContext.request.contextPath}/static/images/logo.jpg">
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/dashboard.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/reminder-modal.css" />
    <script src="${pageContext.request.contextPath}/static/js/i18n.js"></script>
    <script type="module" src="${pageContext.request.contextPath}/static/js/reminder-modal.js"></script>
  </head>
  <body>
    <div class="app-shell" id="appShell">
      <aside class="sidebar-menu">
        <div class="brand" id="brandLogo" tabindex="0" role="button">
         <div class="brand-icon">
					<img src="${pageContext.request.contextPath}/static/images/logo.jpg" alt="Logo" class="brand-logo-img">
				</div>
          <div class="brand-info">
            <p data-i18n="summary.brandTag">Summary</p>
            <h1 data-i18n="brand.aiAssistant">NOX</h1>
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
          <a href="${pageContext.request.contextPath}/summary" class="nav-link active">
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
        </nav>

        <!-- Lower Sidebar Area -->
        <div class="user-profile-widget">
          <div class="avatar" id="sidebarAvatar">AI</div>
          <div class="user-info">
            <p id="sidebarName">Session Active</p>
            <span id="sidebarEmail">Loading...</span>
          </div>
          <button class="reminder-bell" id="openRemindersBtn" type="button" aria-label="Reminders" title="Reminders"><i class="fa-solid fa-bell"></i></button>
        </div>

      </aside>

      <header class="global-top-nav" style="display: flex; justify-content: flex-end; align-items: center; gap: 1rem;">
        <a href="${pageContext.request.contextPath}/homepage" class="top-nav-item active" data-i18n="nav.home">Home</a>
        <a href="${pageContext.request.contextPath}/homepage#features" class="top-nav-item" data-i18n="nav.features">Features</a>
        <a href="${pageContext.request.contextPath}/homepage#about" class="top-nav-item" data-i18n="nav.about">About Us</a>
        <a href="${pageContext.request.contextPath}/profile" class="top-nav-item profile-btn">
          <i class="fa-solid fa-user"></i>
          <span data-i18n="nav.profile">Profile</span>
        </a>
      </header>

      <main class="app-main">
        <div class="top-navigation-bar">
          <a href="${pageContext.request.contextPath}/index" class="back-link" data-i18n="back.toRecording"><i class="fa-solid fa-arrow-left"></i> Back to Speech Recording</a>
        </div>

        <div class="panel">
          <div class="panel-header">
            <div>
              <p class="eyebrow" data-i18n="summary.eyebrow">Text Overview</p>
              <h2 data-i18n="summary.title">Key Takeaways & Summary</h2>
            </div>
            <button id="generateSummaryBtn" class="btn translate" type="button">
              <i class="fa-solid fa-wand-magic-sparkles"></i> <span data-i18n="summary.run">Summarize Text</span>
            </button>
          </div>

          <div class="summary-card">
            <div class="action-toolbar">
              <span class="status-badge" id="summaryStatus" data-i18n="summary.statusReady">Ready to summarize</span>
              <div style="display: flex; gap: 0.5rem;">
                <button id="copySummaryBtn" class="icon-btn" title="Copy Summary" type="button"><i class="fa-regular fa-copy"></i> <span data-i18n="summary.copySummary">Copy</span></button>
                <button id="clearSummaryBtn" class="icon-btn" title="Clear Text" type="button"><i class="fa-solid fa-trash-can"></i> <span data-i18n="summary.clearText">Clear</span></button>
              </div>
            </div>
            <textarea id="summaryText" class="summary-content" data-i18n-placeholder="summary.placeholder" placeholder="Summary will be generated here from your transcribed audio..."></textarea>

            <div class="output-footer" style="display: flex; gap: 0.75rem; flex-wrap: wrap; justify-content: flex-end; margin-top: 1rem;">
              <button id="todoNavBtn" class="btn transcribe" type="button" disabled>
                <i class="fa-solid fa-list-check"></i> <span data-i18n="btn.todo">To-Do List</span>
              </button>
              <button id="translateNavBtn" class="btn translate" type="button" disabled>
                <i class="fa-solid fa-language"></i> <span data-i18n="btn.translate">Translate</span>
              </button>
              <button id="textNavBtn" class="btn transcribe" type="button" disabled>
                <i class="fa-solid fa-pen-to-square"></i> <span data-i18n="btn.qna">Q&A</span>
              </button>
            </div>
          </div>
        </div>
      </main>
    </div>

    <script>
      const TRANSCRIBE_KEY = 'transcribeOriginalText';
      const SUMMARY_RES_KEY = 'summaryResultText';

      // Sidebar Toggle Logic
      const brandLogo = document.getElementById('brandLogo');
      const appShell = document.getElementById('appShell');

      function toggleSidebar() {
        if (!appShell) return;
        appShell.classList.toggle('sidebar-collapsed');
        const isCollapsed = appShell.classList.contains('sidebar-collapsed');
        localStorage.setItem('sidebarCollapsed', isCollapsed ? 'true' : 'false');
      }

      if (localStorage.getItem('sidebarCollapsed') === 'true' && appShell) {
        appShell.classList.add('sidebar-collapsed');
      }

      if (brandLogo) {
        brandLogo.addEventListener('click', toggleSidebar);
        brandLogo.addEventListener('keydown', (e) => {
          if (e.key === 'Enter' || e.key === ' ') {
            e.preventDefault();
            toggleSidebar();
          }
        });
      }

      fetch('${pageContext.request.contextPath}/api/profile', { method: 'GET', headers: {'Accept':'application/json'}, credentials: 'same-origin' })
      .then(function(r){ if(!r.ok) throw new Error('Not logged in'); return r.json(); })
      .then(function(d){
        var n = d.username || '';
        var e = d.email || '';
        var i = (n.charAt(0) || '?').toUpperCase();
        var sn = document.getElementById('sidebarName');
        var se = document.getElementById('sidebarEmail');
        var sa = document.getElementById('sidebarAvatar');
        if(sn){ sn.textContent = n; sn.removeAttribute('data-i18n'); }
        if(se){ se.textContent = e; se.removeAttribute('data-i18n'); }
        if(sa) sa.textContent = i;
      }).catch(function(){});

      // UI Control & Action Logic
      const summaryText = document.getElementById('summaryText');
      const generateSummaryBtn = document.getElementById('generateSummaryBtn');
      const summaryStatus = document.getElementById('summaryStatus');
      const translateNavBtn = document.getElementById('translateNavBtn');
      const todoNavBtn = document.getElementById('todoNavBtn');
      const textNavBtn = document.getElementById('textNavBtn');

      function toggleActionButtons(enable) {
        if (translateNavBtn) translateNavBtn.disabled = !enable;
        if (todoNavBtn) todoNavBtn.disabled = !enable;
        if (textNavBtn) textNavBtn.disabled = !enable;
      }

      function persistSummaryState() {
        const res = summaryText.value.trim();
        if (res) sessionStorage.setItem(SUMMARY_RES_KEY, res);
        else sessionStorage.removeItem(SUMMARY_RES_KEY);
      }

      window.addEventListener('DOMContentLoaded', () => {
        const savedResult = sessionStorage.getItem(SUMMARY_RES_KEY);
        if (savedResult) {
          summaryText.value = savedResult;
        } else {
          const transcribeText = sessionStorage.getItem(TRANSCRIBE_KEY);
          if (transcribeText) summaryText.value = transcribeText;
        }
        toggleActionButtons(summaryText.value.trim().length > 0);
      });

      summaryText.addEventListener('input', () => {
        toggleActionButtons(summaryText.value.trim().length > 0);
        persistSummaryState();
      });

      document.getElementById('clearSummaryBtn').addEventListener('click', () => {
        summaryText.value = '';
        summaryStatus.textContent = NOX_I18N.t('common.cleared');
        sessionStorage.removeItem(SUMMARY_RES_KEY);
        toggleActionButtons(false);
      });

      document.getElementById('copySummaryBtn').addEventListener('click', () => {
        if (!summaryText.value) return;
        navigator.clipboard.writeText(summaryText.value);
        alert(NOX_I18N.t('summary.copied'));
      });

      generateSummaryBtn.addEventListener('click', async () => {
        let textToSummarize = summaryText.value.trim();
        if (!textToSummarize) {
          textToSummarize = (sessionStorage.getItem(TRANSCRIBE_KEY) || '').trim();
          if (textToSummarize) summaryText.value = textToSummarize;
        }
        if (!textToSummarize) {
          alert(NOX_I18N.t('common.enterTextFirst'));
          return;
        }

        summaryStatus.textContent = NOX_I18N.t('summary.generating');
        generateSummaryBtn.disabled = true;
        toggleActionButtons(false);

        try {
          const response = await fetch('${pageContext.request.contextPath}/api/summary', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: new URLSearchParams({ text: textToSummarize })
          });

          const data = await response.json();

          if (response.ok && data.summary) {
            summaryText.value = data.summary;
            summaryStatus.textContent = NOX_I18N.t('summary.completed');
            toggleActionButtons(true);
            persistSummaryState();
          } else {
            summaryText.value = NOX_I18N.t('common.error') + ': ' + (data.error || 'Summary generation failed.');
            summaryStatus.textContent = NOX_I18N.t('common.error');
          }
        } catch (error) {
          console.error(error);
          summaryText.value = NOX_I18N.t('summary.connFailed');
          summaryStatus.textContent = NOX_I18N.t('summary.connError');
        } finally {
          generateSummaryBtn.disabled = false;
        }
      });

      // Flow Redirection — always pass the original transcribed text
      function redirectWithText(targetPage) {
        const text = sessionStorage.getItem(TRANSCRIBE_KEY);
        if (!text) return;
        window.location.href = targetPage;
      }

      translateNavBtn.addEventListener('click', () => redirectWithText('${pageContext.request.contextPath}/translate'));
      todoNavBtn.addEventListener('click', () => redirectWithText('${pageContext.request.contextPath}/todolist'));
      textNavBtn.addEventListener('click', () => redirectWithText('${pageContext.request.contextPath}/text'));
    </script>
  </body>
</html>

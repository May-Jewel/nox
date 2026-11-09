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
            <p data-i18n="translate.brandTag">Audio Translator</p>
            <h1 data-i18n="brand.aiAssistant">NOX</h1>
          </div>
        </div>

        <nav class="side-nav" aria-label="Primary navigation">
          <a href="${pageContext.request.contextPath}/index" class="nav-link">
            <i class="fa-solid fa-microphone"></i>
            <span data-i18n="side.transcribe">Transcribe</span>
          </a>
          <a href="${pageContext.request.contextPath}/translate" class="nav-link active">
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
          <a href="${pageContext.request.contextPath}/index" class="back-link"><i class="fa-solid fa-arrow-left"></i> <span data-i18n="back.toRecording">Back to Recording Workspace</span></a>
        </div>

        <div class="panel">
          <div class="panel-header">
            <div>
              <p class="eyebrow" data-i18n="translate.eyebrow">Language Converter</p>
              <h2 data-i18n="translate.title">Translate Transcribed Audio</h2>
            </div>
            <button id="runTranslateBtn" class="btn-primary" type="button">
              <i class="fa-solid fa-rotate"></i> <span data-i18n="translate.run">Translate Now</span>
            </button>
          </div>

          <div class="translation-grid">
            <div class="text-box-wrapper">
              <div class="box-toolbar">
                <p class="eyebrow" style="margin:0;" data-i18n="translate.sourceLabel">Source Text (Original)</p>
                <div class="action-icons">
                  <button id="copySourceBtn" class="icon-btn" title="Copy Text" type="button"><i class="fa-regular fa-copy"></i></button>
                  <button id="clearSourceBtn" class="icon-btn" title="Clear Text" type="button"><i class="fa-solid fa-trash-can"></i></button>
                </div>
              </div>
              <div class="output-card">
                <textarea id="sourceText" placeholder="Original transcription will appear here..." data-i18n-placeholder="translate.sourcePlaceholder"></textarea>
              </div>
            </div>

            <div class="text-box-wrapper">
              <div class="box-toolbar">
                <select id="targetLang" class="lang-select">
                  <option value="my" selected>Burmese (မြန်မာ)</option>
                  <option value="en">English</option>
                  <option value="es">Spanish</option>
                  <option value="fr">French</option>
                  <option value="de">German</option>
                  <option value="zh">Chinese</option>
                  <option value="ja">Japanese</option>
                  <option value="hi">Hindi</option>
                  <option value="th">Thai</option>
                </select>
                <div class="action-icons">
                  <button id="copyTargetBtn" class="icon-btn" title="Copy Translated Text" type="button"><i class="fa-regular fa-copy"></i></button>
                  <button id="clearTargetBtn" class="icon-btn" title="Clear Text" type="button"><i class="fa-solid fa-trash-can"></i></button>
                </div>
              </div>
              <div class="output-card">
                <textarea id="targetText" readonly placeholder="Translated text will appear here..." data-i18n-placeholder="translate.targetPlaceholder"></textarea>
              </div>
            </div>
          </div>

          <!-- ACTION BUTTON FOOTER -->
          <div class="output-footer" style="display: flex; gap: 0.75rem; flex-wrap: wrap; justify-content: flex-end; margin-top: 1.5rem;">
            <button id="summaryNavBtn" class="btn transcribe" type="button" disabled>
              <i class="fa-solid fa-file-contract"></i> <span data-i18n="btn.summarize">Summarize</span>
            </button>
            <button id="todoNavBtn" class="btn transcribe" type="button" disabled>
              <i class="fa-solid fa-list-check"></i> <span data-i18n="btn.todo">To-Do List</span>
            </button>
            <button id="textNavBtn" class="btn transcribe" type="button" disabled>
              <i class="fa-solid fa-pen-to-square"></i> <span data-i18n="btn.qna">Q&A</span>
            </button>
          </div>
        </div>
      </main>
    </div>

    <script>
      const TRANSCRIBE_KEY = 'transcribeOriginalText';
      const TRANSLATE_SRC_KEY = 'translateSourceText';
      const TRANSLATE_RES_KEY = 'translateResultText';

 
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

      // Translation & Interface Logic
      const sourceArea = document.getElementById('sourceText');
      const targetArea = document.getElementById('targetText');
      const targetLangSelect = document.getElementById('targetLang');
      const runTranslateBtn = document.getElementById('runTranslateBtn');
      const summaryNavBtn = document.getElementById('summaryNavBtn');
      const todoNavBtn = document.getElementById('todoNavBtn');
      const textNavBtn = document.getElementById('textNavBtn');

      function toggleActionButtons(enable) {
        if (summaryNavBtn) summaryNavBtn.disabled = !enable;
        if (todoNavBtn) todoNavBtn.disabled = !enable;
        if (textNavBtn) textNavBtn.disabled = !enable;
      }

      function persistTranslateState() {
        const src = sourceArea.value.trim();
        const res = targetArea.value.trim();
        if (src) sessionStorage.setItem(TRANSLATE_SRC_KEY, src);
        else sessionStorage.removeItem(TRANSLATE_SRC_KEY);
        if (res) sessionStorage.setItem(TRANSLATE_RES_KEY, res);
        else sessionStorage.removeItem(TRANSLATE_RES_KEY);
      }

      function restoreTranslateState() {
        const src = sessionStorage.getItem(TRANSLATE_SRC_KEY);
        const res = sessionStorage.getItem(TRANSLATE_RES_KEY);
        if (src && !sourceArea.value) sourceArea.value = src;
        if (res && !targetArea.value) targetArea.value = res;
        toggleActionButtons(sourceArea.value.trim().length > 0 || targetArea.value.trim().length > 0);
      }

      window.addEventListener('DOMContentLoaded', () => {
        const transcribeText = sessionStorage.getItem(TRANSCRIBE_KEY);
        if (transcribeText && !sourceArea.value) {
          sourceArea.value = transcribeText;
        }
        restoreTranslateState();
      });

      sourceArea.addEventListener('input', () => {
        toggleActionButtons(sourceArea.value.trim().length > 0 || targetArea.value.trim().length > 0);
        persistTranslateState();
      });

      targetArea.addEventListener('input', () => {
        persistTranslateState();
      });

      document.getElementById('clearSourceBtn').addEventListener('click', () => {
        sourceArea.value = '';
        sessionStorage.removeItem(TRANSLATE_SRC_KEY);
        toggleActionButtons(targetArea.value.trim().length > 0);
      });

      document.getElementById('clearTargetBtn').addEventListener('click', () => {
        targetArea.value = '';
        sessionStorage.removeItem(TRANSLATE_RES_KEY);
        toggleActionButtons(sourceArea.value.trim().length > 0);
      });

      document.getElementById('copySourceBtn').addEventListener('click', () => {
        if (!sourceArea.value) return;
        navigator.clipboard.writeText(sourceArea.value);
        alert(NOX_I18N.t('translate.originalCopied'));
      });

      document.getElementById('copyTargetBtn').addEventListener('click', () => {
        if (!targetArea.value) return;
        navigator.clipboard.writeText(targetArea.value);
        alert(NOX_I18N.t('translate.translatedCopied'));
      });

      runTranslateBtn.addEventListener('click', async () => {
        let text = sourceArea.value.trim();
        if (!text) {
          text = (sessionStorage.getItem(TRANSCRIBE_KEY) || '').trim();
          if (text) sourceArea.value = text;
        }
        const lang = targetLangSelect.value;

        if (!text) {
          alert(NOX_I18N.t('common.enterTextFirst'));
          return;
        }

        targetArea.value = NOX_I18N.t('translate.translating');
        runTranslateBtn.disabled = true;

        try {
          const response = await fetch('${pageContext.request.contextPath}/api/translate', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: new URLSearchParams({ text: text, lang: lang })
          });

          const data = await response.json();

          if (response.ok && data.translatedText) {
            targetArea.value = data.translatedText;
            toggleActionButtons(true);
            persistTranslateState();
          } else {
            targetArea.value = NOX_I18N.t('common.error') + ': ' + (data.error || 'Translation failed.');
          }
        } catch (error) {
          console.error(error);
          targetArea.value = NOX_I18N.t('translate.connFailed');
        } finally {
          runTranslateBtn.disabled = false;
        }
      });

     
      function redirectWithText(targetPage) {
        const text = sessionStorage.getItem(TRANSCRIBE_KEY);
        if (!text) return;
        sessionStorage.setItem(TRANSCRIBE_KEY, text);
        window.location.href = targetPage;
      }

      summaryNavBtn.addEventListener('click', () => redirectWithText('${pageContext.request.contextPath}/summary'));
      todoNavBtn.addEventListener('click', () => redirectWithText('${pageContext.request.contextPath}/todolist'));
      textNavBtn.addEventListener('click', () => redirectWithText('${pageContext.request.contextPath}/text'));
    </script>
  </body>
</html>

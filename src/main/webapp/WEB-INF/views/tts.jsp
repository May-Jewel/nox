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
            <p data-i18n="tts.brandTag">Text to Speech</p>
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
          <a href="${pageContext.request.contextPath}/tts" class="nav-link active">
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
              <p class="eyebrow" data-i18n="tts.eyebrow">Voice Synthesis</p>
              <h2 data-i18n="tts.title">Convert Text to Speech</h2>
            </div>
          </div>

          <div class="text-box-wrapper">
            <div class="box-toolbar">
              <p class="eyebrow" style="margin:0;" data-i18n="tts.inputLabel">Input Text</p>
              <div class="action-icons">
                <button id="clearInputBtn" class="icon-btn" title="Clear Text" type="button"><i class="fa-solid fa-trash-can"></i></button>
              </div>
            </div>
            <div class="output-card">
              <textarea id="text-input" data-i18n-placeholder="tts.inputPlaceholder" placeholder="Enter text to convert to speech..."></textarea>
            </div>
          </div>

          <div class="controls-grid" style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 1.5rem; margin-top: 1.5rem;">
            <div class="control-group">
              <label for="language-select" data-i18n="tts.languageLabel">Select Language:</label>
              <select id="language-select" class="lang-select">
                <option value="my">🇲🇲 Myanmar (မြန်မာ)</option>
                <option value="en">🇺🇸 English (English)</option>
                <option value="ja">🇯🇵 Japanese (日本語)</option>
                <option value="ko">🇰🇷 Korean (한국어)</option>
                <option value="zh">🇨🇳 Chinese (中文)</option>
                <option value="th">🇹🇭 Thai (ไทย)</option>
                <option value="ru">🇷🇺 Russian (Русский)</option>
                <option value="es">🇪🇸 Spanish (Español)</option>
                <option value="fr">🇫🇷 French (Français)</option>
                <option value="de">🇩🇪 German (Deutsch)</option>
              </select>
            </div>

            <div class="control-group">
              <label for="rate" data-i18n="tts.speedLabel">Speed: <span id="rate-val">1.0</span></label>
              <input type="range" id="rate" min="0.5" max="1.5" step="0.1" value="1.0">
            </div>

            <div class="control-group">
              <label for="pitch" data-i18n="tts.pitchLabel">Pitch: <span id="pitch-val">1.0</span></label>
              <input type="range" id="pitch" min="0.5" max="1.5" step="0.1" value="1.0">
            </div>
          </div>

          <div class="btn-group" style="display: flex; gap: 0.75rem; flex-wrap: wrap; margin-top: 1.5rem;">
            <button id="play-btn" class="btn translate" type="button">
              <i class="fa-solid fa-play"></i> <span data-i18n="tts.play">Play / Speak</span>
            </button>
            <button id="pause-btn" class="btn translate" type="button">
              <i class="fa-solid fa-pause"></i> <span data-i18n="tts.pause">Pause</span>
            </button>
            <button id="resume-btn" class="btn translate" type="button">
              <i class="fa-solid fa-circle-play"></i> <span data-i18n="tts.resume">Resume</span>
            </button>
            <button id="stop-btn" class="btn transcribe" type="button">
              <i class="fa-solid fa-stop"></i> <span data-i18n="tts.stop">Stop</span>
            </button>
          </div>

          <div id="status" class="status-bar" style="margin-top: 1rem; padding: 0.75rem; background: var(--bg-dark); border: 1px solid var(--card-border); border-radius: 10px; font-weight: 500;" data-i18n="tts.statusReady">Ready</div>
        </div>
      </main>
    </div>

    <script>
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

      // TTS Logic
      const textInput = document.getElementById('text-input');
      const langSelect = document.getElementById('language-select');
      const rateInput = document.getElementById('rate');
      const pitchInput = document.getElementById('pitch');
      const rateVal = document.getElementById('rate-val');
      const pitchVal = document.getElementById('pitch-val');
      const playBtn = document.getElementById('play-btn');
      const pauseBtn = document.getElementById('pause-btn');
      const resumeBtn = document.getElementById('resume-btn');
      const stopBtn = document.getElementById('stop-btn');
      const statusDiv = document.getElementById('status');
      const clearInputBtn = document.getElementById('clearInputBtn');

      // SessionStorage keys for TTS state persistence
      const TTS_TEXT_KEY = 'ttsInputText';
      const TTS_LANG_KEY = 'ttsLanguage';
      const TTS_RATE_KEY = 'ttsRate';
      const TTS_PITCH_KEY = 'ttsPitch';

      let isStopped = false;
      let audioQueue = [];
      let currentAudioElement = null;

      if (rateInput && rateVal) {
        rateInput.addEventListener('input', function () { rateVal.innerText = rateInput.value; });
      }
      if (pitchInput && pitchVal) {
        pitchInput.addEventListener('input', function () { pitchVal.innerText = pitchInput.value; });
      }

      // Persist TTS state to sessionStorage
      function persistTtsState() {
        const text = textInput.value.trim();
        if (text) sessionStorage.setItem(TTS_TEXT_KEY, text);
        else sessionStorage.removeItem(TTS_TEXT_KEY);

        if (langSelect.value) sessionStorage.setItem(TTS_LANG_KEY, langSelect.value);
        if (rateInput.value) sessionStorage.setItem(TTS_RATE_KEY, rateInput.value);
        if (pitchInput.value) sessionStorage.setItem(TTS_PITCH_KEY, pitchInput.value);
      }

      // Restore TTS state from sessionStorage
      function restoreTtsState() {
        const savedText = sessionStorage.getItem(TTS_TEXT_KEY);
        const savedLang = sessionStorage.getItem(TTS_LANG_KEY);
        const savedRate = sessionStorage.getItem(TTS_RATE_KEY);
        const savedPitch = sessionStorage.getItem(TTS_PITCH_KEY);

        if (savedText && !textInput.value) textInput.value = savedText;
        if (savedLang && langSelect) langSelect.value = savedLang;
        if (savedRate && rateInput) {
          rateInput.value = savedRate;
          rateVal.innerText = savedRate;
        }
        if (savedPitch && pitchInput) {
          pitchInput.value = savedPitch;
          pitchVal.innerText = savedPitch;
        }
      }

      window.addEventListener('DOMContentLoaded', () => {
        restoreTtsState();
      });

    
      textInput.addEventListener('input', persistTtsState);
      langSelect.addEventListener('change', persistTtsState);
      rateInput.addEventListener('input', persistTtsState);
      pitchInput.addEventListener('input', persistTtsState);

      function splitTextIntoSafeChunks(text, maxLength) {
        if (!maxLength) maxLength = 100;
        const cleanText = text.replace(/[\r\n]+/g, " ").trim();
        let chunks = [];
        let index = 0;

        while (index < cleanText.length) {
          let chunk = cleanText.substring(index, index + maxLength);

          if (index + maxLength < cleanText.length) {
            let lastSpace = Math.max(
              chunk.lastIndexOf(" "),
              chunk.lastIndexOf("။"),
              chunk.lastIndexOf("၊"),
              chunk.lastIndexOf(".")
            );

            if (lastSpace > 20) {
              chunk = chunk.substring(0, lastSpace + 1);
            }
          }

          chunks.push(chunk.trim());
          index += chunk.length;
        }

        return chunks.filter(function (c) { return c.length > 0; });
      }

      function updateStatus(key, params) {
        statusDiv.textContent = NOX_I18N.tf(key, params);
      }

      function processQueue() {
        if (isStopped || audioQueue.length === 0) {
          playBtn.disabled = false;
          updateStatus('tts.statusReady');
          return;
        }

        const currentItem = audioQueue.shift();

        updateStatus('tts.speaking', { current: currentItem.index, total: currentItem.total });

        const bodyData = 'text=' + encodeURIComponent(currentItem.text) +
                         '&lang=' + encodeURIComponent(currentItem.lang) +
                         '&rate=' + currentItem.rate;

        fetch('${pageContext.request.contextPath}/api/tts', {
          method: 'POST',
          headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
          body: bodyData
        })
        .then(function (response) {
          if (!response.ok) throw new Error("Server status: " + response.status);
          return response.blob();
        })
        .then(function (blob) {
          if (isStopped) return;

          const blobUrl = URL.createObjectURL(blob);
          currentAudioElement = new Audio(blobUrl);
          currentAudioElement.playbackRate = currentItem.rate;

          currentAudioElement.onended = function () {
            URL.revokeObjectURL(blobUrl);
            processQueue();
          };

          currentAudioElement.onerror = function (e) {
            console.error("Audio playback error:", e);
            URL.revokeObjectURL(blobUrl);
            processQueue();
          };

          currentAudioElement.play().catch(function (err) {
            console.error("Play error:", err);
            processQueue();
          });
        })
        .catch(function (err) {
          console.error("Fetch/Stream error:", err);
          processQueue();
        });
      }

      playBtn.addEventListener('click', function () {
        const text = textInput.value.trim();
        const lang = langSelect ? langSelect.value : 'en';
        const rate = rateInput ? parseFloat(rateInput.value) : 1.0;

        if (!text) {
          alert(NOX_I18N.t('tts.enterText'));
          return;
        }

        if (currentAudioElement) {
          currentAudioElement.pause();
          currentAudioElement = null;
        }

        isStopped = false;
        playBtn.disabled = true;

        const chunks = splitTextIntoSafeChunks(text, 100);

        audioQueue = chunks.map(function (chunkText, i) {
          return {
            text: chunkText,
            lang: lang,
            rate: rate,
            index: i + 1,
            total: chunks.length
          };
        });

        processQueue();
      });

      pauseBtn.addEventListener('click', function () {
        if (currentAudioElement && !currentAudioElement.paused) {
          currentAudioElement.pause();
          updateStatus('tts.statusPaused');
        }
      });

      resumeBtn.addEventListener('click', function () {
        if (currentAudioElement && currentAudioElement.paused) {
          currentAudioElement.play();
          updateStatus('tts.statusSpeaking');
        }
      });

      stopBtn.addEventListener('click', function () {
        isStopped = true;
        audioQueue = [];
        if (currentAudioElement) {
          currentAudioElement.pause();
          currentAudioElement = null;
        }
        playBtn.disabled = false;
        updateStatus('tts.statusStopped');
      });

      clearInputBtn.addEventListener('click', function () {
        textInput.value = '';
        sessionStorage.removeItem(TTS_TEXT_KEY);
        sessionStorage.removeItem(TTS_LANG_KEY);
        sessionStorage.removeItem(TTS_RATE_KEY);
        sessionStorage.removeItem(TTS_PITCH_KEY);
        updateStatus('tts.statusReady');
      });
    </script>
  </body>
</html>

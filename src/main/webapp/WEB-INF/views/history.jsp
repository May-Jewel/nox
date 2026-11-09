<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title data-i18n="history.title">History</title>
    <link rel="icon" type="image/jpeg" href="${pageContext.request.contextPath}/static/images/logo.jpg">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/reminder-modal.css">
    <script src="${pageContext.request.contextPath}/static/js/i18n.js"></script>
    <script type="module" src="${pageContext.request.contextPath}/static/js/reminder-modal.js"></script>
    <style>
      .hidden {
        display: none !important;
      }

      .history-summary {
        font-size: 0.9rem;
        color: var(--text-muted);
        font-weight: 500;
      }

      .brand {
        background: transparent;
        border: none;
        text-align: left;
      }

      .sidebar-menu form {
        width: 100%;
      }

      .confirm-text {
        margin: 0;
        color: var(--text-muted);
        font-size: 0.92rem;
      }

      
      .history-toolbar {
        display: flex;
        flex-wrap: wrap;
        align-items: center;
        gap: 0.9rem;
        margin-bottom: 1.5rem;
      }

      .search-box {
        position: relative;
        flex: 1 1 260px;
        min-width: 220px;
      }

      .search-box i {
        position: absolute;
        left: 1rem;
        top: 50%;
        transform: translateY(-50%);
        color: var(--text-muted);
        font-size: 0.9rem;
      }

      .search-box input {
        width: 100%;
        background: #ffffff;
        border: 1.5px solid #DCEBF2;
        border-radius: 14px;
        padding: 0.7rem 1rem 0.7rem 2.6rem;
        color: var(--text);
        outline: none;
        font-size: 0.92rem;
        transition: border-color 0.2s;
      }

      .search-box input:focus {
        border-color: var(--border-focus);
        box-shadow: 0 0 0 3px var(--accent-glow);
      }

      .filter-pills {
        display: flex;
        gap: 0.45rem;
        flex-wrap: wrap;
      }

      .filter-pill {
        background: #ffffff;
        border: 1.5px solid #DCEBF2;
        color: var(--text-muted);
        padding: 0.45rem 1rem;
        border-radius: 999px;
        font-size: 0.85rem;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.2s ease;
      }

      .filter-pill:hover {
        border-color: var(--border-focus);
        color: var(--text);
      }

      .filter-pill.active {
        background: #082F49;
        color: #FFFFFF;
        border-color: #082F49;
        box-shadow: 0 3px 10px rgba(8, 47, 73, 0.25);
      }

      .toolbar-actions {
        display: flex;
        gap: 0.6rem;
        margin-left: auto;
      }

      .btn-danger-ghost {
        background: #ffffff;
        border: 1.5px solid rgba(217, 56, 56, 0.35);
        color: #c23030;
        padding: 0.6rem 1.1rem;
        border-radius: 12px;
        font-weight: 600;
        font-size: 0.87rem;
        cursor: pointer;
        display: inline-flex;
        align-items: center;
        gap: 0.5rem;
        transition: all 0.2s ease;
      }

      .btn-danger-ghost:hover {
        background: rgba(217, 56, 56, 0.08);
        border-color: #d93838;
      }

      .btn-danger-ghost:disabled {
        opacity: 0.45;
        cursor: not-allowed;
      }

      
      .activity-list {
        display: flex;
        flex-direction: column;
        gap: 1rem;
      }

      .activity-card {
        background: var(--card-bg);
        border: 1px solid var(--card-border);
        border-radius: 18px;
        padding: 1.25rem 1.4rem;
        display: flex;
        flex-direction: column;
        gap: 0.85rem;
        transition: border-color 0.2s, box-shadow 0.2s;
      }

      .activity-card:hover {
        border-color: var(--border-focus);
        box-shadow: var(--shadow);
      }

      .activity-card.selected {
        border-color: var(--accent);
        box-shadow: 0 0 0 3px var(--accent-glow);
      }

      .activity-card-top {
        display: flex;
        align-items: center;
        gap: 0.8rem;
      }

      .activity-check {
        width: 1.15rem;
        height: 1.15rem;
        accent-color: var(--accent);
        cursor: pointer;
        flex-shrink: 0;
      }

      .feature-badge {
        display: inline-flex;
        align-items: center;
        gap: 0.45rem;
        padding: 0.3rem 0.8rem;
        border-radius: 999px;
        font-size: 0.78rem;
        font-weight: 700;
        letter-spacing: 0.02em;
      }

      .badge-transcribe { background: rgba(32, 168, 196, 0.15); color: #082F49; border: 1px solid rgba(32, 168, 196, 0.4); }
      .badge-summary   { background: rgba(8, 47, 73, 0.12); color: #082F49; border: 1px solid rgba(8, 47, 73, 0.3); }
      .badge-translate { background: rgba(244, 215, 123, 0.3); color: #7a5e00; border: 1px solid rgba(244, 215, 123, 0.7); }
      .badge-todo      { background: rgba(123, 201, 164, 0.25); color: #1e6345; border: 1px solid rgba(123, 201, 164, 0.6); }
      .badge-tts       { background: rgba(244, 215, 123, 0.3); color: #7a5e00; border: 1px solid rgba(244, 215, 123, 0.7); }

      .activity-time {
        margin-left: auto;
        font-size: 0.78rem;
        color: var(--text-muted);
        white-space: nowrap;
      }

      .activity-card-body {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 1rem;
      }

      .activity-snippet {
        background: var(--bg-dark);
        border: 1px solid var(--card-border);
        border-radius: 12px;
        padding: 0.7rem 0.9rem;
        min-height: 56px;
      }

      .snippet-label {
        font-size: 0.68rem;
        text-transform: uppercase;
        letter-spacing: 0.07em;
        color: var(--text-muted);
        font-weight: 700;
        margin-bottom: 0.3rem;
      }

      .snippet-text {
        font-size: 0.87rem;
        color: var(--text);
        line-height: 1.5;
        display: -webkit-box;
        -webkit-line-clamp: 3;
        -webkit-box-orient: vertical;
        overflow: hidden;
        margin: 0;
        word-break: break-word;
      }

      .activity-meta {
        display: flex;
        align-items: center;
        gap: 0.5rem;
        flex-wrap: wrap;
      }

      .meta-chip {
        background: rgba(32, 168, 196, 0.12);
        color: var(--text-muted);
        border: 1px solid var(--card-border);
        border-radius: 999px;
        padding: 0.18rem 0.7rem;
        font-size: 0.75rem;
        font-weight: 600;
      }

      .activity-card-footer {
        display: flex;
        align-items: center;
        gap: 0.5rem;
        border-top: 1px solid #DCEBF2;
        padding-top: 0.8rem;
      }

      .card-action {
        background: transparent;
        border: 1px solid transparent;
        color: var(--text-muted);
        padding: 0.4rem 0.7rem;
        border-radius: 10px;
        font-size: 0.82rem;
        font-weight: 600;
        cursor: pointer;
        display: inline-flex;
        align-items: center;
        gap: 0.4rem;
        transition: all 0.2s;
      }

      .card-action:hover {
        background: rgba(32, 168, 196, 0.12);
        color: var(--text);
      }

      .card-action.danger:hover {
        background: rgba(217, 56, 56, 0.1);
        color: #d93838;
      }

      .card-action.spacer {
        margin-left: auto;
      }

      
      .empty-state i {
        font-size: 3rem;
        margin-bottom: 1rem;
        color: var(--accent);
        opacity: 0.7;
      }

      .empty-state h3 {
        margin: 0 0 0.4rem 0;
        color: var(--text);
      }

      .empty-state p {
        margin: 0 0 1.2rem 0;
      }

      
      .pagination {
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 1rem;
        margin-top: 1.75rem;
      }

      .page-btn {
        background: #ffffff;
        border: 1.5px solid #DCEBF2;
        color: var(--text);
        padding: 0.5rem 1.1rem;
        border-radius: 12px;
        font-weight: 600;
        font-size: 0.85rem;
        cursor: pointer;
        display: inline-flex;
        align-items: center;
        gap: 0.5rem;
        transition: all 0.2s;
      }

      .page-btn:hover:not(:disabled) {
        border-color: var(--border-focus);
        background: rgba(32, 168, 196, 0.1);
      }

      .page-btn:disabled {
        opacity: 0.4;
        cursor: not-allowed;
      }

      .page-indicator {
        font-size: 0.85rem;
        color: var(--text-muted);
        font-weight: 600;
      }

     
      .modal-backdrop {
        position: fixed;
        inset: 0;
        background: rgba(8, 47, 73, 0.45);
        backdrop-filter: blur(4px);
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 1.25rem;
        z-index: 10000;
      }

      .modal-box {
        background: #FFFFFF;
        border: 1px solid var(--card-border);
        border-radius: 22px;
        box-shadow: 0 20px 50px rgba(8, 47, 73, 0.25);
        width: 100%;
        max-width: 720px;
        max-height: 86vh;
        display: flex;
        flex-direction: column;
        overflow: hidden;
      }

      .modal-box.small {
        max-width: 420px;
      }

      .modal-head {
        display: flex;
        align-items: center;
        gap: 0.8rem;
        padding: 1.2rem 1.5rem;
        border-bottom: 1px solid var(--card-border);
      }

      .modal-head h3 {
        margin: 0;
        font-size: 1.1rem;
        color: var(--text);
      }

      .modal-close {
        margin-left: auto;
        background: transparent;
        border: none;
        color: var(--text-muted);
        font-size: 1.1rem;
        cursor: pointer;
        width: 34px;
        height: 34px;
        border-radius: 10px;
        transition: all 0.2s;
      }

      .modal-close:hover {
        background: rgba(32, 168, 196, 0.15);
        color: var(--text);
      }

      .modal-body {
        padding: 1.25rem 1.5rem;
        overflow-y: auto;
        display: flex;
        flex-direction: column;
        gap: 1rem;
      }

      .modal-meta {
        display: flex;
        flex-wrap: wrap;
        gap: 0.5rem;
      }

      .detail-section .snippet-text {
        -webkit-line-clamp: unset;
        white-space: pre-wrap;
        max-height: 260px;
        overflow-y: auto;
      }

      .modal-foot {
        display: flex;
        justify-content: flex-end;
        gap: 0.7rem;
        padding: 1.1rem 1.5rem;
        border-top: 1px solid var(--card-border);
      }

     
      .toast-msg {
        position: fixed;
        bottom: 2rem;
        right: 2rem;
        background: #ffffff;
        border: 1px solid var(--card-border);
        color: var(--text);
        padding: 0.85rem 1.4rem;
        border-radius: 12px;
        font-size: 0.9rem;
        display: flex;
        align-items: center;
        gap: 0.6rem;
        box-shadow: 0 10px 25px rgba(8, 47, 73, 0.15);
        transform: translateY(100px);
        opacity: 0;
        transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        z-index: 100000;
      }

      .toast-msg.show {
        transform: translateY(0);
        opacity: 1;
      }

    
      .skeleton {
        background: linear-gradient(90deg, rgba(177, 222, 243, 0.25) 25%, rgba(177, 222, 243, 0.5) 50%, rgba(177, 222, 243, 0.25) 75%);
        background-size: 200% 100%;
        animation: shimmer 1.4s infinite;
        border-radius: 12px;
        height: 120px;
      }

      @keyframes shimmer {
        0% { background-position: 200% 0; }
        100% { background-position: -200% 0; }
      }

      @media (max-width: 900px) {
        .activity-card-body {
          grid-template-columns: 1fr;
        }

        .activity-time {
          display: none;
        }
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
          <a href="${pageContext.request.contextPath}/history" class="nav-link active">
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
        <a href="${pageContext.request.contextPath}/profile" class="top-nav-item profile-btn">
          <i class="fa-solid fa-user"></i>
          <span data-i18n="nav.profile">Profile</span>
        </a>
      </header>

      <main class="app-main">
        <section class="panel">
          <div class="panel-header">
            <div>
              <p class="eyebrow" data-i18n="history.eyebrow">Revisit your work</p>
              <h2 data-i18n="history.title">Activity History</h2>
            </div>
            <span class="history-summary" id="totalLabel">Loading...</span>
          </div>

          <div class="history-toolbar">
            <div class="search-box">
              <i class="fa-solid fa-magnifying-glass" aria-hidden="true"></i>
              <input id="searchInput" type="search" placeholder="Search your history..." aria-label="Search history" data-i18n-placeholder="history.searchPlaceholder" data-i18n-aria="history.searchAria">
            </div>

            <div class="filter-pills" id="filterPills" role="group" aria-label="Filter by feature" data-i18n-aria="history.filterAria">
              <button type="button" class="filter-pill active" data-filter="all" data-i18n="history.filterAll">All</button>
              <button type="button" class="filter-pill" data-filter="transcribe" data-i18n="history.filterTranscribe">Transcribe</button>
              <button type="button" class="filter-pill" data-filter="summary" data-i18n="history.filterSummary">Summary</button>
              <button type="button" class="filter-pill" data-filter="translate" data-i18n="history.filterTranslate">Translate</button>
              <button type="button" class="filter-pill" data-filter="todo" data-i18n="history.filterTodo">To-Do</button>
              <button type="button" class="filter-pill" data-filter="tts" data-i18n="history.filterTts">Text to Speech</button>
            </div>

            <div class="toolbar-actions">
              <button id="deleteSelectedBtn" type="button" class="btn-danger-ghost" disabled>
                <i class="fa-solid fa-trash-can"></i>
                <span data-i18n="history.deleteSelected">Delete Selected</span>
              </button>
              <button id="clearAllBtn" type="button" class="btn-danger-ghost">
                <i class="fa-solid fa-broom"></i>
                <span data-i18n="history.clearAll">Clear All</span>
              </button>
            </div>
          </div>

          <div id="loadingState" class="activity-list">
            <div class="skeleton"></div>
            <div class="skeleton"></div>
            <div class="skeleton"></div>
          </div>

          <div id="activityList" class="activity-list"></div>

          <div id="emptyState" class="empty-state hidden">
            <i class="fa-solid fa-clock-rotate-left"></i>
            <h3 id="emptyTitle" data-i18n="history.emptyTitle">No history yet</h3>
            <p id="emptyText" data-i18n="history.emptyText">Your transcribe, summary, translate, to-do and text-to-speech activities will appear here.</p>
            <a href="${pageContext.request.contextPath}/index" class="btn-primary">
              <i class="fa-solid fa-microphone"></i>
              <span data-i18n="history.startTranscribing">Start Transcribing</span>
            </a>
          </div>

          <div id="pagination" class="pagination hidden">
            <button id="prevPageBtn" type="button" class="page-btn">
              <i class="fa-solid fa-chevron-left"></i>
              <span data-i18n="history.prev">Prev</span>
            </button>
            <span id="pageIndicator" class="page-indicator">Page 1</span>
            <button id="nextPageBtn" type="button" class="page-btn">
              <span data-i18n="history.next">Next</span>
              <i class="fa-solid fa-chevron-right"></i>
            </button>
          </div>
        </section>
      </main>
    </div>

   
    <div id="detailModal" class="modal-backdrop hidden" role="dialog" aria-modal="true" aria-labelledby="detailModalTitle">
      <div class="modal-box">
        <div class="modal-head">
          <span id="detailBadge" class="feature-badge"></span>
          <h3 id="detailModalTitle" data-i18n="history.detailTitle">Activity Detail</h3>
          <button type="button" class="modal-close" aria-label="Close" data-i18n-aria="history.closeAria">
            <i class="fa-solid fa-xmark"></i>
          </button>
        </div>
        <div class="modal-body">
          <div class="modal-meta" id="detailMeta"></div>
          <div class="detail-section">
            <p class="snippet-label" data-i18n="history.input">Input</p>
            <div class="activity-snippet"><p class="snippet-text" id="detailInput">-</p></div>
          </div>
          <div class="detail-section">
            <p class="snippet-label" data-i18n="history.output">Output</p>
            <div class="activity-snippet"><p class="snippet-text" id="detailOutput">-</p></div>
          </div>
          <div class="detail-section hidden" id="ttsAudioSection">
            <p class="snippet-label" data-i18n="history.ttsAudio">Generated Audio</p>
            <div class="activity-snippet">
              <audio id="ttsAudioPlayer" controls style="width: 100%;"></audio>
              <p class="snippet-text" id="ttsAudioStatus" style="margin-top: 0.5rem; font-size: 0.8rem;"></p>
            </div>
          </div>
        </div>
        <div class="modal-foot">
          <button id="copyDetailBtn" type="button" class="btn-secondary">
            <i class="fa-solid fa-copy"></i>
            <span data-i18n="history.copyOutput">Copy Output</span>
          </button>
          <button id="downloadTtsBtn" type="button" class="btn-secondary hidden">
            <i class="fa-solid fa-download"></i>
            <span data-i18n="history.downloadAudio">Download Audio</span>
          </button>
          <button type="button" class="btn-primary modal-close-action">
            <i class="fa-solid fa-xmark"></i>
            <span data-i18n="close">Close</span>
          </button>
        </div>
      </div>
    </div>

   
    <div id="confirmModal" class="modal-backdrop hidden" role="dialog" aria-modal="true" aria-labelledby="confirmTitle">
      <div class="modal-box small">
        <div class="modal-head">
          <h3 id="confirmTitle" data-i18n="history.confirmTitle">Are you sure?</h3>
          <button type="button" class="modal-close" aria-label="Close" data-i18n-aria="history.closeAria">
            <i class="fa-solid fa-xmark"></i>
          </button>
        </div>
        <div class="modal-body">
          <p class="confirm-text" id="confirmText" data-i18n="history.confirmText">This action cannot be undone.</p>
        </div>
        <div class="modal-foot">
          <button id="confirmCancelBtn" type="button" class="btn-secondary" data-i18n="cancel">Cancel</button>
          <button id="confirmOkBtn" type="button" class="btn-danger-ghost" data-i18n="delete">Delete</button>
        </div>
      </div>
    </div>

    <div id="toast" class="toast-msg">
      <i class="fa-solid fa-circle-check"></i>
      <span id="toastText"></span>
    </div>

    <script>
      const PAGE_SIZE = 8;

      const FEATURES = {
        transcribe: { label: () => NOX_I18N.t('history.filterTranscribe'), icon: 'fa-microphone', badgeClass: 'badge-transcribe' },
        summary:    { label: () => NOX_I18N.t('history.filterSummary'),    icon: 'fa-file-contract', badgeClass: 'badge-summary' },
        translate:  { label: () => NOX_I18N.t('history.filterTranslate'),  icon: 'fa-language', badgeClass: 'badge-translate' },
        todo:       { label: () => NOX_I18N.t('history.filterTodo'),      icon: 'fa-list-check', badgeClass: 'badge-todo' },
        tts:        { label: () => NOX_I18N.t('history.filterTts'),       icon: 'fa-volume-high', badgeClass: 'badge-tts' }
      };

      const LANG_NAMES = { en: 'English', my: 'Burmese', th: 'Thai', ja: 'Japanese', zh: 'Chinese', ko: 'Korean' };

      const state = {
        filter: 'all',
        search: '',
        page: 1,
        total: 0,
        hasMore: false,
        items: [],
        selected: new Set()
      };

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

     

      function showToast(message) {
        const toast = document.getElementById('toast');
        document.getElementById('toastText').textContent = message;
        toast.classList.add('show');
        clearTimeout(showToast._timer);
        showToast._timer = setTimeout(() => toast.classList.remove('show'), 2600);
      }

      function formatTime(dbTimestamp) {
        if (!dbTimestamp) return '';
        const date = new Date(dbTimestamp.replace(' ', 'T'));
        if (isNaN(date.getTime())) return dbTimestamp;
        const diffMs = Date.now() - date.getTime();
        const minutes = Math.floor(diffMs / 60000);
        if (minutes < 1) return NOX_I18N.t('history.justNow');
        if (minutes < 60) return NOX_I18N.tf('history.minAgo', { m: minutes });
        const hours = Math.floor(minutes / 60);
        if (hours < 24) return NOX_I18N.tf('history.hourAgo', { h: hours });
        const days = Math.floor(hours / 24);
        if (days < 7) return NOX_I18N.tf('history.dayAgo', { d: days });
        return date.toLocaleDateString(undefined, { year: 'numeric', month: 'short', day: 'numeric' });
      }

      function parseMetadata(raw) {
        try {
          return raw ? JSON.parse(raw) : {};
        } catch (e) {
          return {};
        }
      }

      function metaChips(meta) {
        const chips = [];
        if (meta.fileName) chips.push('<i class="fa-solid fa-file-audio"></i> ' + meta.fileName);
        if (meta.fileSizeKB) chips.push((meta.fileSizeKB / 1024).toFixed(1) + ' MB');
        if (meta.targetLang) chips.push('<i class="fa-solid fa-globe"></i> ' + NOX_I18N.t('history.to') + ': ' + (LANG_NAMES[meta.targetLang] || meta.targetLang.toUpperCase()));
        if (meta.taskCount != null) chips.push('<i class="fa-solid fa-list-check"></i> ' + NOX_I18N.tf('history.tasks', { n: meta.taskCount }));
        return chips;
      }

      function esc(value) {
        const div = document.createElement('div');
        div.textContent = value == null ? '' : String(value);
        return div.innerHTML;
      }

      function badgeHtml(featureType) {
        const f = FEATURES[featureType] || { label: () => featureType, icon: 'fa-star', badgeClass: '' };
        return '<span class="feature-badge ' + f.badgeClass + '"><i class="fa-solid ' + f.icon + '"></i>' + esc(typeof f.label === 'function' ? f.label() : f.label) + '</span>';
      }

      async function copyText(text) {
        try {
          await navigator.clipboard.writeText(text || '');
        } catch (e) {
          const ta = document.createElement('textarea');
          ta.value = text || '';
          document.body.appendChild(ta);
          ta.select();
          document.execCommand('copy');
          document.body.removeChild(ta);
        }
        showToast(NOX_I18N.t('history.copied'));
      }

 

      async function fetchList() {
        const params = new URLSearchParams({ filter: state.filter, page: state.page, limit: PAGE_SIZE });
        if (state.search) params.set('search', state.search);
        const res = await fetch('${pageContext.request.contextPath}/api/history?' + params.toString());
        if (res.status === 401) {
          window.location.href = '${pageContext.request.contextPath}/login';
          return null;
        }
        if (!res.ok) throw new Error('Failed to load history');
        return res.json();
      }

      async function fetchDetail(id) {
        const res = await fetch('${pageContext.request.contextPath}/api/history?id=' + encodeURIComponent(id));
        if (!res.ok) throw new Error('Failed to load detail');
        return res.json();
      }

      async function deleteRequest(query) {
        const res = await fetch('${pageContext.request.contextPath}/api/history?' + query, { method: 'DELETE' });
        if (!res.ok) throw new Error('Delete failed');
        return res.json();
      }



      function buildCard(item) {
        const card = document.createElement('div');
        card.className = 'activity-card' + (state.selected.has(item.id) ? ' selected' : '');
        card.dataset.id = item.id;

        const meta = parseMetadata(item.metadata);
        const chips = metaChips(meta);

        const top = document.createElement('div');
        top.className = 'activity-card-top';
        top.innerHTML =
          '<input type="checkbox" class="activity-check" aria-label="' + esc(NOX_I18N.t('history.selectAria')) + '">' +
          badgeHtml(item.featureType) +
          '<span class="activity-time">' + esc(formatTime(item.createdAt)) + '</span>';
        card.appendChild(top);

        const body = document.createElement('div');
        body.className = 'activity-card-body';
        body.innerHTML =
          '<div class="activity-snippet"><p class="snippet-label">' + esc(NOX_I18N.t('history.input')) + '</p>' +
          '<p class="snippet-text">' + esc(item.inputData || '-') + '</p></div>' +
          '<div class="activity-snippet"><p class="snippet-label">' + esc(NOX_I18N.t('history.output')) + '</p>' +
          '<p class="snippet-text">' + esc(item.outputData || '-') + '</p></div>';
        card.appendChild(body);

        if (chips.length) {
          const metaRow = document.createElement('div');
          metaRow.className = 'activity-meta';
          metaRow.innerHTML = chips.map((c) => '<span class="meta-chip">' + c + '</span>').join('');
          card.appendChild(metaRow);
        }

        const footer = document.createElement('div');
        footer.className = 'activity-card-footer';
        footer.innerHTML =
          '<button type="button" class="card-action" data-action="copy">' +
          '<i class="fa-solid fa-copy"></i><span>' + esc(NOX_I18N.t('history.copyAction')) + '</span></button>' +
          '<button type="button" class="card-action" data-action="view">' +
          '<i class="fa-solid fa-eye"></i><span>' + esc(NOX_I18N.t('history.viewAction')) + '</span></button>' +
          '<button type="button" class="card-action danger" data-action="delete">' +
          '<i class="fa-solid fa-trash-can"></i><span>' + esc(NOX_I18N.t('history.deleteAction')) + '</span></button>';
        card.appendChild(footer);

        const checkbox = top.querySelector('.activity-check');
        checkbox.checked = state.selected.has(item.id);
        checkbox.addEventListener('change', () => {
          if (checkbox.checked) {
            state.selected.add(item.id);
          } else {
            state.selected.delete(item.id);
          }
          card.classList.toggle('selected', checkbox.checked);
          updateBulkBar();
        });

        footer.addEventListener('click', (e) => {
          const btn = e.target.closest('button[data-action]');
          if (!btn) return;
          const action = btn.dataset.action;
          if (action === 'copy') copyText(item.outputData);
          if (action === 'view') openDetail(item.id);
          if (action === 'export') exportSingle(item.id);
          if (action === 'delete') confirmAction(NOX_I18N.t('history.deleteThis'), () => deleteItems([item.id]));
        });

        return card;
      }

      function render(data) {
        const list = document.getElementById('activityList');
        const loading = document.getElementById('loadingState');
        const empty = document.getElementById('emptyState');
        const pagination = document.getElementById('pagination');

        loading.classList.add('hidden');
        list.innerHTML = '';

        if (!data || data.error || !Array.isArray(data.items) || data.items.length === 0) {
          if (data && data.error) {
            document.getElementById('emptyTitle').textContent = NOX_I18N.t('history.failedToLoad');
            document.getElementById('emptyText').textContent = NOX_I18N.t('history.failedLoadToast');
          } else {
            document.getElementById('emptyTitle').textContent =
              (state.filter !== 'all' || state.search) ? NOX_I18N.t('history.noMatches') : NOX_I18N.t('history.emptyTitle');
            document.getElementById('emptyText').textContent =
              (state.filter !== 'all' || state.search)
                ? NOX_I18N.t('history.tryDifferent')
                : NOX_I18N.t('history.emptyText');
          }
          empty.classList.remove('hidden');
          pagination.classList.add('hidden');
          document.getElementById('totalLabel').textContent = NOX_I18N.t('history.noActivities');
          return;
        }

        empty.classList.add('hidden');
        data.items.forEach((item) => list.appendChild(buildCard(item)));

        document.getElementById('totalLabel').textContent =
          data.total === 1 ? NOX_I18N.t('history.totalActivity') : NOX_I18N.tf('history.totalActivities', { n: data.total });

        var totalPages = Math.max(1, Math.ceil(data.total / (data.limit || PAGE_SIZE)));
        document.getElementById('pageIndicator').textContent = NOX_I18N.tf('history.pageOf', { page: data.page || 1, total: totalPages });
        document.getElementById('prevPageBtn').disabled = (data.page || 1) <= 1;
        document.getElementById('nextPageBtn').disabled = !data.hasMore;
        pagination.classList.remove('hidden');
      }

      function updateBulkBar() {
        const deleteBtn = document.getElementById('deleteSelectedBtn');
        const hasSelection = state.selected.size > 0;
        
        deleteBtn.disabled = !hasSelection;
        deleteBtn.querySelector('span').textContent =
          hasSelection ? NOX_I18N.tf('history.deleteSelectedN', { n: state.selected.size }) : NOX_I18N.t('history.deleteSelected');
      }

      /* ---------------- load & refresh ---------------- */

      async function loadHistory() {
        const loading = document.getElementById('loadingState');
        loading.classList.remove('hidden');
        document.getElementById('activityList').innerHTML = '';
        try {
          const data = await fetchList();
          if (data) render(data);
        } catch (err) {
          console.error(err);
          loading.classList.add('hidden');
          document.getElementById('totalLabel').textContent = NOX_I18N.t('history.failedToLoad');
          showToast(NOX_I18N.t('history.failedLoadToast'));
        }
      }

      function goToPage(page) {
        state.page = page;
        loadHistory();
      }

      function deleteItems(ids) {
        deleteRequest('ids=' + encodeURIComponent(ids.join(',')))
          .then((data) => {
            showToast(NOX_I18N.tf('history.deletedN', { n: data.deleted }));
            ids.forEach((id) => state.selected.delete(id));
            updateBulkBar();
            if (state.items.length === ids.length && state.page > 1) {
              state.page -= 1;
            }
            loadHistory();
          })
          .catch(() => showToast(NOX_I18N.t('history.deleteFailed')));
      }

      function clearAll() {
        deleteRequest('all=true')
          .then((data) => {
            showToast(NOX_I18N.tf('history.deletedN', { n: data.deleted }));
            state.selected.clear();
            state.page = 1;
            updateBulkBar();
            loadHistory();
          })
          .catch(() => showToast(NOX_I18N.t('history.clearFailed')));
      }



      function openModal(id) {
        document.getElementById(id).classList.remove('hidden');
      }

      function closeModal(id) {
        document.getElementById(id).classList.add('hidden');
      }

      let pendingAction = null;

      function confirmAction(message, action) {
        document.getElementById('confirmText').textContent = message;
        pendingAction = action;
        openModal('confirmModal');
      }

      function openDetail(id) {
        fetchDetail(id)
          .then((item) => {
            const meta = parseMetadata(item.metadata);
            const f = FEATURES[item.featureType] || { label: () => item.featureType, icon: 'fa-star', badgeClass: '' };
            document.getElementById('detailBadge').className = 'feature-badge ' + f.badgeClass;
            document.getElementById('detailBadge').innerHTML =
              '<i class="fa-solid ' + f.icon + '"></i>' + esc(typeof f.label === 'function' ? f.label() : f.label);
            document.getElementById('detailModalTitle').textContent = NOX_I18N.tf('history.activityFrom', { time: formatTime(item.createdAt) });

            const chips = metaChips(meta);
            document.getElementById('detailMeta').innerHTML = chips.length
              ? chips.map((c) => '<span class="meta-chip">' + c + '</span>').join('')
              : '<span class="meta-chip">' + esc(item.createdAt) + '</span>';

            document.getElementById('detailInput').textContent = item.inputData || '-';
            document.getElementById('detailOutput').textContent = item.outputData || '-';
            document.getElementById('copyDetailBtn').dataset.text = item.outputData || '';

  
            const ttsAudioSection = document.getElementById('ttsAudioSection');
            const ttsAudioPlayer = document.getElementById('ttsAudioPlayer');
            const ttsAudioStatus = document.getElementById('ttsAudioStatus');
            const downloadTtsBtn = document.getElementById('downloadTtsBtn');
            

            let ttsAudioQueue = [];
            let ttsCurrentAudio = null;
            let ttsIsStopped = false;

            function splitTextForTts(text, maxLength = 100) {
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
              return chunks.filter(c => c.length > 0);
            }

            function processTtsQueue() {
              if (ttsIsStopped || ttsAudioQueue.length === 0) {
                ttsAudioStatus.textContent = '';
                return;
              }
              const currentItem = ttsAudioQueue.shift();
              ttsAudioStatus.textContent = NOX_I18N.tf('history.speakingChunk', { current: currentItem.index, total: currentItem.total });
              
              const chunkUrl = '${pageContext.request.contextPath}/api/tts?text=' + encodeURIComponent(currentItem.text) + '&tl=' + encodeURIComponent(currentItem.lang);
              
              fetch(chunkUrl)
                .then(response => {
                  if (!response.ok) throw new Error('Server status: ' + response.status);
                  return response.blob();
                })
                .then(blob => {
                  if (ttsIsStopped) return;
                  const blobUrl = URL.createObjectURL(blob);
                  ttsCurrentAudio = new Audio(blobUrl);
                  
                  ttsCurrentAudio.onended = () => {
                    URL.revokeObjectURL(blobUrl);
                    processTtsQueue();
                  };
                  ttsCurrentAudio.onerror = () => {
                    URL.revokeObjectURL(blobUrl);
                    processTtsQueue();
                  };
                  
                  ttsCurrentAudio.play().catch(() => processTtsQueue());
                })
                .catch(() => processTtsQueue());
            }

            if (item.featureType === 'TTS') {
              ttsAudioSection.classList.remove('hidden');
              downloadTtsBtn.classList.remove('hidden');
              ttsAudioStatus.textContent = NOX_I18N.t('history.regeneratingAudio');
              
              const lang = meta.lang || 'my';
              const fullText = item.inputData || '';
              const chunks = splitTextForTts(fullText, 100);
              
              if (chunks.length === 1) {
   
                const ttsUrl = '${pageContext.request.contextPath}/api/tts?text=' + encodeURIComponent(chunks[0]) + '&tl=' + lang;
                ttsAudioPlayer.src = ttsUrl;
                ttsAudioPlayer.onloadeddata = () => { ttsAudioStatus.textContent = ''; };
                ttsAudioPlayer.onerror = () => { ttsAudioStatus.textContent = NOX_I18N.t('history.audioFailed'); };
              } else {
          
                ttsAudioPlayer.style.display = 'none';
                ttsAudioQueue = chunks.map((chunk, i) => ({
                  text: chunk,
                  lang: lang,
                  index: i + 1,
                  total: chunks.length
                }));
                ttsIsStopped = false;
                processTtsQueue();
              }

    
              downloadTtsBtn.onclick = async () => {
                downloadTtsBtn.disabled = true;
                downloadTtsBtn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> ' + NOX_I18N.t('history.regeneratingAudio');
                try {
                  const downloadUrl = '${pageContext.request.contextPath}/api/tts/download?text=' + encodeURIComponent(fullText) + '&tl=' + encodeURIComponent(lang) + '&filename=tts-' + item.id + '.mp3';
                  const response = await fetch(downloadUrl);
                  if (!response.ok) {
                    const errorText = await response.text();
                    throw new Error(errorText || 'Failed to download audio');
                  }
                  const blob = await response.blob();
                  const url = URL.createObjectURL(blob);
                  const a = document.createElement('a');
                  a.href = url;
                  a.download = 'tts-' + item.id + '.mp3';
                  document.body.appendChild(a);
                  a.click();
                  document.body.removeChild(a);
                  URL.revokeObjectURL(url);
                  showToast(NOX_I18N.t('history.activityExported'));
                } catch (err) {
                  console.error(err);
                  showToast(NOX_I18N.t('history.exportFailed'));
                } finally {
                  downloadTtsBtn.disabled = false;
                  downloadTtsBtn.innerHTML = '<i class="fa-solid fa-download"></i> ' + NOX_I18N.t('history.downloadAudio');
                }
              };

      
              const stopTtsPlayback = () => {
                ttsIsStopped = true;
                ttsAudioQueue = [];
                if (ttsCurrentAudio) {
                  ttsCurrentAudio.pause();
                  ttsCurrentAudio.src = '';
                  ttsCurrentAudio = null;
                }
                ttsAudioPlayer.pause();
                ttsAudioPlayer.src = '';
              };
              
         
              const modalCloseBtns = document.querySelectorAll('#detailModal .modal-close, #detailModal .modal-close-action');
              modalCloseBtns.forEach(btn => {
                btn.onclick = () => {
                  stopTtsPlayback();
                  closeModal('detailModal');
                };
              });
              document.getElementById('detailModal').onclick = (e) => {
                if (e.target === e.currentTarget) {
                  stopTtsPlayback();
                  closeModal('detailModal');
                }
              };
            } else {
              ttsAudioSection.classList.add('hidden');
              downloadTtsBtn.classList.add('hidden');
              ttsAudioPlayer.style.display = '';
              ttsAudioPlayer.src = '';
              ttsAudioPlayer.removeAttribute('src');
              downloadTtsBtn.onclick = null;
            }

            openModal('detailModal');
          })
          .catch(() => showToast(NOX_I18N.t('history.failedLoadDetail')));
      }

   

      document.querySelectorAll('.filter-pill').forEach((pill) => {
        pill.addEventListener('click', () => {
          document.querySelectorAll('.filter-pill').forEach((p) => p.classList.remove('active'));
          pill.classList.add('active');
          state.filter = pill.dataset.filter;
          state.page = 1;
          loadHistory();
        });
      });

      let searchTimer = null;
      document.getElementById('searchInput').addEventListener('input', (e) => {
        clearTimeout(searchTimer);
        searchTimer = setTimeout(() => {
          state.search = e.target.value.trim();
          state.page = 1;
          loadHistory();
        }, 350);
      });

      document.getElementById('prevPageBtn').addEventListener('click', () => goToPage(state.page - 1));
      document.getElementById('nextPageBtn').addEventListener('click', () => goToPage(state.page + 1));

      document.getElementById('deleteSelectedBtn').addEventListener('click', () => {
        const ids = Array.from(state.selected);
        confirmAction(NOX_I18N.tf('history.deleteSelectedConfirm', { n: ids.length }), () => deleteItems(ids));
      });

      document.getElementById('clearAllBtn').addEventListener('click', () => {
        confirmAction(NOX_I18N.t('history.deleteAllConfirm'), clearAll);
      });

      document.getElementById('confirmOkBtn').addEventListener('click', () => {
        closeModal('confirmModal');
        if (pendingAction) {
          const action = pendingAction;
          pendingAction = null;
          action();
        }
      });

      document.getElementById('confirmCancelBtn').addEventListener('click', () => closeModal('confirmModal'));

      document.querySelectorAll('#confirmModal .modal-close').forEach((btn) => {
        btn.addEventListener('click', () => closeModal('confirmModal'));
      });

      document.getElementById('copyDetailBtn').addEventListener('click', (e) => {
        copyText(e.currentTarget.dataset.text);
      });

      document.querySelectorAll('#detailModal .modal-close, #detailModal .modal-close-action').forEach((btn) => {
        btn.addEventListener('click', () => closeModal('detailModal'));
      });

      document.querySelectorAll('.modal-backdrop').forEach((backdrop) => {
        backdrop.addEventListener('click', (e) => {
          if (e.target === backdrop) backdrop.classList.add('hidden');
        });
      });

      document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape') {
          document.querySelectorAll('.modal-backdrop').forEach((m) => m.classList.add('hidden'));
        }
      });

      loadHistory();
    </script>
  </body>
</html>

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
  <style>
    .todo-deadline {
      display: flex;
      align-items: center;
      gap: 0.4rem;
      margin-right: 0.35rem;
      flex-shrink: 0;
    }

    .todo-deadline input.todo-date,
    .todo-deadline input.todo-time {
      width: auto;
      padding: 0.4rem 0.5rem;
      border: 1.5px solid #DCEBF2;
      border-radius: 10px;
      background: #FFFFFF;
      color: #263238;
      font-size: 0.8rem;
      font-weight: 500;
      outline: none;
      transition: border-color 0.2s, box-shadow 0.2s;
    }

    .todo-deadline input:focus {
      border-color: #20A8C4;
      box-shadow: 0 0 0 3px rgba(32, 168, 196, 0.2);
    }

    @media (max-width: 640px) {
      .todo-item {
        flex-wrap: wrap;
        gap: 0.5rem;
      }
      .todo-deadline {
        width: 100%;
        justify-content: flex-end;
      }
    }
  </style>
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
					<p data-i18n="todo.brandTag">To-Do List </p>
					<h1 data-i18n="brand.aiAssistant">NOX</h1>
				</div>
			</div>

			<nav class="side-nav" aria-label="Primary navigation">
				<a href="${pageContext.request.contextPath}/index" class="nav-link"> 
					<i class="fa-solid fa-microphone"></i> <span data-i18n="side.transcribe">Transcribe</span>
				</a> 
				<a href="${pageContext.request.contextPath}/translate" class="nav-link"> 
					<i class="fa-solid fa-language"></i> <span data-i18n="side.translate">Translate</span>
				</a> 
				<a href="${pageContext.request.contextPath}/summary" class="nav-link"> 
					<i class="fa-solid fa-file-contract"></i> <span data-i18n="side.summarize">Summarize</span>
				</a> 
				<a href="${pageContext.request.contextPath}/todolist" class="nav-link active"> 
					<i class="fa-solid fa-list-check"></i> <span data-i18n="side.todo">To-Do List</span>
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
				<i class="fa-solid fa-user"></i> <span data-i18n="nav.profile">Profile</span>
			</a>
		</header>

		<main class="app-main">
			<div class="top-navigation-bar">
				<a href="${pageContext.request.contextPath}/index" class="back-link"><i class="fa-solid fa-arrow-left"></i> <span data-i18n="back.toRecording">Back to Recording Workspace</span></a>
			</div>

			<div class="panel">
				<div class="panel-header">
					<div>
						<p class="eyebrow" data-i18n="todo.eyebrow">Task Extraction</p>
						<h2 data-i18n="todo.title">Generated To-Do List</h2>
					</div>
					<button id="extractTasksBtn" class="btn-primary" type="button">
						<i class="fa-solid fa-bolt"></i> <span data-i18n="todo.extract">Extract Action Items</span>
					</button>
				</div>

				<div class="progress-section">
					<div class="progress-meta">
						<span data-i18n="todo.progressLabel">Task Completion</span> <span id="progressText">0 of 0 completed</span>
					</div>
					<div class="progress-bar-bg">
						<div id="progressBarFill" class="progress-bar-fill"></div>
					</div>
				</div>

				<div class="input-group">
					<input type="text" id="manualTaskInput" class="todo-input" data-i18n-placeholder="todo.addPlaceholder" placeholder="Add a custom task manually..." />
					<button id="addTaskBtn" class="btn-secondary" type="button">
						<i class="fa-solid fa-plus"></i> <span data-i18n="todo.add">Add</span>
					</button>
				</div>

				<div class="filter-bar">
					<button class="filter-tab active" data-filter="all" data-i18n="todo.filterAll">All</button>
					<button class="filter-tab" data-filter="active" data-i18n="todo.filterActive">Active</button>
					<button class="filter-tab" data-filter="completed" data-i18n="todo.filterCompleted">Completed</button>
				</div>

				<ul id="todoList" class="todo-list"></ul>

				<!-- ACTION BUTTON FOOTER -->
				<div class="output-footer" style="display: flex; gap: 0.75rem; flex-wrap: wrap; justify-content: flex-end; margin-top: 1.5rem;">
					<button id="summaryNavBtn" class="btn transcribe" type="button">
						<i class="fa-solid fa-file-contract"></i> <span data-i18n="btn.summarize">Summarize</span>
					</button>
					<button id="translateNavBtn" class="btn translate" type="button">
						<i class="fa-solid fa-language"></i> <span data-i18n="btn.translate">Translate</span>
					</button>
					<button id="textNavBtn" class="btn transcribe" type="button">
						<i class="fa-solid fa-pen-to-square"></i> <span data-i18n="btn.qna">Q&A</span>
					</button>
				</div>
			</div>
		</main>
	</div>

	<script>
    const TRANSCRIBE_KEY = 'transcribeOriginalText';

    // ----------------------------------------------------------------
    // Sidebar Toggle Logic
    // ----------------------------------------------------------------
    const brandLogo = document.getElementById('brandLogo');
    const appShell  = document.getElementById('appShell');

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
        if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); toggleSidebar(); }
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

    // ----------------------------------------------------------------
    // DOM refs
    // ----------------------------------------------------------------
    const todoList       = document.getElementById('todoList');
    const manualTaskInput= document.getElementById('manualTaskInput');
    const addTaskBtn     = document.getElementById('addTaskBtn');
    const extractTasksBtn= document.getElementById('extractTasksBtn');
    const progressText   = document.getElementById('progressText');
    const progressBarFill= document.getElementById('progressBarFill');
    const filterTabs     = document.querySelectorAll('.filter-tab');
    const translateNavBtn= document.getElementById('translateNavBtn');
    const summaryNavBtn  = document.getElementById('summaryNavBtn');
    const textNavBtn     = document.getElementById('textNavBtn');

    let currentFilter = 'all';

    // ----------------------------------------------------------------
    // Progress + filter helpers
    // ----------------------------------------------------------------
    function updateProgress() {
      const items     = todoList.querySelectorAll('.todo-item');
      const total     = items.length;
      const completed = todoList.querySelectorAll('.todo-item.completed').length;
      progressText.textContent = NOX_I18N.tf('todo.progress', {completed, total});
      progressBarFill.style.width = (total === 0 ? 0 : (completed / total) * 100) + '%';
      checkEmptyState();
    }

    function checkEmptyState() {
      const visible = todoList.querySelectorAll('.todo-item:not([style*="display: none"])');
      let emptyState = todoList.querySelector('.empty-state');
      if (visible.length === 0) {
        if (!emptyState) {
          emptyState = document.createElement('div');
          emptyState.className = 'empty-state';
          emptyState.innerHTML = `
            <i class="fa-solid fa-clipboard-list"></i>
            <p>${NOX_I18N.t('todo.empty')}</p>
          `;
          todoList.appendChild(emptyState);
        }
      } else if (emptyState) {
        emptyState.remove();
      }
    }

    function applyFilter() {
      todoList.querySelectorAll('.todo-item').forEach(item => {
        const done = item.classList.contains('completed');
        if      (currentFilter === 'all')       item.style.display = 'flex';
        else if (currentFilter === 'active')    item.style.display = done ? 'none' : 'flex';
        else if (currentFilter === 'completed') item.style.display = done ? 'flex' : 'none';
      });
      checkEmptyState();
    }

    filterTabs.forEach(tab => {
      tab.addEventListener('click', () => {
        filterTabs.forEach(t => t.classList.remove('active'));
        tab.classList.add('active');
        currentFilter = tab.dataset.filter;
        applyFilter();
      });
    });

    // ----------------------------------------------------------------
    // Date / time parser – best-effort extraction from task text
    // Only extracts when the text contains an explicit date/day/time.
    // ----------------------------------------------------------------
    function pad2(n) { return String(n).padStart(2, '0'); }
    function fmtDate(d) { return d.getFullYear() + '-' + pad2(d.getMonth()+1) + '-' + pad2(d.getDate()); }

    function parseDateTimeFromText(text) {
      const lc  = text.toLowerCase();
      const now = new Date();
      let date  = null;
      let time  = null;

      // ── Relative / named days ──────────────────────────────────────
      if (lc.includes('today')) {
        date = fmtDate(now);
      } else if (lc.includes('tomorrow')) {
        const d = new Date(now); d.setDate(d.getDate() + 1); date = fmtDate(d);
      } else if (/\bnext\s+week\b/.test(lc)) {
        const d = new Date(now); d.setDate(d.getDate() + 7); date = fmtDate(d);
      } else {
        const dayNames = ['sunday','monday','tuesday','wednesday','thursday','friday','saturday'];
        for (let i = 0; i < dayNames.length; i++) {
          if (lc.includes(dayNames[i])) {
            const diff = ((i - now.getDay()) + 7) % 7 || 7; // always next occurrence
            const d = new Date(now); d.setDate(d.getDate() + diff); date = fmtDate(d);
            break;
          }
        }
      }

      // ── ISO date YYYY-MM-DD ────────────────────────────────────────
      const isoM = text.match(/\b(\d{4}-\d{2}-\d{2})\b/);
      if (isoM) date = isoM[1];

      // ── Time: 3pm / 3:30pm / 15:00 ────────────────────────────────
      const ampmRe = /\b(\d{1,2})(?::(\d{2}))?\s*(am|pm)\b/i;
      const h24Re  = /\b([01]?\d|2[0-3]):([0-5]\d)\b/;
      const tAmpm  = text.match(ampmRe);
      if (tAmpm) {
        let h = parseInt(tAmpm[1], 10);
        const m = tAmpm[2] ? parseInt(tAmpm[2], 10) : 0;
        const mer = tAmpm[3].toLowerCase();
        if (mer === 'pm' && h !== 12) h += 12;
        if (mer === 'am' && h === 12) h = 0;
        time = pad2(h) + ':' + pad2(m);
      } else {
        const t24 = text.match(h24Re);
        if (t24) time = t24[0];
      }

      return (date || time) ? { date, time } : null;
    }

   
    function fmtDateTimeLocal(d) {
      return d.getFullYear() + '-' + pad2(d.getMonth()+1) + '-' + pad2(d.getDate()) +
             ' ' + pad2(d.getHours()) + ':' + pad2(d.getMinutes()) + ':00';
    }

    function setupDeadlineAutoReminder(dateInput, timeInput, span, reminderBtn) {
      let currentId = null;
      let lastKey   = '';

      function updateBellState() {
        if (currentId !== null) {
          reminderBtn.classList.add('has-reminder');
          reminderBtn.title     = 'Edit reminder';
          reminderBtn.innerHTML = '<i class="fa-solid fa-bell"></i>';
        } else {
          reminderBtn.classList.remove('has-reminder');
          reminderBtn.title     = 'Add reminder';
          reminderBtn.innerHTML = '<i class="fa-regular fa-bell"></i>';
        }
      }

     
      function computePayload(useDefaultDeadline) {
        const api = window.NOX_REMINDERS;
        if (!api) return null;
        const defaults     = api.getDefaults();
        const offsetType   = defaults.offsetType;
        const offsetMin    = defaults.offsetMinutes;

        let dueDate, dueMs;
        if (dateInput.value && timeInput.value) {
          dueDate = dateInput.value + ' ' + timeInput.value + ':00';
          dueMs   = new Date(dateInput.value + 'T' + timeInput.value + ':00').getTime();
        } else if (useDefaultDeadline) {
        
          const deadline = (defaults.deadlineMinutes || 1440) * 60000;
          const d = new Date(Date.now() + deadline);
          dueDate = fmtDateTimeLocal(d);
          dueMs   = d.getTime();
        } else {
          return null;
        }

        let triggerMs = dueMs;
        if      (offsetType === '1_DAY_BEFORE')                triggerMs = dueMs - 86400000;
        else if (offsetType === '1_HOUR_BEFORE')               triggerMs = dueMs - 3600000;
        else if (offsetType === '10_MIN_BEFORE')               triggerMs = dueMs - 600000;
        else if (offsetType === 'CUSTOM' && offsetMin)         triggerMs = dueMs - offsetMin * 60000;

        if (isNaN(triggerMs) || triggerMs <= Date.now()) return null;

        const payload = { text: span.textContent, dueDate: dueDate, offsetType: offsetType };
        if (offsetType === 'CUSTOM' && offsetMin) payload.customOffsetMinutes = offsetMin;
        return payload;
      }

      async function ensureReminder(useDefaultDeadline) {
        const api = window.NOX_REMINDERS;
        if (!api) return;
        const payload = computePayload(useDefaultDeadline);
        if (!payload) return;
        try {
          if (currentId === null) {
            const result = await api.create(payload);
            if (result && result.success) {
              currentId = result.id;
              updateBellState();
              api.updateBadge && api.updateBadge();
            }
          } else {
            await api.update(currentId, payload);
            api.updateBadge && api.updateBadge();
          }
        } catch (e) { console.error(e); }
      }


      reminderBtn.addEventListener('click', async () => {
        const api = window.NOX_REMINDERS;
        if (!api) return;
        if (currentId !== null) {
          try {
            const items = await api.list();
            const item  = items.find(r => r.id === currentId);
            if (item) { api.openAndEdit(item); return; }
          } catch (_) {}
          currentId = null;
          updateBellState();
        }
        api.openAndNew(span.textContent);
      });


      async function syncReminder() {
        const dateVal = dateInput.value;
        const timeVal = timeInput.value;
        const key     = (dateVal || '') + '|' + (timeVal || '');
        if (key === lastKey) return;
        lastKey = key;

        const api = window.NOX_REMINDERS;
        if (!api) return;


        if (!dateVal || !timeVal) {
          if (currentId !== null) {
            try { await api.remove(currentId); } catch (_) {}
            currentId = null;
            updateBellState();
            api.updateBadge && api.updateBadge();
          }
          return;
        }

        await ensureReminder(false);
      }

      dateInput.addEventListener('change', syncReminder);
      timeInput.addEventListener('change', syncReminder);

      return { ensureReminder };
    }

   
    function createTodoElement(taskText, isExtracted) {
      const li = document.createElement('li');
      li.className = 'todo-item';

      const contentDiv = document.createElement('div');
      contentDiv.className = 'todo-content';

      const checkbox = document.createElement('input');
      checkbox.type      = 'checkbox';
      checkbox.className = 'todo-checkbox';

      const span = document.createElement('span');
      span.className   = 'todo-text';
      span.textContent = taskText;

      checkbox.addEventListener('change', () => {
        li.classList.toggle('completed', checkbox.checked);
        updateProgress();
        applyFilter();
      });

      contentDiv.appendChild(checkbox);
      contentDiv.appendChild(span);

      const deleteBtn = document.createElement('button');
      deleteBtn.className = 'delete-btn';
      deleteBtn.title     = 'Delete Task';
      deleteBtn.type      = 'button';
      deleteBtn.innerHTML = '<i class="fa-solid fa-trash-can"></i>';
      deleteBtn.addEventListener('click', () => { li.remove(); updateProgress(); });

      if (isExtracted) {
     
        const deadlineWrap = document.createElement('div');
        deadlineWrap.className = 'todo-deadline';

        const dateInput = document.createElement('input');
        dateInput.type      = 'date';
        dateInput.className = 'todo-date';
        dateInput.title     = 'Deadline date';

        const timeInput = document.createElement('input');
        timeInput.type      = 'time';
        timeInput.className = 'todo-time';
        timeInput.title     = 'Deadline time';

        const reminderBtn = document.createElement('button');
        reminderBtn.type      = 'button';
        reminderBtn.className = 'todo-reminder-btn';
        reminderBtn.title     = 'Add reminder';
        reminderBtn.innerHTML = '<i class="fa-regular fa-bell"></i>';

        deadlineWrap.appendChild(dateInput);
        deadlineWrap.appendChild(timeInput);
        deadlineWrap.appendChild(reminderBtn);

        const auto = setupDeadlineAutoReminder(dateInput, timeInput, span, reminderBtn);

        li.appendChild(contentDiv);
        li.appendChild(deadlineWrap);
        li.appendChild(deleteBtn);

     
        li._dateInput = dateInput;
        li._timeInput = timeInput;
        li.__ensureReminder = auto.ensureReminder;
      } else {
    
        const reminderBtn = document.createElement('button');
        reminderBtn.type      = 'button';
        reminderBtn.className = 'todo-reminder-btn';
        reminderBtn.title     = 'Add reminder';
        reminderBtn.innerHTML = '<i class="fa-regular fa-bell"></i>';
        reminderBtn.addEventListener('click', () => {
          const api = window.NOX_REMINDERS;
          if (api) api.openAndNew(span.textContent);
        });

        li.appendChild(contentDiv);
        li.appendChild(reminderBtn);
        li.appendChild(deleteBtn);
      }

      return li;
    }

    
    addTaskBtn.addEventListener('click', () => {
      const text = manualTaskInput.value.trim();
      if (!text) return;
      const emptyState = todoList.querySelector('.empty-state');
      if (emptyState) emptyState.remove();
      todoList.appendChild(createTodoElement(text, false));
      manualTaskInput.value = '';
      updateProgress();
      applyFilter();
    });

    manualTaskInput.addEventListener('keypress', (e) => {
      if (e.key === 'Enter') { e.preventDefault(); addTaskBtn.click(); }
    });

    
    async function extractTasks() {
      const sourceText = sessionStorage.getItem(TRANSCRIBE_KEY);
      if (!sourceText) { alert(NOX_I18N.t('todo.noText')); return; }

      extractTasksBtn.disabled = true;
      extractTasksBtn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> ' + NOX_I18N.t('todo.extracting');

      try {
        const response = await fetch('${pageContext.request.contextPath}/api/todolist', {
          method:  'POST',
          headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
          body:    new URLSearchParams({ text: sourceText })
        });

        const data = await response.json();

        if (response.ok && Array.isArray(data.tasks)) {
          todoList.innerHTML = '';

          for (const task of data.tasks) {
            const li = createTodoElement(task, true);
            todoList.appendChild(li);

            
            const parsed = parseDateTimeFromText(task);
            if (parsed && li._dateInput && li._timeInput) {
              if (parsed.date) li._dateInput.value = parsed.date;
              if (parsed.time) li._timeInput.value = parsed.time;
            }

          
            if (li.__ensureReminder) {
              await li.__ensureReminder(true);
            }
          }

          updateProgress();
          applyFilter();
        }
      } catch (error) {
        console.error(error);
      } finally {
        extractTasksBtn.disabled = false;
        extractTasksBtn.innerHTML = '<i class="fa-solid fa-bolt"></i> ' + NOX_I18N.t('todo.extract');
      }
    }

    extractTasksBtn.addEventListener('click', extractTasks);

    window.addEventListener('DOMContentLoaded', () => {
      checkEmptyState();
      if (sessionStorage.getItem(TRANSCRIBE_KEY)) {
        extractTasks();
      }
    });

    
    translateNavBtn.addEventListener('click', () => { window.location.href = '${pageContext.request.contextPath}/translate'; });
    summaryNavBtn.addEventListener('click',   () => { window.location.href = '${pageContext.request.contextPath}/summary'; });
    textNavBtn.addEventListener('click',      () => { window.location.href = '${pageContext.request.contextPath}/text'; });
  </script>
</body>
</html>

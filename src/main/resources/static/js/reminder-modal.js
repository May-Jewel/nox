/* ==========================================================================
 * reminder-modal.js - Sidebar Reminders card for NOX.
 *
 * Provides:
 *   - A shared modal opened from the sidebar bell button.
 *   - View / create / edit / delete reminders (POST/PUT/GET/DELETE /reminder).
 *   - Global "Default Settings" panel (offsetType + custom minutes) persisted
 *     via GET/PUT /user-defaults.
 *   - Pending-reminder badge count on every .reminder-bell button.
 *   - window.NOX_REMINDERS API re-used by todolist.html.
 * ========================================================================== */
console.log("REMINDER MODAL LOADED");

import { initializeApp } from "https://www.gstatic.com/firebasejs/10.13.2/firebase-app.js";
import {
  getMessaging,
  getToken
} from "https://www.gstatic.com/firebasejs/10.13.2/firebase-messaging.js";

import { firebaseConfig } from "./firebase-config.js";

const app       = initializeApp(firebaseConfig);
const messaging = getMessaging(app);

const VAPID_KEY = "BCj6bun5U5b3tchg3yad2U6R-VlQvBqRueK7jMxTzD_Nq3lA5-p9yLTsEXzzeXE8tlfEcXr8x0Kxyvv_SCVwU2Y";

const UNIT_MULTIPLIER = { minutes: 1, hours: 60, days: 1440 };

/* ------------------------------------------------------------------ */
/*  User defaults cache                                                */
/* ------------------------------------------------------------------ */
let cachedDefaults = { offsetType: "1_DAY_BEFORE", offsetMinutes: null, deadlineMinutes: 1440 };

/* ------------------------------------------------------------------ */
/*  Tiny i18n + element helpers                                        */
/* ------------------------------------------------------------------ */
function mt(key) {
  if (window.NOX_I18N && typeof window.NOX_I18N.t === "function") {
    const v = window.NOX_I18N.t(key);
    if (v && v !== key) return v;
  }
  return fallback(key);
}

const FALLBACK = {
  "reminder.title":               "Set a Reminder",
  "reminder.eyebrow":             "Deadline Alerts",
  "reminder.reminders":           "Reminders",
  "reminder.new":                 "New Reminder",
  "reminder.save":                "Save Reminder",
  "reminder.cancel":              "Cancel",
  "reminder.close":               "Close",
  "reminder.taskLabel":           "Task / Reminder Text",
  "reminder.taskPlaceholder":     "Enter your reminder or task...",
  "reminder.dueDateLabel":        "Deadline Date",
  "reminder.dueTimeLabel":        "Deadline Time",
  "reminder.offsetLabel":         "Remind Me",
  "reminder.offsetExact":         "At deadline",
  "reminder.offset10min":         "10 minutes before",
  "reminder.offset1hr":           "1 hour before",
  "reminder.offset1day":          "1 day before",
  "reminder.offsetCustom":        "Custom: before deadline",
  "reminder.customLabel":         "Remind before",
  "reminder.customMinutes":       "minutes",
  "reminder.customHours":         "hours",
  "reminder.customDays":          "days",
  "reminder.enableNotifications": "Enable Notifications",
  "reminder.noReminders":         "No reminders yet.",
  "reminder.noRemindersHint":     "Set a deadline on an extracted task, or add one manually.",
  "reminder.dueLabel":            "Due",
  "reminder.alertLabel":          "Alert",
  "reminder.permissionDenied":    "❌ Notification permission denied.",
  "reminder.enabled":             "✅ Notifications enabled.",
  "reminder.notificationFailed":  "❌ Notification setup failed.",
  "reminder.fillAll":             "⚠️ Please fill all required fields.",
  "reminder.futureTime":          "⚠️ Please select a future time.",
  "reminder.saving":              "Saving...",
  "reminder.saved":               "✅ Reminder saved successfully.",
  "reminder.updated":             "✅ Reminder updated.",
  "reminder.failed":              "Reminder could not be saved.",
  "reminder.connFailed":          "❌ Could not connect to server.",
  "reminder.deleted":             "Reminder deleted.",
  "reminder.deleteFailed":        "Failed to delete reminder.",
  "reminder.deleteThis":          "Delete this reminder?"
};

function fallback(key) { return FALLBACK[key] || key; }
function el(id)         { return document.getElementById(id); }
function setStatus(msg) { const s = el("reminderStatus"); if (s) s.textContent = msg; }
function pad(n)         { return String(n).padStart(2, "0"); }

/* ------------------------------------------------------------------ */
/*  User-defaults API                                                  */
/* ------------------------------------------------------------------ */
async function loadUserDefaults() {
  try {
    const data = await requestJSON("user-defaults", {
      method: "GET",
      headers: { "Accept": "application/json" }
    });
    if (data && data.success) {
      cachedDefaults = {
        offsetType:      data.offsetType      || "1_DAY_BEFORE",
        offsetMinutes:   data.offsetMinutes   != null ? Number(data.offsetMinutes) : null,
        deadlineMinutes: data.deadlineMinutes != null ? Number(data.deadlineMinutes) : 1440
      };
    }
  } catch (e) {
    console.warn("Could not load user defaults:", e);
  }
  return cachedDefaults;
}

function getDefaults() {
  return {
    offsetType:      cachedDefaults.offsetType,
    offsetMinutes:   cachedDefaults.offsetMinutes,
    deadlineMinutes: cachedDefaults.deadlineMinutes
  };
}

/* ------------------------------------------------------------------ */
/*  Badge – pending reminder count on every .reminder-bell button      */
/* ------------------------------------------------------------------ */
async function updateBadge() {
  try {
    const bells = document.querySelectorAll(".reminder-bell");
    if (!bells.length) return;

    const items = await listReminders();
    const now   = Date.now();
    const count = items.filter(item => {
      if (item.sent) return false;
      const t = new Date((item.reminderTime || "").replace(" ", "T")).getTime();
      return t > now;
    }).length;

    bells.forEach(bell => {
      let badge = bell.querySelector(".reminder-badge");
      if (count > 0) {
        if (!badge) {
          badge = document.createElement("span");
          badge.className = "reminder-badge";
          bell.appendChild(badge);
        }
        badge.textContent = count > 99 ? "99+" : String(count);
        badge.hidden = false;
      } else if (badge) {
        badge.hidden = true;
      }
    });
  } catch (_) { /* silently ignore – user may not be logged in */ }
}

/* ------------------------------------------------------------------ */
/*  Modal DOM                                                          */
/* ------------------------------------------------------------------ */
function buildModal() {
  if (document.getElementById("reminderOverlay")) return;

  const overlay = document.createElement("div");
  overlay.className = "reminder-overlay";
  overlay.id        = "reminderOverlay";

  overlay.innerHTML = `
    <div class="reminder-modal" role="dialog" aria-modal="true" aria-labelledby="reminderTitle">
      <div class="reminder-modal-header">
        <div>
          <p class="reminder-modal-eyebrow" data-rm="reminder.eyebrow">Deadline Alerts</p>
          <h3 id="reminderTitle" data-rm="reminder.title">Set a Reminder</h3>
        </div>
        <button class="reminder-modal-close" id="reminderClose" type="button"
                aria-label="Close" data-rm-aria="reminder.close">&#10005;</button>
      </div>

      <p class="reminder-status" id="reminderStatus" role="status" aria-live="polite"></p>

      <!-- LIST VIEW -->
      <div id="reminderListPanel">

        <button class="reminder-enable-btn" id="reminderEnableBtn" type="button">
          <i class="fa-solid fa-bell"></i>
          <span data-rm="reminder.enableNotifications">Enable Notifications</span>
        </button>
        <ul class="reminder-ul" id="reminderUl"></ul>
        <button class="btn-primary reminder-new-btn" id="reminderNewBtn" type="button">
          <i class="fa-solid fa-plus"></i>
          <span data-rm="reminder.new">New Reminder</span>
        </button>
      </div>

      <!-- FORM VIEW -->
      <div id="reminderFormPanel" hidden>
        <div class="reminder-form-group">
          <label for="reminderTextInput" data-rm="reminder.taskLabel">Task / Reminder Text</label>
          <input type="text" id="reminderTextInput"
                 placeholder="Enter your reminder or task..."
                 data-rm-ph="reminder.taskPlaceholder" />
        </div>

        <div class="reminder-form-row">
          <div class="reminder-form-group">
            <label for="reminderDueDate" data-rm="reminder.dueDateLabel">Deadline Date</label>
            <input type="date" id="reminderDueDate" />
          </div>
          <div class="reminder-form-group">
            <label for="reminderDueTime" data-rm="reminder.dueTimeLabel">Deadline Time</label>
            <input type="time" id="reminderDueTime" />
          </div>
        </div>

        <div class="reminder-form-group">
          <label for="reminderOffsetType" data-rm="reminder.offsetLabel">Remind Me</label>
          <select id="reminderOffsetType"></select>
        </div>

        <!-- Only shown when "Custom:" is selected -->
        <div class="reminder-form-row" id="customOffsetRow" hidden>
          <div class="reminder-form-group">
            <label for="customOffsetNumber" data-rm="reminder.customLabel">Remind before</label>
            <input type="number" id="customOffsetNumber" min="1" step="1" value="15" />
          </div>
          <div class="reminder-form-group">
            <label for="customOffsetUnit">Unit</label>
            <select id="customOffsetUnit">
              <option value="minutes" data-rm="reminder.customMinutes">minutes</option>
              <option value="hours"   data-rm="reminder.customHours">hours</option>
              <option value="days"    data-rm="reminder.customDays">days</option>
            </select>
          </div>
        </div>

        <div class="reminder-modal-actions">
          <button class="reminder-cancel-btn" id="reminderCancelBtn" type="button"
                  data-rm="reminder.cancel">Cancel</button>
          <button class="btn-primary reminder-save-btn" id="reminderSaveBtn" type="button">
            <i class="fa-solid fa-clock"></i>
            <span data-rm="reminder.save">Save Reminder</span>
          </button>
        </div>
      </div>
    </div>
  `;

  document.body.appendChild(overlay);

  /* ── Populate reminder-form offset select ── */
  const PRESETS = [
    ["EXACT",         mt("reminder.offsetExact")],
    ["10_MIN_BEFORE", mt("reminder.offset10min")],
    ["1_HOUR_BEFORE", mt("reminder.offset1hr")],
    ["1_DAY_BEFORE",  mt("reminder.offset1day")],
    ["CUSTOM",        mt("reminder.offsetCustom")]
  ];

  const offsetSel = el("reminderOffsetType");
  PRESETS.forEach(([v, lbl]) => {
    const o = document.createElement("option");
    o.value = v; o.textContent = lbl;
    offsetSel.appendChild(o);
  });
  /* Ensure customOffsetRow starts hidden and toggles correctly */
  el("customOffsetRow").hidden = true;
  offsetSel.addEventListener("change", () => {
    el("customOffsetRow").hidden = offsetSel.value !== "CUSTOM";
  });
  offsetSel.value = "1_DAY_BEFORE";

  /* ── Modal wiring ── */
  el("reminderClose").addEventListener("click", close);
  overlay.addEventListener("mousedown", (e) => { if (e.target === overlay) close(); });
  el("reminderNewBtn").addEventListener("click",    () => startNew());
  el("reminderCancelBtn").addEventListener("click", () => showList());
  el("reminderSaveBtn").addEventListener("click",   saveReminder);
  el("reminderEnableBtn").addEventListener("click", enableNotifications);
}

/* Re-translate when modal opens */
function applyModalLabels() {
  document.querySelectorAll("[data-rm]").forEach(n => {
    n.textContent = mt(n.getAttribute("data-rm"));
  });
  document.querySelectorAll("[data-rm-ph]").forEach(n => {
    n.setAttribute("placeholder", mt(n.getAttribute("data-rm-ph")));
  });
  document.querySelectorAll("[data-rm-aria]").forEach(n => {
    n.setAttribute("aria-label", mt(n.getAttribute("data-rm-aria")));
  });
}

/* ------------------------------------------------------------------ */
/*  Open / close                                                       */
/* ------------------------------------------------------------------ */
function open() {
  buildModal();
  applyModalLabels();
  el("reminderOverlay").classList.add("open");
  document.body.style.overflow = "hidden";
  setStatus("");

  /* Refresh cached user defaults (offset + default deadline duration) so the
     auto-reminder logic in todolist.html always uses the latest values. */
  loadUserDefaults();

  renderList();
}

function close() {
  const overlay = el("reminderOverlay");
  if (!overlay) return;
  overlay.classList.remove("open");
  document.body.style.overflow = "";
}

/* ------------------------------------------------------------------ */
/*  Rendering the saved list                                           */
/* ------------------------------------------------------------------ */
function fmtDateTime(value) {
  if (!value) return "";
  const parts = String(value).split(" ");
  if (parts.length < 2) return value;
  return parts[0] + " " + parts[1].substring(0, 5);
}

async function renderList() {
  const ul = el("reminderUl");
  if (!ul) return;

  let items = [];
  try {
    items = await listReminders();
  } catch (error) {
    console.error(error);
    setStatus(mt("reminder.connFailed"));
    return;
  }

  ul.innerHTML = "";

  if (!items.length) {
    const li = document.createElement("li");
    li.className  = "reminder-empty";
    li.innerHTML  = `<i class="fa-solid fa-bell-slash"></i>
      <p>${mt("reminder.noReminders")}</p>
      <small>${mt("reminder.noRemindersHint")}</small>`;
    ul.appendChild(li);
    updateBadge();
    return;
  }

  items.forEach((item) => {
    const li   = document.createElement("li");
    li.className = "reminder-item";

    const icon = document.createElement("span");
    icon.className = "reminder-item-icon";
    icon.innerHTML = '<i class="fa-solid fa-bell"></i>';

    const info = document.createElement("div");
    info.className = "reminder-item-info";

    const text = document.createElement("p");
    text.className   = "reminder-item-text";
    text.textContent = item.reminderText || "—";

    const meta = document.createElement("p");
    meta.className   = "reminder-item-meta";
    meta.textContent = mt("reminder.dueLabel") + ": " + (fmtDateTime(item.dueDate) || "-") +
                       " • " + mt("reminder.alertLabel") + ": ";
    const timeSpan = document.createElement("span");
    timeSpan.className   = "reminder-item-time";
    timeSpan.textContent = fmtDateTime(item.reminderTime);
    meta.appendChild(timeSpan);

    info.appendChild(text);
    info.appendChild(meta);

    const actions = document.createElement("div");
    actions.className = "reminder-item-actions";

    const editBtn = document.createElement("button");
    editBtn.type      = "button";
    editBtn.className = "reminder-edit-btn";
    editBtn.title     = mt("reminder.reminders");
    editBtn.innerHTML = '<i class="fa-solid fa-pen"></i>';
    editBtn.addEventListener("click", () => startEdit(item));

    const delBtn = document.createElement("button");
    delBtn.type      = "button";
    delBtn.className = "reminder-delete-btn";
    delBtn.title     = mt("reminder.close");
    delBtn.innerHTML = '<i class="fa-solid fa-trash-can"></i>';
    delBtn.addEventListener("click", () => deleteReminder(item.id, li));

    actions.appendChild(editBtn);
    actions.appendChild(delBtn);

    li.appendChild(icon);
    li.appendChild(info);
    li.appendChild(actions);
    ul.appendChild(li);
  });

  updateBadge();
}

/* ------------------------------------------------------------------ */
/*  Form state: list / new / edit                                      */
/* ------------------------------------------------------------------ */
let editingId = -1;

function showList() {
  el("reminderListPanel").hidden = false;
  el("reminderFormPanel").hidden = true;
  editingId = -1;
}

function showForm() {
  el("reminderListPanel").hidden = true;
  el("reminderFormPanel").hidden = false;
  /* Always recalculate customOffsetRow visibility when showing the form */
  el("reminderOffsetType").dispatchEvent(new Event("change"));
}

function clearForm() {
  el("reminderTextInput").value    = "";
  el("reminderDueDate").value      = "";
  el("reminderDueTime").value      = "";
  el("reminderOffsetType").value   = "1_DAY_BEFORE";
  el("customOffsetNumber").value   = "15";
  el("customOffsetUnit").value     = "hours";
  el("customOffsetRow").hidden     = true;   // always hide on reset
}

function startNew(prefillText) {
  editingId = -1;
  clearForm();
  if (prefillText) el("reminderTextInput").value = prefillText;
  showForm();
  el("reminderTextInput").focus();
}

function startEdit(item) {
  editingId = item.id;
  clearForm();

  el("reminderTextInput").value = item.reminderText || "";

  const due   = String(item.dueDate || "");
  const parts = due.split(" ");
  if (parts.length >= 2) {
    el("reminderDueDate").value = parts[0];
    el("reminderDueTime").value = parts[1].substring(0, 5);
  }

  const offset = item.offsetType || "EXACT";
  el("reminderOffsetType").value = offset;

  const customMinutes = Number(item.customOffsetMinutes || 0);
  if (offset === "CUSTOM" && customMinutes > 0) {
    if      (customMinutes % 1440 === 0) { el("customOffsetUnit").value = "days";    el("customOffsetNumber").value = String(customMinutes / 1440); }
    else if (customMinutes % 60   === 0) { el("customOffsetUnit").value = "hours";   el("customOffsetNumber").value = String(customMinutes / 60);   }
    else                                 { el("customOffsetUnit").value = "minutes"; el("customOffsetNumber").value = String(customMinutes);          }
  }

  showForm();   /* dispatchEvent("change") will handle customOffsetRow visibility */
  el("reminderTextInput").focus();
}

/* Open modal and jump directly to editing a specific reminder */
function openAndEdit(item) {
  open();
  setTimeout(() => startEdit(item), 60);
}

/* Open modal in "new reminder" form, pre-filled with a task's text */
function openAndNew(prefillText) {
  open();
  setTimeout(() => startNew(prefillText), 60);
}

/* ------------------------------------------------------------------ */
/*  Save (create or edit)                                              */
/* ------------------------------------------------------------------ */
function triggerTime(dueStr, offsetType, customOffsetMinutes) {
  const due = new Date(dueStr.replace(" ", "T"));
  if (offsetType === "10_MIN_BEFORE") return new Date(due.getTime() - 600000);
  if (offsetType === "1_HOUR_BEFORE") return new Date(due.getTime() - 3600000);
  if (offsetType === "1_DAY_BEFORE")  return new Date(due.getTime() - 86400000);
  if (offsetType === "CUSTOM")        return new Date(due.getTime() - (customOffsetMinutes || 0) * 60000);
  return due;
}

function buildPayload() {
  const text       = el("reminderTextInput").value.trim();
  const dueDate    = el("reminderDueDate").value;
  const dueTime    = el("reminderDueTime").value;
  const offsetType = el("reminderOffsetType").value;

  if (!text || !dueDate || !dueTime) {
    setStatus(mt("reminder.fillAll"));
    return null;
  }

  const dueStr = dueDate + " " + dueTime + ":00";
  let customOffsetMinutes = null;

  if (offsetType === "CUSTOM") {
    const num  = parseInt(el("customOffsetNumber").value, 10);
    const unit = el("customOffsetUnit").value;
    if (!num || num < 1) { setStatus(mt("reminder.fillAll")); return null; }
    customOffsetMinutes = num * (UNIT_MULTIPLIER[unit] || 1);
  }

  const trigger = triggerTime(dueStr, offsetType, customOffsetMinutes);
  if (trigger <= new Date()) { setStatus(mt("reminder.futureTime")); return null; }

  const payload = {
    text:        text,
    dueDate:     dueStr,
    offsetType:  offsetType,
    token:       localStorage.getItem("fcmToken") || ""
  };
  if (customOffsetMinutes !== null) payload.customOffsetMinutes = customOffsetMinutes;
  return { payload, text };
}

async function saveReminder() {
  const built = buildPayload();
  if (!built) return;

  const button   = el("reminderSaveBtn");
  button.disabled = true;
  setStatus(mt("reminder.saving"));

  try {
    let result;
    if (editingId > 0) {
      result = await updateReminder(editingId, built.payload);
    } else {
      result = await createReminder(built.payload);
    }

    if (result && result.success) {
      setStatus(editingId > 0 ? mt("reminder.updated") : mt("reminder.saved"));
      if (result.reminderTime) scheduleAlert(built.text, result.reminderTime);
      showList();
      renderList();
    } else {
      setStatus("❌ " + ((result && result.message) || mt("reminder.failed")));
    }
  } catch (error) {
    console.error(error);
    setStatus(mt("reminder.connFailed"));
  } finally {
    button.disabled = false;
  }
}

function deleteReminder(id, li) {
  if (!window.confirm(mt("reminder.deleteThis"))) return;
  removeReminder(id)
    .then((result) => {
      if (result && result.success) {
        if (li && li.parentNode) li.remove();
        setStatus(mt("reminder.deleted"));
        updateBadge();
      } else {
        setStatus(mt("reminder.deleteFailed"));
      }
    })
    .catch((error) => {
      console.error(error);
      setStatus(mt("reminder.deleteFailed"));
    });
}

/* ------------------------------------------------------------------ */
/*  Local alert (browser notification + speech)                        */
/* ------------------------------------------------------------------ */
function scheduleAlert(text, reminderTimeStr) {
  if (!reminderTimeStr) return;
  const trigger = new Date(reminderTimeStr.replace(" ", "T"));
  const delay   = trigger.getTime() - Date.now();
  if (delay <= 0) return;

  setTimeout(() => {
    if ("Notification" in window && Notification.permission === "granted") {
      new Notification("⏰ Reminder", { body: text });
    }
    const speech = new SpeechSynthesisUtterance("It's your time to act. " + text + " deadline today");
    speech.lang  = "en-US";
    window.speechSynthesis.speak(speech);
  }, delay);
}

/* ------------------------------------------------------------------ */
/*  Notifications (browser + FCM token)                                */
/* ------------------------------------------------------------------ */
async function enableNotifications() {
  const btn = el("reminderEnableBtn");
  if (btn) btn.disabled = true;

  try {
    if (!("Notification" in window)) { setStatus(mt("reminder.notificationFailed")); return; }
    const permission = await Notification.requestPermission();
    if (permission !== "granted") { setStatus(mt("reminder.permissionDenied")); return; }

    const isConfigured = firebaseConfig && firebaseConfig.apiKey &&
                         !String(firebaseConfig.apiKey).startsWith("YOUR_");
    if (isConfigured && "serviceWorker" in navigator) {
      try {
        const reg   = await navigator.serviceWorker.register("./firebase-messaging-sw.js");
        const token = await getToken(messaging, { vapidKey: VAPID_KEY, serviceWorkerRegistration: reg });
        if (token) { console.log("FCM Token:", token); localStorage.setItem("fcmToken", token); }
      } catch (error) { console.error(error); }
    }
    setStatus(mt("reminder.enabled"));
  } catch (error) {
    console.error(error);
    setStatus(mt("reminder.notificationFailed"));
  } finally {
    if (btn) btn.disabled = false;
  }
}

/* ------------------------------------------------------------------ */
/*  API (also exposed for todolist.html auto-create)                   */
/* ------------------------------------------------------------------ */
async function requestJSON(url, options) {
  const res = await fetch(url, options);
  let data  = {};
  try   { data = await res.json(); }
  catch (_) { data = {}; }
  return data;
}

async function listReminders() {
  const data = await requestJSON("reminder", { method: "GET", headers: { "Accept": "application/json" } });
  return (data && Array.isArray(data.items)) ? data.items : [];
}

async function createReminder(payload) {
  return requestJSON("reminder", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(payload)
  });
}

async function updateReminder(id, payload) {
  const body = Object.assign({}, payload, { id });
  return requestJSON("reminder", {
    method: "PUT",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(body)
  });
}

async function removeReminder(id) {
  return requestJSON("reminder?id=" + encodeURIComponent(id), {
    method: "DELETE",
    headers: { "Accept": "application/json" }
  });
}

/* ------------------------------------------------------------------ */
/*  Wire up the sidebar bell + Escape close                            */
/* ------------------------------------------------------------------ */
document.addEventListener("keydown", (e) => { if (e.key === "Escape") close(); });

function initBell() {
  const bell = document.querySelector(".reminder-bell");
  if (bell) {
    bell.addEventListener("click", (e) => { e.preventDefault(); open(); });
  }
  /* Show badge on page load */
  updateBadge();
}

if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", initBell);
} else {
  initBell();
}

/* Load defaults in background immediately so getDefaults() has values */
loadUserDefaults().catch(() => {});

/* ------------------------------------------------------------------ */
/*  Public API                                                         */
/* ------------------------------------------------------------------ */
window.NOX_REMINDERS = {
  open:        open,
  openAndEdit: openAndEdit,
  openAndNew:  openAndNew,
  close:       close,
  list:        listReminders,
  create:      createReminder,
  update:      updateReminder,
  remove:      removeReminder,
  getDefaults: getDefaults,
  updateBadge: updateBadge
};
/*!
 * i18n.js - Centralized translation system for NOX.
 *
 * Supported languages:
 *   en  -> English
 *   my  -> Myanmar (Burmese)
 *
 * The active language lives in the server-side HTTP session and is read from
 * the /language endpoint. This file is the single source of truth for all
 * user-facing text in the application.
 *
 * Usage in HTML:
 *   <span data-i18n="nav.home">Home</span>
 *   <input data-i18n-placeholder="login.email" ...>
 *   <button data-i18n-title="translate.copyText" ...>
 *   <title data-i18n="history.title">History</title>
 *
 * Usage in JavaScript:
 *   NOX_I18N.t('index.recording')          -> plain translate
 *   NOX_I18N.tf('todo.progress', {completed: 2, total: 5})
 *   NOX_I18N.ready.then(function(){ ... }) -> run once language is known
 */
(function (global) {
  'use strict';

  var DICT = {
    en: {
      /* ---- shared / chrome ---- */
      'brand.tagline': 'Speech & Text',
      'brand.aiAssistant': 'NOX',
      'nav.home': 'Home',
      'nav.features': 'Features',
      'nav.about': 'About Us',
      'nav.profile': 'Profile',
      'nav.login': 'Login',
      'nav.register': 'Register',
      'nav.logout': 'Logout',
      'workspace': 'Smart Workspace',
      'session.active': 'Session Active',
      'loading': 'Loading...',
      'copy': 'Copy',
      'clear': 'Clear',
      'delete': 'Delete',
      'close': 'Close',
      'cancel': 'Cancel',
      'back.toRecording': 'Back to Speech Recording',
      'common.error': 'Error',
      'common.enterTextFirst': 'Please enter or transcribe text first!',
      'common.cleared': 'Cleared',

      /* ---- sidebar ---- */
      'side.transcribe': 'Transcribe',
      'side.translate': 'Translate',
      'side.summarize': 'Summarize',
      'side.todo': 'To-Do List',
      'side.qna': 'Q&A',
      'side.history': 'History',
      'side.tts': 'Text to Speech',

      /* ---- shared footer buttons ---- */
      'btn.summarize': 'Summarize',
      'btn.translate': 'Translate',
      'btn.todo': 'To-Do List',
      'btn.qna': 'Q&A',
      'btn.reset': 'Reset',
      'btn.tts': 'Text to Speech',

      /* ---- index.html (transcribe dashboard) ---- */
      'index.eyebrow.audio': 'Audio Input',
      'index.title.audio': 'Record or upload your audio',
      'index.status.load': 'Load',
      'index.record': 'Record',
      'index.upload': 'Upload',
      'index.noFile': 'No file selected',
      'index.uploadPreview': 'Upload a file to preview',
      'index.waveformHint': 'Start recording to see live waveform or upload audio to preview.',
      'index.transcribe': 'Transcribe',
      'index.eyebrow.output': 'Transcription Output',
      'index.title.output': 'Text generated from your audio',
      'index.transcriptPlaceholder': 'Transcribed texts will appear here...',
      'index.status.idle': 'Idle',
      'index.restoredAudio': 'Restored audio',
      'index.sessionAudio': 'Session audio',
      'index.audioRestored': 'Audio restored from your session.',
      'index.stop': 'Stop',
      'index.recording': 'Recording',
      'index.waveformActive': 'Live waveform is active',
      'index.recordingComplete': 'Recording complete. Click Transcribe to process.',
      'index.permissionDenied': 'Permission denied',
      'index.fileLoaded': 'File loaded. Play preview or send for transcription.',
      'index.fileReady': 'File Ready',
      'index.sending': 'Sending audio...',
      'index.transcriptionComplete': 'Transcription complete',
      'index.transcriptionFailed': 'Transcription failed. Check backend connectivity and try again.',

      /* ---- profile.html ---- */
      'profile.langEyebrow': 'Preferences',
      'profile.eyebrow': 'Account Overview',
      'profile.title': 'My Profile',
      'profile.sessionChecking': 'Checking session...',
      'profile.username': 'Username',
      'profile.emailLabel': 'Login Profile (Email)',
      'profile.viewHistory': 'View History',
      'profile.logout': 'Logout',
      'profile.loggedInAs': 'Logged in as {name}',
      'profile.sessionExpired': 'Session expired',
      'profile.guest': 'Guest',
      'lang.title': 'Language',
      'lang.english': 'English',
      'lang.myanmar': 'မြန်မာ',

      /* ---- homepage.html (landing page) ---- */
      'hero.eyebrow': 'AI-powered note taking',
      'hero.title': 'Effortless Voice Notes',
      'hero.desc': 'Convert speech to text, translate languages, generate quick summaries, correct grammar errors, and chat directly with your records.',
      'hero.cta': 'Get Started Now',
      'hero.discover': 'Discover More',
      'about.title': 'NOX',
      'about.desc': 'Nox(Vox&Note) is a smart web platform built to help users record and manage audio notes during meetings, lectures, and daily tasks. By combining automated transcription, translation, summarization, grammar correction, and Q&A chat, it eliminates manual note-taking and saves valuable time.',
      'about.learnMore': 'Learn More',
      'mock.transcribed': 'Transcribed',
      'mock.summary': 'Summary',
      'features.title': 'Features & How It Works',
      'features.stt.title': 'Speech-to-Text',
      'features.stt.desc': 'Record voice or upload audio to generate accurate transcripts in seconds.',
      'features.translate.title': 'Burmese-English Translation',
      'features.translate.desc': 'Instantly translate content across languages during meetings and study sessions.',
      'features.summary.title': 'AI Summarization',
      'features.summary.desc': 'Receive quick takeaways from your recordings.',
      'features.todolist.title': 'To-Do Lists',
      'features.todolist.desc': ' Automatically generate to-do lists from the imported record/mp3.',
      'features.qa.title': 'Interactive Q&A',
      'features.qa.desc': 'Ask questions directly to your saved audio recordings and receive instant answers or polish any text.',
      'features.tts.title': 'Text-To-Speech',
      'features.tts.desc': 'Upload desired text to convert into speech as fast or slow you want.',
      'footer.text': '© 2026 Notes Assistant. Built for effortless note capture.',

      /* ---- login.html ---- */
      'login.title': 'Welcome Back',
      'login.subtitle': 'Sign in to access your dashboard',
      'login.successMsg': 'Registration successful! Please login with your credentials.',
      'login.invalid': 'Invalid email or password.',
      'login.email': 'Email Address',
      'login.password': 'Password',
      'login.submit': 'Login',
      'login.noAccount': 'Don\'t have an account yet?',
      'login.createOne': 'Create one',
      'login.genericError': 'Something went wrong. Please try again.',

      /* ---- register.html ---- */
      'reg.title': 'Create an Account',
      'reg.subtitle': 'Register to start capturing AI notes & voice dictation',
      'reg.failed': 'Registration failed. Please try again.',
      'reg.fullname': 'Full Name',
      'reg.email': 'Email Address',
      'reg.password': 'Password',
      'reg.confirm': 'Confirm Password',
      'reg.mismatch': 'Passwords do not match!',
      'reg.submit': 'Register Account',
      'reg.hasAccount': 'Already have an account?',
      'reg.signIn': 'Sign in here',
      'reg.genericError': 'Something went wrong. Please try again.',

      /* ---- translate.html ---- */
      'translate.brandTag': 'Audio Translator',
      'translate.eyebrow': 'Language Converter',
      'translate.title': 'Translate Transcribed Audio',
      'translate.run': 'Translate Now',
      'translate.sourceLabel': 'Source Text (Original)',
      'translate.sourcePlaceholder': 'Original transcription will appear here...',
      'translate.copyText': 'Copy Text',
      'translate.clearText': 'Clear Text',
      'translate.copyTranslated': 'Copy Translated Text',
      'translate.targetPlaceholder': 'Translated text will appear here...',
      'translate.originalCopied': 'Original text copied!',
      'translate.translatedCopied': 'Translated text copied!',
      'translate.translating': 'Translating...',
      'translate.failed': 'Translation failed.',
      'translate.connFailed': 'Failed to connect to backend translation service.',

      /* ---- summary.html ---- */
      'summary.brandTag': 'Summary',
      'summary.eyebrow': 'Text Overview',
      'summary.title': 'Key Takeaways & Summary',
      'summary.run': 'Summarize Text',
      'summary.statusReady': 'Ready to summarize',
      'summary.copySummary': 'Copy Summary',
      'summary.clearText': 'Clear Text',
      'summary.placeholder': 'Summary will be generated here from your transcribed audio...',
      'summary.copied': 'Summary copied to clipboard!',
      'summary.generating': 'Generating...',
      'summary.completed': 'Completed',
      'summary.failed': 'Summary generation failed.',
      'summary.connFailed': 'Failed to connect to backend summary service.',
      'summary.connError': 'Connection Error',

      /* ---- text.html ---- */
      'text.brandTag': 'Polish & Chat',
      'text.eyebrow': 'Text Editor',
      'text.title': 'Polish & Chat With Your Transcript',
      'text.polish': 'Polish',
      'text.chat': 'Q&A',
      'text.sourceLabel': 'Transcript (Original)',
      'text.sourcePlaceholder': 'Your transcribed text will appear here...',
      'text.chatLabel': 'Chat Query (optional)',
      'text.chatPlaceholder': 'Ask a question about the transcript...',
      'text.resultLabel': 'Result',
      'text.resultReady': 'Ready',
      'text.copyResult': 'Copy Result',
      'text.clearResult': 'Clear Result',
      'text.clearQuery': 'Clear Query',
      'text.targetPlaceholder': 'Polished text or chat answer will appear here...',
      'text.originalCopied': 'Original text copied!',
      'text.resultCopied': 'Result copied!',
      'text.polishing': 'Polishing...',
      'text.thinking': 'Thinking...',
      'text.generating': 'Generating...',
      'text.completed': 'Completed',
      'text.failed': 'Text processing failed.',
      'text.connFailed': 'Failed to connect to backend text service.',
      'text.connError': 'Connection Error',

      /* ---- todolist.html ---- */
      'todo.brandTag': 'To-Do List',
      'todo.eyebrow': 'Task Extraction',
      'todo.title': 'Generated To-Do List',
      'todo.extract': 'Extract Action Items',
      'todo.progressLabel': 'Task Completion',
      'todo.progress': '{completed} of {total} completed',
      'todo.addPlaceholder': 'Add a custom task manually...',
      'todo.add': 'Add',
      'todo.filterAll': 'All',
      'todo.filterActive': 'Active',
      'todo.filterCompleted': 'Completed',
      'todo.empty': 'No action items found. Click "Extract Action Items" or add one manually above.',
      'todo.deleteTask': 'Delete Task',
      'todo.noText': 'No transcribed text found to extract action items from. Please transcribe or summarize first.',
      'todo.extracting': 'Extracting...',
      /* ---- reminder (sidebar card) ---- */
      'reminder.title': 'Set a Reminder',
      'reminder.eyebrow': 'Deadline Alerts',
      'reminder.reminders': 'Reminders',
      'reminder.new': 'New Reminder',
      'reminder.save': 'Save Reminder',
      'reminder.cancel': 'Cancel',
      'reminder.close': 'Close',
      'reminder.taskLabel': 'Task / Reminder Text',
      'reminder.taskPlaceholder': 'Enter your reminder or task...',
      'reminder.dueDateLabel': 'Deadline Date',
      'reminder.dueTimeLabel': 'Deadline Time',
      'reminder.offsetLabel': 'Remind Me',
      'reminder.offsetExact': 'At deadline',
      'reminder.offset10min': '10 minutes before',
      'reminder.offset1hr': '1 hour before',
      'reminder.offset1day': '1 day before',
      'reminder.offsetCustom': 'Custom: before deadline',
      'reminder.customLabel': 'Remind before',
      'reminder.customMinutes': 'minutes',
      'reminder.customHours': 'hours',
      'reminder.customDays': 'days',
      'reminder.enableNotifications': 'Enable Notifications',
      'reminder.noReminders': 'No reminders yet.',
      'reminder.noRemindersHint': 'Set a deadline on a task in the To-Do list, or add one manually.',
      'reminder.dueLabel': 'Due',
      'reminder.alertLabel': 'Alert',
      'reminder.permissionDenied': '❌ Notification permission denied.',
      'reminder.enabled': '✅ Notifications enabled.',
      'reminder.notificationFailed': '❌ Notification setup failed.',
      'reminder.fillAll': '⚠️ Please fill all required fields.',
      'reminder.futureTime': '⚠️ Please select a future time.',
      'reminder.saving': 'Saving...',
      'reminder.saved': '✅ Reminder saved successfully.',
      'reminder.updated': '✅ Reminder updated.',
      'reminder.failed': 'Reminder could not be saved.',
      'reminder.connFailed': '❌ Could not connect to server.',
      'reminder.deleted': 'Reminder deleted.',
      'reminder.deleteFailed': 'Failed to delete reminder.',
      'reminder.deleteThis': 'Delete this reminder?',

      /* ---- tts.html ---- */
      'tts.brandTag': 'Text to Speech',
      'tts.eyebrow': 'Voice Synthesis',
      'tts.title': 'Convert Text to Speech',
      'tts.inputLabel': 'Input Text',
      'tts.inputPlaceholder': 'Enter text to convert to speech...',
      'tts.languageLabel': 'Select Language:',
      'tts.speedLabel': 'Speed',
      'tts.pitchLabel': 'Pitch',
      'tts.play': 'Play / Speak',
      'tts.pause': 'Pause',
      'tts.resume': 'Resume',
      'tts.stop': 'Stop',
      'tts.statusReady': 'Ready',
      'tts.statusSpeaking': 'Speaking...',
      'tts.statusPaused': 'Paused',
      'tts.statusStopped': 'Stopped',
      'tts.enterText': 'Please enter text',
      'tts.speaking': 'Speaking chunk {current} of {total}...',

      /* ---- history.html ---- */
      'history.eyebrow': 'Revisit your work',
      'history.title': 'Activity History',
      'history.searchPlaceholder': 'Search your history...',
      'history.searchAria': 'Search history',
      'history.filterAria': 'Filter by feature',
      'history.filterAll': 'All',
      'history.filterTranscribe': 'Transcribe',
      'history.filterSummary': 'Summary',
      'history.filterTranslate': 'Translate',
      'history.filterTodo': 'To-Do',
      'history.filterTts': 'Text to Speech',
      'history.exportTitle': 'Export all history as PDF',
      'history.exportAll': 'Export All',
      'history.deleteSelected': 'Delete Selected',
      'history.clearAll': 'Clear All',
      'history.emptyTitle': 'No history yet',
      'history.emptyText': 'Your transcribe, summary, translate, to-do and text-to-speech activities will appear here.',
      'history.startTranscribing': 'Start Transcribing',
      'history.prev': 'Prev',
      'history.next': 'Next',
      'history.pageOf': 'Page {page} of {total}',
      'history.detailTitle': 'Activity Detail',
      'history.closeAria': 'Close',
      'history.input': 'Input',
      'history.output': 'Output',
      'history.copyOutput': 'Copy Output',
      'history.confirmTitle': 'Are you sure?',
      'history.confirmText': 'This action cannot be undone.',
      'history.justNow': 'Just now',
      'history.minAgo': '{m}m ago',
      'history.hourAgo': '{h}h ago',
      'history.dayAgo': '{d}d ago',
      'history.tasks': '{n} tasks',
      'history.to': 'To',
      'history.copied': 'Copied to clipboard',
      'history.noMatches': 'No matching records',
      'history.tryDifferent': 'Try a different search term or filter.',
      'history.noActivities': '0 activities',
      'history.totalActivity': '1 activity',
      'history.totalActivities': '{n} activities',
      'history.deleteSelectedN': 'Delete Selected ({n})',
      'history.failedToLoad': 'Failed to load',
      'history.failedLoadToast': 'Failed to load history',
      'history.failedLoadDetail': 'Failed to load detail',
      'history.deletedN': 'Deleted {n} item(s)',
      'history.deleteFailed': 'Failed to delete',
      'history.clearFailed': 'Failed to clear history',
      'history.activityFrom': 'Activity from {time}',
      'history.activityExported': 'Activity exported',
      'history.exportSuccess': 'Export completed successfully',
      'history.exportFailed': 'Export failed',
      'history.exportedN': 'Exported {n} activities',
      'history.deleteSelectedConfirm': 'Delete {n} selected item(s)?',
      'history.deleteAllConfirm': 'Permanently delete ALL of your history?',
      'history.selectAria': 'Select activity',
      'history.copyAction': 'Copy',
      'history.viewAction': 'View',
      'history.exportAction': 'Export',
      'history.deleteAction': 'Delete',
      'history.deleteThis': 'Delete this activity?',
      'history.ttsAudio': 'Generated Audio',
      'history.playAudio': 'Play Audio',
      'history.downloadAudio': 'Download Audio',
      'history.regeneratingAudio': 'Regenerating audio...',
      'history.audioFailed': 'Failed to generate audio',
      'history.speakingChunk': 'Speaking chunk {current} of {total}...',

      /* ---- logout.html ---- */
      'logout.title': 'User Dashboard',
      'logout.subtitle': 'You are currently logged in to your active NOX session.',
      'logout.logout': 'Log Out',
      'logout.return': 'Return to Workspace',
      'logout.dontWant': 'Don\'t want to log out?',
      'logout.goBack': 'Go back to your workspace'
    },

    my: {
      /* ---- shared / chrome ---- */
      'brand.tagline': 'အသံနှင့် စာသား',
      'brand.aiAssistant': 'NOX',
      'nav.home': 'မူလစာမျက်မှာ',
      'nav.features': 'လုပ်ဆောင်ချက်များ',
      'nav.about': 'အကြောင်းအရာ',
      'nav.profile': 'ပရိုဖိုင်',
      'nav.login': 'အကောင့်ဝင်ရန်',
      'nav.register': 'အကောင့်ဖွင့်ရန်',
      'nav.logout': 'ထွက်မည်',
      'workspace': 'မိမိနေရာ',
      'session.active': 'အသုံးပြုနေသည်',
      'loading': 'တင်နေသည်...',
      'copy': 'ကူးယူမည်',
      'clear': 'ရှင်းလင်းမည်',
      'delete': 'ဖျက်မည်',
      'close': 'ပိတ်မည်',
      'cancel': 'ပယ်ဖျက်မည်',
      'back.toRecording': 'အသံမှတ်တမ်းသို့ ပြန်သွားရန်',
      'common.error': 'အမှား',
      'common.enterTextFirst': 'ကျေးဇူးပြု၍ စာသားထည့်သွင်းပါ!',
      'common.cleared': 'ရှင်းလင်းပြီးပါပြီ',

      /* ---- sidebar ---- */
      'side.transcribe': 'စာသားပြောင်း',
      'side.translate': 'ဘာသာပြန်',
      'side.summarize': 'အနှစ်ချုပ်',
      'side.todo': 'လုပ်ရန်စာရင်း',
      'side.qna': 'မေးဖြေ',
      'side.history': 'မှတ်တမ်း',
      'side.tts': 'စာသားကို အသံပြောင်း',

      /* ---- shared footer buttons ---- */
      'btn.summarize': 'အနှစ်ချုပ်',
      'btn.translate': 'ဘာသာပြန်',
      'btn.todo': 'လုပ်ရန်စာရင်း',
      'btn.qna': 'မေးဖြေ',
      'btn.reset': 'ပြန်လည်စတင်ရန်',
      'btn.tts': 'စာသားကို အသံထွက်ပြောင်းရန်',

      /* ---- index.html (transcribe dashboard) ---- */
      'index.eyebrow.audio': 'အသံထည့်သွင်းရန်',
      'index.title.audio': 'အသံသွင်းပါ သို့မဟုတ် အသံဖိုင်တင်ပါ',
      'index.status.load': 'load',
      'index.record': 'မှတ်တမ်းတင်ရန်',
      'index.upload': 'အပ်လုဒ်',
      'index.noFile': 'ဖိုင်မရွေးရသေးပါ',
      'index.uploadPreview': 'ပြသရန် ဖိုင်တစ်ခု အပ်လုဒ်ပ်လုပ်ပါ',
      'index.waveformHint': 'အသံသွင်းပါ သို့မဟုတ် အသံဖိုင်တင်ပါ',
      'index.transcribe': 'စာသားသို့ပြောင်းရန်',
      'index.eyebrow.output': 'ရလဒ်',
      'index.title.output': 'ဖိုင်မှရရှိသော စာသား',
      'index.transcriptPlaceholder': 'ပြောင်းလဲထားသော စာသားများ ဤနေရာတွင် ပေါ်လာမည်...',
      'index.status.idle': 'ရပ်နားနေသည်',
      'index.restoredAudio': 'ပြန်လည်ယူထားသော အသံ',
      'index.sessionAudio': 'အသံ',
      'index.audioRestored': 'အသံကို ပြန်လည်ရယူထားသည်',
      'index.stop': 'ရပ်ရန်',
      'index.recording': 'မှတ်တမ်းတင်နေသည်',
      'index.waveformActive': 'အသံဖိုင် ပို့နေသည်',
      'index.recordingComplete': 'မှတ်တမ်းတင်ခြင်း ပြီးပါပြီ။ စာသားပြောင်းရန် နှိပ်ပါ။',
      'index.permissionDenied': 'ခွင့်ပြုချက် ငြင်းပယ်ခံရသည်',
      'index.fileLoaded': 'ဖိုင်တင်ပြီးပါပြီ။ နားထောင်ရန် သို့မဟုတ် စာသားပြောင်းရန် ခလုတ်နှိပ်ပါ။',
      'index.fileReady': 'ဖိုင် အဆင်သင့်ဖြစ်ပါပြီ',
      'index.sending': 'အသံဖိုင် ပို့နေသည်...',
      'index.transcriptionComplete': 'စာသားပြောင်းခြင်း ပြီးစီးပါပြီ',
      'index.transcriptionFailed': 'စာသားပြောင်းခြင်း မအောင်မြင်ပါ။ ဆာဗာချိတ်ဆက်မှု စစ်ဆေးပြီး ထပ်ကြိုးစားပါ။',

      /* ---- profile.html ---- */
      'profile.langEyebrow': 'ရွေးချယ်မှုများ',
      'profile.eyebrow': 'အကျဉ်းချုပ်',
      'profile.title': 'ပရိုဖိုင်',
      'profile.sessionChecking': 'စစ်ဆေးနေသည်...',
      'profile.username': 'အသုံးပြုသူအမည်',
      'profile.emailLabel': 'အကောင့်ဝင်ရန် (အီးမေးလ်)',
      'profile.viewHistory': 'မှတ်တမ်း ကြည့်ရန်',
      'profile.logout': 'ထွက်မည်',
      'profile.loggedInAs': 'အကောင့်ဝင်ထားသူ- {name}',
      'profile.sessionExpired': ' သက်တမ်းကုန်သွားပါပြီ',
      'profile.guest': 'ဧည့်သည်',
      'lang.title': 'ဘာသာစကား',
      'lang.english': 'English',
      'lang.myanmar': 'မြန်မာ',

      /* ---- homepage.html (landing page) ---- */
      'hero.eyebrow': 'AI နှင့်မှတ်စုထုတ်ခြင်း',
      'hero.title': 'အသံ မှ မှတ်စုများ',
      'hero.desc': 'အသံကို စာသားအဖြစ်ပြောင်းခြင်း၊ ဘာသာပြန်ခြင်း၊ အနှစ်ချုပ်ခြင်း၊ သဒ္ဒါအမှားပြင်ခြင်း၊ သင့်မှတ်တမ်းများနှင့် တိုက်ရိုက်စကားပြောခြင်းတို့ကို လုပ်ဆောင်နိုင်သည်။',
      'hero.cta': 'စတင်ရန်',
      'hero.discover': 'ပိုမိုလေ့လာရန်',
      'about.title': 'NOX',
      'about.desc': 'Nox (Vox & Note) သည် အစည်းအဝေးများ၊ သင်ခန်းစာများနှင့် နေ့စဉ်လုပ်ငန်းဆောင်တာများအတွင်း အသံမှတ်စုများ မှတ်တမ်းတင်ခြင်းနှင့် စီမံခြင်းအတွက် တည်ဆောက်ထားသော စမတ်ဝဘ်ပလက်ဖောင်းတစ်ခုဖြစ်သည်။ အလိုအလျောက် စာသားပြောင်းခြင်း၊ ဘာသာပြန်ခြင်း၊ အနှစ်ချုပ်ခြင်း၊ သဒ္ဒါပြင်ဆင်ခြင်းနှင့် Q&A စကားပြောခြင်းတို့ကို ပေါင်းစပ်ထားခြင်းဖြင့် လက်ဖြင့်မှတ်စုရေးခြင်းကို ဖယ်ရှားပြီး အဖိုးတန်အချိန်များကို သက်သာစေသည်။',
      'about.learnMore': 'ပိုမိုလေ့လာရန်',
      'mock.transcribed': 'စာသားပြောင်းပြီး',
      'mock.summary': 'အနှစ်ချုပ်',
      'features.title': 'လုပ်ဆောင်ချက်များ',
      'features.stt.title': 'အသံမှစာသားသို့',
      'features.stt.desc': 'မှတ်တမ်းတင်ထားသော အသံ သို့မဟုတ် အပ်လုဒ်ပ် လုပ်ထားသော အသံကို စက္ကန့်ပိုင်းအတွင်း တိကျသောစာသားအဖြစ် ပြောင်းလဲနိုင်သည်။',
      'features.translate.title': 'မြန်မာ-အင်္ဂလိပ် ဘာသာပြန်',
      'features.translate.desc': 'အစည်းအဝေးများနှင့် စာသင်ချိန်များအတွင်း အကြောင်းအရာများကို ဘာသာစကားများကြား ချက်ချင်း ဘာသာပြန်နိုင်သည်။',
      'features.summary.title': 'AI အနှစ်ချုပ်',
      'features.summary.desc': 'သင့်မှတ်တမ်းများမှ အဓိကအချက်များကို ရယူပါ။',
      'features.todolist.title': 'လုပ်ရန်စာရင်း',
      'features.todolist.desc': 'ထည့်သွင်းလိုက်သော ဖိုင်/အသံမှ လုပ်စာရာစရင်းများကို အလိုအလျောက်ထုတ်ပေးသည်။',
      'features.qa.title': 'အမေးအဖြ',
      'features.qa.desc': 'သင့်သိမ်းဆည်းထားသော အသံမှတ်တမ်းများကို တိုက်ရိုက်မေးမြန်းပြီး ချက်ချင်းအဖြေရယူပါ။',
      'features.tts.title': 'စာမှ အသံပြောင်းခြင်း',
      'features.tts.desc': 'လိုချင်သည့် စာကို လိုချင်သည့် အမြန်နှုန်းဖြင့် ရယူနိုင်သည်။',
      'footer.text': '© 2026 NOX. Built for effortless note capture.',

      /* ---- login.html ---- */
      'login.title': 'ပြန်လည်ကြိုဆိုပါသည်',
      'login.subtitle': 'သင့်ဒက်ရှ်ဘုတ်သို့ ဝင်ရောက်ရန် အကောင့်ဝင်ပါ',
      'login.successMsg': 'အကောင့်ဖွင့်ခြင်း အောင်မြင်ပါပြီ။ သင့်အထောက်အထားများဖြင့် အကောင့်ဝင်ပါ။',
      'login.invalid': 'အီးမေးလ် သို့မဟုတ် စကားဝှက် မှားနေပါသည်။',
      'login.email': 'အီးမေးလ်',
      'login.password': 'စကားဝှက်',
      'login.submit': 'အကောင့်ဝင်ရန်',
      'login.noAccount': 'အကောင့်မရှိသေးပါသလား?',
      'login.createOne': 'အကောင့်ဖွင့်ရန်',
      'login.genericError': 'တစ်စုံတစ်ရာ မှားယွင်းနေပါတယ်။ ထပ်မံကြိုးစားပါ။',

      /* ---- register.html ---- */
      'reg.title': 'အကောင့်ဖွင့်ရန်',
      'reg.subtitle': 'AI မှတ်စုများနှင့် အသံဖိုင်ထည့်သွင်းခြင်းကို စတင်ရန် စာရင်းသွင်းပါ',
      'reg.failed': 'စာရင်းသွင်းခြင်း မအောင်မြင်ပါ။ ထပ်မံကြိုးစားပါ။',
      'reg.fullname': 'အမည်အပြည့်အစုံ',
      'reg.email': 'အီးမေးလ်',
      'reg.password': 'စကားဝှက်',
      'reg.confirm': 'စကားဝှက် အတည်ပြုရန်',
      'reg.mismatch': 'စကားဝှက်များ တူညီမှုမရှိပါ!',
      'reg.submit': 'အကောင့်ဖွင့်မည်',
      'reg.hasAccount': 'အကောင့်ရှိပြီးသားပါလား?',
      'reg.signIn': 'ဤနေရာတွင် ဝင်ရောက်ပါ',
      'reg.genericError': 'တစ်စုံတစ်ရာ မှားယွင်းနေပါတယ်။ ထပ်မံကြိုးစားပါ။',

      /* ---- translate.html ---- */
      'translate.brandTag': 'ဘာသာပြန်',
      'translate.eyebrow': 'ဘာသာစကားပြောင်းလဲမှု',
      'translate.title': 'မှတ်တမ်းတင်ထားသော အသံဖိုင်ကို ဘာသာပြန်ရန်',
      'translate.run': 'ဘာသာပြန်မည်',
      'translate.sourceLabel': 'မူရင်း',
      'translate.sourcePlaceholder': 'မူရင်းစာသား ဤနေရာတွင် ပေါ်လာမည်...',
      'translate.copyText': 'စာသားကူးယူရန်',
      'translate.clearText': 'စာသားရှင်းလင်းရန်',
      'translate.copyTranslated': 'ဘာသာပြန်ထားသော စာသားကို ကူးယူရန်',
      'translate.targetPlaceholder': 'ဘာသာပြန်ထားသော စာသား ဤနေရာတွင် ပေါ်လာမည်...',
      'translate.originalCopied': 'မူရင်းစာသား ကူးယူပြီးပါပြီ!',
      'translate.translatedCopied': 'ဘာသာပြန်စာသား ကူးယူပြီးပါပြီ!',
      'translate.translating': 'ဘာသာပြန်နေသည်...',
      'translate.failed': 'ဘာသာပြန်ခြင်း မအောင်မြင်ပါ။',
      'translate.connFailed': 'နောက်ခံဘာသာပြန်ဝန်ဆောင်မှုသို့ ချိတ်ဆက်၍မရပါ။',

      /* ---- summary.html ---- */
      'summary.brandTag': 'အနှစ်ချုပ်',
      'summary.eyebrow': 'စာသား အကျဉ်းချုပ်',
      'summary.title': 'အဓိကအချက်များနှင့် အနှစ်ချုပ်',
      'summary.run': 'စာသားကို အနှစ်ချုပ်ရန်',
      'summary.statusReady': 'အနှစ်ချုပ်ရန်',
      'summary.copySummary': 'အနှစ်ချုပ် ကူးယူရန်',
      'summary.clearText': 'စာသားရှင်းလင်းရန်',
      'summary.placeholder': 'သင့်အသံမှတ်တမ်းမှ အနှစ်ချုပ် ဤနေရာတွင် ထုတ်လုပ်မည်...',
      'summary.copied': 'အနှစ်ချုပ် ကလစ်ဘုတ်သို့ ကူးယူပြီးပါပြီ!',
      'summary.generating': 'ထုတ်လုပ်နေသည်...',
      'summary.completed': 'ပြီးစီးပါပြီ',
      'summary.failed': 'အနှစ်ချုပ်ထုတ်လုပ်ခြင်း မအောင်မြင်ပါ။',
      'summary.connFailed': 'နောက်ခံအနှစ်ချုပ်ဝန်ဆောင်မှုသို့ ချိတ်ဆက်၍မရပါ။',
      'summary.connError': 'ချိတ်ဆက်မှု အမှား',

      /* ---- text.html ---- */
      'text.brandTag': 'ပြင်ဆင်ခြင်းနှင့် စကားပြောခြင်း',
      'text.eyebrow': 'စာသားတည်းဖြတ်ခြင်း',
      'text.title': 'သင့်မှတ်တမ်းကို ပြင်ဆင်ခြင်းနှင့် အမေးအဖြေ',
      'text.polish': 'ပြင်ဆင်',
      'text.chat': 'မေးဖြေ',
      'text.sourceLabel': 'မှတ်တမ်း (မူရင်း)',
      'text.sourcePlaceholder': 'သင့်မှတ်တမ်းတင်ထားသော စာသား ဤနေရာတွင် ပေါ်လာမည်...',
      'text.chatLabel': 'မေးခွန်း (ရွေးချယ်နိုင်)',
      'text.chatPlaceholder': 'မှတ်တမ်းနှင့်ပတ်သက်၍ မေးခွန်းမေးပါ...',
      'text.resultLabel': 'ရလဒ်',
      'text.resultReady': 'အသင့်',
      'text.copyResult': 'ရလဒ် ကူးယူရန်',
      'text.clearResult': 'ရလဒ် ရှင်းလင်းရန်',
      'text.clearQuery': 'မေးခွန်း ရှင်းလင်းရန်',
      'text.targetPlaceholder': 'ပြင်ဆင်ထားသော စာသား သို့မဟုတ် အဖြေ ဤနေရာတွင် ပေါ်လာမည်...',
      'text.originalCopied': 'မူရင်းစာသား ကူးယူပြီးပါပြီ!',
      'text.resultCopied': 'ရလဒ် ကူးယူပြီးပါပြီ!',
      'text.polishing': 'ပြင်ဆင်နေသည်...',
      'text.thinking': 'စဉ်းစားနေသည်...',
      'text.generating': 'ထုတ်လုပ်နေသည်...',
      'text.completed': 'ပြီးစီးပါပြီ',
      'text.failed': 'စာသားလုပ်ဆောင်ခြင်း မအောင်မြင်ပါ။',
      'text.connFailed': 'နောက်ခံစာသားဝန်ဆောင်မှုသို့ ချိတ်ဆက်၍မရပါ။',
      'text.connError': 'ချိတ်ဆက်မှု အမှား',

      /* ---- todolist.html ---- */
      'todo.brandTag': 'လုပ်ရန်စာရင်း',
      'todo.eyebrow': 'ဆောင်ရွက်ရမည့် အရာများ ထုတ်ယူခြင်း',
      'todo.title': 'ထုတ်လုပ်ထားသော လုပ်ရန်စာရင်း',
      'todo.extract': 'လုပ်ဆောင်ရမည့်အရာများ ထုတ်ယူရန်',
      'todo.progressLabel': 'လုပ်ဆောင်ချက် ပြီးစီးမှု',
      'todo.progress': '{completed} / {total} ပြီးစီးသည်',
      'todo.addPlaceholder': 'ကိုယ်တိုင် လုပ်ဆောင်ရမည့်အရာ ထည့်သွင်းပါ...',
      'todo.add': 'ထည့်ရန်',
      'todo.filterAll': 'အားလုံး',
      'todo.filterActive': 'လုပ်ဆောင်နေဆဲ',
      'todo.filterCompleted': 'ပြီးစီးပြီး',
      'todo.empty': 'လုပ်ဆောင်ရမည့်အရာ မတွေ့ပါ။ "Extract Action Items" ကိုနှိပ်ပါ သို့မဟုတ် အထက်တွင် ကိုယ်တိုင်ထည့်သွင်းပါ။',
      'todo.deleteTask': 'လုပ်ဆောင်ရမည့်အရာ ဖျက်ရန်',
      'todo.noText': 'လုပ်ဆောင်ရမည့်အရာ ထုတ်ယူရန် မှတ်တမ်းတင်ထားသော စာသား မတွေ့ပါ။ ကျေးဇူးပြု၍ အရင်ဆုံး မှတ်တမ်းတင်ပါ သို့မဟုတ် အနှစ်ချုပ်ပါ။',
      'todo.extracting': 'ထုတ်ယူနေသည်...',
      /* ---- reminder (sidebar card) ---- */
      'reminder.title': 'သတိပေးချက် သတ်မှတ်ရန်',
      'reminder.eyebrow': 'သတ်မှတ်ချိန် အချက်ပြချက်',
      'reminder.reminders': 'သတိပေးချက်များ',
      'reminder.new': 'သတိပေးချက်အသစ်',
      'reminder.save': 'သတိပေးချက် သိမ်းရန်',
      'reminder.cancel': 'ပယ်ဖျက်ရန်',
      'reminder.close': 'ပိတ်ရန်',
      'reminder.taskLabel': 'လုပ်ငန်း / သတိပေးစာသား',
      'reminder.taskPlaceholder': 'သင့်သတိပေးချက် သို့မဟုတ် လုပ်ငန်းကို ထည့်ပါ...',
      'reminder.dueDateLabel': 'သတ်မှတ်ရက်',
      'reminder.dueTimeLabel': 'သတ်မှတ်ချိန်',
      'reminder.offsetLabel': 'သတိပေးရန်',
      'reminder.offsetExact': 'သတ်မှတ်ချိန်အတိအကျ',
      'reminder.offset10min': '10 မိနစ် ကြိုတင်',
      'reminder.offset1hr': '1 နာရီ ကြိုတင်',
      'reminder.offset1day': '1 ရက် ကြိုတင်',
      'reminder.offsetCustom': 'စိတ်ကြိုက်: သတ်မှတ်ချိန်မတိုင်မီ',
      'reminder.customLabel': 'သတိပေးရမည့်အချိန်',
      'reminder.customMinutes': 'မိနစ်',
      'reminder.customHours': 'နာရီ',
      'reminder.customDays': 'ရက်',
      'reminder.enableNotifications': 'အကြောင်းကြားချက်များ ဖွင့်ရန်',
      'reminder.noReminders': 'သတိပေးချက် မရှိသေးပါ။',
      'reminder.noRemindersHint': 'လုပ်စရာစာရင်းတွင် သတ်မှတ်ရက် ထည့်ပါ သို့မဟုတ် ကိုယ်တိုင် ထည့်ပါ။',
      'reminder.dueLabel': 'သတ်မှတ်ရက်',
      'reminder.alertLabel': 'အချက်ပေး',
      'reminder.permissionDenied': '❌ အကြောင်းကြားချက် ခွင့်ပြုချက် ငြင်းပယ်ခံရသည်။',
      'reminder.enabled': '✅ အကြောင်းကြားချက်များ ဖွင့်ပြီးပါပြီ။',
      'reminder.notificationFailed': '❌ အကြောင်းကြားချက် စနစ်ထည့်သွင်းမှု မအောင်မြင်ပါ။',
      'reminder.fillAll': '⚠️ ကျေးဇူးပြု၍ လိုအပ်သော အချက်အားလုံး ဖြည့်ပါ။',
      'reminder.futureTime': '⚠️ ကျေးဇူးပြု၍ အနာဂတ်အချိန်ကို ရွေးပါ။',
      'reminder.saving': 'သိမ်းနေသည်...',
      'reminder.saved': '✅ သတိပေးချက် အောင်မြင်စွာ သိမ်းပြီးပါပြီ။',
      'reminder.updated': '✅ သတိပေးချက် ပြင်ဆင်ပြီးပါပြီ။',
      'reminder.failed': 'သတိပေးချက် သိမ်း၍မရပါ။',
      'reminder.connFailed': '❌ ဆာဗာနှင့် ချိတ်ဆက်၍မရပါ။',
      'reminder.deleted': 'သတိပေးချက် ဖျက်လိုက်ပါပြီ။',
      'reminder.deleteFailed': 'သတိပေးချက် ဖျက်၍မရပါ။',
      'reminder.deleteThis': 'ဤသတိပေးချက်ကို ဖျက်မည်လား?',

      /* ---- tts.html ---- */
      'tts.brandTag': 'စာသားကို အသံထွက်ပြောင်းရန်',
      'tts.eyebrow': 'အသံလုပ်ဆောင်မှု',
      'tts.title': 'စာသားကို အသံထွက်ပြောင်းရန်',
      'tts.inputLabel': 'ထည့်သွင်းစာသား',
      'tts.inputPlaceholder': 'အသံထွက်ပြောင်းချင်သော စာသားထည့်ပါ...',
      'tts.languageLabel': 'ဘာသာစကား ရွေးချယ်ပါ:',
      'tts.speedLabel': 'အမြန်နှုန်း',
      'tts.pitchLabel': 'အသံမြင့်/နိမ့်',
      'tts.play': '▶ ဖွင့်လှစ်ရန် / ပြောရန်',
      'tts.pause': '⏸ ရပ်ထားရန်',
      'tts.resume': '⏯ ဆက်လက်လုပ်ဆောင်ရန်',
      'tts.stop': '⏹ ရပ်နားရန်',
      'tts.statusReady': 'အသင့်ရှိပါသည်',
      'tts.statusSpeaking': 'အသံထွက်နေပါသည်...',
      'tts.statusPaused': 'ခဏရပ်ထားပါသည်',
      'tts.statusStopped': 'ရပ်တန့်လိုက်ပါပြီ',
      'tts.enterText': 'ကျေးဇူးပြု၍ စာသား ရိုက်ထည့်ပါ',
      'tts.speaking': 'အသံထွက်နေပါသည်... ({current} / {total})',

/* ---- history.html ---- */
      'history.eyebrow': 'သင့်လုပ်ဆောင်ချက်များကို ပြန်လည်ကြည့်ရှုပါ',
      'history.title': 'လုပ်ဆောင်မှု မှတ်တမ်း',
      'history.searchPlaceholder': 'သင့်မှတ်တမ်းကို ရှာဖွေပါ...',
      'history.searchAria': 'မှတ်တမ်း ရှာဖွေရန်',
      'history.filterAria': 'လုပ်ဆောင်ချက်များအလိုက် စစ်ထုတ်ရန်',
      'history.filterAll': 'အားလုံး',
      'history.filterTranscribe': 'စာသားပြောင်း',
      'history.filterSummary': 'အနှစ်ချုပ်',
      'history.filterTranslate': 'ဘာသာပြန်',
      'history.filterTodo': 'လုပ်ရန်စာရင်း',
      'history.filterTts': 'စာသားကို အသံထွက်ပြောင်းရန်',
      'history.exportTitle': 'မှတ်တမ်းအားလုံးကို ထုတ်ယူရန်',
      'history.exportAll': 'အားလုံး ထုတ်ယူရန်',
      'history.deleteSelected': 'ရွေးထားသည့်များ ဖျက်ရန်',
      'history.clearAll': 'အားလုံး ရှင်းလင်းရန်',
      'history.emptyTitle': 'မှတ်တမ်း မရှိသေးပါ',
      'history.emptyText': 'သင့် စာသားပြောင်း၊ အနှစ်ချုပ်၊ ဘာသာပြန်၊ လုပ်စရာ နှင့် စာသားကို အသံထွက်ပြောင်းရန် လုပ်ဆောင်ချက်များ ဤနေရာတွင် ပေါ်လာမည်။',
      'history.startTranscribing': 'စာသားပြောင်းခြင်း စတင်ရန်',
      'history.prev': 'ယခင်',
      'history.next': 'ရှေ့',
      'history.pageOf': 'စာမျက်နှာ {page} / {total}',
      'history.detailTitle': 'လုပ်ဆောင်မှု အသေးစိတ်',
      'history.closeAria': 'ပိတ်ရန်',
      'history.input': 'ထည့်သွင်းမှု',
      'history.output': 'ရလဒ်',
      'history.copyOutput': 'ရလဒ် ကူးယူရန်',
      'history.confirmTitle': 'သေချာပါသလား?',
      'history.confirmText': 'ဤလုပ်ဆောင်ချက်ကို ပြန်လည်၍မရနိုင်ပါ။',
      'history.justNow': 'ယခုလေးတင်',
      'history.minAgo': '{m} မိနစ်ခန့် အကြာ',
      'history.hourAgo': '{h} နာရီခန့် အကြာ',
      'history.dayAgo': '{d} ရက်ခန့် အကြာ',
      'history.tasks': '{n} ခု',
      'history.to': 'သို့',
      'history.copied': 'ကလစ်ဘုတ်သို့ ကူးယူပြီးပါပြီ',
      'history.noMatches': 'ကိုက်ညီသော မှတ်တမ်း မတွေ့ပါ',
      'history.tryDifferent': 'အခြားရှာဖွေမှု သို့မဟုတ် စစ်ထုတ်မှုကို ကြိုးစားပါ။',
      'history.noActivities': 'လုပ်ဆောင်မှု ၀',
      'history.totalActivity': 'လုပ်ဆောင်မှု ၁ ခု',
      'history.totalActivities': 'လုပ်ဆောင်မှု {n} ခု',
      'history.deleteSelectedN': 'ရွေးထားသည်များ ဖျက်ရန် ({n})',
      'history.failedToLoad': 'ဖတ်ယူ၍မရပါ',
      'history.failedLoadToast': 'မှတ်တမ်း ဖတ်ယူ၍မရပါ',
      'history.failedLoadDetail': 'အသေးစိတ် ဖတ်ယူ၍မရပါ',
      'history.deletedN': '{n} ခု ဖျက်လိုက်ပါပြီ',
      'history.deleteFailed': 'ဖျက်၍မရပါ',
      'history.clearFailed': 'ရှင်းလင်း၍မရပါ',
      'history.activityFrom': '{time} မှ လုပ်ဆောင်မှု',
'history.activityExported': 'လုပ်ဆောင်မှု ထုတ်ယူပြီးပါပြီ',
      'history.exportSuccess': 'ထုတ်ယူလုပ်ဆောင်မှု အောင်မြင်ပြီးပါပြီ',
      'history.exportFailed': 'ထုတ်ယူ하여မရပါ',
      'history.exportedN': 'လုပ်ဆောင်မှု {n} ခု ထုတ်�ယ야ူပြီးပါပြီ',
      'history.deleteSelectedConfirm': 'ရွေးထားသော လုပ်ဆောင်မှု {n} ခုကို ဖျက်မလား?',
      'history.deleteAllConfirm': 'သင့်မှတ်တမ်း အားလုံးကို အပြီးတိုင် ဖျက်မလား?',
      'history.selectAria': 'လုပ်ဆောင်မှု ရွေးရန်',
      'history.copyAction': 'ကူးယူ',
      'history.viewAction': 'ကြည့်ရန်',
      'history.exportAction': 'ထုတ်ယူ',
      'history.deleteAction': 'ဖျက်',
      'history.deleteThis': 'ဤလုပ်ဆောင်မှုကို ဖျက်မလား?',
      'history.ttsAudio': 'ထုတ်လုပ်ထားသော အသံ',
      'history.playAudio': 'အသံ ဖွင့်လှစ်ရန်',
      'history.downloadAudio': 'အသံ ရယူရန်',
      'history.regeneratingAudio': 'အသံ ပြန်လည်ထုတ်လုပ်နေသည်...',
      'history.audioFailed': 'အသံ ထုတ်လုပ်မှုမအောင်မြင်',
      'history.speakingChunk': 'အသံထွက်နေပါသည်... ({current} / {total})',

      /* ---- logout.html ---- */
      'logout.title': 'အသုံးပြုသူ ဒက်ရှ်ဘုတ်',
      'logout.subtitle': 'သင်သည် NOX session တွင် လက်ရှိ အကောင့်ဝင်နေပါသည်။',
      'logout.logout': 'ထွက်မည်',
      'logout.return': 'မူလနေရာသို့ ပြန်သွားရန်',
      'logout.dontWant': 'ထွက်ချင်ပါသလား?',
      'logout.goBack': 'မူလနေရာသို့ ပြန်သွားပါ'
    }
  };

  var currentLang = 'en';
  var applied = false;
  var readyResolve = null;

  var ready = new Promise(function (resolve) {
    readyResolve = resolve;
  });

  function translate(key) {
    var langDict = DICT[currentLang] || DICT.en;
    var value = langDict[key];
    return value !== undefined ? value : key;
  }

  function translateWith(key, params) {
    var value = translate(key);
    if (params) {
      Object.keys(params).forEach(function (name) {
        value = value.split('{' + name + '}').join(String(params[name]));
      });
    }
    return value;
  }

  function resolveFromServer() {
    return fetch('language', {
      method: 'GET',
      credentials: 'same-origin',
      headers: { 'Accept': 'application/json' }
    })
      .then(function (res) {
        if (!res.ok) throw new Error('language request failed');
        return res.json();
      })
      .then(function (data) {
        return data && data.lang === 'my' ? 'my' : 'en';
      })
      .catch(function () {
        return 'en';
      });
  }

  function applyTranslations() {
    document.documentElement.setAttribute('lang', currentLang);
    var dict = DICT[currentLang] || DICT.en;

    document.querySelectorAll('[data-i18n]').forEach(function (el) {
      var key = el.getAttribute('data-i18n');
      if (dict[key] !== undefined) el.textContent = dict[key];
    });

    document.querySelectorAll('[data-i18n-placeholder]').forEach(function (el) {
      var key = el.getAttribute('data-i18n-placeholder');
      if (dict[key] !== undefined) el.setAttribute('placeholder', dict[key]);
    });

    document.querySelectorAll('[data-i18n-title]').forEach(function (el) {
      var key = el.getAttribute('data-i18n-title');
      if (dict[key] !== undefined) el.setAttribute('title', dict[key]);
    });

    document.querySelectorAll('[data-i18n-aria]').forEach(function (el) {
      var key = el.getAttribute('data-i18n-aria');
      if (dict[key] !== undefined) el.setAttribute('aria-label', dict[key]);
    });

    document.querySelectorAll('[data-i18n-value]').forEach(function (el) {
      var key = el.getAttribute('data-i18n-value');
      if (dict[key] !== undefined) el.value = dict[key];
    });

    document.querySelectorAll('[data-i18n-html]').forEach(function (el) {
      var key = el.getAttribute('data-i18n-html');
      if (dict[key] !== undefined) el.innerHTML = dict[key];
    });
  }

  function finishInit(lang) {
    currentLang = lang;
    applied = true;
    applyTranslations();
    readyResolve();
  }

  /* Start reading the session language immediately. */
  resolveFromServer().then(function (lang) {
    finishInit(lang);
  });

  /* Re-apply once the DOM is fully parsed (in case it changed while loading). */
  document.addEventListener('DOMContentLoaded', function () {
    if (applied) applyTranslations();
  });

  global.NOX_I18N = {
    t: translate,
    tf: translateWith,
    lang: function () { return currentLang; },
    ready: ready,
    available: function () {
      return ['en', 'my'];
    }
  };
})(window);

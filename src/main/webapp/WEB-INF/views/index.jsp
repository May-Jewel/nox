<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<link rel="icon" type="image/jpeg" href="${pageContext.request.contextPath}/static/images/logo.jpg">
<title>NOX</title>
<meta name="description"
	content="Modern AI assistant interface for recording, uploading, and processing speech." />
<link rel="preconnect" href="https://fonts.googleapis.com" />
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
<link
	href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap"
	rel="stylesheet" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
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
					<p data-i18n="brand.tagline">Speech & Text</p>
					<h1 data-i18n="brand.aiAssistant">NOX</h1>
				</div>
			</div>

			<nav class="side-nav" aria-label="Primary navigation">
				<a href="${pageContext.request.contextPath}/index" class="nav-link active"> <i
					class="fa-solid fa-microphone"></i> <span data-i18n="side.transcribe">Transcribe</span>
				</a> <a href="${pageContext.request.contextPath}/translate" class="nav-link"> <i
					class="fa-solid fa-language"></i> <span data-i18n="side.translate">Translate</span>
				</a> <a href="${pageContext.request.contextPath}/summary" class="nav-link"> <i
					class="fa-solid fa-file-contract"></i> <span data-i18n="side.summarize">Summarize</span>
				</a> <a href="${pageContext.request.contextPath}/todolist" class="nav-link"> <i
					class="fa-solid fa-list-check"></i> <span data-i18n="side.todo">To-Do List</span>
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

			
			<div class="user-profile-widget">
				<div class="avatar" id="sidebarAvatar">AI</div>
				<div class="user-info">
					<p id="sidebarName">Session Active</p>
					<span id="sidebarEmail">Loading...</span>
				</div>
				<button class="reminder-bell" id="openRemindersBtn" type="button" aria-label="Reminders" title="Reminders"><i class="fa-solid fa-bell"></i></button>
			</div>

		</aside>
		<header class="global-top-nav"
			style="display: flex; justify-content: flex-end; align-items: center; gap: 1rem;">
			<a href="${pageContext.request.contextPath}/homepage" class="top-nav-item active" data-i18n="nav.home">Home</a> <a
				href="${pageContext.request.contextPath}/homepage#features" class="top-nav-item" data-i18n="nav.features">Features</a> <a
				href="${pageContext.request.contextPath}/homepage#about" class="top-nav-item" data-i18n="nav.about">About Us</a> <a
				href="${pageContext.request.contextPath}/profile" class="top-nav-item profile-btn"> <i
				class="fa-solid fa-user"></i> <span data-i18n="nav.profile">Profile</span>
			</a>
		</header>

		<main class="app-main">


			<section class="panel audio-panel" id="features">
				<div class="panel-header">
					<div>
						<p class="eyebrow" data-i18n="index.eyebrow.audio">Audio Input</p>
						<h2 data-i18n="index.title.audio">Record or upload your audio</h2>
					</div>
					<span class="status-badge" id="recordStatus" data-i18n="index.status.load">Load</span>
				</div>

				<div class="audio-card">
					<div class="audio-actions"
						style="display: flex; gap: 0.75rem; margin-bottom: 1rem;">
						<button id="recordBtn" class="control-btn" type="button">
							<span class="icon pulse"><i class="fa-solid fa-microphone"></i></span>
							<span data-i18n="index.record">Record</span>
						</button>
						<label class="control-btn upload-label"> <span
							class="icon"><i class="fa-solid fa-upload"></i></span> <span data-i18n="index.upload">Upload</span>
							<input id="audioUpload" type="file" accept="audio/*"
							hidden="hidden" />
						</label>
					</div>

				<div class="waveform-shell">
					<canvas id="waveform" aria-label="Audio waveform visualization"></canvas>
					<div class="waveform-overlay hidden" id="fileBadge">
						<div class="badge-copy">
							<p class="badge-title" id="fileName">No file selected</p>
							<p class="badge-meta" id="fileSize">Upload a file to preview</p>
						</div>
						<audio id="previewPlayer" controls hidden="hidden"></audio>
					</div>
				</div>

				<p class="waveform-hint" id="waveformHint"
					style="color: var(--text-muted); margin-top: 0.75rem; text-align: center;"
					data-i18n="index.waveformHint">
					Start recording to see live waveform or upload audio to preview.</p>

				<div class="audio-footer" style="margin-top: 1rem;">
					<button id="transcribeBtn" class="btn transcribe" type="button"
						disabled data-i18n="index.transcribe">Transcribe</button>
				</div>
				</div>
			</section>

			<section class="panel output-panel" id="about"
				style="margin-top: 2rem;">
				<div class="panel-header">
					<div>
						<p class="eyebrow" data-i18n="index.eyebrow.output">Transcription Output</p>
						<h2 data-i18n="index.title.output">Text generated from your audio</h2>
					</div>
				</div>

				<div class="output-card">
					<textarea id="transcript"
						data-i18n-placeholder="index.transcriptPlaceholder"
						placeholder="Transcribed texts will appear here..."
						style="min-height: 180px; margin-bottom: 1rem;"></textarea>
					<div class="output-footer"
						style="display: flex; gap: 0.75rem; flex-wrap: wrap; justify-content: flex-end;">
						<button id="clearTranscribeBtn" class="btn transcribe" type="button">
							<i class="fa-solid fa-broom"></i> <span data-i18n="btn.reset">Reset</span>
						</button>
						<button id="summaryNavBtn" class="btn transcribe" type="button"
							disabled>
							<i class="fa-solid fa-file-contract"></i> <span data-i18n="btn.summarize">Summarize</span>
						</button>
						<button id="todoNavBtn" class="btn transcribe" type="button"
							disabled>
							<i class="fa-solid fa-list-check"></i> <span data-i18n="btn.todo">To-Do List</span>
						</button>
						<button id="translateNavBtn" class="btn translate" type="button"
							disabled>
							<i class="fa-solid fa-language"></i> <span data-i18n="btn.translate">Translate</span>
						</button>
						<button id="textNavBtn" class="btn transcribe" type="button"
							disabled>
							<i class="fa-solid fa-pen-to-square"></i> <span data-i18n="btn.qna">Q&A</span>
						</button>
					</div>
				</div>
			</section>
		</main>
	</div>

	<script>
		
		const brandLogo = document.getElementById('brandLogo');
		const appShell = document.getElementById('appShell');

		function toggleSidebar() {
			if (!appShell) return;
			appShell.classList.toggle('sidebar-collapsed');
			const isCollapsed = appShell.classList.contains('sidebar-collapsed');
			localStorage.setItem('sidebarCollapsed', isCollapsed ? 'true' : 'false');
			
			if (typeof resizeCanvas === 'function') {
				setTimeout(resizeCanvas, 305);
			}
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

		const recordBtn = document.getElementById('recordBtn');
		const audioUpload = document.getElementById('audioUpload');
		const previewPlayer = document.getElementById('previewPlayer');
		const fileBadge = document.getElementById('fileBadge');
		const fileNameEl = document.getElementById('fileName');
		const fileSizeEl = document.getElementById('fileSize');
		const waveformHint = document.getElementById('waveformHint');
		const statusBadge = document.getElementById('recordStatus');
		const transcribeBtn = document.getElementById('transcribeBtn');
		const transcriptEl = document.getElementById('transcript');
		const canvas = document.getElementById('waveform');
		const ctx = canvas.getContext('2d');

		const translateNavBtn = document.getElementById('translateNavBtn');
		const summaryNavBtn = document.getElementById('summaryNavBtn');
		const todoNavBtn = document.getElementById('todoNavBtn');
		const textNavBtn = document.getElementById('textNavBtn');

		let audioContext, analyser, mediaRecorder, dataArray, source, animationId, stream;
		let recording = false;
		let currentAudioFile = null;
		let recordingChunks = [];

		function resizeCanvas() {
			const rect = canvas.parentElement.getBoundingClientRect();
			canvas.width = rect.width * window.devicePixelRatio;
			canvas.height = rect.height * window.devicePixelRatio;
			ctx.setTransform(window.devicePixelRatio, 0, 0, window.devicePixelRatio, 0, 0);
		}

		function updateStatus(text, active = false) {
			statusBadge.textContent = text;
		}

		function toggleActionButtons(enable) {
			translateNavBtn.disabled = !enable;
			summaryNavBtn.disabled = !enable;
			todoNavBtn.disabled = !enable;
			textNavBtn.disabled = !enable;
		}

		
		const MAX_PERSIST_AUDIO_SIZE = 25 * 1024 * 1024;
		const TRANSCRIBE_KEY = 'transcribeOriginalText';

		function persistTranscribeText() {
			const text = transcriptEl.value.trim();
			if (text) {
				sessionStorage.setItem(TRANSCRIBE_KEY, text);
			} else {
				sessionStorage.removeItem(TRANSCRIBE_KEY);
			}
		}

		function persistTranscribeAudio() {
			if (!currentAudioFile) {
				sessionStorage.removeItem('transcribeAudioMeta');
				sessionStorage.removeItem('transcribeAudioDataUrl');
				try { localStorage.removeItem('transcribeAudioDataUrl'); } catch (e) {}
				return;
			}
			sessionStorage.setItem('transcribeAudioMeta', JSON.stringify({
				fileName: currentAudioFile.name,
				fileSize: currentAudioFile.size
			}));
			if (currentAudioFile.size > MAX_PERSIST_AUDIO_SIZE) return;
			const reader = new FileReader();
			reader.onload = () => {
				const dataUrl = String(reader.result);
				try {
					localStorage.setItem('transcribeAudioDataUrl', dataUrl);
					sessionStorage.removeItem('transcribeAudioDataUrl');
				} catch (e) {
					try {
						sessionStorage.setItem('transcribeAudioDataUrl', dataUrl);
					} catch (e2) {}
				}
			};
			reader.onerror = () => {};
			reader.readAsDataURL(currentAudioFile);
		}

		function restoreTranscribeState() {
		    const savedText = sessionStorage.getItem(TRANSCRIBE_KEY);
		    if (savedText) {
		        transcriptEl.value = savedText;
		        toggleActionButtons(true);
		    }
		    try {
		        const metaRaw = sessionStorage.getItem('transcribeAudioMeta');
		        if (!metaRaw) return;
		        const meta = JSON.parse(metaRaw);

		      
		        if (meta.fileName) fileNameEl.textContent = meta.fileName;
		        if (meta.fileSize) fileSizeEl.textContent = (meta.fileSize / 1024 / 1024).toFixed(2) + ' MB';
		        
		       
		        fileNameEl.removeAttribute('data-i18n');
		        fileSizeEl.removeAttribute('data-i18n');
		        
		      
		        fileBadge.classList.remove('hidden');
		        waveformHint.textContent = NOX_I18N.t('index.audioRestored');

		       
		        const dataUrl = localStorage.getItem('transcribeAudioDataUrl') || sessionStorage.getItem('transcribeAudioDataUrl');
		        if (dataUrl) {
		            previewPlayer.src = dataUrl;
		            previewPlayer.hidden = false;
		            fetch(dataUrl)
		                .then((r) => r.blob())
		                .then((blob) => {
		                    currentAudioFile = new File([blob], meta.fileName || 'restored-audio.mp3', { type: blob.type || 'audio/mp3' });
		                    transcribeBtn.disabled = false;
		                })
		                .catch(() => {});
		        }
		    } catch (e) {
		        console.error('Failed to restore transcribe state', e);
		    }
		}

		function clearTranscribeState() {
			if (recording) stopRecording();
			transcriptEl.value = '';
			currentAudioFile = null;
			previewPlayer.pause();
			previewPlayer.removeAttribute('src');
			previewPlayer.load();
			previewPlayer.hidden = true;
			fileBadge.classList.add('hidden');
			fileNameEl.textContent = NOX_I18N.t('index.noFile');
			fileSizeEl.textContent = NOX_I18N.t('index.uploadPreview');
			waveformHint.textContent = NOX_I18N.t('index.waveformHint');
			updateStatus(NOX_I18N.t('index.status.idle'));
			transcribeBtn.disabled = true;
			toggleActionButtons(false);
			sessionStorage.removeItem(TRANSCRIBE_KEY);
			sessionStorage.removeItem('transcribeAudioMeta');
			sessionStorage.removeItem('transcribeAudioDataUrl');
			try { localStorage.removeItem('transcribeAudioDataUrl'); } catch (e) {}
			
			fileNameEl.removeAttribute('data-i18n');
			fileSizeEl.removeAttribute('data-i18n');
		}

		function drawWaveform() {
			if (!analyser) return;
			const width = canvas.clientWidth;
			const height = canvas.clientHeight;
			analyser.getByteFrequencyData(dataArray);

			ctx.clearRect(0, 0, width, height);
			const barWidth = (width / dataArray.length) * 2.5;
			let barHeight;
			let x = 0;

			for (let i = 0; i < dataArray.length; i++) {
				barHeight = dataArray[i] / 2;
				ctx.fillStyle = 'rgba(32, 168, 196, ' + Math.max(0.3, barHeight / 80) + ')';
				ctx.fillRect(x, height / 2 - barHeight / 2, barWidth, barHeight);
				x += barWidth + 2;
			}

			animationId = requestAnimationFrame(drawWaveform);
		}

		async function startRecording() {
			stream = await navigator.mediaDevices.getUserMedia({ audio: true });
			audioContext = new (window.AudioContext || window.webkitAudioContext)();
			analyser = audioContext.createAnalyser();
			analyser.fftSize = 128;
			dataArray = new Uint8Array(analyser.frequencyBinCount);

			source = audioContext.createMediaStreamSource(stream);
			source.connect(analyser);

			recordingChunks = [];
			mediaRecorder = new MediaRecorder(stream);
			
			mediaRecorder.ondataavailable = (event) => {
				if (event.data.size > 0) recordingChunks.push(event.data);
			};

			mediaRecorder.start();

			recordBtn.classList.add('recording');
			recordBtn.querySelector('span:last-child').textContent = NOX_I18N.t('index.stop');
			updateStatus(NOX_I18N.t('index.recording'), true);
			waveformHint.textContent = NOX_I18N.t('index.waveformActive');
			fileBadge.classList.add('hidden');
			previewPlayer.hidden = true;

			drawWaveform();
			toggleActionButtons(false);
			transcribeBtn.disabled = true;
			transcriptEl.value = '';
		}
		function setCurrentAudioFile(file) {
		    currentAudioFile = file;
		    fileNameEl.textContent = file.name;
		    fileSizeEl.textContent = (file.size / 1024 / 1024).toFixed(2) + ' MB';
		    
		 
		    previewPlayer.src = URL.createObjectURL(file);
		    previewPlayer.hidden = false;
		    
		  
		    fileBadge.classList.remove('hidden'); 
		    
		    toggleActionButtons(false);
		    transcribeBtn.disabled = false;
		    persistTranscribeAudio();
		}

		function stopRecording() {
			if (mediaRecorder && mediaRecorder.state !== 'inactive') mediaRecorder.stop();
			if (stream) stream.getTracks().forEach((track) => track.stop());
			if (audioContext) audioContext.close();

			cancelAnimationFrame(animationId);
			ctx.clearRect(0, 0, canvas.clientWidth, canvas.clientHeight);

			recording = false;
			recordBtn.classList.remove('recording');
			recordBtn.querySelector('span:last-child').textContent = NOX_I18N.t('index.record');
			updateStatus(NOX_I18N.t('index.status.idle'), false);

			setTimeout(() => {
				const recordedBlob = new Blob(recordingChunks, { type: 'audio/mp3' });
				const recordedFile = new File([recordedBlob], 'recording-' + Date.now() + '.mp3', { type: 'audio/mp3' });
				setCurrentAudioFile(recordedFile);
				waveformHint.textContent = NOX_I18N.t('index.recordingComplete');
			}, 200);
		}

		recordBtn.addEventListener('click', async () => {
			if (recording) {
				stopRecording();
				return;
			}
			try {
				recording = true;
				await startRecording();
			} catch (error) {
				updateStatus(NOX_I18N.t('index.permissionDenied'));
				recording = false;
				console.error(error);
			}
		});

		audioUpload.addEventListener('change', () => {
			const file = audioUpload.files[0];
			if (!file) return;
			setCurrentAudioFile(file);
			waveformHint.textContent = NOX_I18N.t('index.fileLoaded');
			updateStatus(NOX_I18N.t('index.fileReady'));
		});

		async function transcribeAudio() {
			if (!currentAudioFile) return;

			updateStatus(NOX_I18N.t('index.sending'), true);
			transcribeBtn.disabled = true;
			toggleActionButtons(false);
			transcriptEl.value = '';

			const formData = new FormData();
			formData.append('audio', currentAudioFile);

			try {
				const response = await fetch('${pageContext.request.contextPath}/api/transcribe', {
					method: 'POST',
					body: formData,
				});

				const data = await response.json();

				if (response.ok) {
					transcriptEl.value = data.text;
					updateStatus(NOX_I18N.t('index.transcriptionComplete'));
					toggleActionButtons(true);
					persistTranscribeText();
					persistTranscribeAudio();
					['summaryResult', 'translatedText', 'todoTasks', 'qnaResult'].forEach((key) => sessionStorage.removeItem(key));
				} else {
					transcriptEl.value = "Error: " + (data.error || NOX_I18N.t('index.transcriptionFailed'));
					updateStatus(NOX_I18N.t('common.error'));
					transcribeBtn.disabled = false;
				}
			} catch (error) {
				console.error(error);
				transcriptEl.value = NOX_I18N.t('index.transcriptionFailed');
				updateStatus(NOX_I18N.t('common.error'));
				transcribeBtn.disabled = false;
			}
		}

		transcribeBtn.addEventListener('click', transcribeAudio);

		transcriptEl.addEventListener('input', () => {
			toggleActionButtons(transcriptEl.value.trim().length > 0);
			persistTranscribeText();
		});

		function redirectWithText(targetPage) {
			const text = transcriptEl.value.trim();
			if (!text) return;
			sessionStorage.setItem('transcribedSourceText', text);
			sessionStorage.setItem('sourceText', text);
			window.location.href = targetPage;
		}

		translateNavBtn.addEventListener('click', () => redirectWithText('${pageContext.request.contextPath}/translate'));
		summaryNavBtn.addEventListener('click', () => redirectWithText('${pageContext.request.contextPath}/summary'));
		todoNavBtn.addEventListener('click', () => redirectWithText('${pageContext.request.contextPath}/todolist'));
		textNavBtn.addEventListener('click', () => redirectWithText('${pageContext.request.contextPath}/text'));

		const clearTranscribeBtn = document.getElementById('clearTranscribeBtn');
		if (clearTranscribeBtn) {
			clearTranscribeBtn.addEventListener('click', clearTranscribeState);
		}

		window.addEventListener('resize', resizeCanvas);
		resizeCanvas();
		
		NOX_I18N.ready.then(function() {
			restoreTranscribeState();
		});
	</script>
</body>
</html>

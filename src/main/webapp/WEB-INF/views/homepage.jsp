<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Nox</title>
    <link rel="icon" type="image/jpeg" href="${pageContext.request.contextPath}/static/images/logo.jpg">
    <meta
      name="description"
      content="Nox helps convert speech to text, translate languages, and summarize content effortlessly."
    />
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
      href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap"
      rel="stylesheet"
    />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"
    />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/home.css" />
    <script src="${pageContext.request.contextPath}/static/js/i18n.js"></script>
  </head>
  <body>
    <header class="site-header">
     <div class="container nav-wrap">
        <a class="logo" href="#home">
          <img src="${pageContext.request.contextPath}/static/images/logo.jpg" alt="NOX Logo" class="logo-img">
          <span >NOX</span>
        </a>
        <nav class="main-nav" aria-label="Primary navigation">
          <a href="#home" data-i18n="nav.home">Home</a>
          <a href="#about" data-i18n="nav.about">About Us</a>
          <a href="#features" data-i18n="nav.features">Features</a>
          <a class="btn btn-outline" href="${pageContext.request.contextPath}/login">Login</a>
          <a class="btn btn-primary" href="${pageContext.request.contextPath}/register">Register</a>
        </nav>
      </div>
    </header>

    <main id="home">
      <section class="hero">
        <div class="container hero-content">
          <div class="hero-text">
            <p class="eyebrow" data-i18n="hero.eyebrow">AI-powered note taking</p>
            <h1 data-i18n="hero.title">Effortless Voice Notes </h1>
            <p data-i18n="hero.desc">
              Convert speech to text, translate languages, generate quick
              summaries, correct grammar errors, and chat directly with your records.
            </p>
            <div class="hero-actions">
              <a class="btn btn-primary" href="${pageContext.request.contextPath}/login" data-i18n="hero.cta">Get Started Now</a>
              <a class="btn btn-secondary" href="#about" data-i18n="hero.discover">Discover More</a>
            </div>
          </div>
        </div>
      </section>

      <section id="about" class="section about">
        <div class="container about-grid">
          <div class="section-text">
            <h2 data-i18n="about.title">NOX</h2>
            <p data-i18n="about.desc">
              Nox(Vox&Note) is a smart web platform built to help users
              record and manage audio notes during meetings,
              lectures, and daily tasks. By combining automated transcription,
              translation, summarization, to-do-list, and Q&amp;A chat, text-to-speech,
              it eliminates manual note-taking and saves valuable time.
            </p>
            <a class="btn btn-dark" href="#features" data-i18n="about.learnMore">Learn More</a>
          </div>
          <div class="about-visual" aria-hidden="true">
            <div class="device-card">
              <div class="device-screen">
                <div class="mockup-header">
                  <span class="dot"></span>
                  <span class="dot"></span>
                  <span class="dot"></span>
                </div>
                <div class="mockup-panel">
                  <div class="mockup-chip" data-i18n="mock.transcribed">Transcribed</div>
                  <div class="mockup-line long"></div>
                  <div class="mockup-line"></div>
                  <div class="mockup-line"></div>
                  <div class="mockup-line short"></div>
                </div>
                <div class="mockup-panel secondary">
                  <div class="mockup-chip accent" data-i18n="mock.summary">Summary</div>
                  <div class="mockup-line long"></div>
                  <div class="mockup-line"></div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      <section id="features" class="section features">
        <div class="container">
          <div class="section-heading">
            <h2 data-i18n="features.title">Features &amp; How It Works</h3>
          </div>
          <div class="cards">
            <article class="feature-card">
              <div class="icon">
                <i class="fa-solid fa-microphone"></i>
              </div>
              <h3 data-i18n="features.stt.title">Speech-to-Text</h3>
              <p data-i18n="features.stt.desc">
                Record voice or upload audio to generate accurate transcripts in
                seconds.
              </p>
            </article>

            <article class="feature-card">
              <div class="icon">
                <i class="fa-solid fa-language"></i>
              </div>
              <h3 data-i18n="features.translate.title">Burmese-English Translation</h3>
              <p data-i18n="features.translate.desc">
                Instantly translate content across languages during meetings and study sessions.
              </p>
            </article>

            <article class="feature-card">
              <div class="icon">
                <i class="fa-solid fa-wand-magic-sparkles"></i>
              </div>
              <h3 data-i18n="features.summary.title">AI Summarization</h3>
              <p data-i18n="features.summary.desc">
                Receive quick takeaways from your recordings.
              </p>
            </article>

            <article class="feature-card">
              <div class="icon">
                <i class="fa-solid fa-list-check"></i>
              </div>
              <h3 data-i18n="features.todolist.title">To-Do Lists</h3>
              <p data-i18n="features.todolist.desc">
                Automatically generate to-do lists from the imported record/mp3.
              </p>
            </article>

            <article class="feature-card">
              <div class="icon">
                <i class="fa-solid fa-comments"></i>
              </div>
              <h3 data-i18n="features.qa.title">Interactive Q&amp;A</h3>
              <p data-i18n="features.qa.desc">
                Ask questions directly to your saved audio recordings and receive instant answers or polish any text.
              </p>
            </article>

            <article class="feature-card">
              <div class="icon">
                <i class="fa-solid fa-volume-high"></i>
              </div>
              <h3 data-i18n="features.tts.title">Text-To-Speech</h3>
              <p data-i18n="features.tts.desc">
                Upload desired text to convert into speech as fast or slow you want.
              </p>
            </article>
          </div>
        </div>
      </section>
    </main>

    <footer class="site-footer">
      <div class="container footer-wrap">
        <p data-i18n="footer.text">© 2026 NOX. Built for effortless note capture.</p>
        
      </div>
    </footer>
  </body>
</html>

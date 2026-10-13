// ---------- Hamburger menu ----------
(function () {
  const btn = document.getElementById("menuBtn");
  const drawer = document.getElementById("drawer");
  const overlay = document.getElementById("overlay");
  if (!btn || !drawer || !overlay) return;

  function setOpen(open) {
    btn.classList.toggle("open", open);
    drawer.classList.toggle("open", open);
    overlay.classList.toggle("show", open);
    btn.setAttribute("aria-expanded", String(open));
    document.body.style.overflow = open ? "hidden" : "";
  }

  btn.addEventListener("click", function () {
    setOpen(!drawer.classList.contains("open"));
  });
  overlay.addEventListener("click", function () { setOpen(false); });
  document.addEventListener("keydown", function (e) {
    if (e.key === "Escape") setOpen(false);
  });
})();

// ---------- Scroll reveal ----------
(function () {
  const items = document.querySelectorAll(".reveal");
  if (!("IntersectionObserver" in window)) {
    items.forEach(function (el) { el.classList.add("visible"); });
    return;
  }
  const io = new IntersectionObserver(function (entries) {
    entries.forEach(function (entry) {
      if (entry.isIntersecting) {
        entry.target.classList.add("visible");
        io.unobserve(entry.target);
      }
    });
  }, { threshold: 0.15 });
  items.forEach(function (el, i) {
    el.style.transitionDelay = (i % 4) * 0.08 + "s";
    io.observe(el);
  });
})();

// ---------- Neon particle background ----------
(function () {
  const canvas = document.getElementById("bg-canvas");
  if (!canvas) return;
  if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) return;

  const ctx = canvas.getContext("2d");
  let w, h, particles;

  function resize() {
    w = canvas.width = window.innerWidth;
    h = canvas.height = window.innerHeight;
    const count = Math.min(70, Math.floor((w * h) / 22000));
    particles = Array.from({ length: count }, function () {
      return {
        x: Math.random() * w,
        y: Math.random() * h,
        vx: (Math.random() - 0.5) * 0.35,
        vy: (Math.random() - 0.5) * 0.35,
        r: Math.random() * 1.8 + 0.6
      };
    });
  }

  function frame() {
    ctx.clearRect(0, 0, w, h);
    for (let i = 0; i < particles.length; i++) {
      const p = particles[i];
      p.x += p.vx; p.y += p.vy;
      if (p.x < 0 || p.x > w) p.vx *= -1;
      if (p.y < 0 || p.y > h) p.vy *= -1;

      ctx.beginPath();
      ctx.arc(p.x, p.y, p.r, 0, Math.PI * 2);
      ctx.fillStyle = "rgba(168, 85, 247, 0.8)";
      ctx.shadowColor = "#a855f7";
      ctx.shadowBlur = 12;
      ctx.fill();

      for (let j = i + 1; j < particles.length; j++) {
        const q = particles[j];
        const dx = p.x - q.x, dy = p.y - q.y;
        const d = Math.sqrt(dx * dx + dy * dy);
        if (d < 130) {
          ctx.shadowBlur = 0;
          ctx.strokeStyle = "rgba(168, 85, 247," + (0.18 * (1 - d / 130)) + ")";
          ctx.lineWidth = 1;
          ctx.beginPath();
          ctx.moveTo(p.x, p.y);
          ctx.lineTo(q.x, q.y);
          ctx.stroke();
        }
      }
    }
    requestAnimationFrame(frame);
  }

  window.addEventListener("resize", resize);
  resize();
  frame();
})();

// ---------- Copy buttons ----------
document.querySelectorAll("[data-copy]").forEach(function (el) {
  el.addEventListener("click", function (e) {
    e.preventDefault();
    const text = el.getAttribute("data-copy");
    if (navigator.clipboard) {
      navigator.clipboard.writeText(text).then(function () {
        const old = el.textContent;
        el.textContent = "Copied!";
        setTimeout(function () { el.textContent = old; }, 1400);
      });
    }
  });
});

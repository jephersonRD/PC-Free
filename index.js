// ==============================================
// MOBILE MENU TOGGLE
// ==============================================
const menuToggle = document.getElementById('menuToggle');
const navMenu = document.getElementById('navMenu');

menuToggle.addEventListener('click', () => {
    navMenu.classList.toggle('active');
    
    const icon = menuToggle.querySelector('i');
    if (navMenu.classList.contains('active')) {
        icon.classList.remove('bi-list');
        icon.classList.add('bi-x');
    } else {
        icon.classList.remove('bi-x');
        icon.classList.add('bi-list');
    }
});

// Close menu when clicking on a link
document.querySelectorAll('.nav-link').forEach(link => {
    link.addEventListener('click', () => {
        navMenu.classList.remove('active');
        const icon = menuToggle.querySelector('i');
        icon.classList.remove('bi-x');
        icon.classList.add('bi-list');
    });
});

// ==============================================
// GSAP SCROLL ANIMATIONS
// ==============================================
gsap.registerPlugin(ScrollTrigger);

// Animate all elements with 'reveal-up' class
const revealElements = document.querySelectorAll('.reveal-up');

revealElements.forEach((element) => {
    gsap.to(element, {
        scrollTrigger: {
            trigger: element,
            start: 'top 85%',
            end: 'bottom 20%',
            toggleClass: 'active',
            once: true
        }
    });
});

// ==============================================
// SMOOTH SCROLL FOR ANCHOR LINKS
// ==============================================
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        const target = document.querySelector(this.getAttribute('href'));
        
        if (target) {
            const offsetTop = target.offsetTop - 70; // Account for fixed header
            
            window.scrollTo({
                top: offsetTop,
                behavior: 'smooth'
            });
        }
    });
});

// ==============================================
// HEADER BACKGROUND ON SCROLL
// ==============================================
const header = document.querySelector('.main-header');
let lastScrollY = window.scrollY;

window.addEventListener('scroll', () => {
    const currentScrollY = window.scrollY;

    if (currentScrollY > lastScrollY && currentScrollY > header.offsetHeight) {
        // Scrolling down
        header.classList.add('hidden');
    } else {
        // Scrolling up
        header.classList.remove('hidden');
    }

    if (currentScrollY > 50) {
        header.style.background = 'rgba(18, 18, 18, 0.95)';
    } else {
        header.style.background = 'rgba(18, 18, 18, 0.8)';
    }

    lastScrollY = currentScrollY <= 0 ? 0 : currentScrollY; // For Mobile or negative scrolling
});

// ==============================================
// FEATURE CARD HOVER EFFECT
// ==============================================

// ==============================================
// CTA SPOTLIGHT EFFECT
// ==============================================
const ctaSection = document.getElementById('cta-section');

if (ctaSection) {
    ctaSection.addEventListener('mousemove', (e) => {
        const rect = ctaSection.getBoundingClientRect();
        ctaSection.style.setProperty('--x', `${e.clientX - rect.left}px`);
        ctaSection.style.setProperty('--y', `${e.clientY - rect.top}px`);
    });
}

// ==============================================
// FAQ ACCORDION
// ==============================================
const faqItems = document.querySelectorAll('.faq-item');

faqItems.forEach(item => {
    const question = item.querySelector('.faq-question');
    const answer = item.querySelector('.faq-answer');
    const icon = question.querySelector('i');

    question.addEventListener('click', () => {
        const isActive = item.classList.contains('active');

        item.classList.toggle('active');
        icon.classList.toggle('bi-plus-circle');
        icon.classList.toggle('bi-dash-circle');

        if (item.classList.contains('active')) {
            answer.style.maxHeight = answer.scrollHeight + 'px';
        } else {
            answer.style.maxHeight = '0px';
        }
    });
});
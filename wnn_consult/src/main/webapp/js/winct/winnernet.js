
// menu


  document.querySelectorAll(".menu > li").forEach(function (menuItem) {
    menuItem.addEventListener("mouseenter", function () {
      const submenu = this.querySelector(".submenu");
      if (submenu) submenu.style.display = "block";
    });
    menuItem.addEventListener("mouseleave", function () {
      const submenu = this.querySelector(".submenu");
      if (submenu) submenu.style.display = "none";
    });
  });


// 슬라이드
const slides = document.querySelectorAll('.slide');
const toggleBtn = document.getElementById('toggleBtn');
const toggleIcon = document.getElementById('toggleIcon');
const numberBtns = document.querySelectorAll('.number');

let current = 0;
let isPlaying = true;
let intervalId = null;

// 슬라이드 보여주는 함수
function showSlide(index) {
  current = index;
  slides.forEach((slide, i) => {
    slide.classList.toggle('active', i === index);
  });

  // 숫자 버튼 색상 업데이트
  numberBtns.forEach((btn, i) => {
    if (i === index) {
      btn.classList.add('active');
    } else {
      btn.classList.remove('active');
    }
  });
}

function nextSlide() {
  current = (current + 1) % slides.length;
  showSlide(current);
}

// 슬라이드 시작: play.png 표시
function startSlider() {
  intervalId = setInterval(nextSlide, 3000);
  isPlaying = true;
  toggleIcon.innerHTML = `<img src="/images/winct/play.png" alt="Play" width="32" height="30">`;
}

// 슬라이드 정지: stop.png 표시
function stopSlider() {
  clearInterval(intervalId);
  isPlaying = false;
  toggleIcon.innerHTML = `<img src="/images/winct/stop.png" alt="Stop" width="32" height="30">`;
}

// 버튼 클릭 이벤트
toggleBtn.addEventListener('click', () => {
  isPlaying ? stopSlider() : startSlider();
});

// 숫자 버튼 클릭 이벤트
numberBtns.forEach(btn => {
  btn.addEventListener('click', () => {
    const slideIndex = parseInt(btn.getAttribute('data-slide'));
    showSlide(slideIndex);
  });
});

// 초기 시작
startSlider();


// 공지사항 텝메뉴

document.querySelectorAll('.tab').forEach(tab => {
  tab.addEventListener('click', function () {
    // 탭 활성화
    document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
    this.classList.add('active');

    // 콘텐츠 활성화
    const target = this.dataset.tab;
    document.querySelectorAll('.tabContent').forEach(c => c.classList.remove('active'));
    document.getElementById(target).classList.add('active');
  });
});




// 하단 화살표 50픽셀 도달시 나타남, 클릭시 천천히 최상단, logo 클릭시 천천히 최상단

const scrollArrow = document.querySelector('.scroll-arrow');
const logo = document.querySelector('.logo');

const scrollToTop = e => {
  e.preventDefault();
  window.scrollTo({ top: 0, behavior: 'smooth' });
};

window.addEventListener('scroll', () =>
  scrollArrow.classList.toggle('show', window.scrollY > 50)
);

scrollArrow?.addEventListener('click', scrollToTop);
logo?.addEventListener('click', scrollToTop);



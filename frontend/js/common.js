// =============================================
// 智能家居IoT - 公共工具库 v2
// 新增: 涟漪点击效果、数字滚动动画、交互增强
// =============================================

// 同源部署时用相对路径；以 file:// 打开时回退到本地后端
const API = (location.protocol === 'file:')
    ? 'http://localhost:8080/api'
    : (location.origin && location.port ? location.origin : 'http://localhost:8080') + '/api';

// 通用请求
async function request(url, options = {}) {
    try {
        const res = await fetch(`${API}${url}`, {
            headers: { 'Content-Type': 'application/json' },
            ...options
        });
        return await res.json();
    } catch (e) {
        console.error('请求失败:', e);
        return { code: -1, message: '网络错误' };
    }
}

async function apiGet(url) { return request(url); }
async function apiPost(url, data) { return request(url, { method: 'POST', body: JSON.stringify(data) }); }
async function apiPut(url, data) { return request(url, { method: 'PUT', body: JSON.stringify(data) }); }
async function apiDelete(url) { return request(url, { method: 'DELETE' }); }

// Toast通知
function showToast(msg, type = 'success') {
    let container = document.querySelector('.toast-container');
    if (!container) {
        container = document.createElement('div');
        container.className = 'toast-container';
        document.body.appendChild(container);
    }
    const toast = document.createElement('div');
    toast.className = `toast toast-${type}`;
    toast.innerHTML = `<i class="bi bi-${type === 'success' ? 'check-circle' : 'exclamation-circle'}"></i>${msg}`;
    container.appendChild(toast);
    setTimeout(() => {
        toast.style.opacity = '0';
        toast.style.transform = 'translateX(60px)';
        setTimeout(() => toast.remove(), 300);
    }, 2500);
}

// 数字滚动动画
function animateNumber(el, target, duration = 800) {
    const start = parseInt(el.textContent) || 0;
    const diff = target - start;
    if (diff === 0) { el.textContent = target; return; }
    const startTime = performance.now();
    function tick(now) {
        const elapsed = now - startTime;
        const progress = Math.min(elapsed / duration, 1);
        // easeOutCubic
        const ease = 1 - Math.pow(1 - progress, 3);
        el.textContent = Math.round(start + diff * ease);
        if (progress < 1) requestAnimationFrame(tick);
    }
    requestAnimationFrame(tick);
}

// 设备类型图标
function getDeviceIcon(type) {
    const icons = { sensor: 'bi-thermometer-half', light: 'bi-lightbulb', fan: 'bi-fan', switch: 'bi-toggles', camera: 'bi-camera', lock: 'bi-lock' };
    return icons[type] || 'bi-gear';
}

// 设备类型中文
function getDeviceTypeLabel(type) {
    const labels = { sensor: '传感器', light: '灯具', fan: '风扇', switch: '开关', camera: '摄像头', lock: '门锁' };
    return labels[type] || type;
}

// 格式化时间
function formatTime(str) {
    if (!str) return '--';
    const d = new Date(str);
    const pad = n => String(n).padStart(2, '0');
    return `${pad(d.getMonth()+1)}-${pad(d.getDate())} ${pad(d.getHours())}:${pad(d.getMinutes())}`;
}

function formatDateTime(str) {
    if (!str) return '--';
    const d = new Date(str);
    const pad = n => String(n).padStart(2, '0');
    return `${d.getFullYear()}-${pad(d.getMonth()+1)}-${pad(d.getDate())} ${pad(d.getHours())}:${pad(d.getMinutes())}`;
}

// 顶部导航HTML生成器
function renderNav(activePage) {
    return `
    <nav class="top-nav">
        <a href="index.html" class="nav-brand">
            <div class="nav-brand-icon"><i class="bi bi-house-gear"></i></div>
            <span>SmartHome IoT</span>
        </a>
        <ul class="nav-links" id="navLinks">
            <li><a href="index.html" class="${activePage === 'dashboard' ? 'active' : ''}">
                <i class="bi bi-grid-1x2"></i> 数据总览
            </a></li>
            <li><a href="management.html" class="${activePage === 'management' ? 'active' : ''}">
                <i class="bi bi-hdd-rack"></i> 设备管理
            </a></li>
            <li><a href="report.html" class="${activePage === 'report' ? 'active' : ''}">
                <i class="bi bi-bar-chart-line"></i> 数据报表
            </a></li>
        </ul>
        <div class="nav-right">
            <span class="nav-time" id="navTime"></span>
            <button class="nav-hamburger" onclick="document.getElementById('navLinks').classList.toggle('open')">
                <i class="bi bi-list"></i>
            </button>
        </div>
    </nav>`;
}

// 更新导航时间
function startClock() {
    const el = document.getElementById('navTime');
    if (!el) return;
    function tick() {
        const now = new Date();
        const pad = n => String(n).padStart(2, '0');
        el.textContent = `${pad(now.getHours())}:${pad(now.getMinutes())}:${pad(now.getSeconds())}`;
    }
    tick();
    setInterval(tick, 1000);
}

// ========== 全局交互增强 ==========

// 移动端：禁用双击缩放
document.addEventListener('DOMContentLoaded', function() {
    document.addEventListener('touchstart', function(e) {
        if (e.touches.length > 1) e.preventDefault();
    }, { passive: false });

    // 移动端：点击外部关闭导航菜单
    document.addEventListener('click', function(e) {
        const nav = document.getElementById('navLinks');
        const hamburger = document.querySelector('.nav-hamburger');
        if (nav && nav.classList.contains('open') && !nav.contains(e.target) && !hamburger.contains(e.target)) {
            nav.classList.remove('open');
        }
    });

    // 移动端：关闭模态框（点击遮罩）
    document.addEventListener('click', function(e) {
        if (e.target.classList.contains('modal-overlay') && e.target.classList.contains('show')) {
            e.target.classList.remove('show');
        }
    });
});

// 涟漪点击效果 - 给所有按钮和可点击元素添加
document.addEventListener('click', function(e) {
    const target = e.target.closest('.btn, .btn-icon, .filter-chip, .room-tab, .stat-card, .summary-card');
    if (!target) return;

    const ripple = document.createElement('span');
    const rect = target.getBoundingClientRect();
    const size = Math.max(rect.width, rect.height);
    const x = e.clientX - rect.left - size / 2;
    const y = e.clientY - rect.top - size / 2;

    ripple.style.cssText = `
        position: absolute;
        width: ${size}px;
        height: ${size}px;
        left: ${x}px;
        top: ${y}px;
        background: rgba(37,99,235,0.15);
        border-radius: 50%;
        transform: scale(0);
        animation: rippleEffect 0.6s ease-out;
        pointer-events: none;
        z-index: 10;
    `;

    // 确保目标元素有 position
    const pos = getComputedStyle(target).position;
    if (pos === 'static') target.style.position = 'relative';
    target.style.overflow = 'hidden';

    target.appendChild(ripple);
    setTimeout(() => ripple.remove(), 600);
});

// 添加涟漪动画到页面
if (!document.getElementById('ripple-style')) {
    const style = document.createElement('style');
    style.id = 'ripple-style';
    style.textContent = `
        @keyframes rippleEffect {
            to { transform: scale(4); opacity: 0; }
        }
    `;
    document.head.appendChild(style);
}

// 导航链接点击反馈
document.addEventListener('DOMContentLoaded', function() {
    // 给所有交互元素添加 active 反馈
    document.addEventListener('mousedown', function(e) {
        const el = e.target.closest('.btn, .btn-icon, .filter-chip, .room-tab');
        if (el) el.style.transform = 'scale(0.96)';
    });
    document.addEventListener('mouseup', function(e) {
        const el = e.target.closest('.btn, .btn-icon, .filter-chip, .room-tab');
        if (el) el.style.transform = '';
    });
    document.addEventListener('mouseleave', function(e) {
        const el = e.target.closest('.btn, .btn-icon, .filter-chip, .room-tab');
        if (el) el.style.transform = '';
    }, true);
});

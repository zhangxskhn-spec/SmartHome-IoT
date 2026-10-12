-- =============================================
-- 智能家居IoT数据管理系统 - 数据库初始化
-- 数据库名: smart_home_iot
-- =============================================

CREATE DATABASE IF NOT EXISTS smart_home_iot DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE smart_home_iot;

-- 房间表
CREATE TABLE IF NOT EXISTS room (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL COMMENT '房间名称',
    icon VARCHAR(50) DEFAULT 'bi-house' COMMENT '图标类名',
    sort_order INT DEFAULT 0 COMMENT '排序',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='房间表';

-- 设备表
CREATE TABLE IF NOT EXISTS device (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL COMMENT '设备名称',
    type VARCHAR(30) NOT NULL COMMENT '类型: sensor/light/fan/switch/camera/lock',
    room_id BIGINT COMMENT '所属房间',
    model VARCHAR(100) COMMENT '设备型号',
    status TINYINT DEFAULT 1 COMMENT '0-离线 1-在线',
    switch_state TINYINT DEFAULT 0 COMMENT '0-关 1-开',
    battery INT DEFAULT 100 COMMENT '电量百分比',
    signal_strength INT DEFAULT 90 COMMENT '信号强度',
    last_online DATETIME COMMENT '最后在线时间',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_room (room_id),
    INDEX idx_type (type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='设备表';

-- 传感器数据表
CREATE TABLE IF NOT EXISTS sensor_reading (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    device_id BIGINT NOT NULL,
    temperature DECIMAL(5,2) COMMENT '温度℃',
    humidity DECIMAL(5,2) COMMENT '湿度%',
    light_level INT COMMENT '光照lux',
    pm25 DECIMAL(6,2) COMMENT 'PM2.5',
    co2 DECIMAL(7,2) COMMENT 'CO2 ppm',
    noise DECIMAL(5,2) COMMENT '噪音dB',
    record_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_device_time (device_id, record_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='传感器数据表';

-- 告警记录表
CREATE TABLE IF NOT EXISTS alert_record (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    device_id BIGINT,
    alert_type VARCHAR(30) NOT NULL COMMENT '类型: temperature/humidity/offline/intrusion/fire',
    level VARCHAR(10) DEFAULT 'warning' COMMENT '级别: info/warning/danger',
    message VARCHAR(255) NOT NULL,
    is_read TINYINT DEFAULT 0 COMMENT '0-未读 1-已读',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_read (is_read)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='告警记录表';

-- 自动化规则表
CREATE TABLE IF NOT EXISTS automation_rule (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL COMMENT '规则名称',
    trigger_device_id BIGINT COMMENT '触发设备',
    trigger_condition VARCHAR(100) COMMENT '触发条件 如:temperature>30',
    action_device_id BIGINT COMMENT '执行设备',
    action_type VARCHAR(50) COMMENT '执行动作 如:switch_on/switch_off',
    enabled TINYINT DEFAULT 1 COMMENT '是否启用',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='自动化规则表';

-- ========== 重置演示数据（支持重复执行 init.sql）==========
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE sensor_reading;
TRUNCATE TABLE alert_record;
TRUNCATE TABLE automation_rule;
TRUNCATE TABLE device;
TRUNCATE TABLE room;
SET FOREIGN_KEY_CHECKS = 1;

-- ========== 初始数据 ==========

INSERT INTO room (name, icon, sort_order) VALUES
('客厅', 'bi-lamp', 1),
('主卧', 'bi-moon', 2),
('次卧', 'bi-book', 3),
('厨房', 'bi-cup-hot', 4),
('卫生间', 'bi-droplet', 5),
('阳台', 'bi-sun', 6);

INSERT INTO device (name, type, room_id, model, status, switch_state, battery, signal_strength, last_online) VALUES
('温度湿度传感器', 'sensor', 1, 'DHT22-Pro', 1, 0, 95, 92, NOW()),
('智能吸顶灯', 'light', 1, 'Yeelight-650', 1, 1, 100, 88, NOW()),
('立式空调', 'switch', 1, 'Gree-3P', 1, 1, 100, 85, NOW()),
('智能门锁', 'lock', 1, 'Aqara-D100', 1, 0, 78, 95, NOW()),
('温湿度传感器', 'sensor', 2, 'DHT22-Pro', 1, 0, 88, 90, NOW()),
('床头灯', 'light', 2, 'Philips-Hue', 1, 0, 100, 93, NOW()),
('智能窗帘', 'switch', 2, 'Aqara-B1', 1, 0, 65, 87, NOW()),
('空气质量传感器', 'sensor', 3, 'MQ-135', 1, 0, 92, 89, NOW()),
('台灯', 'light', 3, 'Mijia-Desk', 1, 1, 100, 96, NOW()),
('烟雾报警器', 'sensor', 4, 'Honeywell-SD', 1, 0, 100, 91, NOW()),
('排气扇', 'fan', 4, 'Panasonic-FV', 1, 0, 100, 82, NOW()),
('热水器', 'switch', 5, 'Haier-EC600', 1, 1, 100, 78, NOW()),
('湿度传感器', 'sensor', 5, 'DHT22', 1, 0, 90, 86, NOW()),
('阳台灯', 'light', 6, 'Yeelight-Bulb', 0, 0, 100, 0, NOW() - INTERVAL 2 HOUR),
('摄像头', 'camera', 6, 'Xiaomi-360', 1, 1, 55, 72, NOW());

-- 模拟7天传感器数据（每小时一条，设备1和5）
INSERT INTO sensor_reading (device_id, temperature, humidity, light_level, pm25, co2, noise, record_time)
SELECT 
    1,
    22 + RAND() * 8,
    45 + RAND() * 25,
    200 + RAND() * 600,
    15 + RAND() * 40,
    350 + RAND() * 300,
    30 + RAND() * 25,
    NOW() - INTERVAL (t) HOUR
FROM (
    SELECT a.N + b.N * 10 AS t FROM 
    (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a,
    (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10 UNION SELECT 11 UNION SELECT 12 UNION SELECT 13 UNION SELECT 14 UNION SELECT 15 UNION SELECT 16) b
) nums
WHERE t <= 168;

INSERT INTO sensor_reading (device_id, temperature, humidity, light_level, pm25, co2, noise, record_time)
SELECT 
    5,
    20 + RAND() * 6,
    50 + RAND() * 20,
    100 + RAND() * 400,
    10 + RAND() * 30,
    300 + RAND() * 250,
    25 + RAND() * 20,
    NOW() - INTERVAL (t) HOUR
FROM (
    SELECT a.N + b.N * 10 AS t FROM 
    (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a,
    (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10 UNION SELECT 11 UNION SELECT 12 UNION SELECT 13 UNION SELECT 14 UNION SELECT 15 UNION SELECT 16) b
) nums
WHERE t <= 168;

-- 告警数据
INSERT INTO alert_record (device_id, alert_type, level, message, is_read, create_time) VALUES
(1, 'temperature', 'warning', '客厅温度过高: 35.2℃', 0, NOW() - INTERVAL 1 HOUR),
(14, 'offline', 'danger', '阳台灯已离线超过2小时', 0, NOW() - INTERVAL 30 MINUTE),
(4, 'intrusion', 'danger', '检测到门锁异常开锁尝试', 1, NOW() - INTERVAL 6 HOUR),
(10, 'fire', 'danger', '厨房烟雾浓度超标!', 1, NOW() - INTERVAL 1 DAY),
(15, 'offline', 'info', '摄像头电量低于60%', 0, NOW() - INTERVAL 2 HOUR),
(5, 'humidity', 'warning', '主卧湿度过低: 32%', 0, NOW() - INTERVAL 3 HOUR);

-- 自动化规则
INSERT INTO automation_rule (name, trigger_device_id, trigger_condition, action_device_id, action_type, enabled) VALUES
('高温自动开空调', 1, 'temperature>30', 3, 'switch_on', 1),
('低温自动关空调', 1, 'temperature<18', 3, 'switch_off', 1),
('晚间自动开床头灯', NULL, 'time:22:00', 6, 'switch_on', 1),
('烟雾报警自动排风', 10, 'pm25>100', 11, 'switch_on', 1);

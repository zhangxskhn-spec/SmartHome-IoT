package com.iot.smarthome.entity;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class AlertRecord {
    private Long id;
    private Long deviceId;
    private String alertType;
    private String level;
    private String message;
    private Integer isRead;
    private LocalDateTime createTime;
    // JOIN
    private String deviceName;
}

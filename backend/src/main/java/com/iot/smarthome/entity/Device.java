package com.iot.smarthome.entity;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class Device {
    private Long id;
    private String name;
    private String type;
    private Long roomId;
    private String model;
    private Integer status;
    private Integer switchState;
    private Integer battery;
    private Integer signalStrength;
    private LocalDateTime lastOnline;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
    // JOIN fields
    private String roomName;
}

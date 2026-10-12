package com.iot.smarthome.entity;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class AutomationRule {
    private Long id;
    private String name;
    private Long triggerDeviceId;
    private String triggerCondition;
    private Long actionDeviceId;
    private String actionType;
    private Integer enabled;
    private LocalDateTime createTime;
}

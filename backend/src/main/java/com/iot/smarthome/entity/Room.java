package com.iot.smarthome.entity;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class Room {
    private Long id;
    private String name;
    private String icon;
    private Integer sortOrder;
    private LocalDateTime createTime;
}

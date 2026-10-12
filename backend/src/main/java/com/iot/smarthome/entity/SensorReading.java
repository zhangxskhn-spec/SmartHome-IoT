package com.iot.smarthome.entity;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class SensorReading {
    private Long id;
    private Long deviceId;
    private BigDecimal temperature;
    private BigDecimal humidity;
    private Integer lightLevel;
    private BigDecimal pm25;
    private BigDecimal co2;
    private BigDecimal noise;
    private LocalDateTime recordTime;
}

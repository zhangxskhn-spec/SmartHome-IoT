package com.iot.smarthome.service;

import com.iot.smarthome.entity.SensorReading;
import com.iot.smarthome.mapper.SensorReadingMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class SensorService {
    @Autowired private SensorReadingMapper mapper;
    
    public List<SensorReading> getLatest(Long deviceId, int limit) { return mapper.selectLatest(deviceId, limit); }
    public SensorReading getLatestOne(Long deviceId) { return mapper.selectLatestOne(deviceId); }
    public List<SensorReading> getByTimeRange(Long deviceId, String start, String end) {
        return mapper.selectByTimeRange(deviceId, start, end);
    }
    public int add(SensorReading r) { return mapper.insert(r); }
}

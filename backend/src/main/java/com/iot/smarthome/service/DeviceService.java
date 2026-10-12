package com.iot.smarthome.service;

import com.iot.smarthome.entity.Device;
import com.iot.smarthome.mapper.DeviceMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Map;

@Service
public class DeviceService {
    @Autowired private DeviceMapper mapper;
    
    public List<Device> getAll() { return mapper.selectAll(); }
    public Device getById(Long id) { return mapper.selectById(id); }
    public List<Device> getByRoom(Long roomId) { return mapper.selectByRoomId(roomId); }
    public List<Device> getByType(String type) { return mapper.selectByType(type); }
    public int add(Device d) {
        if (d.getStatus() == null) d.setStatus(1);
        if (d.getSwitchState() == null) d.setSwitchState(0);
        if (d.getBattery() == null) d.setBattery(100);
        if (d.getSignalStrength() == null) d.setSignalStrength(85);
        return mapper.insert(d);
    }
    public int update(Device d) { return mapper.update(d); }
    public int delete(Long id) { return mapper.deleteById(id); }
    public int toggleSwitch(Long id, Integer state) { return mapper.updateSwitch(id, state); }
    public Map<String, Object> getStats() { return mapper.selectStats(); }
}

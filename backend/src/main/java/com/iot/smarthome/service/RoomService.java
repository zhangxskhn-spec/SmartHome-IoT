package com.iot.smarthome.service;

import com.iot.smarthome.entity.Room;
import com.iot.smarthome.mapper.RoomMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class RoomService {
    @Autowired private RoomMapper mapper;
    
    public List<Room> getAll() { return mapper.selectAll(); }
    public Room getById(Long id) { return mapper.selectById(id); }
    public int add(Room r) { return mapper.insert(r); }
    public int update(Room r) { return mapper.update(r); }
    public int delete(Long id) { return mapper.deleteById(id); }
}

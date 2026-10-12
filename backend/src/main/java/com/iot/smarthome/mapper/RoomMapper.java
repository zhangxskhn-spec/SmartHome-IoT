package com.iot.smarthome.mapper;

import com.iot.smarthome.entity.Room;
import java.util.List;

public interface RoomMapper {
    List<Room> selectAll();
    Room selectById(Long id);
    int insert(Room room);
    int update(Room room);
    int deleteById(Long id);
}

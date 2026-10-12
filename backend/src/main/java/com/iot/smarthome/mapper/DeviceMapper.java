package com.iot.smarthome.mapper;

import com.iot.smarthome.entity.Device;
import org.apache.ibatis.annotations.Param;
import java.util.List;
import java.util.Map;

public interface DeviceMapper {
    List<Device> selectAll();
    Device selectById(Long id);
    List<Device> selectByRoomId(Long roomId);
    List<Device> selectByType(String type);
    int insert(Device device);
    int update(Device device);
    int deleteById(Long id);
    int updateSwitch(@Param("id") Long id, @Param("state") Integer state);
    int updateStatus(@Param("id") Long id, @Param("status") Integer status);
    Map<String, Object> selectStats();
}

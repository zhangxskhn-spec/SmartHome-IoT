package com.iot.smarthome.mapper;

import com.iot.smarthome.entity.SensorReading;
import org.apache.ibatis.annotations.Param;
import java.util.List;

public interface SensorReadingMapper {
    List<SensorReading> selectLatest(@Param("deviceId") Long deviceId, @Param("limit") int limit);
    SensorReading selectLatestOne(Long deviceId);
    List<SensorReading> selectByTimeRange(@Param("deviceId") Long deviceId,
                                          @Param("startTime") String startTime,
                                          @Param("endTime") String endTime);
    int insert(SensorReading reading);
}

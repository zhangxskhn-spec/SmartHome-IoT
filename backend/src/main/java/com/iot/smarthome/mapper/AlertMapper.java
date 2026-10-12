package com.iot.smarthome.mapper;

import com.iot.smarthome.entity.AlertRecord;
import java.util.List;

public interface AlertMapper {
    List<AlertRecord> selectAll();
    List<AlertRecord> selectUnread();
    int markRead(Long id);
    int markAllRead();
    int insert(AlertRecord alert);
    int selectUnreadCount();
}

package com.iot.smarthome.service;

import com.iot.smarthome.entity.AlertRecord;
import com.iot.smarthome.mapper.AlertMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class AlertService {
    @Autowired private AlertMapper mapper;
    
    public List<AlertRecord> getAll() { return mapper.selectAll(); }
    public List<AlertRecord> getUnread() { return mapper.selectUnread(); }
    public int markRead(Long id) { return mapper.markRead(id); }
    public int markAllRead() { return mapper.markAllRead(); }
    public int getUnreadCount() { return mapper.selectUnreadCount(); }
    public int add(AlertRecord a) { return mapper.insert(a); }
}

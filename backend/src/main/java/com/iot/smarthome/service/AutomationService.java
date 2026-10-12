package com.iot.smarthome.service;

import com.iot.smarthome.entity.AutomationRule;
import com.iot.smarthome.mapper.AutomationMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class AutomationService {
    @Autowired private AutomationMapper mapper;
    
    public List<AutomationRule> getAll() { return mapper.selectAll(); }
    public int add(AutomationRule r) { return mapper.insert(r); }
    public int update(AutomationRule r) { return mapper.update(r); }
    public int delete(Long id) { return mapper.deleteById(id); }
    public int toggle(Long id) { return mapper.toggleEnabled(id); }
}

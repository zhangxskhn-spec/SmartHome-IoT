package com.iot.smarthome.mapper;

import com.iot.smarthome.entity.AutomationRule;
import java.util.List;

public interface AutomationMapper {
    List<AutomationRule> selectAll();
    int insert(AutomationRule rule);
    int update(AutomationRule rule);
    int deleteById(Long id);
    int toggleEnabled(Long id);
}

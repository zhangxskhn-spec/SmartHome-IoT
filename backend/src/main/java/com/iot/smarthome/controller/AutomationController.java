package com.iot.smarthome.controller;

import com.iot.smarthome.entity.AutomationRule;
import com.iot.smarthome.service.AutomationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.*;

@RestController
@RequestMapping("/api/automation")
@CrossOrigin(origins = "*")
public class AutomationController {
    @Autowired private AutomationService service;
    
    @GetMapping
    public Map<String, Object> list() {
        Map<String, Object> r = new HashMap<>();
        r.put("code", 200); r.put("data", service.getAll());
        return r;
    }
    
    @PostMapping
    public Map<String, Object> add(@RequestBody AutomationRule rule) {
        Map<String, Object> r = new HashMap<>();
        r.put("code", service.add(rule) > 0 ? 200 : 500);
        return r;
    }
    
    @DeleteMapping("/{id}")
    public Map<String, Object> delete(@PathVariable Long id) {
        Map<String, Object> r = new HashMap<>();
        r.put("code", service.delete(id) > 0 ? 200 : 500);
        return r;
    }
    
    @PutMapping("/{id}/toggle")
    public Map<String, Object> toggle(@PathVariable Long id) {
        Map<String, Object> r = new HashMap<>();
        r.put("code", service.toggle(id) > 0 ? 200 : 500);
        return r;
    }
}

package com.iot.smarthome.controller;

import com.iot.smarthome.service.AlertService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.*;

@RestController
@RequestMapping("/api/alerts")
@CrossOrigin(origins = "*")
public class AlertController {
    @Autowired private AlertService service;
    
    @GetMapping
    public Map<String, Object> list(@RequestParam(required = false, defaultValue = "all") String filter) {
        Map<String, Object> r = new HashMap<>();
        r.put("code", 200);
        r.put("data", "unread".equals(filter) ? service.getUnread() : service.getAll());
        return r;
    }
    
    @GetMapping("/count")
    public Map<String, Object> unreadCount() {
        Map<String, Object> r = new HashMap<>();
        r.put("code", 200); r.put("data", service.getUnreadCount());
        return r;
    }
    
    @PutMapping("/{id}/read")
    public Map<String, Object> markRead(@PathVariable Long id) {
        Map<String, Object> r = new HashMap<>();
        r.put("code", 200); service.markRead(id);
        return r;
    }
    
    @PutMapping("/read-all")
    public Map<String, Object> markAllRead() {
        Map<String, Object> r = new HashMap<>();
        service.markAllRead(); r.put("code", 200);
        return r;
    }
}

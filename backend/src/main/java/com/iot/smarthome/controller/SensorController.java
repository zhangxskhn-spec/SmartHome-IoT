package com.iot.smarthome.controller;

import com.iot.smarthome.service.SensorService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.*;

@RestController
@RequestMapping("/api/sensors")
@CrossOrigin(origins = "*")
public class SensorController {
    @Autowired private SensorService service;
    
    @GetMapping
    public Map<String, Object> latest(@RequestParam Long deviceId, @RequestParam(defaultValue = "24") int limit) {
        Map<String, Object> r = new HashMap<>();
        r.put("code", 200); r.put("data", service.getLatest(deviceId, limit));
        return r;
    }
    
    @GetMapping("/{deviceId}/latest")
    public Map<String, Object> latestOne(@PathVariable Long deviceId) {
        Map<String, Object> r = new HashMap<>();
        var data = service.getLatestOne(deviceId);
        if (data != null) { r.put("code", 200); r.put("data", data); }
        else { r.put("code", 404); r.put("message", "暂无数据"); }
        return r;
    }
    
    @GetMapping("/{deviceId}/range")
    public Map<String, Object> range(@PathVariable Long deviceId,
                                      @RequestParam String start, @RequestParam String end) {
        Map<String, Object> r = new HashMap<>();
        r.put("code", 200); r.put("data", service.getByTimeRange(deviceId, start, end));
        return r;
    }
}

package com.iot.smarthome.controller;

import com.iot.smarthome.entity.Device;
import com.iot.smarthome.service.DeviceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.*;

@RestController
@RequestMapping("/api")
@CrossOrigin(origins = "*")
public class DeviceController {
    @Autowired private DeviceService service;
    
    @GetMapping("/devices")
    public Map<String, Object> list(@RequestParam(required = false) String type,
                                     @RequestParam(required = false) Long roomId) {
        Map<String, Object> r = new HashMap<>();
        List<Device> data;
        if (roomId != null) data = service.getByRoom(roomId);
        else if (type != null && !type.isEmpty()) data = service.getByType(type);
        else data = service.getAll();
        r.put("code", 200); r.put("data", data);
        return r;
    }
    
    @GetMapping("/devices/{id}")
    public Map<String, Object> get(@PathVariable Long id) {
        Map<String, Object> r = new HashMap<>();
        Device d = service.getById(id);
        if (d != null) { r.put("code", 200); r.put("data", d); }
        else { r.put("code", 404); r.put("message", "设备不存在"); }
        return r;
    }
    
    @PostMapping("/devices")
    public Map<String, Object> add(@RequestBody Device d) {
        Map<String, Object> r = new HashMap<>();
        int rows = service.add(d);
        r.put("code", rows > 0 ? 200 : 500);
        r.put("message", rows > 0 ? "添加成功" : "添加失败");
        if (rows > 0) r.put("data", d);
        return r;
    }
    
    @PutMapping("/devices/{id}")
    public Map<String, Object> update(@PathVariable Long id, @RequestBody Device d) {
        Map<String, Object> r = new HashMap<>();
        d.setId(id);
        int rows = service.update(d);
        r.put("code", rows > 0 ? 200 : 500);
        r.put("message", rows > 0 ? "更新成功" : "更新失败");
        return r;
    }
    
    @DeleteMapping("/devices/{id}")
    public Map<String, Object> delete(@PathVariable Long id) {
        Map<String, Object> r = new HashMap<>();
        int rows = service.delete(id);
        r.put("code", rows > 0 ? 200 : 500);
        r.put("message", rows > 0 ? "删除成功" : "删除失败");
        return r;
    }
    
    @PutMapping("/devices/{id}/switch")
    public Map<String, Object> toggleSwitch(@PathVariable Long id, @RequestBody Map<String, Integer> body) {
        Map<String, Object> r = new HashMap<>();
        Integer state = body.get("switchState");
        if (state == null) { r.put("code", 400); r.put("message", "缺少参数"); return r; }
        int rows = service.toggleSwitch(id, state);
        r.put("code", rows > 0 ? 200 : 500);
        r.put("message", rows > 0 ? "开关已切换" : "操作失败");
        return r;
    }
    
    @GetMapping("/stats")
    public Map<String, Object> stats() {
        Map<String, Object> r = new HashMap<>();
        r.put("code", 200); r.put("data", service.getStats());
        return r;
    }
}

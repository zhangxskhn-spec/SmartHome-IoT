package com.iot.smarthome.controller;

import com.iot.smarthome.entity.Room;
import com.iot.smarthome.service.RoomService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.*;

@RestController
@RequestMapping("/api/rooms")
@CrossOrigin(origins = "*")
public class RoomController {
    @Autowired private RoomService service;
    
    @GetMapping
    public Map<String, Object> list() {
        Map<String, Object> r = new HashMap<>();
        r.put("code", 200); r.put("data", service.getAll());
        return r;
    }
    
    @PostMapping
    public Map<String, Object> add(@RequestBody Room room) {
        Map<String, Object> r = new HashMap<>();
        int rows = service.add(room);
        r.put("code", rows > 0 ? 200 : 500); r.put("message", rows > 0 ? "添加成功" : "添加失败");
        return r;
    }
    
    @DeleteMapping("/{id}")
    public Map<String, Object> delete(@PathVariable Long id) {
        Map<String, Object> r = new HashMap<>();
        int rows = service.delete(id);
        r.put("code", rows > 0 ? 200 : 500); r.put("message", rows > 0 ? "删除成功" : "删除失败");
        return r;
    }
}

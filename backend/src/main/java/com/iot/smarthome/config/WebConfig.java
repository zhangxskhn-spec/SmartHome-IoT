package com.iot.smarthome.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

/**
 * 托管 frontend 静态页面，使 http://localhost:8080 可直接访问。
 * 优先使用项目内 frontend 目录（开发），其次使用打包进 classpath 的 static。
 */
@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        String frontendLocation = resolveFrontendLocation();
        registry.addResourceHandler("/**")
                .addResourceLocations(frontendLocation, "classpath:/static/")
                .setCachePeriod(0);
    }

    private String resolveFrontendLocation() {
        // 从 backend 工作目录向上找 ../frontend
        Path[] candidates = {
                Paths.get("..", "frontend"),
                Paths.get("frontend"),
                Paths.get("..", "..", "frontend")
        };
        for (Path p : candidates) {
            try {
                Path abs = p.toAbsolutePath().normalize();
                if (Files.isDirectory(abs) && Files.isDirectory(abs.resolve("pages"))) {
                    return abs.toUri().toString();
                }
            } catch (Exception ignored) {
            }
        }
        // 回退：仍指向相对路径，配合 classpath:/static/ 使用
        return "file:../frontend/";
    }
}

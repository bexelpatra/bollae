package com.boatsched.controller;

import com.boatsched.dto.SystemConfigResponse;
import com.boatsched.dto.SystemConfigUpdateRequest;
import com.boatsched.service.SystemConfigService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/system")
public class SystemConfigController {
    private final SystemConfigService systemConfigService;

    public SystemConfigController(SystemConfigService systemConfigService) {
        this.systemConfigService = systemConfigService;
    }

    @GetMapping("/config")
    public ResponseEntity<SystemConfigResponse> getConfig() {
        return ResponseEntity.ok(systemConfigService.getConfig());
    }

    @PutMapping("/config")
    @PreAuthorize("hasRole('MANAGER')")
    public ResponseEntity<SystemConfigResponse> updateConfig(@RequestBody SystemConfigUpdateRequest request) {
        return ResponseEntity.ok(systemConfigService.updateConfig(request));
    }
}

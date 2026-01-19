package com.boatsched.service;

import com.boatsched.dto.SystemConfigResponse;
import com.boatsched.dto.SystemConfigUpdateRequest;
import com.boatsched.entity.SystemConfig;
import com.boatsched.entity.User;
import com.boatsched.repository.SystemConfigRepository;
import com.boatsched.repository.UserRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class SystemConfigService {
    private final SystemConfigRepository systemConfigRepository;
    private final UserRepository userRepository;
    private final FCMService fcmService;

    public SystemConfigService(SystemConfigRepository systemConfigRepository,
                                UserRepository userRepository,
                                FCMService fcmService) {
        this.systemConfigRepository = systemConfigRepository;
        this.userRepository = userRepository;
        this.fcmService = fcmService;
    }

    @Transactional(readOnly = true)
    public SystemConfigResponse getConfig() {
        SystemConfig config = systemConfigRepository.findById(1L)
                .orElseGet(() -> {
                    SystemConfig newConfig = new SystemConfig();
                    newConfig.setId(1L);
                    newConfig.setIsDangerMode(false);
                    return systemConfigRepository.save(newConfig);
                });

        return new SystemConfigResponse(
                config.getNoticeTitle(),
                config.getNoticeContent(),
                config.getPopupContent(),
                config.getIsDangerMode()
        );
    }

    @Transactional
    public SystemConfigResponse updateConfig(SystemConfigUpdateRequest request) {
        SystemConfig config = systemConfigRepository.findById(1L)
                .orElseGet(() -> {
                    SystemConfig newConfig = new SystemConfig();
                    newConfig.setId(1L);
                    newConfig.setIsDangerMode(false);
                    return newConfig;
                });

        boolean dangerModeChanged = false;
        if (request.getIsDangerMode() != null &&
            !request.getIsDangerMode().equals(config.getIsDangerMode())) {
            dangerModeChanged = true;
        }

        if (request.getNoticeTitle() != null) {
            config.setNoticeTitle(request.getNoticeTitle());
        }
        if (request.getNoticeContent() != null) {
            config.setNoticeContent(request.getNoticeContent());
        }
        if (request.getPopupContent() != null) {
            config.setPopupContent(request.getPopupContent());
        }
        if (request.getIsDangerMode() != null) {
            config.setIsDangerMode(request.getIsDangerMode());
        }

        config = systemConfigRepository.save(config);

        if (dangerModeChanged) {
            notifyAllUsers(config.getIsDangerMode());
        }

        return new SystemConfigResponse(
                config.getNoticeTitle(),
                config.getNoticeContent(),
                config.getPopupContent(),
                config.getIsDangerMode()
        );
    }

    private void notifyAllUsers(boolean isDangerMode) {
        List<User> allUsers = userRepository.findAll();
        List<String> tokens = allUsers.stream()
                .map(User::getFcmToken)
                .filter(token -> token != null && !token.isEmpty())
                .collect(Collectors.toList());

        String message = isDangerMode
                ? "Danger mode has been activated. Please check the notice."
                : "Danger mode has been deactivated.";

        fcmService.sendBroadcast(tokens, "System Alert", message);
    }
}

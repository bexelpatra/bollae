package com.boatsched.service;

import com.boatsched.dto.LoginRequest;
import com.boatsched.dto.LoginResponse;
import com.boatsched.dto.RegisterRequest;
import com.boatsched.entity.User;
import com.boatsched.repository.UserRepository;
import com.boatsched.security.JwtTokenProvider;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class UserService {
    private final UserRepository userRepository;
    private final JwtTokenProvider jwtTokenProvider;

    public UserService(UserRepository userRepository, JwtTokenProvider jwtTokenProvider) {
        this.userRepository = userRepository;
        this.jwtTokenProvider = jwtTokenProvider;
    }

    @Transactional
    public LoginResponse register(RegisterRequest request) {
        if (userRepository.existsByPhoneNumber(request.getPhoneNumber())) {
            throw new IllegalArgumentException("Phone number already exists");
        }

        User user = new User();
        user.setPhoneNumber(request.getPhoneNumber());
        user.setStoreName(request.getStoreName());
        user.setRepresentativeName(request.getRepresentativeName());
        user.setRole(User.Role.USER);

        user = userRepository.save(user);

        String token = jwtTokenProvider.generateToken(
                user.getId(),
                user.getPhoneNumber(),
                user.getRole().name()
        );

        return new LoginResponse(
                token,
                user.getId(),
                user.getPhoneNumber(),
                user.getStoreName(),
                user.getRepresentativeName(),
                user.getRole().name()
        );
    }

    @Transactional(readOnly = true)
    public LoginResponse login(LoginRequest request) {
        User user = userRepository.findByPhoneNumber(request.getPhoneNumber())
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        String token = jwtTokenProvider.generateToken(
                user.getId(),
                user.getPhoneNumber(),
                user.getRole().name()
        );

        return new LoginResponse(
                token,
                user.getId(),
                user.getPhoneNumber(),
                user.getStoreName(),
                user.getRepresentativeName(),
                user.getRole().name()
        );
    }

    @Transactional
    public void updateFcmToken(Long userId, String fcmToken) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));
        user.setFcmToken(fcmToken);
        userRepository.save(user);
    }

    @Transactional(readOnly = true)
    public User getUserById(Long userId) {
        return userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));
    }
}

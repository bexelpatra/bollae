package com.boatsched.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class LoginResponse {
    private String token;
    private Long userId;
    private String phoneNumber;
    private String storeName;
    private String representativeName;
    private String role;
}

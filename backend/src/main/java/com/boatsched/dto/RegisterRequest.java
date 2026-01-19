package com.boatsched.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class RegisterRequest {
    @NotBlank(message = "Phone number is required")
    private String phoneNumber;

    @NotBlank(message = "Store name is required")
    private String storeName;

    @NotBlank(message = "Representative name is required")
    private String representativeName;
}

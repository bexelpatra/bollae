package com.boatsched.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalTime;

@Data
@AllArgsConstructor
public class ScheduleResponse {
    private Long id;
    private Long userId;
    private String storeName;
    private String representativeName;
    private String phoneNumber;
    private LocalDate scheduleDate;
    private LocalTime scheduleTime;
    private Integer paxCount;
    private String purpose;
    private String note;
    private String status;
}

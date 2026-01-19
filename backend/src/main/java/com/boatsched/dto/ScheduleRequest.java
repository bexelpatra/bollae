package com.boatsched.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalTime;

@Data
public class ScheduleRequest {
    @NotNull(message = "Schedule date is required")
    private LocalDate scheduleDate;

    @NotNull(message = "Schedule time is required")
    private LocalTime scheduleTime;

    @NotNull(message = "Pax count is required")
    private Integer paxCount;

    @NotNull(message = "Purpose is required")
    private String purpose;

    private String note;
}

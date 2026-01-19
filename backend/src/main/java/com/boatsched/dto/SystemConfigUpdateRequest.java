package com.boatsched.dto;

import lombok.Data;

@Data
public class SystemConfigUpdateRequest {
    private String noticeTitle;
    private String noticeContent;
    private String popupContent;
    private Boolean isDangerMode;
}

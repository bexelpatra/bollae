package com.boatsched.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class SystemConfigResponse {
    private String noticeTitle;
    private String noticeContent;
    private String popupContent;
    private Boolean isDangerMode;
}

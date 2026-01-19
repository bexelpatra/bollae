package com.boatsched.service;

import com.boatsched.dto.ScheduleRequest;
import com.boatsched.dto.ScheduleResponse;
import com.boatsched.entity.Schedule;
import com.boatsched.entity.User;
import com.boatsched.repository.ScheduleRepository;
import com.boatsched.repository.UserRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class ScheduleService {
    private final ScheduleRepository scheduleRepository;
    private final UserRepository userRepository;
    private final FCMService fcmService;

    public ScheduleService(ScheduleRepository scheduleRepository,
                           UserRepository userRepository,
                           FCMService fcmService) {
        this.scheduleRepository = scheduleRepository;
        this.userRepository = userRepository;
        this.fcmService = fcmService;
    }

    @Transactional
    public ScheduleResponse createSchedule(Long userId, ScheduleRequest request) {
        LocalDate tomorrow = LocalDate.now().plusDays(1);
        if (!request.getScheduleDate().equals(tomorrow)) {
            throw new IllegalArgumentException("Schedule can only be created for the next day");
        }

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        Schedule schedule = new Schedule();
        schedule.setUser(user);
        schedule.setScheduleDate(request.getScheduleDate());
        schedule.setScheduleTime(request.getScheduleTime());
        schedule.setPaxCount(request.getPaxCount());
        schedule.setPurpose(request.getPurpose());
        schedule.setNote(request.getNote());
        schedule.setStatus(Schedule.Status.REQUESTED);

        schedule = scheduleRepository.save(schedule);

        notifyManagers(user.getStoreName() + " has created a new schedule");

        return toResponse(schedule);
    }

    @Transactional(readOnly = true)
    public List<ScheduleResponse> getSchedulesByUser(Long userId, String status) {
        List<Schedule> schedules;
        if (status != null) {
            schedules = scheduleRepository.findByUserIdAndStatus(
                    userId, Schedule.Status.valueOf(status)
            );
        } else {
            schedules = scheduleRepository.findByUserId(userId);
        }
        return schedules.stream().map(this::toResponse).collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<ScheduleResponse> getAllSchedules(String status) {
        List<Schedule> schedules;
        if (status != null) {
            schedules = scheduleRepository.findByStatus(Schedule.Status.valueOf(status));
        } else {
            schedules = scheduleRepository.findAll();
        }
        return schedules.stream().map(this::toResponse).collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public ScheduleResponse getScheduleById(Long scheduleId) {
        Schedule schedule = scheduleRepository.findById(scheduleId)
                .orElseThrow(() -> new IllegalArgumentException("Schedule not found"));
        return toResponse(schedule);
    }

    @Transactional
    public ScheduleResponse approveSchedule(Long scheduleId) {
        Schedule schedule = scheduleRepository.findById(scheduleId)
                .orElseThrow(() -> new IllegalArgumentException("Schedule not found"));

        if (schedule.getStatus() != Schedule.Status.REQUESTED) {
            throw new IllegalArgumentException("Only REQUESTED schedules can be approved");
        }

        schedule.setStatus(Schedule.Status.APPROVED);
        schedule = scheduleRepository.save(schedule);

        User user = schedule.getUser();
        fcmService.sendNotification(
                user.getFcmToken(),
                "Schedule Approved",
                "Your schedule for " + schedule.getScheduleDate() + " has been approved"
        );

        return toResponse(schedule);
    }

    @Transactional
    public void cancelSchedule(Long scheduleId, Long userId, boolean isManager) {
        Schedule schedule = scheduleRepository.findById(scheduleId)
                .orElseThrow(() -> new IllegalArgumentException("Schedule not found"));

        if (!isManager && !schedule.getUser().getId().equals(userId)) {
            throw new IllegalArgumentException("You can only cancel your own schedules");
        }

        if (schedule.getStatus() == Schedule.Status.CANCELED) {
            throw new IllegalArgumentException("Schedule is already canceled");
        }

        schedule.setStatus(Schedule.Status.CANCELED);
        scheduleRepository.save(schedule);

        if (isManager && !schedule.getUser().getId().equals(userId)) {
            User user = schedule.getUser();
            fcmService.sendNotification(
                    user.getFcmToken(),
                    "Schedule Canceled",
                    "Your schedule for " + schedule.getScheduleDate() + " has been canceled by the manager"
            );
        }
    }

    private ScheduleResponse toResponse(Schedule schedule) {
        User user = schedule.getUser();
        return new ScheduleResponse(
                schedule.getId(),
                user.getId(),
                user.getStoreName(),
                user.getRepresentativeName(),
                user.getPhoneNumber(),
                schedule.getScheduleDate(),
                schedule.getScheduleTime(),
                schedule.getPaxCount(),
                schedule.getPurpose(),
                schedule.getNote(),
                schedule.getStatus().name()
        );
    }

    private void notifyManagers(String message) {
        List<User> managers = userRepository.findAll().stream()
                .filter(u -> u.getRole() == User.Role.MANAGER)
                .collect(Collectors.toList());

        for (User manager : managers) {
            fcmService.sendNotification(manager.getFcmToken(), "New Schedule", message);
        }
    }
}

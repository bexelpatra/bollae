package com.boatsched.service;

import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class FCMService {
    private static final Logger logger = LoggerFactory.getLogger(FCMService.class);

    public void sendNotification(String fcmToken, String title, String body) {
        if (fcmToken == null || fcmToken.isEmpty()) {
            logger.warn("FCM token is null or empty, skipping notification");
            return;
        }

        try {
            Message message = Message.builder()
                    .setToken(fcmToken)
                    .setNotification(Notification.builder()
                            .setTitle(title)
                            .setBody(body)
                            .build())
                    .build();

            String response = FirebaseMessaging.getInstance().send(message);
            logger.info("Successfully sent message: {}", response);
        } catch (Exception e) {
            logger.error("Failed to send FCM notification", e);
        }
    }

    public void sendBroadcast(List<String> fcmTokens, String title, String body) {
        for (String token : fcmTokens) {
            sendNotification(token, title, body);
        }
    }
}

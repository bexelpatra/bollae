package com.boatsched.config;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

import jakarta.annotation.PostConstruct;
import java.io.FileInputStream;
import java.io.IOException;

@Configuration
public class FirebaseConfig {
    private static final Logger logger = LoggerFactory.getLogger(FirebaseConfig.class);

    @Value("${firebase.config-path}")
    private String firebaseConfigPath;

    @PostConstruct
    public void initialize() {
        if (firebaseConfigPath == null || firebaseConfigPath.isEmpty()) {
            logger.warn("Firebase config path not provided. FCM notifications will not work.");
            return;
        }

        try {
            java.io.File configFile = new java.io.File(firebaseConfigPath);
            if (!configFile.exists()) {
                logger.warn("Firebase config file not found at: {}. FCM notifications will not work.", firebaseConfigPath);
                return;
            }

            FileInputStream serviceAccount = new FileInputStream(firebaseConfigPath);

            FirebaseOptions options = FirebaseOptions.builder()
                    .setCredentials(GoogleCredentials.fromStream(serviceAccount))
                    .build();

            FirebaseApp.initializeApp(options);
            logger.info("Firebase initialized successfully");
        } catch (IOException e) {
            logger.error("Failed to initialize Firebase", e);
        }
    }
}

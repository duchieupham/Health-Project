//package com.dh.health.service;
//
//import org.springframework.stereotype.Service;
//
//import com.dh.health.dto.PnsRequest;
//import com.google.firebase.messaging.FirebaseMessaging;
//import com.google.firebase.messaging.FirebaseMessagingException;
//import com.google.firebase.messaging.Message;
//
//@Service
//public class FCMService {
//
//    public String pushNotification(PnsRequest pnsRequest) {
//        Message message = Message.builder()
//                .putData("content", pnsRequest.getContent())
//                .setToken(pnsRequest.getFcmToken())
//                .build();
//
//        String response = null;
//        try {
//            response = FirebaseMessaging.getInstance().send(message);
//        } catch (FirebaseMessagingException e) {
//            e.printStackTrace();
//        }
//        return response;
//    }
//}

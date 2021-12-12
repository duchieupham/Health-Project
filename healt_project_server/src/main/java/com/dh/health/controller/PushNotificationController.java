//package com.dh.health.controller;
//
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.web.bind.annotation.PostMapping;
//import org.springframework.web.bind.annotation.RequestBody;
//import org.springframework.web.bind.annotation.RestController;
//
//import com.dh.health.dto.PnsRequest;
//import com.dh.health.service.FCMService;
//
//@RestController
//public class PushNotificationController {
//
//    @Autowired
//    private FCMService fcmService;
//
//    @PostMapping("/notification")
//    public String sendSampleNotification(@RequestBody PnsRequest pnsRequest) {
//        return fcmService.pushNotification(pnsRequest);
//    }
//}

package com.ironpulse.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Document(collection = "members")
public class Member {

    @Id
    private String id;
    
    private String name;
    private String email;
    private String phone;
    private int age;
    private LocalDate joinDate;
    private String membershipPlan;
    private String status; // ACTIVE, INACTIVE, SUSPENDED
    private String type; // REGULAR, CORPORATE, STUDENT
    private double monthlyFee;
    private LocalDate lastPaymentDate;
    private String address;
    private String notes;
}

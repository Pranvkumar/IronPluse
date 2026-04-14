package com.ironpulse.service;

import com.ironpulse.model.Member;
import com.ironpulse.model.Payment;
import com.ironpulse.repository.MemberRepository;
import com.ironpulse.repository.PaymentRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class DashboardService {

    private final MemberRepository memberRepository;
    private final PaymentRepository paymentRepository;

    /**
     * Get comprehensive dashboard overview
     */
    public Map<String, Object> getDashboardOverview() {
        Map<String, Object> overview = new HashMap<>();
        
        long totalMembers = memberRepository.count();
        long activeMembers = memberRepository.countByStatus("ACTIVE");
        
        List<Payment> allPayments = paymentRepository.findAll();
        long totalPayments = allPayments.size();
        long paidPayments = paymentRepository.countByStatus("PAID");
        
        double totalRevenue = allPayments.stream()
                .filter(p -> "PAID".equals(p.getStatus()))
                .mapToDouble(Payment::getAmount)
                .sum();
        
        // Today's revenue
        LocalDateTime now = LocalDateTime.now();
        double todayRevenue = allPayments.stream()
                .filter(p -> "PAID".equals(p.getStatus()) && isSameDay(p.getPaymentDate(), now))
                .mapToDouble(Payment::getAmount)
                .sum();
        
        overview.put("totalMembers", totalMembers);
        overview.put("activeMembers", activeMembers);
        overview.put("totalPayments", totalPayments);
        overview.put("paidPayments", paidPayments);
        overview.put("totalRevenue", totalRevenue);
        overview.put("todayRevenue", todayRevenue);
        overview.put("collectionRate", totalPayments > 0 ? (double) paidPayments / totalPayments * 100 : 0);
        
        return overview;
    }

    /**
     * Get revenue data for charts
     */
    public Map<String, Object> getRevenueData() {
        Map<String, Object> data = new HashMap<>();
        
        List<Payment> paidPayments = paymentRepository.findByStatus("PAID");
        
        double monthlyRevenue = paidPayments.stream()
                .mapToDouble(Payment::getAmount)
                .average()
                .orElse(0.0);
        
        data.put("monthlyAverage", monthlyRevenue);
        data.put("totalRevenue", paidPayments.stream()
                .mapToDouble(Payment::getAmount)
                .sum());
        data.put("paymentCount", paidPayments.size());
        
        return data;
    }

    /**
     * Get member distribution across plans
     */
    public Map<String, Object> getMemberDistribution() {
        Map<String, Object> distribution = new HashMap<>();
        
        List<Member> allMembers = memberRepository.findAll();
        
        Map<String, Long> planDistribution = allMembers.stream()
                .collect(Collectors.groupingBy(
                    Member::getMembershipPlan,
                    Collectors.counting()
                ));
        
        Map<String, Long> statusDistribution = allMembers.stream()
                .collect(Collectors.groupingBy(
                    Member::getStatus,
                    Collectors.counting()
                ));
        
        distribution.put("byPlan", planDistribution);
        distribution.put("byStatus", statusDistribution);
        distribution.put("total", allMembers.size());
        
        return distribution;
    }

    /**
     * Get recent activities
     */
    public Map<String, Object> getRecentActivities() {
        Map<String, Object> activities = new HashMap<>();
        
        // Recent payments (last 10)
        List<Payment> recentPayments = paymentRepository.findAll()
                .stream()
                .sorted((a, b) -> b.getPaymentDate().compareTo(a.getPaymentDate()))
                .limit(10)
                .collect(Collectors.toList());
        
        // Recent members (last 5)
        List<Member> recentMembers = memberRepository.findAll()
                .stream()
                .sorted((a, b) -> b.getJoinDate().compareTo(a.getJoinDate()))
                .limit(5)
                .collect(Collectors.toList());
        
        activities.put("recentPayments", recentPayments);
        activities.put("recentMembers", recentMembers);
        
        return activities;
    }

    /**
     * Helper method to check if dates are same day
     */
    private boolean isSameDay(LocalDateTime dateTime, LocalDateTime compareWith) {
        if (dateTime == null) return false;
        return dateTime.toLocalDate().equals(compareWith.toLocalDate());
    }
}

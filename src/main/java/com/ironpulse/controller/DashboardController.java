package com.ironpulse.controller;

import com.ironpulse.service.DashboardService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/dashboard")
@RequiredArgsConstructor
@CrossOrigin(origins = "*", maxAge = 3600)
public class DashboardController {

    private final DashboardService dashboardService;

    /**
     * Get dashboard overview
     */
    @GetMapping("/overview")
    public ResponseEntity<Map<String, Object>> getDashboardOverview() {
        Map<String, Object> overview = dashboardService.getDashboardOverview();
        return ResponseEntity.ok(overview);
    }

    /**
     * Get revenue data for charts
     */
    @GetMapping("/revenue")
    public ResponseEntity<Map<String, Object>> getRevenueData() {
        Map<String, Object> data = dashboardService.getRevenueData();
        return ResponseEntity.ok(data);
    }

    /**
     * Get member distribution
     */
    @GetMapping("/members/distribution")
    public ResponseEntity<Map<String, Object>> getMemberDistribution() {
        Map<String, Object> data = dashboardService.getMemberDistribution();
        return ResponseEntity.ok(data);
    }

    /**
     * Get recent activities
     */
    @GetMapping("/activities/recent")
    public ResponseEntity<Map<String, Object>> getRecentActivities() {
        Map<String, Object> activities = dashboardService.getRecentActivities();
        return ResponseEntity.ok(activities);
    }
}

package com.ironpulse.controller;

import com.ironpulse.model.Payment;
import com.ironpulse.service.PaymentService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/payments")
@RequiredArgsConstructor
@CrossOrigin(origins = "*", maxAge = 3600)
public class PaymentController {

    private final PaymentService paymentService;

    /**
     * Get all payments
     */
    @GetMapping
    public ResponseEntity<List<Payment>> getAllPayments(
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String memberId) {
        List<Payment> payments = paymentService.getAllPayments(status, memberId);
        return ResponseEntity.ok(payments);
    }

    /**
     * Get payment by ID
     */
    @GetMapping("/{id}")
    public ResponseEntity<Payment> getPaymentById(@PathVariable String id) {
        return paymentService.getPaymentById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    /**
     * Record new payment
     */
    @PostMapping
    public ResponseEntity<Payment> recordPayment(@RequestBody Payment payment) {
        Payment recorded = paymentService.recordPayment(payment);
        return ResponseEntity.status(HttpStatus.CREATED).body(recorded);
    }

    /**
     * Update payment status
     */
    @PutMapping("/{id}/status")
    public ResponseEntity<Payment> updatePaymentStatus(
            @PathVariable String id,
            @RequestBody Map<String, String> payload) {
        String status = payload.get("status");
        return paymentService.updatePaymentStatus(id, status)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    /**
     * Get member's payments
     */
    @GetMapping("/member/{memberId}")
    public ResponseEntity<List<Payment>> getMemberPayments(@PathVariable String memberId) {
        List<Payment> payments = paymentService.getPaymentsByMemberId(memberId);
        return ResponseEntity.ok(payments);
    }

    /**
     * Get revenue statistics
     */
    @GetMapping("/stats/revenue")
    public ResponseEntity<Map<String, Object>> getRevenueStats() {
        Map<String, Object> stats = paymentService.getRevenueStatistics();
        return ResponseEntity.ok(stats);
    }

    /**
     * Delete payment
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletePayment(@PathVariable String id) {
        paymentService.deletePayment(id);
        return ResponseEntity.noContent().build();
    }
}

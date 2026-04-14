package com.ironpulse.service;

import com.ironpulse.model.Payment;
import com.ironpulse.repository.PaymentRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.YearMonth;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Slf4j
public class PaymentService {

    private final PaymentRepository paymentRepository;

    /**
     * Get all payments with optional filtering
     */
    public List<Payment> getAllPayments(String status, String memberId) {
        if (status != null && !status.isEmpty() && memberId != null && !memberId.isEmpty()) {
            return paymentRepository.findByMemberIdAndStatus(memberId, status);
        }
        if (status != null && !status.isEmpty()) {
            return paymentRepository.findByStatus(status);
        }
        if (memberId != null && !memberId.isEmpty()) {
            return paymentRepository.findByMemberId(memberId);
        }
        return paymentRepository.findAll();
    }

    /**
     * Get payment by ID
     */
    public Optional<Payment> getPaymentById(String id) {
        return paymentRepository.findById(id);
    }

    /**
     * Record new payment
     */
    public Payment recordPayment(Payment payment) {
        payment.setCreatedAt(LocalDateTime.now());
        payment.setUpdatedAt(LocalDateTime.now());
        log.info("Recording payment for member: {}", payment.getMemberId());
        return paymentRepository.save(payment);
    }

    /**
     * Update payment status
     */
    public Optional<Payment> updatePaymentStatus(String id, String status) {
        return paymentRepository.findById(id).map(payment -> {
            payment.setStatus(status);
            payment.setUpdatedAt(LocalDateTime.now());
            log.info("Updated payment {} status to: {}", id, status);
            return paymentRepository.save(payment);
        });
    }

    /**
     * Get payments for specific member
     */
    public List<Payment> getPaymentsByMemberId(String memberId) {
        return paymentRepository.findByMemberId(memberId);
    }

    /**
     * Delete payment
     */
    public void deletePayment(String id) {
        log.info("Deleting payment: {}", id);
        paymentRepository.deleteById(id);
    }

    /**
     * Get revenue statistics
     */
    public Map<String, Object> getRevenueStatistics() {
        long totalPayments = paymentRepository.count();
        long paidPayments = paymentRepository.countByStatus("PAID");
        long pendingPayments = paymentRepository.countByStatus("PENDING");
        
        double totalRevenue = paymentRepository.findByStatus("PAID")
                .stream()
                .mapToDouble(Payment::getAmount)
                .sum();
        
        double pendingAmount = paymentRepository.findByStatus("PENDING")
                .stream()
                .mapToDouble(Payment::getAmount)
                .sum();
        
        return Map.of(
            "totalPayments", totalPayments,
            "paidPayments", paidPayments,
            "pendingPayments", pendingPayments,
            "totalRevenue", totalRevenue,
            "pendingAmount", pendingAmount,
            "collectionRate", totalPayments > 0 ? (double) paidPayments / totalPayments * 100 : 0
        );
    }
}

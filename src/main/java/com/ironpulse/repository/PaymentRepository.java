package com.ironpulse.repository;

import com.ironpulse.model.Payment;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface PaymentRepository extends MongoRepository<Payment, String> {

    List<Payment> findByMemberId(String memberId);
    
    List<Payment> findByStatus(String status);
    
    List<Payment> findByMemberIdAndStatus(String memberId, String status);
    
    Optional<Payment> findByInvoiceNumber(String invoiceNumber);
    
    @Query("{ 'paymentDate': { $gte: ?0, $lte: ?1 } }")
    List<Payment> findByPaymentDateRange(LocalDateTime startDate, LocalDateTime endDate);
    
    @Query("{ 'status': 'PAID', 'paymentDate': { $gte: ?0, $lte: ?1 } }")
    List<Payment> findPaidPaymentsByDateRange(LocalDateTime startDate, LocalDateTime endDate);
    
    long countByStatus(String status);
    
    long countByMemberId(String memberId);
}

package com.ironpulse.repository;

import com.ironpulse.model.Member;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface MemberRepository extends MongoRepository<Member, String> {

    List<Member> findByStatus(String status);
    
    List<Member> findByMembershipPlan(String plan);
    
    Optional<Member> findByEmail(String email);
    
    Optional<Member> findByPhone(String phone);
    
    @Query("{ 'name': { $regex: ?0, $options: 'i' } }")
    List<Member> searchByName(String name);
    
    @Query("{ $or: [ " +
           "{ 'name': { $regex: ?0, $options: 'i' } }, " +
           "{ 'email': { $regex: ?0, $options: 'i' } }, " +
           "{ 'phone': { $regex: ?0, $options: 'i' } } " +
           "] }")
    List<Member> searchByMultipleFields(String searchTerm);
    
    long countByStatus(String status);
    
    long countByMembershipPlan(String plan);
}

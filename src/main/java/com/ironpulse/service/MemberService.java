package com.ironpulse.service;

import com.ironpulse.model.Member;
import com.ironpulse.repository.MemberRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Slf4j
public class MemberService {

    private final MemberRepository memberRepository;

    /**
     * Get all members with optional filtering
     */
    public List<Member> getAllMembers(String status, String plan) {
        if (status != null && !status.isEmpty()) {
            return memberRepository.findByStatus(status);
        }
        if (plan != null && !plan.isEmpty()) {
            return memberRepository.findByMembershipPlan(plan);
        }
        return memberRepository.findAll();
    }

    /**
     * Get member by ID
     */
    public Optional<Member> getMemberById(String id) {
        return memberRepository.findById(id);
    }

    /**
     * Search members by name, email, or phone
     */
    public List<Member> searchMembers(String query) {
        log.info("Searching members with query: {}", query);
        return memberRepository.searchByMultipleFields(query);
    }

    /**
     * Create new member
     */
    public Member createMember(Member member) {
        log.info("Creating new member: {}", member.getName());
        Member created = memberRepository.save(member);
        log.info("Member created with ID: {}", created.getId());
        return created;
    }

    /**
     * Update member
     */
    public Optional<Member> updateMember(String id, Member memberUpdate) {
        return memberRepository.findById(id).map(existing -> {
            if (memberUpdate.getName() != null) existing.setName(memberUpdate.getName());
            if (memberUpdate.getEmail() != null) existing.setEmail(memberUpdate.getEmail());
            if (memberUpdate.getPhone() != null) existing.setPhone(memberUpdate.getPhone());
            if (memberUpdate.getAge() > 0) existing.setAge(memberUpdate.getAge());
            if (memberUpdate.getMembershipPlan() != null) existing.setMembershipPlan(memberUpdate.getMembershipPlan());
            if (memberUpdate.getStatus() != null) existing.setStatus(memberUpdate.getStatus());
            if (memberUpdate.getMonthlyFee() > 0) existing.setMonthlyFee(memberUpdate.getMonthlyFee());
            
            log.info("Updating member: {}", id);
            return memberRepository.save(existing);
        });
    }

    /**
     * Delete member
     */
    public void deleteMember(String id) {
        log.info("Deleting member: {}", id);
        memberRepository.deleteById(id);
    }

    /**
     * Get member statistics
     */
    public Map<String, Object> getStatistics() {
        long totalMembers = memberRepository.count();
        long activeMembers = memberRepository.countByStatus("ACTIVE");
        long inactiveMembers = memberRepository.countByStatus("INACTIVE");
        
        return Map.of(
            "totalMembers", totalMembers,
            "activeMembers", activeMembers,
            "inactiveMembers", inactiveMembers,
            "activationRate", totalMembers > 0 ? (double) activeMembers / totalMembers * 100 : 0
        );
    }
}

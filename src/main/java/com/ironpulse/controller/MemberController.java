package com.ironpulse.controller;

import com.ironpulse.model.Member;
import com.ironpulse.service.MemberService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/members")
@RequiredArgsConstructor
@CrossOrigin(origins = "*", maxAge = 3600)
public class MemberController {

    private final MemberService memberService;

    /**
     * Get all members
     */
    @GetMapping
    public ResponseEntity<List<Member>> getAllMembers(
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String plan) {
        List<Member> members = memberService.getAllMembers(status, plan);
        return ResponseEntity.ok(members);
    }

    /**
     * Get member by ID
     */
    @GetMapping("/{id}")
    public ResponseEntity<Member> getMemberById(@PathVariable String id) {
        return memberService.getMemberById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    /**
     * Search members
     */
    @GetMapping("/search")
    public ResponseEntity<List<Member>> searchMembers(@RequestParam String query) {
        List<Member> results = memberService.searchMembers(query);
        return ResponseEntity.ok(results);
    }

    /**
     * Create new member
     */
    @PostMapping
    public ResponseEntity<Member> createMember(@RequestBody Member member) {
        Member created = memberService.createMember(member);
        return ResponseEntity.status(HttpStatus.CREATED).body(created);
    }

    /**
     * Update member
     */
    @PutMapping("/{id}")
    public ResponseEntity<Member> updateMember(
            @PathVariable String id,
            @RequestBody Member memberUpdate) {
        return memberService.updateMember(id, memberUpdate)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    /**
     * Delete member
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteMember(@PathVariable String id) {
        memberService.deleteMember(id);
        return ResponseEntity.noContent().build();
    }

    /**
     * Get member statistics
     */
    @GetMapping("/stats/summary")
    public ResponseEntity<Map<String, Object>> getMemberStats() {
        Map<String, Object> stats = memberService.getStatistics();
        return ResponseEntity.ok(stats);
    }
}

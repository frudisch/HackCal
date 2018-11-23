package com.senacor.hacking.days.event.service.service;

import com.senacor.hacking.days.event.service.handler.port.EventMemberList;
import com.senacor.hacking.days.event.service.repository.UserRepository;
import com.senacor.hacking.days.event.service.repository.domain.User;
import lombok.AllArgsConstructor;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@AllArgsConstructor
public class MemberService {

    private final UserRepository userRepository;

    public EventMemberList selectEventMember(UUID eventId) {
        return EventMemberList.builder()
                .event(eventId)
                .member(userRepository.selectAllUserByEventId(eventId).stream().map(User::getId).collect(Collectors.toList()))
                .build();
    }

    public void removeMember(UUID eventId, UUID userId) {
        User user = userRepository.selectUserById(userId);
        user.getAttendingEvents().remove(eventId);
        userRepository.findAndReplaceUser(userId, user);
    }

    public void addMembers(UUID eventId, List<UUID> newMembers) {
        newMembers.forEach(member -> {
            User user = userRepository.selectUserById(member);
            if(user == null) {
                user = User.builder()
                        .id(UUID.randomUUID())
                        .firstName("Test")
                        .lastName("Hans")
                        .attendingEvents(new ArrayList<>())
                        .build();
                userRepository.createUser(user);
            }
            user.getAttendingEvents().add(eventId);
            user.setAttendingEvents(user.getAttendingEvents().stream().distinct().collect(Collectors.toList()));
            userRepository.findAndReplaceUser(member, user);
        });
    }

    private com.senacor.hacking.days.event.service.handler.port.User mapUser(User user) {
        return com.senacor.hacking.days.event.service.handler.port.User.builder()
                .firstName(user.getFirstName())
                .lastName(user.getLastName())
                .uuid(user.getId())
                .build();
    }
}
